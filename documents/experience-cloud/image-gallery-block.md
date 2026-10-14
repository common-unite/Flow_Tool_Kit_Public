# Image Gallery Block

An Image Gallery is a Design Block type that shows one list of photos in one of four arrangements. A visitor can open any photo at full size and move through the set, or open every photo with its caption in one window.

Add a Design Block to the page, choose **Image Gallery** as its type, and add photos.

## Settings

| Setting | Where | What it does |
|---|---|---|
| Photos | Photos | The list. Each photo has a **Photo** and a **Caption**. The photo is chosen the way every Design Block image is: **Asset** (an Asset File), **URL** (a full address, `resource:Name/path.png` for packaged art, or a merge field such as `{{Photo_URL__c}}` that the record fills in), or **CMS** (the content key of a published CMS image, pasted from the CMS workspace, since a list cannot have a picker per photo). The caption is shown under the photo in All photos and in the viewer, and is read to screen readers as the photo's description. List order is display order. |
| Layout | Photos, once the list has a photo | Mosaic, Grid, Masonry or Filmstrip. Visitors never see a layout switcher. |
| Thumbnails | Photos, once the list has a photo | On or off. Shows or hides the row of small photos along the bottom of the viewer. |
| Section Label, Heading, Subheading | Heading | The shared heading every Design Block type has, drawn above the photos. Merge fields work. Leave a line empty to leave it off. |
| Card Style | Card Style | The frame around the gallery. Elevated by default. Clean removes the frame, so the photos run to the section's own edges. |
| Badges, Buttons, Footnote, Background, Border, Spacing, Motion, Visibility | the shared panes | As on every other type. |

## The four layouts

Every layout has a wide version and a narrow one. The block switches by its own width, under 640 px, so a gallery placed in a narrow page column draws the narrow version on a desktop too.

| Layout | Wide | Narrow |
|---|---|---|
| Mosaic | The first 5 photos in a 4 by 2 frame, the first photo filling the left half. A "View all N photos" button sits inside the bottom right corner. | The first photo full width with a "1 / N" count and the View all button over it, then three small photos under it. The third carries a "+N" that opens All photos. |
| Grid | The first 6 photos in 3 columns. With more than 6, the sixth carries a "+N" that opens All photos. | The first 4 photos in 2 columns of squares, the fourth carrying the "+N". |
| Masonry | The first 9 photos in 3 columns, each at its own shape. A "View all N photos" button below. | The first 6 photos in 2 columns, with a full width View all button below. |
| Filmstrip | Every photo in one row that scrolls sideways and snaps to each photo, with a View all link and previous and next buttons under it. | One photo at a time with the next peeking in from the right. "Swipe for more" on the left and a View all link on the right. |

A layout draws the photos it has. With fewer photos than it shows, the frame closes up; there is never an empty cell, and the layout never changes to another one.

## What a visitor can do

**Open a photo.** Any photo opens the viewer at that photo: the whole photo on a dark screen, a counter ("3 / 12"), its caption, and previous and next buttons that wrap around from the last photo to the first. The left and right arrow keys move too, as does a sideways swipe on a phone. With Thumbnails on, a row of small photos runs along the bottom with the current one marked; choosing one jumps to it. **Esc** or the Close button closes the viewer and puts focus back on the photo that opened it.

**See every photo.** Every View all control and every "+N" opens **All photos**: a window with every photo and its caption. Choosing a photo there opens the viewer over the window. Esc closes the viewer first and All photos second. The viewer's own **View all** control (not shown on a phone) opens All photos, or returns to it when it is already open behind.

A Grid with six photos or fewer has no View all control of its own, since every photo is already on the page; the viewer's View all still opens All photos.

## Accessibility

- Every photo on the page is a button, reachable with Tab and opened with Enter or Space, named by its caption. A photo without a caption is named "Photo 3 of 12".
- The viewer is a dialog, named by its counter and caption. Focus stays inside it while it is open.
- Previous, Next, Close and the thumbnails all carry labels. Every label is a custom label and can be reworded or translated (see [Custom Labels](../advanced-topics/custom-labels.md), "Site Design Block, Image Gallery").
- When the visitor's device asks for reduced motion, there is no hover zoom and the thumbnail row does not scroll smoothly.

## Notes

- An Asset File is served to a site visitor without any further setup. A URL is used as given, so a photo on another server needs to be reachable by the visitor.
- Captions and the heading accept merge fields on a record page, like every other Design Block text.
- The viewer uses the browser's own dialog, so it can sit above the All photos window. In an org with Lightning Web Security turned off, where that dialog is not available, the same viewer opens inside a window instead.
- Sizes follow the gallery's design: a Mosaic frame is 450 px tall, Grid photos are 4:3, Filmstrip photos 300 by 220 px. Colours follow the site's brand and accent, as every Design Block does.
