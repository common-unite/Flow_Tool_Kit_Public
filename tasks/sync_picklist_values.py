"""CCI task that adds the package's picklist values to an org that is missing them (#696, #723).

New values on a managed picklist reach fresh installs only. An org that UPGRADES keeps the value
list it had (field picklists since Spring '18, global value sets since Summer '19), so every value
added to a restricted field after a client first installed is missing in that client's org.

This task reads the value lists from the package source that ships with the installer (the
frozen release tag), retrieves the matching picklist fields, record types and global value sets
from the org, adds only the values the org does not have, and deploys only the entities it
changed. It never removes, relabels, reorders, reactivates or changes a default. A value the org
already has, active or inactive, is left alone. Re-running is a no-op.

Scope:
    - every Picklist and MultiselectPicklist custom field under ``source_path``/objects on custom
      objects and standard objects, except custom metadata types (__mdt) and platform events (__e);
    - the record type picklist assignments of those fields, so a new value is selectable on each
      record type the package makes it available on;
    - every global value set under ``source_path``/globalValueSets.
    Fields that read a global value set are skipped; the set itself is synced.

Vendored into this repo's ``tasks/`` package so MetaDeploy can import it (the worker runs stock
CumulusCI without ``cci_flowtoolkit_tasks``). Keep in sync with
``cci-flowtoolkit-tasks/cci_flowtoolkit_tasks/sync_picklist_values.py``.

Register in ``cumulusci.yml``::

    tasks:
        sync_packaged_picklist_values:
            class_path: tasks.sync_picklist_values.SyncPackagedPicklistValues

Usage::

    cci task run sync_packaged_picklist_values --org <subscriber>
    cci task run sync_packaged_picklist_values --org <namespaced dev org> -o managed False
    cci task run sync_packaged_picklist_values --org <org> -o dry_run True     # report only
"""

from __future__ import annotations

import xml.etree.ElementTree as ElementTree
from pathlib import Path
from urllib.parse import unquote

from cumulusci.core.utils import process_bool_arg, process_list_arg
from cumulusci.tasks.metadata_etl.base import BaseMetadataTransformTask
from cumulusci.utils.xml.metadata_tree import parse

METADATA_NAMESPACE = "{http://soap.sforce.com/2006/04/metadata}"
NAMESPACE_TOKEN = "%%%NAMESPACE%%%"
PICKLIST_TYPES = {"Picklist", "MultiselectPicklist"}
DEFAULT_EXCLUDED_SUFFIXES = ["__mdt", "__e"]


def strip_namespace(name, prefix):
    """FlowToolKit__Form_Template__c and Form_Template__c are the same name to this task."""
    if prefix and name.startswith(prefix + "__"): return name[len(prefix) + 2:]
    return name


def tokenize(name):
    """Custom names get the namespace token; standard object names do not."""
    return name if not name.endswith("__c") else NAMESPACE_TOKEN + name


def child_text(element, tag):
    found = element.find(METADATA_NAMESPACE + tag)
    return found.text if found is not None and found.text is not None else None


def read_field_values(field_file):
    """(values, reads_global_value_set) for one field file, or None when the field is not a picklist."""
    root = ElementTree.parse(field_file).getroot()
    if child_text(root, "type") not in PICKLIST_TYPES: return None
    value_set = root.find(METADATA_NAMESPACE + "valueSet")
    if value_set is None: return None
    if value_set.find(METADATA_NAMESPACE + "valueSetName") is not None: return ([], True)
    definition = value_set.find(METADATA_NAMESPACE + "valueSetDefinition")
    if definition is None: return ([], False)
    values = []
    for value in definition.findall(METADATA_NAMESPACE + "value"):
        full_name = child_text(value, "fullName")
        if full_name is None: continue
        values.append({"fullName": full_name, "label": child_text(value, "label") or full_name})
    return (values, False)


def read_record_type_values(record_type_file):
    """{field name: [value fullName, ...]} for one record type file."""
    root = ElementTree.parse(record_type_file).getroot()
    assignments = {}
    for picklist in root.findall(METADATA_NAMESPACE + "picklistValues"):
        field_name = child_text(picklist, "picklist")
        if field_name is None: continue
        assignments[field_name] = [child_text(value, "fullName") for value in picklist.findall(METADATA_NAMESPACE + "values") if child_text(value, "fullName")]
    return assignments


