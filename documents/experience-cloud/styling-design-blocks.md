# Styling Design Blocks

The Form (Design Block) component takes its look from three places, strongest first:

1. **The block's own settings in Experience Builder.** A Brand Color, Card Background or padding an editor picked on a block always wins for that block.
2. **Your site's Theme panel.** The brand color and fonts you set for the site flow into every block, with no CSS.
3. **Site CSS.** For anything the Theme panel does not cover, a short list of `-override` tokens restyles every block at once.

## Brand every block from the Theme panel

Set your site's colors and fonts in Experience Builder's **Theme** panel and every design block follows. The blocks read the values the site publishes as styling hooks, on Aura and LWR sites alike:

| Theme panel value | Site hook | What follows it in the blocks |
|---|---|---|
| Brand color | `--dxp-g-brand` | Buttons, icon tiles, gradients and hover chrome |
| Brand color, first shade | `--dxp-g-brand-1` | The accent: gradient stops, checklist ticks, highlights |
| Body font | `--dxp-s-body-font-family` | All block text |
| Heading font | `--dxp-g-heading-font-family` | Block headings |

This is the recommended way to brand blocks. Nothing else is needed for most sites.

## Site CSS: the override tokens

When the Theme panel does not cover something, set these tokens in the site's CSS. In Experience Builder open **Theme**, then **Edit CSS**, and define them on `:root`:

```css
:root {
    --ftk-site-brand-override: #7526e3;
    --ftk-site-part-gap-override: 24px;
}
```

Use the exact `-override` name. Each base token reads its override first, then the Theme panel hook, then the built-in default.

| Token | Controls | Default |
|---|---|---|
| `--ftk-site-brand-override` | The brand color, replacing the Theme panel's | Theme brand color, else `#0176d3` |
| `--ftk-site-accent-override` | The accent color | Theme brand color's first shade, else the brand |
| `--ftk-site-font-override` | The font for all block text | Theme body font, else the SLDS font |
| `--ftk-site-heading-font-override` | The font for block headings | Theme heading font, else the body font |
| `--ftk-site-white-override` | The "paper" white used on dark surfaces | `#ffffff` |
| `--ftk-site-part-gap-override` | The one gap between a block's parts: header, stats, buttons, footnote | `28px` |
| `--ftk-site-ease-override` | Hover and motion easing | `200ms cubic-bezier(0.22, 0.61, 0.36, 1)` |
| `--ftk-site-shadow-sm-override`, `-md-`, `-lg-`, `-xl-override` | The four elevation tiers | SLDS global shadows |
| `--ftk-site-texture-color-override` | Background texture line color | `rgba(5, 7, 15, 0.06)` |
| `--ftk-site-scrim-override` | The tint laid over a photo behind white copy | The brand, darkened |

Dark sections re-tune some ink and line colors so text stays readable on dark backgrounds; that is part of the block's design, not something site CSS changes.

## Older tokens (deprecated)

Before the Theme panel wiring, the blocks documented a longer list of `--ftk-site-*` tokens. **They still work**: a site that sets one keeps its value. They are deprecated: no new tokens join this list. For new styling, use the Theme panel, a block's own settings, or the override tokens above.

These are set by their own name on `:root`. Where a block's own setting covers the same thing, the block's setting wins for that block.

### Palette and inks

| Token | Controls |
|---|---|
| `--ftk-site-accent` | Accent color; prefer `--ftk-site-accent-override` |
| `--ftk-site-card-bg` | Card fill for every card surface style |
| `--ftk-site-gold` | Warning and highlight accents (timeline warning ring) |
| `--ftk-site-heading-ink` | Heading text color |
| `--ftk-site-ink`, `--ftk-site-ink-soft`, `--ftk-site-ink-muted` | Body text inks, strongest to lightest |
| `--ftk-site-ink-accent` | Accented inline text (links, emphasis) |
| `--ftk-site-ink-inverse`, `--ftk-site-ink-inverse-soft`, `--ftk-site-ink-inverse-muted` | Text on dark surfaces, strongest to lightest |
| `--ftk-site-warning-ink` | Warning text (timeline states) |
| `--ftk-site-facts-label-ink`, `--ftk-site-facts-value-ink` | Facts rows label and value inks |
| `--ftk-site-check-fill` | Fill behind a checklist bullet's tick |

