"""CCI tasks for the dev org's test Experience Cloud sites (#1211).

``DeployTestingSites`` deploys their pages with the org's key prefixes filled in.
``ActivateTestingSites`` makes them ready for a guest. ``create_community`` leaves a site Under Construction, closed to guests, with a guest
user that holds nothing. For each site this task:

1. sets the Network Live, with guest access to public APIs and files on (an LWR guest
   gets 401 on every ui-api call without them, #984);
2. gives the site's guest user each permission set in ``guest_permission_sets``;
3. publishes the site and waits for the publish job (BackgroundOperation) to finish;
4. opens the site's home page with no session and expects a 200 that is not the login
   page, retrying while the publish reaches the CDN.

Any step that fails raises, so the flow running it fails (salesforce rule 74: the dev
flow leaves the org ready, or says loudly that it did not).

Register in ``cumulusci.yml``::

    tasks:
        activate_testing_sites:
            class_path: tasks.testing_sites.ActivateTestingSites
"""

import time

import requests

from cumulusci.core.exceptions import CumulusCIException
from cumulusci.core.source_transforms.transforms import FindReplaceSpec, FindReplaceTransform, FindReplaceTransformOptions
from cumulusci.core.utils import process_bool_arg, process_list_arg
from cumulusci.tasks.salesforce import BaseSalesforceApiTask, Deploy

NETWORK_SETTINGS = {"Status": "Live", "OptionsGuestChatterEnabled": True, "OptionsGuestFileAccessEnabled": True}


class DeployTestingSites(Deploy):
    """Deploy the test sites' bundles (scratch-org/showcase) with each object's key prefix filled in.

    An Aura site keys an object page's routes by the object's key prefix (detail-a0F), which differs between
    orgs, so the Form Template and Form Submission pages in experiences/Testing_Aura1 carry
    {{keyPrefix:<object>}} and this task replaces it with the org's prefix before deploying (#1211)."""

    task_docs = "Deploy scratch-org/showcase (the test sites' pages) with {{keyPrefix:<object>}} replaced by the org's key prefix for each object in key_prefix_objects (#1211)."
    task_options = {
        **Deploy.task_options,
        "key_prefix_objects": {"description": "Objects whose {{keyPrefix:<object>}} token is filled in, without namespace, comma separated."},
    }

    def _run_task(self):
        namespace = self.project_config.project__package__namespace
        client = self.org_config.salesforce_client
        patterns = []
        for object_name in process_list_arg(self.options.get("key_prefix_objects") or []):
            api_name = f"{namespace}__{object_name}" if namespace and self._is_namespaced_org(namespace) else object_name
            prefix = getattr(client, api_name).describe()["keyPrefix"]
            self.logger.info(f"{{{{keyPrefix:{object_name}}}}} = {prefix}")
            patterns.append(FindReplaceSpec(find=f"{{{{keyPrefix:{object_name}}}}}", replace=prefix))
        if patterns:
            self.transforms = [*self.transforms, FindReplaceTransform(FindReplaceTransformOptions(patterns=patterns))]
        super()._run_task()


