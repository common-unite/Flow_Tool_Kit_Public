# Release 4.21

A focused follow-up to 4.20, same day.

- **Formula fields as page conditions** (#573): Form Template Page conditional logic now offers formula fields in the condition builder. They had been excluded as a side effect of a filter aimed at writable fields. Resumed submissions evaluate against formula values loaded with the record; to make a formula-driven page condition react while the respondent is still typing, flag the formula's input fields with **Recalculate Formulas** in the form builder - the recalculated value then flows through the same path as a keystroke and page visibility updates immediately.

Admins: load your public form pages once after upgrading - the first visit pays the component compile so a real visitor doesn't.
