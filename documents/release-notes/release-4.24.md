# Release 4.24

Lookup fields read as names instead of record Ids, PDFs respect page logic and a new Do Not Print flag, and the date picker speaks the user's language.

- **Lookup fields show the record's name, not its Id** (#582, #588): on the review screen and in the Form Submission PDF, a lookup now displays the related record's name. This covers values the respondent picked, values that arrived through pre-fill, and submissions an internal user opens later for review. In the rare case where the name cannot be retrieved, guests see the field omitted rather than a meaningless Id.
- **Hidden pages no longer print** (#583): a page hidden by Form Template Page conditional logic is now excluded from the PDF, matching what the respondent actually saw. Template preview PDFs still show every page by design.
- **New Do Not Print setting** (#584): Form Template Pages and Page Sections gain a **Do Not Print** checkbox that leaves that page or section out of the PDF even when it is visible on screen. Use it for instructions, acknowledgements, or internal-only content. The setting is on the page and section layouts, and on the Section Settings panel.
- **PDF appearance and fixes** (#585): the printed submission now uses one consistent typeface throughout including the page header and footer strips, with clearer field labels and cleaner value boxes. Section headings no longer sit flush against the first field beneath them, page footers appear on pages that have a footer, and stray characters in a few layout classes are gone.
- **Date picker calendar translates** (#586): month names and day-of-week headings in the date/time picker now follow the user's Salesforce language instead of always appearing in English.

Admins: load your public form pages - including any embedded form URLs - once after upgrading; the first visit pays the component compile so a real visitor doesn't.
