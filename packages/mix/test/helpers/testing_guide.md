# Testing Guide - Mix 2.0

This guide explains how to test Mix components using our simplified testing utilities. We've consolidated everything into one core matcher and clear utilities for maximum simplicity and consistency.

## 🎯 **Core Philosophy**

Testing in Mix focuses on understanding one key concept:
- **Resolution Testing** - What Resolvable types resolve to in context

### **🔑 Critical: Understanding Prop Types**

Mix uses a unified `Prop<V>` type that handles both regular values and Mix types:

- **`Prop<V>`** - Unified property type for all values
  - **For regular values**: Uses replacement merge strategy (last value wins)
  - **For Mix types**: Uses accumulation merge strategy (properties combine)
  - **Creation**: Use `Prop.value()` for regular values, `Prop.mix()` for Mix values
  - **Examples**: `Prop<double>? aspectRatio`, `Prop<Color>? color`, `Prop<EdgeInsetsGeometry>? padding`

## 📦 **What's Available**

All testing utilities are in `/test/helpers/testing_utils.dart`:

### Core Matcher
- `resolvesTo<T>(T expected, {BuildContext? context})` - Tests what Resolvable types and Props resolve to

### Mock Utilities  
- `MockBuildContext` - BuildContext with MixScope support for token resolution
- `MockStyle<T>` - Universal test style that wraps any type for testing utilities
- `MockSpec<T>` - Simple spec for test resolution

### Widget Extensions (on WidgetTester)
- `pumpWithMixScope()` - Pump widgets with MixScope containing tokens and modifiers
- `pumpMaterialApp()` - Pump widgets wrapped in MaterialApp

## 🧪 **Testing Patterns**

### **1. Testing Resolution with `resolvesTo()`**

Use `resolvesTo()` to test what Resolvable types actually resolve to in context.

```dart
test('Props resolve to their values', () {
  final colorProp = Prop.value(Colors.red);
  expect(colorProp, resolvesTo(Colors.red));
});

test('Mix types resolve to Flutter types', () {
  final radiusMix = BorderRadiusMix.all(Radius.circular(8.0));
  expect(radiusMix, resolvesTo(BorderRadius.circular(8.0)));
  
  final edgeInsetsMix = EdgeInsetsMix.all(16.0);
  expect(edgeInsetsMix, resolvesTo(const EdgeInsets.all(16.0)));
});

test('Attributes resolve to specs', () {
  final attribute = OpacityModifierAttribute.only(opacity: 0.5);
  expect(attribute, resolvesTo(const OpacityModifier(0.5)));
});

test('Tokens resolve with custom context', () {
  const colorToken = MixToken<Color>('primary');
  final tokenProp = Prop.token(colorToken);
  
  final context = MockBuildContext(
    mixScopeData: MixScopeData.static(
      tokens: {colorToken: const Color(0xFF2196F3)},
    ),
  );
  
  expect(tokenProp, resolvesTo(const Color(0xFF2196F3), context: context));
});
```

## 🎭 **When to Use Mocks**

### **MockBuildContext**

Use when you need BuildContext for resolution:

```dart
test('resolving requires context', () {
  final attribute = SomeAttribute(color: Prop.value(Colors.red));
  final context = MockBuildContext();
  final resolved = attribute.resolve(context);
  
  expect(resolved.color, Colors.red);
});

test('tokens need context with scope data', () {
  const token = MixToken<Color>('surface');
  final context = MockBuildContext(
    mixScopeData: MixScopeData.static(
      tokens: {token: Colors.white},
    ),
  );
  
  final tokenProp = Prop.token(token);
  expect(tokenProp, resolvesTo(Colors.white, context: context));
});
```

### **UtilityTestAttribute**

Use for testing utilities that need a SpecStyle:

```dart
test('utility creates correct attributes', () {
  // For utility functions that take Style<T> builder
  final colorUtility = ColorUtility(MockStyle.new);
  final attr = colorUtility(Colors.red);
  
  expect(attr.value, resolvesTo(Colors.red));
});

test('utility attributes merge correctly', () {
  final first = MockStyle(Prop.value(Colors.red));
  final second = MockStyle(Prop.value(Colors.blue));
  
  final merged = first.merge(second);
  // Prop<T> uses replacement merge, so merged resolves to the second color
  expect(merged.value, resolvesTo(Colors.blue));
});
```

## 🧭 **Common Testing Scenarios**

### **Testing ModifierAttributes**

```dart
test('modifier attribute properties are set correctly', () {
  final attribute = OpacityModifierAttribute(opacity: Prop.value(0.5));

  expect(attribute.opacity, resolvesTo(0.5));
});

test('modifier attribute merging uses replacement strategy', () {
  final attr1 = AspectRatioModifierAttribute(aspectRatio: Prop.value(1.0));
  final attr2 = AspectRatioModifierAttribute(aspectRatio: Prop.value(2.0));

  final merged = attr1.merge(attr2);

  // Prop<T> uses replacement
  expect(merged.aspectRatio, resolvesTo(2.0));
});

test('modifier attribute resolves to modifier', () {
  final attribute = OpacityModifierAttribute(opacity: Prop.value(0.8));

  expect(attribute, resolvesTo(const OpacityModifier(0.8)));
});
```

### **Testing SpecAttributes**

