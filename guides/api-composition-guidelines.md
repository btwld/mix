# Mix API Composition Guide (Concise Tutorial)

## 1) Core Principle

Prefer fluent chaining on Mix/Style types for everyday composition.
- Reads left-to-right, succinct, and easy to reason about
- Example: `BoxMix().size(200, 200)`; `StackMix().alignment(Alignment.center).fit(StackFit.expand)`

---

## 2) Quick Reference

Box sizing
- Fixed square: `BoxMix().size(200, 200)` or `BoxMix(constraints: BoxConstraintsMix.square(200))`
- Fixed width/height: `BoxMix().width(200).height(120)`
- Min/Max bounds: `BoxMix().minWidth(100).maxWidth(300).minHeight(50)`
- Already have a Size: `BoxMix(constraints: BoxConstraintsMix.size(const Size(200, 120)))`

Stack layout
- Chain properties: `StackMix().alignment(Alignment.center).fit(StackFit.expand)`
- Short factory: `StackMix.alignment(Alignment.center).fit(StackFit.expand)`
- Small constructor bundle: `StackMix(alignment: Alignment.center, fit: StackFit.expand)`

Composition
- Reuse fragments: `final card = base.merge(elevated);`
- Everyday props: use chaining instead of merging multiple Mix instances

---

## 3) Decision Tree

- Need a fixed size (w×h)? → `BoxMix().size(w, h)`
- Need a square? → `size(s, s)` or `constraints: BoxConstraintsMix.square(s)`
- Only min/max bounds? → `minWidth()/maxWidth()/minHeight()/maxHeight()`
- Already have a Size or constraints object? → Pass once via constructor
  - `BoxMix(constraints: BoxConstraintsMix.size(size))`
- Combining reusable fragments (e.g., base + elevated)? → `merge()`
- Otherwise → Prefer chaining on the Mix/Style

---

## 4) Code Examples (Before ➜ After)

Example A — Square tile 200×200
- Before (verbose via merging):
```dart
final box = BoxMix(constraints: BoxConstraintsMix.width(200))
  .merge(BoxMix(constraints: BoxConstraintsMix.height(200)));
final stack = StackMix(alignment: Alignment.center, fit: StackFit.expand);
```
- After (preferred chaining or focused factory):
```dart
final box = BoxMix().size(200, 200);
final stack = StackMix().alignment(Alignment.center).fit(StackFit.expand);
// or
final boxAlt = BoxMix(constraints: BoxConstraintsMix.square(200));
```

Example B — Card composition (reusable fragments)
```dart
final base = BoxMix().padding(EdgeInsetsMix.all(16));
final elevated = BoxMix().borderRadius(BorderRadiusMix.circular(12));
final card = base.merge(elevated); // Use merge() when composing fragments
```

Example C — Min/Max constraints
```dart
final resizable = BoxMix()
  .minWidth(120)
  .maxWidth(480)
  .minHeight(80);
```

Example D — You already have a Size
```dart
final size = const Size(240, 160);
final boxFromSize = BoxMix(constraints: BoxConstraintsMix.size(size));
```

---

## 5) Testing Patterns

Keep tests clear and deterministic by favoring chaining and resolution checks.

Basic sizing/stack resolution
```dart
final box = BoxMix().size(200, 200);
final stack = StackMix().alignment(Alignment.center).fit(StackFit.expand);

expect(box.$constraints, resolvesTo(const BoxConstraints.tightFor(width: 200, height: 200), context: context));
expect(stack, resolvesTo(StackSpec(alignment: Alignment.center, fit: StackFit.expand), context: context));
```

Composed fragments
```dart
final base = BoxMix().padding(EdgeInsetsMix.all(16));
final elevated = BoxMix().borderRadius(BorderRadiusMix.circular(12));
final card = base.merge(elevated);

// Assert the resolved properties from the merged Mix
expect(card.$padding, resolvesTo(const EdgeInsets.all(16), context: context));
```

Tip
- Prefer chaining in tests for readability
- Use `merge()` in tests when verifying composition of reusable fragments
- Focus on resolved outcomes, not construction details