def read_global_value_set(value_set_file):
    root = ElementTree.parse(value_set_file).getroot()
    values = []
    for value in root.findall(METADATA_NAMESPACE + "customValue"):
        full_name = child_text(value, "fullName")
        if full_name is None: continue
        values.append({"fullName": full_name, "label": child_text(value, "label") or full_name})
    return values


class SyncPackagedPicklistValues(BaseMetadataTransformTask):
    task_options = {
        "source_path": {"description": "Package source directory that holds objects/ and globalValueSets/. Default: force-app/main/default"},
        "exclude_object_suffixes": {"description": "Object API name suffixes to skip. Default: __mdt, __e"},
        "dry_run": {"description": "Report the missing values without deploying. Default: False"},
        **BaseMetadataTransformTask.task_options,
    }

    def _init_options(self, kwargs):
        super()._init_options(kwargs)
        self.source_path = Path(self.options.get("source_path") or "force-app/main/default")
        self.excluded_suffixes = process_list_arg(self.options.get("exclude_object_suffixes")) or DEFAULT_EXCLUDED_SUFFIXES
        self.dry_run = process_bool_arg(self.options.get("dry_run") or False)
        self._read_source()

    def _read_source(self):
        """Field values, record type assignments and global value sets as the package ships them."""
        self.source_fields = {}
        self.source_record_types = {}
        self.source_value_sets = {}
        objects_path = self.source_path / "objects"
        for object_path in sorted(objects_path.iterdir()) if objects_path.exists() else []:
            object_name = object_path.name
            if any(object_name.endswith(suffix) for suffix in self.excluded_suffixes): continue
            for field_file in sorted((object_path / "fields").glob("*.field-meta.xml")):
                field_values = read_field_values(field_file)
                if field_values is None or field_values[1]: continue
                self.source_fields[(object_name, field_file.name.replace(".field-meta.xml", ""))] = field_values[0]
            for record_type_file in sorted((object_path / "recordTypes").glob("*.recordType-meta.xml")):
                self.source_record_types[(object_name, record_type_file.name.replace(".recordType-meta.xml", ""))] = read_record_type_values(record_type_file)
        for value_set_file in sorted((self.source_path / "globalValueSets").glob("*.globalValueSet-meta.xml")):
            self.source_value_sets[value_set_file.name.replace(".globalValueSet-meta.xml", "")] = read_global_value_set(value_set_file)
        self.logger.info(f"Package source {self.source_path}: {len(self.source_fields)} picklist fields, {len(self.source_record_types)} record types, {len(self.source_value_sets)} global value sets.")

    def _get_entities(self):
        """Everything the source knows about on a retrieve; only what changed on the deploy."""
        if getattr(self, "changed_entities", None) is not None: return self.changed_entities
        fields = {f"{tokenize(object_name)}.{tokenize(field_name)}" for object_name, field_name in self.source_fields}
        record_types = set()
        for object_name, record_type_name in self.source_record_types:
            record_types.add(f"{tokenize(object_name)}.{record_type_name}")
            record_types.add(f"{tokenize(object_name)}.{NAMESPACE_TOKEN}{record_type_name}")
        value_sets = {NAMESPACE_TOKEN + name for name in self.source_value_sets}
        entities = {"CustomField": fields, "RecordType": record_types, "GlobalValueSet": value_sets}
        return {entity: names for entity, names in entities.items() if names}

    @property
    def namespace_prefix(self):
        return self.options.get("namespace_inject") if self.options.get("managed") else None

    def _transform(self):
        self.changed_entities = {}
        self.added_count = 0
        prefix = self.namespace_prefix
        deploy_objects = self.deploy_dir / "objects"
        for object_file in sorted((self.retrieve_dir / "objects").glob("*.object")):
            object_name = strip_namespace(object_file.stem, prefix)
            metadata = parse(str(object_file))
            changed = self._transform_fields(metadata, object_file.stem, object_name) | self._transform_record_types(metadata, object_file.stem, object_name)
            if not changed: continue
            deploy_objects.mkdir(parents=True, exist_ok=True)
            (deploy_objects / object_file.name).write_text(metadata.tostring(xml_declaration=True), encoding="utf-8")
        deploy_sets = self.deploy_dir / "globalValueSets"
        for value_set_file in sorted((self.retrieve_dir / "globalValueSets").glob("*.globalValueSet")):
            if not self._transform_value_set(parse(str(value_set_file)), value_set_file): continue
            deploy_sets.mkdir(parents=True, exist_ok=True)
        self.logger.info(f"{self.added_count} missing value(s) found across {sum(len(names) for names in self.changed_entities.values())} picklist(s).")

    def _record_change(self, entity, api_name):
        self.changed_entities.setdefault(entity, set()).add(api_name)

    def _transform_fields(self, metadata, org_object_name, object_name):
        changed = set()
        for field in metadata.findall("fields"):
            org_field_name = field.fullName.text
            source_values = self.source_fields.get((object_name, strip_namespace(org_field_name, self.namespace_prefix)))
            if not source_values: continue
            value_set = field.find("valueSet")
            definition = value_set.find("valueSetDefinition") if value_set is not None else None
            if definition is None: continue
            existing = {value.fullName.text for value in definition.findall("value")}
            missing = [value for value in source_values if value["fullName"] not in existing]
            if not missing: continue
            for value in missing:
                element = definition.append("value")
                element.append("fullName", text=value["fullName"])
                element.append("default", text="false")
                element.append("label", text=value["label"])
                self.logger.info(f"  + {org_object_name}.{org_field_name}: {value['fullName']}")
            self.added_count += len(missing)
            self._record_change("CustomField", f"{org_object_name}.{org_field_name}")
            changed.add(org_field_name)
        for field in list(metadata.findall("fields")):
            if field.fullName.text not in changed: metadata.remove(field)
        return bool(changed)

    def _transform_record_types(self, metadata, org_object_name, object_name):
        changed = set()
        for record_type in metadata.findall("recordTypes"):
            org_record_type_name = record_type.fullName.text
            source = self.source_record_types.get((object_name, strip_namespace(org_record_type_name, self.namespace_prefix)))
            if not source: continue
            for picklist in record_type.findall("picklistValues"):
                source_values = source.get(strip_namespace(picklist.picklist.text, self.namespace_prefix)) or source.get(picklist.picklist.text)
                if not source_values: continue
                existing = {unquote(value.fullName.text) for value in picklist.findall("values")}
                missing = [value for value in source_values if unquote(value) not in existing]
                for value in missing:
                    element = picklist.append("values")
                    element.append("fullName", text=value)
                    element.append("default", text="false")
                    self.logger.info(f"  + record type {org_object_name}.{org_record_type_name} / {picklist.picklist.text}: {unquote(value)}")
                if missing:
                    self.added_count += len(missing)
                    changed.add(org_record_type_name)
        for record_type in list(metadata.findall("recordTypes")):
            if record_type.fullName.text not in changed: metadata.remove(record_type)
        for name in changed: self._record_change("RecordType", f"{org_object_name}.{name}")
        return bool(changed)

    def _transform_value_set(self, metadata, value_set_file):
        org_name = value_set_file.stem
        source_values = self.source_value_sets.get(strip_namespace(org_name, self.namespace_prefix))
        if not source_values: return False
        existing = {value.fullName.text for value in metadata.findall("customValue")}
        missing = [value for value in source_values if value["fullName"] not in existing]
        if not missing: return False
        for value in missing:
            current = metadata.findall("customValue")
            element = metadata.insert_after(current[-1], "customValue") if current else metadata.insert(0, "customValue")
            element.append("fullName", text=value["fullName"])
            element.append("default", text="false")
            element.append("label", text=value["label"])
            self.logger.info(f"  + global value set {org_name}: {value['fullName']}")
        self.added_count += len(missing)
        self._record_change("GlobalValueSet", org_name)
        target = self.deploy_dir / "globalValueSets" / value_set_file.name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(metadata.tostring(xml_declaration=True), encoding="utf-8")
        return True

    def _run_task(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tempdir:
            self._create_directories(tempdir)
            self._retrieve()
            self._transform()
            if not self.changed_entities:
                self.logger.info("Every packaged picklist value is already in the org. Nothing to deploy.")
                return
            if self.dry_run:
                self.logger.info("Dry run: nothing deployed.")
                return
            self.return_values = {"added": self.added_count, "entities": {entity: sorted(names) for entity, names in self.changed_entities.items()}}
            self._post_deploy(self._deploy())
