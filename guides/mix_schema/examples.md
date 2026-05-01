# Mix JSON Schema — Normative Examples

Status: **v1.0 Draft**
Normative: these examples are part of the v1.0 contract. A compliant canonicalizer MUST produce the canonical forms shown here from the sugar inputs shown alongside. A compliant parser MUST accept both.

Sibling files: [`spec.md`](./spec.md), [`registry.json`](./registry.json), [`error-codes.json`](./error-codes.json), [`schema.v1.json`](./schema.v1.json).

Covered:

1. Animated button — state variants, implicit animation, directive on token.
2. Responsive grid item — breakpoint + orientation variants.
3. Form input — named + state + context variants, text directives, token refs.
4. Themed card (dark mode) — token refs + `onDark` + shadows.
5. Composite widget — `flexbox` with partial variant contribution.

Conventions in this file:
- Each example shows **sugar** (what a producer typically emits) and **canonical** (post-canonicalization form).
- Hosts must supply tokens referenced here through `MixScope` or an inline bundle.

---

## 1. Animated button

**What it shows:** `PressableBox`, implicit animation, `onHovered` changes color via token + directive, `onPressed` scales down, child `StyledText` uses a token-based text style.

### Sugar (producer output)

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "PressableBox",
    "style": {
      "spec": "box",
      "props": {
        "padding": { "value": { "horizontal": 24, "vertical": 12 } },
        "decoration": { "value": {
          "color":        { "token": "color.primary" },
          "borderRadius": { "value": { "all": 8 } }
        } }
      },
      "variants": [
        { "when": "onHovered", "style": { "spec": "box", "props": {
            "decoration": { "value": {
              "color": { "token": "color.primary",
                         "directives": [{ "op": "lighten", "amount": 8 }] }
            } }
        } } },
        { "when": "onPressed", "style": { "spec": "box",
            "modifiers": [
              { "modifier": "scale", "props": { "x": 0.96, "y": 0.96 } }
            ]
        } }
      ],
      "animation": { "kind": "ease", "duration": 200 }
    },
    "child": {
      "widget": "StyledText",
      "text":   "Add to cart",
      "style": { "spec": "text", "props": {
        "style": { "value": {
          "color":      { "token": "color.onPrimary" },
          "fontWeight": { "value": "w600" },
          "fontSize":   { "token": "double.buttonLabel" }
        } }
      } }
    }
  }
}
```

### Canonical form

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "root": {
    "child": {
      "style": {
        "props": {
          "style": { "value": {
            "color":      { "token": "color.onPrimary" },
            "fontSize":   { "token": "double.buttonLabel" },
            "fontWeight": { "value": "w600" }
          } }
        },
        "spec": "text"
      },
      "text":   "Add to cart",
      "widget": "StyledText"
    },
    "style": {
      "animation": { "duration": 200, "kind": "ease" },
      "props": {
        "decoration": { "value": {
          "borderRadius": { "value": {
            "bottomLeft":  { "value": 8.0 },
            "bottomRight": { "value": 8.0 },
            "topLeft":     { "value": 8.0 },
            "topRight":    { "value": 8.0 }
          } },
          "color": { "token": "color.primary" }
        } },
        "padding": { "value": {
          "bottom": { "value": 12.0 },
          "left":   { "value": 24.0 },
          "right":  { "value": 24.0 },
          "top":    { "value": 12.0 }
        } }
      },
      "spec": "box",
      "variants": [
        { "style": { "props": {
            "decoration": { "value": {
              "color": {
                "directives": [{ "amount": 8, "op": "lighten" }],
                "token":      "color.primary"
              }
            } }
          }, "spec": "box" },
          "when": "onHovered" },
        { "style": { "modifiers": [
            { "modifier": "scale", "props": {
              "x": { "value": 0.96 },
              "y": { "value": 0.96 }
            } }
          ], "spec": "box" },
          "when": "onPressed" }
      ]
    },
    "widget": "PressableBox"
  },
  "schema": "1.0.0"
}
```

**Notes.**
- `padding` shorthand `{ horizontal, vertical }` expanded to `{ top, left, right, bottom }`.
- `borderRadius` shorthand `{ all }` expanded to four corners.
- Every leaf wrapped in `{ "value": ... }`.
- Object keys lexically sorted.
- Empty optional fields omitted (no explicit `"variants": []` anywhere).

---

## 2. Responsive grid item

**What it shows:** breakpoint-driven padding and font size; orientation variant tweaks alignment.

