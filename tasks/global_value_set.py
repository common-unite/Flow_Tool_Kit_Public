"""CCI task to add values to a GLOBAL value set owned by an installed managed package.

``add_picklist_entries`` refuses a picklist that reads a Global Value Set ("uses a
Global Value Set, which is not supported"), and CumulusCI's ``add_value_set_entries``
only handles Standard Value Sets. This task fills the gap for the third shape: the
value set is retrieved from the target org, the missing values are merged in, and it
is deployed back, so a value the upstream package or the admin added later is never
dropped. Re-running is a no-op for values that already exist.

``default: True`` on at most one entry makes it the value set's default and clears
the flag on every other value. A field that reads the set still applies its own
field-level default formula first (see ``field_default.SetFieldDefaultValues``).

Vendored into this repo's ``tasks/`` package so MetaDeploy can import it. The
MetaDeploy worker container runs stock CumulusCI and has no
``cci_flowtoolkit_tasks`` installed, so a ``cci_flowtoolkit_tasks.*`` class_path
raises ImportError mid install for the subscriber. Keep this file in sync with
``cci-flowtoolkit-tasks/cci_flowtoolkit_tasks/global_value_set.py``.

Register in ``cumulusci.yml``::

    tasks:
        add_npc_contact_record_type:
            class_path: tasks.global_value_set.AddGlobalValueSetEntries
            options:
                api_names:
                    - "%%%NAMESPACE%%%Contact_Record_Type"
                entries:
                    - fullName: PersonAccount
                      label: PersonAccount
                      default: True

Usage::

    cci task run add_npc_contact_record_type --org npc_subscriber
    cci task run add_npc_contact_record_type --org feature_npc -o managed False   # namespaced dev org
"""

from __future__ import annotations

from cumulusci.core.exceptions import TaskOptionsError
from cumulusci.core.utils import process_bool_arg, process_list_arg
from cumulusci.tasks.metadata_etl import MetadataSingleEntityTransformTask
from cumulusci.utils.xml.metadata_tree import MetadataElement


class AddGlobalValueSetEntries(MetadataSingleEntityTransformTask):
    entity = "GlobalValueSet"
    task_options = {
        "api_names": {
            "description": "List of Global Value Set API names to affect. Namespace tokens "
            "(%%%NAMESPACE%%%) are injected the same way as in add_picklist_entries.",
            "required": True,
        },
        "entries": {
            "description": "List of values to add. Each needs 'fullName' (the API name) and "
            "optionally 'label' (defaults to fullName) and 'default' (True on at most one "
            "entry; it becomes the set's default and every other value's flag is cleared).",
            "required": True,
        },
        **MetadataSingleEntityTransformTask.task_options,
    }

    def _init_options(self, kwargs):
        super()._init_options(kwargs)
        self.entries = process_list_arg(self.options["entries"])
        for entry in self.entries:
            if "fullName" not in entry: raise TaskOptionsError("The 'fullName' key is required on every entry.")
        if sum(1 for entry in self.entries if process_bool_arg(entry.get("default", False))) > 1: raise TaskOptionsError("Only one default value is allowed.")

    def _transform_entity(self, metadata: MetadataElement, api_name: str):
        for entry in self.entries: self._add_entry(metadata, api_name, entry)
        return metadata

    def _add_entry(self, metadata: MetadataElement, api_name: str, entry: dict):
        full_name = entry["fullName"]
        label = entry.get("label") or full_name
        default = process_bool_arg(entry.get("default", False))

        if metadata.find("customValue", fullName=full_name):
            self.logger.warning(f"Value {full_name} already exists on {api_name}.")
        else:
            self._insert_value(metadata, full_name, label, default)

        if not default: return
        for value in metadata.findall("customValue"):
            flag = value.find("default")
            if flag is None: flag = value.insert_after(value.find("fullName"), "default")
            flag.text = "true" if value.find("fullName").text == full_name else "false"

    def _insert_value(self, metadata: MetadataElement, full_name: str, label: str, default: bool):
        """customValue elements must stay ahead of description/masterLabel/sorted, so insert after the last one."""
        existing = metadata.findall("customValue")
        element = metadata.insert_after(existing[-1], "customValue") if existing else metadata.insert(0, "customValue")
        element.append("fullName", text=full_name)
        element.append("default", text=str(default).lower())
        element.append("label", text=label)
        self.logger.info(f"Adding value {full_name} to {metadata.find('masterLabel').text if metadata.find('masterLabel') else 'the value set'}.")
