# Testing

Testing patterns for Mix, adapted from `packages/mix/test/helpers/testing_utils.dart`.

## Core Philosophy

Testing in Mix focuses on **resolution testing**: verify what `Resolvable` types, `Prop` values, Mix value objects, Stylers, and modifier Mix classes resolve to in a `BuildContext`.

## Utilities

Core resolution utilities live in `packages/mix/test/helpers/testing_utils.dart`; widget-state helpers live in `packages/mix/test/helpers/widget_state_test_helper.dart`.

| Utility | Purpose |
|---------|---------|
| `resolvesTo<T>(expected, {context})` | Core matcher for `Resolvable` and `Prop` values |
| `MockBuildContext` | BuildContext with `MixScope` token and modifier-order support |
| `MockStyle<T>` | Universal test style wrapping any type |
| `MockSpec<T>` | Simple spec for test resolution |
| `pumpWithMixScope()` | Widget tester extension: pump a widget inside `MixScope` |
| `pumpMaterialApp()` | Widget tester extension: pump in `MaterialApp` |
| `TestToken<T>` | Test-only concrete `MixToken<T>` implementation |

## Testing Patterns

### Basic Prop Resolution

```dart
test('Props resolve to their values', () {
  final colorProp = Prop.value(Colors.red);

  expect(colorProp, resolvesTo(Colors.red));
});
```

### Mix Type Resolution

```dart
test('Mix types resolve to Flutter types', () {
  final radiusMix = BorderRadiusMix.all(Radius.circular(8.0));
  expect(radiusMix, resolvesTo(BorderRadius.circular(8.0)));

  final edgeInsetsMix = EdgeInsetsGeometryMix.all(16.0);
  expect(edgeInsetsMix, resolvesTo(const EdgeInsets.all(16.0)));
});
```

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

### Merge Behavior: Replacement

Regular `Prop<T>` sources use last-value-wins merge behavior:

```dart
test('Prop<T> merge - replacement strategy', () {
  final prop1 = Prop.value(100.0);
  final prop2 = Prop.value(200.0);
  final prop3 = Prop.value(300.0);

  final merged = prop1.mergeProp(prop2).mergeProp(prop3);

  expect(merged, resolvesTo(300.0));
});
```

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

### Generated Styler Resolution

Generated Stylers expose raw resolved fields with `$` prefixes and resolve to `StyleSpec<TSpec>`:

```dart
test('BoxStyler resolves props and spec values', () {
  final style = BoxStyler()
      .width(100)
      .padding(EdgeInsetsGeometryMix.all(16));

  expect(style.$constraints, resolvesTo(BoxConstraints.tightFor(width: 100)));
  expect(style.$padding, resolvesTo(const EdgeInsets.all(16)));

  final resolved = style.resolve(MockBuildContext());
  expect(resolved.spec.constraints, BoxConstraints.tightFor(width: 100));
  expect(resolved.spec.padding, const EdgeInsets.all(16));
});
```

### Styler Merge

```dart
test('BoxStyler merging combines replacement and accumulation fields', () {
  final base = BoxStyler()
      .width(100)
      .padding(EdgeInsetsGeometryMix.only(left: 8.0));

  final override = BoxStyler()
      .width(200)
      .padding(EdgeInsetsGeometryMix.only(right: 16.0));

  final merged = base.merge(override);

  expect(merged.$constraints, resolvesTo(BoxConstraints.tightFor(width: 200)));
  expect(
    merged.$padding,
    resolvesTo(const EdgeInsets.only(left: 8.0, right: 16.0)),
  );
});
```

### Modifier Mix Testing

```dart
test('modifier mix resolves to modifier', () {
  final modifier = OpacityModifierMix(opacity: 0.8);

  expect(modifier, resolvesTo(const OpacityModifier(0.8)));
});

test('modifier mix merging uses replacement for scalar props', () {
  final base = AspectRatioModifierMix(aspectRatio: 1.0);
  final override = AspectRatioModifierMix(aspectRatio: 2.0);

  final merged = base.merge(override);

  expect(merged.aspectRatio, resolvesTo(2.0));
});
```

### Utility and Fluent API Testing

Test public fluent methods through the generated Styler instead of removed utility classes:

```dart
test('fluent utility method creates correct style', () {
  final style = BoxStyler().color(Colors.orange);
  final resolved = style.resolve(MockBuildContext());

  final decoration = resolved.spec.decoration as BoxDecoration;
  expect(decoration.color, Colors.orange);
});
```

## MockBuildContext

Use `MockBuildContext` when resolution requires a `BuildContext`:

```dart
// Basic context with an empty MixScope.
final context = MockBuildContext();

// Context with token values.
const primary = ColorToken('primary');
final contextWithTokens = MockBuildContext(
  tokens: {primary: Colors.blue},
);

// Context with custom modifier order.
final contextWithOrder = MockBuildContext(
  orderOfModifiers: [OpacityModifier, PaddingModifier],
);
```

## Widget Testing

`pumpWithMixScope` takes the widget as its first positional argument:

```dart
testWidgets('Box renders with style', (tester) async {
  const primary = ColorToken('primary');

  await tester.pumpWithMixScope(
    Box(
      style: BoxStyler().color(primary()).paddingAll(16),
      child: const Text('Hello'),
    ),
    tokens: {primary: Colors.blue},
  );

  expect(find.text('Hello'), findsOneWidget);
});
```

## Common Mistakes

### Tokens Need Context

```dart
// Wrong: token values require context for resolution.
expect(tokenProp, resolvesTo(Colors.blue));

// Correct: provide a context with token mappings.
final context = MockBuildContext(tokens: {token: Colors.blue});
expect(tokenProp, resolvesTo(Colors.blue, context: context));
```

### Use Current Generated Names

Current Mix tests use generated Stylers, modifier Mix classes, direct `MockBuildContext` constructor arguments, and public fluent Styler methods. Avoid older spec-attribute classes, modifier-attribute classes, scope-data wrappers, and utility classes from pre-generated APIs.

## Best Practices

1. Prefer resolution tests for Props, Mix values, Stylers, and modifiers.
2. Use `MockBuildContext(tokens: ...)` when token resolution is involved.
3. Test generated Styler fields through `$field` access only in package tests.
4. Test widget integration with `pumpWithMixScope(widget, tokens: ...)`.
5. Test merge behavior through resolved values, not only object shape.
6. Add widget-state helper tests when interaction variants are involved.
