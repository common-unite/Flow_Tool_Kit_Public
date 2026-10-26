"""CCI task that loads the Form Analytics demo (#900) and drives it through conversion.

The loader saves every response as Draft. This task then submits them (all in one
update by default, now that the dispatcher of #902 runs a bulk load through) and
waits for them to convert. Once every response is Complete it starts the results
recalculation, so the Analytics tab and the campaign comparison have numbers.

``batch_size`` submits a few at a time instead, for an org still on a package
older than 4.50; ``round_timeout`` is how long one round may take.

Register in ``cumulusci.yml``::

    tasks:
        load_form_analytics_demo:
            class_path: tasks.form_analytics_demo.LoadFormAnalyticsDemo
"""

import time

from cumulusci.core.exceptions import CumulusCIException
from cumulusci.tasks.apex.anon import AnonymousApexTask

TEMPLATE_NAME = "Program Outcomes Survey"
LOAD_PATH = "datasets/dev/load_form_analytics_demo.apex"
RECALCULATE_PATH = "datasets/dev/recalculate_form_analytics_demo.apex"
IS_DRAFT = "FlowToolKit__Status__c = 'Draft'"
NOT_COMPLETE = "FlowToolKit__Conversion_Status__c != 'Complete'"
SUBMIT_APEX = """
List<FlowToolKit__Form_Submission__c> drafts = [SELECT Id FROM FlowToolKit__Form_Submission__c WHERE FlowToolKit__Form_Template__r.Name = '{template}' AND FlowToolKit__Status__c = 'Draft' ORDER BY CreatedDate LIMIT {size}];
for (FlowToolKit__Form_Submission__c record : drafts) record.FlowToolKit__Status__c = 'Submitted';
update drafts;
"""


class LoadFormAnalyticsDemo(AnonymousApexTask):
    task_docs = "Load the Form Analytics demo, submit its responses a few at a time until all convert, then recalculate results (#900)."
    task_options = {
        "batch_size": {"description": "Responses submitted per round. Default 0, all at once; 4 for an org on a package older than 4.50 (#902)."},
        "round_timeout": {"description": "Seconds to wait for one round to convert before giving up. Default 420: the 90 responses take about 3 minutes with lock retries."},
    }

    def _init_options(self, kwargs):
        kwargs.setdefault("path", LOAD_PATH)
        super()._init_options(kwargs)
        self.batch_size = int(self.options.get("batch_size") or 0)
        self.round_timeout = int(self.options.get("round_timeout") or 420)

    def _run_task(self):
        self._execute(self._process_apex_from_path(LOAD_PATH))
        rounds = 0
        while self._count(IS_DRAFT):
            waiting = self._count(NOT_COMPLETE)
            size = self.batch_size or waiting
            self._execute(SUBMIT_APEX.format(template=TEMPLATE_NAME, size=size))
            rounds += 1
            self._wait_for(max(0, waiting - size))
            self.logger.info(f"Round {rounds}: {self._count(IS_DRAFT)} responses left to submit")
        self._execute(self._process_apex_from_path(RECALCULATE_PATH))
        self.logger.info(f"Form Analytics demo converted in {rounds} rounds; results recalculation started")

    def _execute(self, apex):
        result = self.tooling._call_salesforce(method="GET", url=f"{self.tooling.base_url}executeAnonymous", params={"anonymousBody": self._prepare_apex(apex)})
        self._check_result(result)

    def _count(self, condition):
        return self.sf.query(f"SELECT COUNT() FROM FlowToolKit__Form_Submission__c WHERE FlowToolKit__Form_Template__r.Name = '{TEMPLATE_NAME}' AND {condition}")["totalSize"]

    def _wait_for(self, target):
        deadline = time.time() + self.round_timeout
        while self._count(NOT_COMPLETE) > target:
            if time.time() > deadline: raise CumulusCIException(f"Form Analytics demo: conversion stopped with more than {target} responses not Complete; see #902")
            time.sleep(5)