### Sugar

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "Box",
    "style": {
      "spec": "box",
      "props": {
        "padding": { "value": { "all": 8 } },
        "alignment": { "value": { "x": -1.0, "y": -1.0 } }
      },
      "variants": [
        { "when": { "context": "breakpoint", "token": "breakpoint.tablet" },
          "style": { "spec": "box", "props": {
            "padding": { "value": { "all": 16 } }
          } } },
        { "when": { "context": "breakpoint", "token": "breakpoint.desktop" },
          "style": { "spec": "box", "props": {
            "padding": { "value": { "all": 24 } }
          } } },
        { "when": { "context": "orientation", "value": "landscape" },
          "style": { "spec": "box", "props": {
            "alignment": { "value": { "x": 0.0, "y": 0.0 } }
          } } }
      ]
    },
    "child": {
      "widget": "StyledText",
      "text":   "Tile",
      "style": { "spec": "text", "props": {
        "style": { "value": { "fontSize": { "token": "double.body" } } }
      } }
    }
  }
}
```

**Canonical diffs vs sugar:**
- `padding.all: 8` → `{ top/left/right/bottom: { "value": 8.0 } }`.
- `alignment.x/y` stays as-is (already canonical `{x, y}` form).
- Later variants win: at tablet+landscape width, `padding.all: 16` overrides base *and* alignment becomes `{0, 0}`.

### Merge behaviour

Given the tablet-landscape state, the resolved spec is:
- `padding.top/left/right/bottom = 16` (tablet variant wins over base).
- `alignment = { x: 0, y: 0 }` (orientation variant wins over base).

---

## 3. Form input

**What it shows:** named + state + context variants stacked on the same node, text directive at spec level, multiple token namespaces.

### Sugar

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "PressableBox",
    "style": {
      "spec": "box",
      "props": {
        "padding": { "value": { "horizontal": 12, "vertical": 10 } },
        "decoration": { "value": {
          "color":        { "token": "color.surface" },
          "borderRadius": { "value": { "all": 6 } },
          "border":       { "value": { "all": { "token": "borderSide.input" } } }
        } }
      },
      "variants": [
        { "when": { "named": "danger" }, "style": { "spec": "box", "props": {
            "decoration": { "value": {
              "border": { "value": { "all": {
                "value": { "color": { "token": "color.danger" }, "width": { "value": 2.0 } }
              } } }
            } }
        } } },
        { "when": "onFocused", "style": { "spec": "box", "props": {
            "decoration": { "value": {
              "border": { "value": { "all": {
                "value": { "color": { "token": "color.accent" }, "width": { "value": 2.0 } }
              } } }
            } }
        } } },
        { "when": "onDisabled", "style": { "spec": "box", "props": {
            "decoration": { "value": {
              "color": { "token": "color.surface",
                         "directives": [{ "op": "desaturate", "amount": 40 }] }
            } }
        } } },
        { "when": { "context": "platform", "value": "iOS" }, "style": {
            "spec": "box", "props": {
              "decoration": { "value": {
                "borderRadius": { "value": { "all": 10 } }
              } }
          } } }
      ]
    },
    "child": {
      "widget": "StyledText",
      "text":   "email",
      "style": {
        "spec": "text",
        "props": {
          "style": { "value": {
            "fontSize":  { "token": "double.caption" },
            "color":     { "token": "color.onSurfaceMuted" }
          } }
        },
        "textDirectives": [{ "op": "uppercase" }]
      }
    }
  }
}
```

**Notes.**
- Array order = precedence. `onDisabled` appearing after `danger` means disabled state overrides danger colour but keeps danger border width.
- `textDirectives` applies to the rendered string (not the style prop).
- Per-corner border sugar: `"border": { "value": { "all": { "token": "borderSide.input" } } }` — `all` is a structured-literal shorthand; canonical expands to `{ top, left, right, bottom }`.

---

## 4. Themed card (dark mode)

**What it shows:** token-heavy styling, `onDark` variant, shadow token, directive-only value on a variant (tweak inherited colour).

### Sugar

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "Box",
    "style": {
      "spec": "box",
      "props": {
        "padding": { "value": { "all": 16 } },
        "decoration": { "value": {
          "color":        { "token": "color.card" },
          "borderRadius": { "value": { "all": { "token": "radius.md" } } },
          "boxShadow":    { "token": "shadow.card" }
        } }
      },
      "variants": [
        { "when": "onDark", "style": { "spec": "box", "props": {
            "decoration": { "value": {
              "color":     { "token": "color.card",
                             "directives": [{ "op": "darken", "amount": 20 }] },
              "boxShadow": { "token": "shadow.cardDark" }
            } }
        } } }
      ]
    },
    "child": {
      "widget": "StyledText",
      "text":   "Card title",
      "style": { "spec": "text", "props": {
        "style": { "token": "text.cardTitle" }
      } }
    }
  }
}
```

**Notes.**
- `boxShadow` uses the `shadow.*` token namespace (returns `List<Shadow>`).
- `text.cardTitle` token replaces the entire `TextStyle` — no structured merge because the leaf resolves as a whole value.
- The `onDark` variant does not replace the decoration color; it applies a directive pipeline to the inherited token. At render time, the consumer resolves `color.card`, then applies `darken(20)`.

---

## 5. Composite widget (`flexbox` + partial variant)

**What it shows:** composite spec with sub-styles, variant contributing to only one half of the composite, modifier at the composite root.

### Sugar

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "RowBox",
    "style": {
      "spec": "flexbox",
      "box": {
        "spec": "box",
        "props": {
          "padding": { "value": { "all": 12 } },
          "decoration": { "value": {
            "color":        { "token": "color.surface" },
            "borderRadius": { "value": { "all": 8 } }
          } }
        }
      },
      "flex": {
        "spec": "flex",
        "props": {
          "mainAxisAlignment":  { "value": "spaceBetween" },
          "crossAxisAlignment": { "value": "center" },
          "spacing":            { "token": "space.sm" }
        }
      },
      "variants": [
        { "when": { "context": "breakpoint", "token": "breakpoint.desktop" },
          "style": {
            "spec": "flexbox",
            "flex": {
              "spec": "flex",
              "props": {
                "spacing": { "token": "space.lg" }
              }
            }
          }
        }
      ],
      "modifiers": [
        { "modifier": "padding", "props": {
            "padding": { "value": { "horizontal": 16 } }
        } }
      ]
    },
    "children": [
      { "widget": "StyledText", "text": "Left",
        "style": { "spec": "text", "props": {
          "style": { "token": "text.body" }
        } } },
      { "widget": "StyledText", "text": "Right",
        "style": { "spec": "text", "props": {
          "style": { "token": "text.body" }
        } } }
    ]
  }
}
```