### Lines, chrome, shadows

| Token | Controls |
|---|---|
| `--ftk-site-hairline-border` | Card outlines (full border shorthand, for example `1px solid #ddd`) |
| `--ftk-site-line`, `--ftk-site-line-border`, `--ftk-site-line-ring` | Dividers, tracks and rings on light sections |
| `--ftk-site-line-inverse` | The same structures on dark sections |
| `--ftk-site-veil`, `--ftk-site-veil-line` | Translucent panel fills and their edges |
| `--ftk-site-shine` | The shine-sweep highlight gradient |
| `--ftk-site-shadow-raised`, `--ftk-site-shadow-raised-hover` | Elevated card shadow and its hover state |
| `--ftk-site-shadow-deep`, `--ftk-site-shadow-deep-hover` | Deep drop shadow and its hover state |
| `--ftk-site-shadow-soft`, `--ftk-site-shadow-gradient`, `--ftk-site-shadow-inset`, `--ftk-site-shadow-inset-hover` | Top bar, gradient card, and inset surface shadows |

### Typography

| Token | Controls |
|---|---|
| `--ftk-site-h1-size` | Hero heading |
| `--ftk-site-h2-size` | Call-to-action and callout headings |
| `--ftk-site-h3-size` | Section headings |
| `--ftk-site-title-size` | A hero's Body Title |
| `--ftk-site-card-title-size` | Card titles |
| `--ftk-site-subheading-size` | Subheadings and lead paragraphs |
| `--ftk-site-quote-size`, `--ftk-site-price-size` | Quote text, pricing figure |
| `--ftk-site-stat-size`, `--ftk-site-stat-inline-size` | Stat numbers, large and inline |
| `--ftk-site-button-size` | Button labels |
| `--ftk-site-text-xs`, `-sm`, `-md`, `-lg` | The four supporting text tiers |
| `--ftk-site-weight-regular`, `-medium`, `-semibold`, `-bold`, `-heavy` | The five weight roles (400 to 800) |
| `--ftk-site-heading-leading`, `--ftk-site-body-leading` | Heading and body line height |
| `--ftk-site-caps-tracking`, `--ftk-site-display-tracking` | Caps-label and display-heading letter spacing |

### Radii and spacing

| Token | Controls |
|---|---|
| `--ftk-site-radius` | The main card and image radius |
| `--ftk-site-radius-sm`, `-md`, `-lg` | Buttons, tiles and large panels |
| `--ftk-site-radius-pill`, `--ftk-site-radius-round`, `--ftk-site-radius-shell` | Pills, circles, and the inset page shell |
| `--ftk-site-card-pad` | Interior padding of every card family |
| `--ftk-site-grid-gap` | Gap between cards in a grid |
| `--ftk-site-button-gap`, `--ftk-site-buttons-gap` | Gap between buttons; space above the button row |
| `--ftk-site-header-gap` | Space between a section header and its content |
| `--ftk-site-body-gap`, `--ftk-site-stats-gap`, `--ftk-site-bullets-gap` | Space under a hero's body copy, inline stats and bullets |
| `--ftk-site-buttons-below`, `--ftk-site-badges-gap` | Space under the button row; space under the badges |
| `--ftk-site-footnote-gap` | Space above the footnote |
| `--ftk-site-pad-top`, `-right`, `-bottom`, `-left` | Section padding (also set per block in the Builder) |
| `--ftk-site-pad-mobile`, `--ftk-site-inset-gutter` | Mobile edge padding; inset-shell gutter |

`--ftk-site-split-gap`, listed here before, was never read by any block and is gone from this page.
