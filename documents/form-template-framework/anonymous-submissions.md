# Anonymous Submissions

The **Anonymous** checkbox on a Form Submission lets a respondent answer without being named on the record. Answers stay. Names, contact details, addresses and links to people are cleared. This page explains what the checkbox does, what it can and cannot promise, and the business process to follow when a survey must be truly anonymous.

> Unreleased. Planned for the next release.

## What the checkbox does

Add the **Anonymous** field (Form Submission object) to a form like any other field. A label such as "Submit anonymously" near the top of the survey works well.

When a respondent ticks it:

- The **Primary Contact (Default)**, **Alternate Contact** and **Organization Details** sections hide, and their values clear.
- Every save of the submission clears what names the respondent: first, middle and last names, email, phones, job title and profile photo for both people; both addresses; company, company email, company phone and website; and the Account, Contact 1, Contact 2 and Lead 2 lookups. Contact 1 Last Name, Contact 2 Last Name and Company read **Anonymous**.
- Demographic answers (birthdate, age, gender, race and ethnicity, pronouns, preferred language, salutation), contact preferences and every other answer are kept.
- **Submitted By** reads **Anonymous**.
- The record's **Owner** follows the template's **Default Owner** setting, as for any submission. The default, Template Owner, keeps the respondent from owning it.
- Conversion skips Contact 1, Contact 2, Lead 1, Lead 2 and the Account. No confirmation email is sent.
- If the template adds respondents to a campaign, the submission is linked to one shared Lead named **Anonymous** (Lead Source **FlowToolKit Anonymous**). That Lead is the campaign member, so the campaign still counts every response. Do not convert this Lead. If someone does, the next anonymous submission creates a fresh one.

The clearing is done by the flow **Form Submission (Before Save → Clear Anonymous Identity)**, which is active when the package is installed. It runs on every save, so it covers forms, the API and data loads. Because a before-save flow clears the values before the record is written, nothing it clears on the first save reaches the record's field history.

Your organization controls this flow. Leave it active to enforce anonymity. To change what is cleared, override it with your own copy. To turn the clearing off, deactivate it: the Anonymous checkbox still hides the identifying sections and still skips creating Contacts and Leads, but the values a respondent sends are kept.

## Who is anonymous to whom

How anonymous a response is depends on who fills in the form.

| Respondent | Created By on the submission | Anonymous to staff who read the data | Anonymous to a system administrator |
|---|---|---|---|
| A guest on a public Experience Cloud site | The site's guest user, the same for every response | Yes | Yes |
| A signed-in Experience Cloud user (customer or partner) | That user | No: Created By names them | No |
| An internal Salesforce user | That user | No: Created By names them | No |

**Salesforce always records the signed-in user as Created By, and no package can change that.** Apex cannot write the Created By field. An org can unlock it only through the **Set Audit Fields upon Record Creation** setting, which is meant for data migration, works only when a record is first created, and needs an administrator to opt in. For a signed-in respondent, the checkbox makes the record confidential, not anonymous: the answers no longer carry their name, but the platform still knows who saved them.

Other traces of a signed-in respondent remain:

- **Last Modified By** names whoever saved the record last.
- **Files** they upload keep them as the file's creator.
- **Login history**, **debug logs** and **Event Monitoring** (where licensed) record their activity.
- **Form Submission History.** The package tracks history on the Account, Contact 1, Contact 2, Lead 1 and Lead 2 lookups. If a submission already held a person before it became anonymous (a record created for that person ahead of time, a saved draft, or an edit by staff), the history keeps the earlier value.
- **Save progress, autosave and resume links.** A partial save creates the submission as the respondent, and a resume link is emailed to their address.

## Business process for truly anonymous surveys

When the organization promises respondents anonymity, collect the survey through a guest-only site so that no signed-in user is ever recorded.

1. **Publish the survey on a public Experience Cloud site.** Follow the [Guest Forms Quickstart](../how-to-guides/guest-forms-quickstart.md). Every response is created by the site's single guest user.
2. **Send everyone the same link.** Use the site link to the Form Template, never a personal pre-filled link or a link opened from a Contact. A personal link ties the response to the person before the checkbox can act.
3. **Send internal staff and portal members to the guest link too.** A signed-in Salesforce user who opens a public site link is a guest on that site, so the response is not tied to their login. Do not put the anonymous survey inside the internal app or on a site page that requires login.
4. **Turn off saving partway through.** On the Form Template, leave **Allow Save Progress**, **Enable Autosave** and **Send Save Progress Email** unchecked. A partial save is made by whoever is filling in the form, and a resume link is emailed to a named address.
5. **Leave file uploads off,** unless respondents are told that a file they upload can identify them.
6. **Keep the Anonymous checkbox on the form.** It still clears anything a respondent types into an identifying field, and it links the response to the shared anonymous Lead for campaign reporting.
7. **Do not add field history tracking** to identifying Form Submission fields in the subscriber org.
8. **Tell respondents what anonymous means.** For example: "Your answers are not linked to your name or contact details." Do not promise that no system record of the visit exists: Salesforce may still log request details such as a network address.

### Embedding on your own website

To put the anonymous survey on the organization's public website rather than an Experience Cloud page, embed it so that it runs as the site's guest user. An embed that signs the visitor in records them as Created By, like any signed-in user.

## Related pages

- [Survey Mode](survey-mode.md)
- [Survey Results](survey-results.md)
- [Campaign Integration](campaign-integration.md)
- [Submission Conversion](submission-conversion.md)
- [Guest Forms Quickstart](../how-to-guides/guest-forms-quickstart.md)
