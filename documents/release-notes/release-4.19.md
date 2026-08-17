# Release 4.19


A focused fix release, one day after 4.18.

- **Read-only lookups no longer start forms** (#546): a Form Template lookup using the Start New Form override stands down whenever the field is effectively read only - whether set in the form builder or because the user lacks edit rights on the record or field. The field falls back to the standard read-only lookup display.
- **Icons are one component everywhere** (#547): stats-mode icon backdrops had kept an oversized legacy padding (a 116px pane around a large icon) while cards used the settled proportions. One shared icon implementation now serves every block - a stat icon at any size renders identically to a card icon.
- **Searchable dropdowns no longer type "undefined"** (#548): a 4.17 regression from the rich-text label work made the search input in selectors (most visibly the icon picker) display the literal text "undefined" while typing. Every searchable dropdown is fixed by the one change.

Admins: load your public form pages once after upgrading - the first visit pays the component compile so a real visitor doesn't.
