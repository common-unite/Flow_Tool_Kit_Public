# Survey Results

Use **Form Analytics** in the Flow Tool Kit app, or a Form Template record's **Analytics** tab, to review answers and charts.

> Available in [Release 4.49](../release-notes/release-4.49.md).

## Enable answer reporting

Open **Form Template Settings → Form Analytics** and turn on **Enable Form Analytics**. Eligible questions create **Form Submission Answer** records when conversion is **Complete** or **Bypassed**. With the switch off, a new submission creates no reporting answers and the template's **Analytics** tab is hidden.

![Enable Form Analytics and Target Score in Form Template Settings](../screenshots/890-form-analytics-setting.png)

The **Survey Section** switch controls respondent presentation independently. Reporting can include questions in Custom mode sections; [Question Reporting](../form-configuration/question-reporting.md) controls which questions contribute.

## Open results from a template

Open the template's **Analytics** tab. If it is hidden by the available width, use **More → Analytics**. The tab appears when **Enable Form Analytics** is on.

![The Analytics tab shows satisfaction and usefulness charts for a completed Training Evaluation response](../screenshots/890-analytics-tab.png)

## Explore responses and charts

**By question** displays individual question charts. Use the **Question** selector to narrow the view. **By type** groups the reporting view by question type, and **Question results** provides stored per-question metrics.

Each chart's **View report** link opens the underlying Salesforce report with its template and question filters supplied. In the training example, the satisfaction chart and its report both show one **Very Satisfied** answer from the completed response.

In **Reports**, the **Form Template (Analytics)** folder contains **By Question**, **By Question Type**, and **Chart Data** folders. Chart Data reports can be empty when opened directly; use a chart's **View report** link to supply their filters.

## Change the chart view

Use **By question**, **By type**, and the **Question** selector to choose what to inspect. Open **View report** for the records behind a chart. Viewing or filtering a chart does not change recorded answers.

Configure question classification, reporting inclusion, and the saved chart choice in [Question Reporting](../form-configuration/question-reporting.md).

## Read the headline metrics

When stored metrics are available, interpret each against the scale of its questions:

| Metric | Meaning |
| --- | --- |
| Responses | Submissions with at least one answer |
| Average Score | Average across the form's 1–5 questions |
| Favorable | Share of answers scoring 4 or 5 on those 1–5 questions |
| Net Promoter Score | Percentage answering 9 or 10 minus the percentage answering 0–6 on the form's 0–10 questions |
| Target Score | An administrator's expected average, on a 1–5 scale |
| Score Gap | Average Score minus Target Score |

A question on a 0–10 scale keeps its own average in the question results and charts. Check each question's scale when comparing averages.

## Read question results

Stored **Question results** are calculated separately from the answer records used by report charts. A response's answers reach the charts at once. The stored numbers follow about two minutes later, when the template's results are worked out again on their own. **Refresh results**, beside **Print or save as PDF**, works them out now.

Shown blank questions and hidden questions are different. **No Response** represents eligible questions that were shown but left blank. A question the respondent never saw does not count as a shown blank answer. Setting a field's reporting inclusion to **Never** affects future answer creation; historical answers remain. See [reporting inclusion](../form-configuration/question-reporting.md#exclude-future-answers-with-never).

## Submit, convert, and recalculate

1. Submit the response and wait for its confirmation.
2. With **Enable Form Analytics** on, wait for conversion to be **Complete** or **Bypassed** and for eligible **Form Submission Answer** records to appear.
3. Open **Analytics → By question**, or a chart's **View report** link, to inspect the saved answers.
4. Stored results update about two minutes after the answers are written. However many responses arrive in that time, the template is worked out once, and only that template's answers are read. To see them sooner, choose **Refresh results** beside **Print or save as PDF**; the panel reloads when the numbers are ready.

**Results Last Changed** on the Form Template records when stored results last changed. A refresh that finds the same numbers leaves it as it was. Reloading a page or switching chart views does not work the results out again. **Refresh results** is offered to users who can write Form Template Results, which the Form Builder Admin permission set grants.

The [Recalculate Results action](../invocable-actions/form-submission-actions.md#recalculate-results) still works out every template at once, from an administrator-triggered or scheduled Flow. Keep a nightly run as a safety net. See [Survey Mode](survey-mode.md) for the respondent experience.