**Notes.**
- Sub-styles carry only `spec` + `props`. No nested `variants`/`modifiers`/`animation` inside `box` or `flex`.
- The desktop variant contributes only a `flex` sub-style; the `box` half is untouched (partial composite override).
- `modifiers` at the composite root wraps the whole composite widget; sub-styles cannot carry modifiers.
- Variant's contributed style uses `spec: "flexbox"` to match the enclosing spec; a `spec: "box"` contribution would be a `variant.spec-mismatch` error.

---

## Conformance-suite role

Each example above corresponds to one or more conformance tests:

| Example | Tests |
|---|---|
| 1 Animated button | sugar → canonical, canonical → Mix objects, render-equivalence after parse/serialize round-trip |
| 2 Responsive grid | variant merge at multiple context conditions (tablet, desktop, landscape, tablet+landscape) |
| 3 Form input | variant precedence (array order), `textDirectives` application, `borderSide.*` token resolution |
| 4 Themed card | directive-only value, token with list type (`shadow.*`), structured equality under dark theme |
| 5 Composite | partial composite override, modifier on composite root, `variant.spec-mismatch` negative case |
| I1 Pressable with `style` | `additionalProperties` rejection on `Widget_Pressable` — `widget.field-forbidden` |
| I2 Token without namespace | `TokenPath` pattern rejection — `token.form-invalid` |
| I3 Variant spec mismatch | `Style_box` / `Style_text` discriminated-union rejection — `variant.spec-mismatch` |
| I4 Animation kind mismatch | `AnimationNode` `additionalProperties` rejection for preset + `curve` — `animation.curve-forbidden` |
| I5 Null value literal | `ValueObject` `not: { type: null }` rejection — `value.null-forbidden` |

Negative examples (to be added): each error code in the error registry should have at least one failing example. That work lives with the reference validator.

---

## Invalid examples (negative cases)

Each example below fails validation. The listed rule and error code indicate why. Conformance tests SHOULD exercise at least one failing input for every error code in [`error-codes.json`](./error-codes.json); these five cover the most common categories.

### I1. Pressable with `style`

Violates: §WidgetNode / §Pressable — "Pressable is a pure behavior wrapper with no style of its own."
Error code: `widget.field-forbidden`

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "Pressable",
    "style":  { "spec": "box" },
    "child":  { "widget": "StyledText", "text": "x" }
  }
}
```

### I2. Token without namespace

Violates: §Tokens / Validation rule — "A token reference MUST have the form `namespace.name` — it MUST contain at least one `.`."
Error code: `token.form-invalid`

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "Box",
    "style": {
      "spec": "box",
      "props": {
        "padding": { "token": "primary" }
      }
    }
  }
}
```

### I3. Variant with mismatched spec

Violates: §Semantics / Variant matching — "A variant's contributed style MUST use the same `spec` as the enclosing StyleNode."
Error code: `variant.spec-mismatch`

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "Box",
    "style": {
      "spec": "box",
      "variants": [
        { "when": "onHovered", "style": { "spec": "text" } }
      ]
    }
  }
}
```

### I4. Animation kind mismatch

Violates: §Animation — "When `kind` is `curve`, the `curve` field is REQUIRED; when `kind` is a preset name, `curve` is FORBIDDEN."
Error code: `animation.curve-forbidden`

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "Box",
    "style": {
      "spec": "box",
      "animation": { "kind": "ease", "duration": 200, "curve": "easeIn" }
    }
  }
}
```

### I5. Null value literal

Violates: §Canonical rules — "Null is rejected as a Value literal; `{ \"value\": null }` is a validation error."
Error code: `value.null-forbidden`

```json
{
  "$schema": "https://mix.dev/schema/v1.json",
  "schema":  "1.0.0",
  "root": {
    "widget": "Box",
    "style": { "spec": "box", "props": { "padding": { "value": null } } }
  }
}
```
