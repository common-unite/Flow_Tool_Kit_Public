# Release 4.6

A fast-follow fixing cloning, which had been quietly damaging templates since January.

## 🛠 Cloning a Form Template now produces an exact copy (#333, #336)

Cloning was rebuilding templates incorrectly, and in two cases losing content outright. Five separate faults, all fixed:

- **Pages were merging into one.** A multi-page template cloned down to a single page holding every section from the whole template. This was the source of the "random sections" a clone appeared to invent, and it was the most damaging of the five.
- **Cloning could fail outright.** If the template's Pre-fill Template carried a unique identifier, the clone stopped with a `DUPLICATE_VALUE` error and produced nothing.
- **An unwanted page and section were added.** Every clone gained a "Primary Contact Information" page with a default field set that the source never had. Because a clone was indistinguishable from a hand-built template, cloning a clone repeated it, so the clutter accumulated with each generation.
- **Hidden pages were dropped.** Pages marked Hide, or restricted to an audience the person cloning did not match, were silently left out of the copy.
- **The header was replaced.** A template with no header picked up the default demo header on being cloned.

A clone is now exactly what you cloned, and it records which template it came from, so you can trace a copy back through its lineage.

## 🆕 Source Id is available for URL parameter mapping (#335)

`Source Id` can now be mapped to a URL parameter, alongside the pre-fill mapping that already supported it. Point a parameter at it and the form loads under that source record's overrides, so one link can select which configuration a form presents. An unrecognised id simply applies no overrides rather than failing.
