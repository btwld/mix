# mix_tailwinds Future Work

Roadmap items for future development. These extend the current Tailwind CSS support.

---

## Animation Extensions

### `motion-safe` / `motion-reduce` Variants

Tailwind's accessibility variants for reduced motion preferences.

**Implementation Notes:**
- Check `MediaQuery.disableAnimations` in Flutter
- Apply animation only when `motion-safe:` prefix is used and animations are enabled
- Skip animation when `motion-reduce:` prefix is used or system has reduced motion enabled

**Example:**
```dart
Div(
  classNames: 'motion-safe:transition motion-safe:duration-300 motion-reduce:transition-none',
  child: Text('Respects user motion preferences'),
)
```

---

## Implemented Features

### Transform Utilities (Implemented)

Tailwind's transform utilities are now fully supported. Transforms build a single composite Matrix4 in Tailwind's fixed order (translate → rotate → scale), ensuring order-independent results.

**Supported Classes:**

| Category | Tokens |
|----------|--------|
| Scale | `scale-0`, `scale-50`, `scale-75`, `scale-90`, `scale-95`, `scale-100`, `scale-105`, `scale-110`, `scale-125`, `scale-150` |
| Rotate | `rotate-0`, `rotate-1`, `rotate-2`, `rotate-3`, `rotate-6`, `rotate-12`, `rotate-45`, `rotate-90`, `rotate-180` + negatives (`-rotate-*`) |
| Translate | `translate-x-{spacing}`, `translate-y-{spacing}` + negatives |

**Usage Example:**
```dart
Div(
  classNames: 'hover:scale-105 transition duration-300',
  child: Text('Hover to scale'),
)
```

**Key Behaviors:**
- `scale-105 rotate-45` produces the same result as `rotate-45 scale-105` (order independent, matching Tailwind)
- Single Transform widget wrapping for performance
- Works with all prefix variants: responsive (`md:scale-110`), state (`hover:scale-105`), dark mode (`dark:rotate-3`)

---

## Deferred Features

### Transform Extensions (YAGNI)

These rare transform features are deferred until needed:

- `scale-x-*`, `scale-y-*` - Independent axis scaling
- `skew-x-*`, `skew-y-*` - Skew transforms
- `origin-*` - Transform origin (default center covers 90%+ of use cases)

---

## Priority Order

1. **motion-safe/motion-reduce** - Accessibility compliance