```dart
test('spec attribute with mixed prop types', () {
  final attribute = BoxSpecAttribute(
    width: Prop.value(100.0),                    // Prop<double> - replacement merge
    padding: Prop.mix(EdgeInsetsMix.all(16.0)), // Prop<EdgeInsetsGeometry> - accumulation merge
  );

  expect(attribute.$width, resolvesTo(100.0));
  expect(attribute.$padding, resolvesTo(const EdgeInsets.all(16.0)));
});

test('spec attribute merging with different prop types', () {
  final base = BoxSpecAttribute(
    width: Prop.value(100.0),
    padding: Prop.mix(EdgeInsetsMix.only(left: 8.0)),
  );

  final override = BoxSpecAttribute(
    width: Prop.value(200.0),                     // Will replace
    padding: Prop.mix(EdgeInsetsMix.only(right: 16.0)), // Will accumulate
  );

  final merged = base.merge(override);

  // Replacement: second wins
  expect(merged.$width, resolvesTo(200.0));

  // Accumulation: both are applied
  expect(merged.$padding, resolvesTo(const EdgeInsets.only(left: 8.0, right: 16.0)));
});

test('spec attribute resolves to spec', () {
  final attribute = BoxSpecAttribute(
    width: Prop.value(150.0),
    height: Prop.value(200.0),
  );

  const expectedSpec = BoxSpec(width: 150.0, height: 200.0);
  expect(attribute, resolvesTo(expectedSpec));
});
```

### **Testing Mix Types**

```dart
test('Mix properties are set and resolve correctly', () {
  final borderMix = BorderMix(
    color: Prop.value(Colors.green),
    width: Prop.value(4.0),
  );
  
  expect(borderMix.color, resolvesTo(Colors.green));
  expect(borderMix.width, resolvesTo(4.0));
});

test('Mix resolves to Flutter type', () {
  final borderSide = BorderSideMix(
    color: Prop.value(Colors.red),
    width: Prop.value(2.0),
  );
  
  const expectedBorderSide = BorderSide(color: Colors.red, width: 2.0);
  expect(borderSide, resolvesTo(expectedBorderSide));
});
```

### **Testing Utilities**

```dart
test('utility function creates correct Prop and resolves', () {
  final colorUtility = ColorUtility(MockStyle.new);
  final attr = colorUtility(Colors.orange);
  
  // Test that it resolves correctly
  expect(attr.value, resolvesTo(Colors.orange));
});
```

### **Testing Merged Props**

```dart
test('Prop<T> merge behavior - replacement strategy', () {
  final prop1 = Prop.value(100.0);
  final prop2 = Prop.value(200.0);
  final prop3 = Prop.value(300.0);

  final merged = prop1.mergeProp(prop2).mergeProp(prop3);

  // Test resolution (last value wins for regular values)
  expect(merged, resolvesTo(300.0));
});

test('Prop<V> with Mix values merge behavior - accumulation strategy', () {
  final borderMix1 = BorderMix(color: Prop.value(Colors.red), width: Prop.value(1.0));
  final borderMix2 = BorderMix(color: Prop.value(Colors.blue));
  final borderMix3 = BorderMix(style: Prop.value(BorderStyle.dashed));

  final prop1 = Prop.mix(borderMix1);
  final prop2 = Prop.mix(borderMix2);
  final prop3 = Prop.mix(borderMix3);

  final merged = prop1.mergeProp(prop2).mergeProp(prop3);

  // Test the resolved value of the accumulated Mix
  final expected = Border.all().copyWith(
    color: Colors.blue,
    width: 1.0,
    style: BorderStyle.dashed,
  );

  expect(merged, resolvesTo(expected));
});
```

## 🚫 **Common Mistakes**

### **1. Testing resolution without context**
```dart
// ❌ Wrong - tokens need context
expect(tokenProp, resolvesTo(Colors.blue));

// ✅ Right - provide context for tokens
final context = MockBuildContext(
  mixScopeData: MixScopeData.static(tokens: {token: Colors.blue}),
);
expect(tokenProp, resolvesTo(Colors.blue, context: context));
```

## 📈 **Best Practices**

1. **Focus on resolution testing** for comprehensive coverage
2. **Use MockBuildContext** when testing resolution that requires context
3. **Provide explicit token mappings** in MixScopeData for token tests
4. **Test merge behavior** by checking the resolved value of merged attributes
5. **Use descriptive test names** that clearly indicate what's being tested
6. **Group related tests** using `group()` for better organization
7. **Test edge cases** like null props, empty merges, and missing tokens

## 🔧 **Migration from Old Testing Patterns**

If you have old test code, here's how to migrate:

```dart
// Old way (deprecated patterns)
expect(prop.getValue(), Colors.red);           // Direct access
expect(prop, hasValue(Colors.red));           // Old matchers
expect(mix.resolve(context), isA<Border>());  // Manual resolution

// New unified approach
expect(prop, resolvesTo(Colors.red));         // Works for Props
expect(mix, resolvesTo(expectedBorder));      // Works for Mix types
expect(attribute, resolvesTo(expectedSpec));  // Works for Attributes

// For token testing with context
final context = MockBuildContext(
  mixScopeData: MixScopeData.static(tokens: {token: value}),
);
expect(tokenProp, resolvesTo(expected, context: context));
```

This unified approach makes testing more consistent, easier to understand, and simpler to maintain across the entire Mix codebase.
