# Testing

Prefer resolved behavior over a generated object's internal shape. Repository
helpers live in `packages/mix/test/helpers/testing_utils.dart`; widget-state
helpers live alongside them in `widget_state_test_helper.dart`. Downstream,
pump real scopes and use the app's testing utilities; these helpers are not a
public package API.

## Resolution and tokens

`resolvesTo(expected, context: ...)` matches Resolvable or Prop values.
Use `MockBuildContext(tokens:, orderOfModifiers:)` for scoped values and
ordering. `MockSpec` / `MockStyle` cover simple test doubles.

### Token Resolution

```dart
test('Tokens resolve with custom context', () {
  const primary = ColorToken('primary');
  final tokenProp = Prop.token(primary);

  final context = MockBuildContext(
    tokens: {primary: const Color(0xFF2196F3)},
  );

  expect(tokenProp, resolvesTo(const Color(0xFF2196F3), context: context));
});
```

Use `TestToken<T>` when no concrete token subtype exists for the value under test:

```dart
const custom = TestToken<MyValue>('custom');
final context = MockBuildContext(tokens: {custom: myValue});
```


## Merge behavior

Plain Prop values replace: `Prop.value(100.0).mergeProp(Prop.value(200.0))`
resolves to 200.0. Mixed values accumulate fields:

### Merge Behavior: Accumulation

`Prop.mix(...)` values accumulate by merging Mix value objects field-by-field:

```dart
test('Prop<V> with Mix values - accumulation strategy', () {
  final prop1 = Prop.mix(EdgeInsetsGeometryMix.only(left: 8.0));
  final prop2 = Prop.mix(EdgeInsetsGeometryMix.only(right: 16.0));

  final merged = prop1.mergeProp(prop2);

  expect(
    merged,
    resolvesTo(const EdgeInsets.only(left: 8.0, right: 16.0)),
  );
});
```


Also verify base styler reuse and a later override through resolved specs:

```dart
final base = BoxStyler().width(100).padding(.left(8));
final merged = base.merge(BoxStyler().width(200).padding(.right(16)));
final spec = merged.resolve(MockBuildContext()).spec;
expect(spec.constraints, BoxConstraints.tightFor(width: 200));
expect(spec.padding, const EdgeInsets.only(left: 8, right: 16));
expect(base.resolve(MockBuildContext()).spec.padding, const EdgeInsets.only(left: 8));
```

Tests inside the package may inspect `$padding` / `$constraints` with
`resolvesTo`. Consumer tests should favor public rendering behavior.

## Generated modifiers

```dart
final modifier = OpacityModifierMix(opacity: 0.8);
expect(modifier, resolvesTo(const OpacityModifier(0.8)));

final context = MockBuildContext(
  orderOfModifiers: [OpacityModifier, PaddingModifier],
);
```

Use current generated `*ModifierMix` names, not removed `*Attribute` classes or
scope-data wrappers. For ordering changes, assert wrapper nesting with a real
widget test as well as the resolved list. For interaction changes, exercise
activation and state priority with the widget-state helpers.

## Widget Testing

`pumpWithMixScope` takes the widget as its first positional argument:

```dart
testWidgets('Box renders with style', (tester) async {
  const primary = ColorToken('primary');

  await tester.pumpWithMixScope(
    Box(
      style: BoxStyler().color(primary()).padding(.all(16)),
      child: const Text('Hello'),
    ),
    tokens: {primary: Colors.blue},
  );

  expect(find.text('Hello'), findsOneWidget);
});
```


`pumpMaterialApp` is also available when Material context is required. Token
expectations need an explicit context or a pumped scope; plain token Props do
not resolve in an empty mock. `ContextToken` fallbacks are a separate case.

## What to cover

- Replacement versus field accumulation, including collisions and nullable inputs.
- Token resolution and missing/wrong-type values when changing token boundaries.
- Generated public calls and annotation contracts when changing generation.
- Focus/keyboard/interaction state when changing Pressable or variant behavior.
- Widget bounds for layout changes; avoid treating a harness assertion as a golden diff.

Use the narrow package check while iterating, then the repository-required
commands from [development workflow](development-workflow.md). Prose-only edits
need link and diff checks rather than new implementation-mirroring tests.
