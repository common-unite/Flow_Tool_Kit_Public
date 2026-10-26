# Compare Survey Rounds With Campaigns

> Upcoming release. Send the same survey more than once, one Campaign per round, and compare the rounds on the Form Analytics tab.

## The pattern

One Form Template is the survey. Each time you send it is a round, and each round is a Campaign.

| Thing | What it is |
|---|---|
| The survey | One Form Template. Its questions, pages and sections never change between rounds. |
| A round | One Campaign that points at that Form Template. A start-of-season survey, a mid-season survey and an end-of-season survey are three Campaigns. |
| A response | One Form Submission, carrying the Campaign it came from. |
| An answer | One Form Submission Answer per question, carrying the same Campaign. |

Do not clone the Form Template for a new round. A clone is a different survey, and its answers are kept apart.

A Campaign is optional. A survey sent with no Campaign still collects answers and still shows on Form Analytics. Its answers are counted under **No campaign**.

## Set up a round

1. Build the survey once as a Form Template. Set its Conversion Type to **Survey**, or add the **Submission Answers** Conversion Rule under another type.
2. Create a Campaign for the round, or clone the Campaign of the last round.
3. Give the Campaign a **Start Date**. Rounds are put in order by Start Date. A Campaign with no Start Date is placed by the day it was created.
4. Set the Campaign's **Form Template** lookup to the survey. See [Campaign Integration](../campaign-integration.md).
5. Add the people you are surveying as Campaign Members, if you know who they are, and send them the form with the Campaign Id.
6. For the next round, repeat from step 2 with a new Campaign and the same Form Template.

A round can change the wording around the survey, such as a title that names the season, through the Campaign and [Pre-fill Templates](../prefill-templates.md). The questions stay the same.

## What happens when someone answers

1. The form loads from the Campaign Id, and the Form Submission carries that Campaign in its **Campaign** field. The round an answer belongs to is read from that field: a submission whose Campaign is blank is counted under **No campaign**.
2. The submission converts. Where your conversion creates Campaign Members, the member's status follows the submission. See [Submission Conversion](../submission-conversion.md).
3. Once conversion completes, one Form Submission Answer is written per question, each carrying the submission's Campaign.
4. The Recalculate Results job counts the answers. It stores one result per question for the survey as a whole, and one per question for each Campaign.

The same person can answer every round. Each round is its own Form Submission under the same Form Template.

## Read one round

1. Open the **Form Analytics** tab and choose the survey in **Form Template**.
2. Choose a round in **Campaign**. The list holds the Campaigns this survey has answers for, oldest first, and **No campaign** when some answers carry none.
3. Every chart, every question's numbers and every list of written answers now count that round only.

Choose **All** to go back to every answer.

## Compare the rounds

Open the **Compare** tab. Each Campaign is a column, oldest first.

| Column | What it shows |
|---|---|
| Question | Each scored question, in the form's order. |
| A column per Campaign | The question's Average Score on 5 and its Favorable share in that round. |
| Change, first to latest | The latest round's number less the first round's. |

A question that was not answered in a round leaves that round's place blank. A question with no score, such as a date or a written answer, is not listed.

A survey needs answers from two Campaigns before there is anything to compare.

## Scores that compare across rounds

Every scored answer carries a **Score (5 Point)**: the question's lowest option counts as 1 and its highest as 5. A round can be compared with another even when a question's scores were changed between them, because the Recalculate Results job gives every answer the score its form sets now.

**Favorable** is the share of answers that scored above the middle of the question's scale.

## Open Form Analytics from another record

A button or link on any object can open Form Analytics on a survey, a round and a view. Lightning keeps only address parameters that start with `c__`.

| Parameter | Value |
|---|---|
| `c__recordId` | The Form Template Id. |
| `c__campaign` | A Campaign Id of that survey, or `none` for the answers with no Campaign. Optional. |
| `c__view` | `compare`, `type` or `results`. Leave it out to open on By question. Optional. |

Example, from a Campaign whose Form Template lookup is filled:

```
/lightning/n/FlowToolKit__Form_Results?c__recordId={!Campaign.FlowToolKit__Form_Template__c}&c__campaign={!Campaign.Id}
```

A value that is not a Campaign of that survey is ignored, and the page opens on every answer.

## Limits

* Rounds compare as groups. Comparing one person's answers from round to round is not part of this release.
* Only scored questions appear on Compare.
* The Compare tab shows up to twelve Campaigns.
* Numbers on Compare, and each question's Responses, Average Score and Favorable, are stored results. They update about two minutes after a response's answers are written, or at once with **Refresh results**. The charts read the answers directly.
