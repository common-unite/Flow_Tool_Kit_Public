# Styling Design Blocks with CSS Design Tokens

Every color, font size, radius, shadow, and spacing value in the Form (Design Block)
component reads a CSS design token - a custom property named `--ftk-site-*`. You can
restyle every block on your site at once from your site's CSS, without touching any
block's configuration.

## Where to put overrides

In Experience Builder, open **Theme → Edit CSS** and define tokens on `:root`:

```css
:root {
    --ftk-site-brand-override: #7526e3;
    --ftk-site-radius: 6px;
    --ftk-site-card-pad: 32px;
    --ftk-site-weight-heavy: 700;
}
```

Every design block on the site picks these up immediately. Anything you do not set
keeps the component's built-in design.

## Precedence: who wins

1. **Values set in Experience Builder win.** If an editor picked a Brand Color or a
   Card Background on a specific block, that block keeps it - your CSS supplies the
   default for every block that did not make an explicit choice.
2. **Your site CSS wins over the built-in defaults.**
3. **Dark sections re-tune some ink and line tokens** so text stays readable on dark
   backgrounds; that context styling is part of the component's design.

## The `-override` tokens

A few base tokens end in `-override` - use that exact name for these:

| Token | Controls | Default |
|---|---|---|
| `--ftk-site-brand-override` | Brand color everywhere (buttons, icons, accents) | Your site's `--dxp-g-brand`, else `#0176d3` |
| `--ftk-site-white-override` | The "paper" white used on dark surfaces | `#ffffff` |
| `--ftk-site-font-override` | Button font stack | SLDS site font |
| `--ftk-site-ease-override` | Hover/motion easing | `200ms cubic-bezier(0.22, 0.61, 0.36, 1)` |
| `--ftk-site-shadow-sm/md/lg/xl-override` | The four elevation tiers | SLDS global shadows |
| `--ftk-site-texture-color-override` | Background texture line color | `rgba(5, 7, 15, 0.06)` |

Every other token is set by its own name, exactly as listed below.

## Common recipes

```css
/* Rebrand: one color drives buttons, icon tiles, gradients, and hover chrome */
:root { --ftk-site-brand-override: #b3282d; }

/* Softer, flatter cards */
:root {
    --ftk-site-radius: 8px;
    --ftk-site-shadow-raised: none;
    --ftk-site-hairline-border: 1px solid #d8d8d4;
}

/* Tighter vertical rhythm */
:root {
    --ftk-site-card-pad: 24px;
    --ftk-site-grid-gap: 16px;
    --ftk-site-buttons-gap: 32px;
    --ftk-site-header-gap: 40px;
}

/* Larger editorial type */
:root {
    --ftk-site-h2-size: clamp(32px, 5vw, 48px);
    --ftk-site-subheading-size: 19px;
    --ftk-site-body-leading: 1.75;
}
```

## Token reference

### Palette and inks

| Token | Controls |
|---|---|
| `--ftk-site-accent` | Accent color (defaults to the brand) |
| `--ftk-site-card-bg` | Card fill for every card surface style |
| `--ftk-site-gold` | Warning/highlight accents (timeline warning ring) |
| `--ftk-site-heading-ink` | Heading text color |
| `--ftk-site-ink` / `-soft` / `-muted` | Body text inks, strongest to lightest |
| `--ftk-site-ink-accent` | Accented inline text (links, emphasis) |
| `--ftk-site-ink-inverse` / `-soft` / `-muted` | Text on dark surfaces, strongest to lightest |
| `--ftk-site-warning-ink` | Warning text (timeline states) |
| `--ftk-site-facts-label-ink` / `--ftk-site-facts-value-ink` | Facts rows label/value inks |

### Lines, chrome, shadows

| Token | Controls |
|---|---|
| `--ftk-site-hairline-border` | Card outlines (full border shorthand, e.g. `1px solid #ddd`) |
| `--ftk-site-line` / `--ftk-site-line-border` / `--ftk-site-line-ring` | Structural dividers, tracks, and rings on light sections |
| `--ftk-site-line-inverse` | The same structures on dark sections |
| `--ftk-site-veil` / `--ftk-site-veil-line` | Translucent panel fills and their edges |
| `--ftk-site-shine` | The shine-sweep highlight gradient |
| `--ftk-site-shadow-raised(-hover)` | Elevated card shadow and its hover state |
| `--ftk-site-shadow-deep(-hover)` | Deep drop shadow surface |
| `--ftk-site-shadow-soft` / `-gradient` / `-inset(-hover)` | Top bar, gradient card, and inset surface shadows |

### Typography

| Token | Controls |
|---|---|
| `--ftk-site-h1-size` | Hero heading |
| `--ftk-site-h2-size` | Call-to-action and callout headings |
| `--ftk-site-h3-size` | Section headings |
| `--ftk-site-title-size` | Showcase title |
| `--ftk-site-card-title-size` | Card titles |
| `--ftk-site-subheading-size` | Subheadings and lead paragraphs |
| `--ftk-site-quote-size` / `--ftk-site-price-size` | Quote text, pricing figure |
| `--ftk-site-stat-size` / `--ftk-site-stat-inline-size` | Stat numbers, large and inline |
| `--ftk-site-button-size` | Button labels |
| `--ftk-site-text-xs/sm/md/lg` | The four supporting text tiers |
| `--ftk-site-weight-regular/medium/semibold/bold/heavy` | The five weight roles (400-800) |
| `--ftk-site-heading-leading` / `--ftk-site-body-leading` | Heading and body line-height |
| `--ftk-site-caps-tracking` / `--ftk-site-display-tracking` | Caps-label and display-heading letter spacing |

### Radii and spacing

| Token | Controls |
|---|---|
| `--ftk-site-radius` | The main card/image radius |
| `--ftk-site-radius-sm/md/lg` | Buttons, tiles, and large panels |
| `--ftk-site-radius-pill` / `-round` / `-shell` | Pills, circles, and the inset page shell |
| `--ftk-site-card-pad` | Interior padding of every card family |
| `--ftk-site-grid-gap` / `--ftk-site-split-gap` | Card grids; two-column split layouts |
| `--ftk-site-button-gap` / `--ftk-site-buttons-gap` | Gap between buttons; space above the button row |
| `--ftk-site-header-gap` | Space between a section header and its content |
| `--ftk-site-pad-top/right/bottom/left` | Section padding (also settable per block in the Builder) |
| `--ftk-site-pad-mobile` / `--ftk-site-inset-gutter` | Mobile edge padding; inset-shell gutter |

Values you set in a block's property panel (colors, alignment, spacing pickers) are
intentionally stronger than these tokens for that block, so editors' explicit choices
always survive a site-wide restyle.