class ActivateTestingSites(BaseSalesforceApiTask):
    task_docs = "Set each named Experience Cloud site Live with guest API access, grant its guest user permission sets, publish it, wait for the publish, and check a guest gets its home page (#1211)."
    task_options = {
        "sites": {"description": "Site names (Network Name), comma separated.", "required": True},
        "guest_permission_sets": {"description": "Permission set API names to give each site's guest user, comma separated."},
        "check_guest": {"description": "Open each site's home page as a guest and fail unless it answers 200. Default True."},
        "timeout": {"description": "Seconds to wait for each publish and each guest check. Default 600."},
    }

    def _init_options(self, kwargs):
        super()._init_options(kwargs)
        self.options["sites"] = process_list_arg(self.options["sites"])
        self.options["guest_permission_sets"] = process_list_arg(self.options.get("guest_permission_sets") or [])
        self.options["check_guest"] = process_bool_arg(self.options.get("check_guest", True))
        self.options["timeout"] = int(self.options.get("timeout") or 600)

    def _run_task(self):
        permission_set_ids = self._permission_set_ids(self.options["guest_permission_sets"])
        for site_name in self.options["sites"]:
            network_id = self._activate_network(site_name)
            self._grant_guest(site_name, permission_set_ids)
            self._publish(site_name, network_id)
        if not self.options["check_guest"]:
            return
        for site_name in self.options["sites"]:
            self._check_guest(site_name)

    def _query(self, soql):
        return self.sf.query_all(soql)["records"]

    def _permission_set_ids(self, names):
        if not names:
            return {}
        quoted = ", ".join(f"'{name}'" for name in names)
        found = {row["Name"]: row["Id"] for row in self._query(f"SELECT Id, Name FROM PermissionSet WHERE Name IN ({quoted})")}
        missing = [name for name in names if name not in found]
        if missing:
            raise CumulusCIException(f"Permission sets not in the org: {', '.join(missing)}")
        return found

    def _activate_network(self, site_name):
        rows = self._query(f"SELECT Id, Status FROM Network WHERE Name = '{site_name}'")
        if not rows:
            raise CumulusCIException(f"No site named {site_name!r}: create_community did not make it")
        network_id = rows[0]["Id"]
        self.sf.Network.update(network_id, NETWORK_SETTINGS)
        self.logger.info(f"{site_name}: Live, guest API and file access on (was {rows[0]['Status']})")
        return network_id

    def _grant_guest(self, site_name, permission_set_ids):
        if not permission_set_ids:
            return
        sites = self._query(f"SELECT GuestUserId FROM Site WHERE MasterLabel = '{site_name}' AND GuestUserId != null LIMIT 1")
        if not sites:
            raise CumulusCIException(f"{site_name}: no guest user")
        guest_id = sites[0]["GuestUserId"]
        quoted = ", ".join(f"'{value}'" for value in permission_set_ids.values())
        held = {row["PermissionSetId"] for row in self._query(f"SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = '{guest_id}' AND PermissionSetId IN ({quoted})")}
        for name, permission_set_id in permission_set_ids.items():
            if permission_set_id in held:
                continue
            self.sf.PermissionSetAssignment.create({"AssigneeId": guest_id, "PermissionSetId": permission_set_id})
        self.logger.info(f"{site_name}: guest holds {', '.join(permission_set_ids)} ({len(permission_set_ids) - len(held)} assigned now)")

    def _publish(self, site_name, network_id):
        started = time.time()
        response = self.sf.restful(f"connect/communities/{network_id}/publish", method="POST") or {}
        job_id = response.get("jobId")
        if not job_id:
            raise CumulusCIException(f"{site_name}: publish returned no job: {response}")
        while time.time() - started < self.options["timeout"]:
            rows = self._query(f"SELECT Status, Error FROM BackgroundOperation WHERE Id = '{job_id}'")
            status = rows[0]["Status"] if rows else None
            if status == "Complete":
                self.logger.info(f"{site_name}: published in {time.time() - started:.0f}s")
                return
            if status in ("Error", "Canceled"):
                raise CumulusCIException(f"{site_name}: publish {status}: {(rows[0].get('Error') or '').strip()[:300]}")
            time.sleep(5)
        raise CumulusCIException(f"{site_name}: still publishing after {self.options['timeout']}s (job {job_id})")

    def _site_url(self, site_name):
        sites = self._query(f"SELECT Id FROM Site WHERE MasterLabel = '{site_name}' AND SiteType = 'ChatterNetworkPicasso' LIMIT 1")
        if not sites:
            raise CumulusCIException(f"{site_name}: no Experience Builder site")
        details = self._query(f"SELECT SecureUrl FROM SiteDetail WHERE DurableId = '{sites[0]['Id']}'")
        if not details or not details[0].get("SecureUrl"):
            raise CumulusCIException(f"{site_name}: no site address")
        return details[0]["SecureUrl"].rstrip("/") + "/"

    def _check_guest(self, site_name):
        url = self._site_url(site_name)
        started = time.time()
        last = ""
        while time.time() - started < self.options["timeout"]:
            try:
                response = requests.get(url, timeout=60, allow_redirects=True)
                on_login = "/login" in response.url.lower()
                if response.status_code == 200 and not on_login:
                    self.logger.info(f"{site_name}: a guest gets {url} (200)")
                    return
                last = f"{response.status_code} at {response.url}"
            except requests.RequestException as error:
                last = str(error)[:200]
            time.sleep(15)
        raise CumulusCIException(f"{site_name}: a guest cannot open {url} after {self.options['timeout']}s: {last}")
