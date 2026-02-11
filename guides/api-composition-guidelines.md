# Mix API Composition Guide (Concise Tutorial)

## 1) Core Principle

Prefer fluent chaining on Styler types for everyday composition.
- Reads left-to-right, succinct, and easy to reason about
- Example: `BoxStyler().size(200, 200)`; `StackStyler().alignment(Alignment.center).fit(StackFit.expand)`

---

## 2) Quick Reference

Box sizing
- Fixed square: `BoxStyler().size(200, 200)` or `BoxStyler(constraints: BoxConstraintsMix.square(200))`
- Fixed width/height: `BoxStyler().width(200).height(120)`
- Min/Max bounds: `BoxStyler().minWidth(100).maxWidth(300).minHeight(50)`
- Already have a Size: `BoxStyler(constraints: BoxConstraintsMix.size(const Size(200, 120)))`

Stack layout
- Chain properties: `StackStyler().alignment(Alignment.center).fit(StackFit.expand)`
- Short factory: `StackStyler.alignment(Alignment.center).fit(StackFit.expand)`
- Small constructor bundle: `StackStyler(alignment: Alignment.center, fit: StackFit.expand)`

Composition
- Reuse fragments: `final card = base.merge(elevated);`
- Everyday props: use chaining instead of merging multiple Styler instances

---

## 3) Decision Tree

- Need a fixed size (w×h)? → `BoxStyler().size(w, h)`
- Need a square? → `size(s, s)` or `constraints: BoxConstraintsMix.square(s)`
- Only min/max bounds? → `minWidth()/maxWidth()/minHeight()/maxHeight()`
- Already have a Size or constraints object? → Pass once via constructor
  - `BoxStyler(constraints: BoxConstraintsMix.size(size))`
- Combining reusable fragments (e.g., base + elevated)? → `merge()`
- Otherwise → Prefer chaining on the Styler

---

## 4) Code Examples (Before → After)

Example A — Square tile 200×200
- Before (verbose via merging):
```dart
final box = BoxStyler(constraints: BoxConstraintsMix.width(200))
  .merge(BoxStyler(constraints: BoxConstraintsMix.height(200)));
final stack = StackStyler(alignment: Alignment.center, fit: StackFit.expand);
```
- After (preferred chaining or focused factory):
```dart
final box = BoxStyler().size(200, 200);
final stack = StackStyler().alignment(Alignment.center).fit(StackFit.expand);
// or
final boxAlt = BoxStyler(constraints: BoxConstraintsMix.square(200));
```

Example B — Card composition (reusable fragments)
```dart
final base = BoxStyler().padding(EdgeInsetsGeometryMix.all(16));
final elevated = BoxStyler().borderRadius(BorderRadiusGeometryMix.circular(12));
final card = base.merge(elevated); // Use merge() when composing fragments
```

Example C — Min/Max constraints
```dart
final resizable = BoxStyler()
  .minWidth(120)
  .maxWidth(480)
  .minHeight(80);
```

Example D — You already have a Size
```dart
final size = const Size(240, 160);
final boxFromSize = BoxStyler(constraints: BoxConstraintsMix.size(size));
```

---

## 5) Testing Patterns

Keep tests clear and deterministic by favoring chaining and resolution checks.

Basic sizing/stack resolution
```dart
final box = BoxStyler().size(200, 200);
final stack = StackStyler().alignment(Alignment.center).fit(StackFit.expand);

expect(box.$constraints, resolvesTo(const BoxConstraints.tightFor(width: 200, height: 200), context: context));
expect(stack, resolvesTo(StackSpec(alignment: Alignment.center, fit: StackFit.expand), context: context));
```

Composed fragments
```dart
final base = BoxStyler().padding(EdgeInsetsGeometryMix.all(16));
final elevated = BoxStyler().borderRadius(BorderRadiusGeometryMix.circular(12));
final card = base.merge(elevated);

// Assert the resolved properties from the merged Styler
expect(card.$padding, resolvesTo(const EdgeInsets.all(16), context: context));
```

Tip
- Prefer chaining in tests for readability
- Use `merge()` in tests when verifying composition of reusable fragments
- Focus on resolved outcomes, not construction details

