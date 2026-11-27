"""Unit tests for SyncPackagedPicklistValues (#1247: Duplicate label: Simple Mapping stopped an install).

Run with the CumulusCI interpreter from the repo root:
    "$HOME/Library/Application Support/pipx/venvs/cumulusci/bin/python" -m unittest discover -s tasks/tests -t .
"""

import logging
import unittest

from cumulusci.utils.xml.metadata_tree import fromstring

from tasks.sync_picklist_values import SyncPackagedPicklistValues

OBJECT = "Form_Template__c"
FIELD = "Conversion_Map_Flow_Contact1__c"
SOURCE_VALUES = [
    {"fullName": "Default", "label": "Default"},
    {"fullName": "FlowToolKit__testing_contact_override", "label": "Simple Mapping"},
]


def object_xml(field_values="", record_type_values=""):
    return f"""<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <fields>
        <fullName>FlowToolKit__{FIELD}</fullName>
        <type>Picklist</type>
        <valueSet><restricted>true</restricted><valueSetDefinition><sorted>false</sorted>
            <value><fullName>Default</fullName><default>true</default><label>Default</label></value>
            {field_values}
        </valueSetDefinition></valueSet>
    </fields>
    <recordTypes>
        <fullName>FlowToolKit__Standard</fullName>
        <picklistValues>
            <picklist>FlowToolKit__{FIELD}</picklist>
            <values><fullName>Default</fullName><default>true</default></values>
            {record_type_values}
        </picklistValues>
    </recordTypes>
</CustomObject>"""


def value_set_xml(values):
    return f"""<?xml version="1.0" encoding="UTF-8"?>
<GlobalValueSet xmlns="http://soap.sforce.com/2006/04/metadata">
    <customValue><fullName>Default</fullName><default>true</default><label>Default</label></customValue>
    {values}
    <masterLabel>Set</masterLabel>
</GlobalValueSet>"""


class FakeValueSetFile:
    def __init__(self, stem): self.stem, self.name = stem, stem + ".globalValueSet"


def make_task(tmp_path=None):
    """A task with its source already read, skipping CumulusCI's org and option setup."""
    task = object.__new__(SyncPackagedPicklistValues)
    task.options = {"managed": True, "namespace_inject": "FlowToolKit"}
    task.logger = logging.getLogger("sync_picklist_values_test")
    task.source_fields = {(OBJECT, FIELD): SOURCE_VALUES}
    task.source_record_types = {(OBJECT, "Standard"): {FIELD: ["Default", "FlowToolKit__testing_contact_override"]}}
    task.source_value_sets = {"Set": SOURCE_VALUES}
    task.changed_entities = {}
    task.added_count = 0
    task.deploy_dir = tmp_path
    return task


def field_value_names(metadata):
    return [value.fullName.text for value in metadata.findall("fields")[0].valueSet.valueSetDefinition.findall("value")]


class SyncPicklistValuesTest(unittest.TestCase):
    def assert_nothing_added(self, xml, expected_warning):
        task = make_task()
        metadata = fromstring(xml.encode())
        with self.assertLogs(task.logger, level="WARNING") as logs:
            changed = task._transform_fields(metadata, f"FlowToolKit__{OBJECT}", OBJECT)
        self.assertFalse(changed)
        self.assertEqual(task.added_count, 0)
        self.assertEqual(task.changed_entities, {})
        self.assertIn(expected_warning, "\n".join(logs.output))

    def test_field_value_without_namespace_prefix_is_not_added_again(self):
        xml = object_xml(field_values="<value><fullName>testing_contact_override</fullName><default>false</default><label>Simple Mapping</label></value>")
        self.assert_nothing_added(xml, "the org has it as testing_contact_override")

    def test_field_label_already_used_by_another_value_is_not_added(self):
        xml = object_xml(field_values="<value><fullName>My_Custom_Flow</fullName><default>false</default><label>Simple Mapping</label></value>")
        self.assert_nothing_added(xml, "its label 'Simple Mapping' is already used by My_Custom_Flow")

    def test_cunite_pbo_state_custom_simple_mapping_value_blocks_the_packaged_one(self):
        """The org from #1247: Default plus a custom value Form_Submission_Convert_Process_Contact_Simple labelled
        Simple Mapping; the packaged FlowToolKit__testing_contact_override (also Simple Mapping) is genuinely missing."""
        xml = object_xml(field_values="<value><fullName>Form_Submission_Convert_Process_Contact_Simple</fullName><default>false</default><label>Simple Mapping</label></value>")
        self.assert_nothing_added(xml, "FlowToolKit__testing_contact_override not added, its label 'Simple Mapping' is already used by Form_Submission_Convert_Process_Contact_Simple")

    def test_genuinely_missing_field_value_is_still_added(self):
        task = make_task()
        metadata = fromstring(object_xml().encode())
        self.assertTrue(task._transform_fields(metadata, f"FlowToolKit__{OBJECT}", OBJECT))
        self.assertEqual(field_value_names(metadata), ["Default", "FlowToolKit__testing_contact_override"])
        self.assertEqual(task.added_count, 1)

    def test_record_type_value_without_namespace_prefix_is_not_added_again(self):
        task = make_task()
        xml = object_xml(record_type_values="<values><fullName>testing_contact_override</fullName><default>false</default></values>")
        with self.assertLogs(task.logger, level="WARNING") as logs:
            changed = task._transform_record_types(fromstring(xml.encode()), f"FlowToolKit__{OBJECT}", OBJECT)
        self.assertFalse(changed)
        self.assertIn("the org has it as testing_contact_override", "\n".join(logs.output))

    def test_global_value_set_label_or_prefix_match_is_not_added(self):
        for values in ("<customValue><fullName>testing_contact_override</fullName><default>false</default><label>Simple Mapping</label></customValue>",
                       "<customValue><fullName>Other</fullName><default>false</default><label>Simple Mapping</label></customValue>"):
            task = make_task()
            with self.assertLogs(task.logger, level="WARNING"):
                self.assertFalse(task._transform_value_set(fromstring(value_set_xml(values).encode()), FakeValueSetFile("FlowToolKit__Set")))
            self.assertEqual(task.added_count, 0)


if __name__ == "__main__":
    unittest.main()
