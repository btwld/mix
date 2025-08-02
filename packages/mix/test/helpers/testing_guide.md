# Testing Guide - Mix 2.0

This guide explains how to test Mix components using our simplified testing utilities. We've consolidated everything into two core matchers and clear utilities for maximum simplicity and consistency.

## 🎯 **Core Philosophy**

Testing in Mix focuses on understanding two key concepts:
1. **Prop Types & Merge Strategies** - How different prop types behave when merged
2. **Resolution Testing** - What Resolvable types resolve to in context

### **🔑 Critical: Understanding Prop Types**

Mix has two distinct prop types with different merge behaviors:

- **`Prop<T>`** - For regular Flutter types (double, Color, AlignmentGeometry, etc.)
  - **Merge Strategy**: **Replacement** (second value wins)
  - **Used in**: Most ModifierAttributes, simple SpecAttribute properties
  - **Example**: `Prop<double>? aspectRatio`, `Prop<Color>? color`

- **`MixProp<V>`** - For Mix types (EdgeInsetsMix, BorderMix, TextStyleMix, etc.)
  - **Merge Strategy**: **Accumulation** (properties merge and combine)
  - **Used in**: Complex SpecAttribute properties that need to accumulate
  - **Example**: `MixProp<EdgeInsetsGeometry>? padding`, `MixProp<Decoration>? decoration`

## 📦 **What's Available**

All testing utilities are in `/test/helpers/testing_utils.dart`:

### Core Matchers
- `expectProp()` - Tests PropBase structure (both Prop<T> and MixProp<V>)
- `resolvesTo()` - Tests what Resolvable types resolve to

### Mock Utilities  
- `MockBuildContext` - BuildContext with MixScope support
- `UtilityTestAttribute<T>` - Universal test attribute
- `MockSpec` - Simple spec for test resolution

### Widget Extensions
- `pumpWithMixScope()` - Pump widgets with MixScope, which contains tokens
- `pumpMaterialApp()` - Pump widgets in MaterialApp

## 🧪 **Testing Patterns**

### **1. Testing Prop Structure with `expectProp()`**

Use `expectProp()` to test what a Prop contains - not what it resolves to.

```dart
test('Prop contains direct values', () {
  final colorProp = Prop.value(Colors.red);
  expectProp(colorProp, Colors.red);
  
  final paddingProp = Prop.value(EdgeInsetsMix.all(16.0));
  expectProp(paddingProp, EdgeInsetsMix.all(16.0));
});

test('Prop contains tokens', () {
  const colorToken = MixToken<Color>('primary');
  final tokenProp = Prop.token(colorToken);
  expectProp(tokenProp, colorToken);
});

test('Prop uses replacement merge strategy', () {
  final prop1 = Prop.value(Colors.red);
  final prop2 = Prop.value(Colors.blue);
  final merged = prop1.merge(prop2);

  expectProp(merged, Colors.blue); // Second value wins for Prop<T>
});

test('MixProp uses accumulation merge strategy', () {
  final borderMix1 = BorderMix(color: Prop.value(Colors.red), width: Prop.value(1.0));
  final borderMix2 = BorderMix(color: Prop.value(Colors.blue));

  final prop1 = MixProp(borderMix1);
  final prop2 = MixProp(borderMix2);
  final merged = prop1.merge(prop2);

  // MixProp accumulates - the merged Mix will have both properties
  final resolvedMix = merged.value;
  expectProp(resolvedMix.color, Colors.blue); // Second color wins
  expectProp(resolvedMix.width, 1.0); // Width preserved from first
});

test('expectProp supports matchers', () {
  final colorProp = Prop.value(Colors.red);
  expectProp(colorProp, isA<Color>());

  final mixProp = MixProp(EdgeInsetsMix.all(16.0));
  expectProp(mixProp, isA<EdgeInsetsMix>());
});
```

### **2. Testing Resolution with `resolvesTo()`**

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
  // For utility functions that take SpecStyle<T> builder
  final colorUtility = ColorUtility(UtilityTestAttribute.new);
  final attr = colorUtility(Colors.red);
  
  expectProp(attr.value as Prop<Color>, Colors.red);
});

test('utility attributes merge correctly', () {
  final first = UtilityTestAttribute(Prop(Colors.red));
  final second = UtilityTestAttribute(Prop(Colors.blue));
  
  final merged = first.merge(second);
  expectProp(merged.value as Prop<Color>, [Colors.red, Colors.blue]);
});
```

## 🎯 **Decision Matrix: expectProp vs resolvesTo**

| **Use `expectProp()` when:** | **Use `resolvesTo()` when:** |
|-------------------------------|------------------------------|
| Testing what a Prop contains | Testing what something resolves to |
| Verifying Prop structure | Verifying resolved values |
| Checking merge behavior | Testing Mix → Flutter conversion |
| Validating token storage | Testing attribute → spec resolution |
| Testing accumulated values | Verifying context-dependent resolution |

### **Examples:**

```dart
// ✅ Both are valid - different purposes
expectProp(colorProp, Colors.red); // Tests what the Prop contains
expect(colorProp, resolvesTo(Colors.red)); // Tests what it resolves to

// ❌ Wrong - testing structure with resolvesTo  
expect(mergedProp, resolvesTo([Colors.red, Colors.blue])); // Won't work

// ✅ Right - testing accumulated structure
expectProp(mergedProp, [Colors.red, Colors.blue]); // Tests what it contains
expect(mergedProp, resolvesTo(Colors.blue)); // Tests what it resolves to (last wins)
```

## 🧭 **Common Testing Scenarios**

### **Testing ModifierAttributes**

```dart
test('modifier attribute properties are set correctly', () {
  final attribute = OpacityModifierAttribute(opacity: Prop.value(0.5));

  expectProp(attribute.opacity, 0.5);
});

test('modifier attribute merging uses replacement strategy', () {
  final attr1 = AspectRatioModifierAttribute(aspectRatio: Prop.value(1.0));
  final attr2 = AspectRatioModifierAttribute(aspectRatio: Prop.value(2.0));

  final merged = attr1.merge(attr2);

  expectProp(merged.aspectRatio, 2.0); // Prop<T> uses replacement
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
    padding: MixProp(EdgeInsetsMix.all(16.0)), // MixProp<EdgeInsetsGeometry> - accumulation merge
  );

  expectProp(attribute.$width, 100.0);
  expectProp(attribute.$padding, isA<EdgeInsetsMix>());
});

test('spec attribute merging with different prop types', () {
  final base = BoxSpecAttribute(
    width: Prop.value(100.0),
    padding: MixProp(EdgeInsetsMix.only(left: 8.0)),
  );

  final override = BoxSpecAttribute(
    width: Prop.value(200.0),                     // Will replace
    padding: MixProp(EdgeInsetsMix.only(right: 16.0)), // Will accumulate
  );

  final merged = base.merge(override);

  expectProp(merged.$width, 200.0); // Replacement: second wins

  // For MixProp, check the resolved Mix has accumulated properties
  final resolvedPadding = merged.$padding!.value;
  expectProp(resolvedPadding.left, 8.0);   // From base
  expectProp(resolvedPadding.right, 16.0); // From override
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
test('Mix properties are set', () {
  final borderMix = BorderMix(
    color: Prop.value(Colors.green),
    width: Prop.value(4.0),
  );
  
  expectProp(borderMix.color, Colors.green);
  expectProp(borderMix.width, 4.0);
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
test('utility function creates correct Prop', () {
  final colorUtility = ColorUtility(UtilityTestAttribute.new);
  final attr = colorUtility(Colors.orange);
  
  // Test that utility created correct Prop structure
  expectProp(attr.value as Prop<Color>, Colors.orange);
  
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

  final merged = prop1.merge(prop2).merge(prop3);

  // Test what it contains (replacement strategy)
  expectProp(merged, 300.0); // Last value wins

  // Test resolution
  expect(merged, resolvesTo(300.0));
});

test('MixProp<V> merge behavior - accumulation strategy', () {
  final borderMix1 = BorderMix(color: Prop.value(Colors.red), width: Prop.value(1.0));
  final borderMix2 = BorderMix(color: Prop.value(Colors.blue));
  final borderMix3 = BorderMix(style: Prop.value(BorderStyle.dashed));

  final prop1 = MixProp(borderMix1);
  final prop2 = MixProp(borderMix2);
  final prop3 = MixProp(borderMix3);

  final merged = prop1.merge(prop2).merge(prop3);

  // Test the accumulated Mix structure
  final resolvedMix = merged.value;
  expectProp(resolvedMix.color, Colors.blue);        // From prop2 (last color)
  expectProp(resolvedMix.width, 1.0);                // From prop1 (preserved)
  expectProp(resolvedMix.style, BorderStyle.dashed); // From prop3 (new property)
});
```

## 🚫 **Common Mistakes**

### **1. Using the wrong matcher**
```dart
// ❌ Wrong - expectProp doesn't test resolution
expectProp(borderMix, isA<Border>());

// ✅ Right - use resolvesTo with specific values when possible
// For complex objects, test specific properties after resolution
final resolved = borderMix.resolve(MockBuildContext());
expect(resolved, isA<Border>());
expect(resolved.top.color, expectedColor);
```

### **2. Testing resolution without context**
```dart
// ❌ Wrong - tokens need context
expect(tokenProp, resolvesTo(Colors.blue));

// ✅ Right - provide context for tokens
final context = MockBuildContext(
  mixScopeData: MixScopeData.static(tokens: {token: Colors.blue}),
);
expect(tokenProp, resolvesTo(Colors.blue, context: context));
```

### **3. Confusing Prop<T> vs MixProp<V> merge behavior**
```dart
// ❌ Wrong - Prop<T> uses replacement, not accumulation
final doubleProp1 = Prop.value(10.0);
final doubleProp2 = Prop.value(20.0);
final merged = doubleProp1.merge(doubleProp2);
expectProp(merged, [10.0, 20.0]); // Wrong! Prop<T> uses replacement

// ✅ Right - understand the prop type
expectProp(merged, 20.0); // Prop<T> replacement: second wins
expect(merged, resolvesTo(20.0)); // Resolves to the replacement value

// ✅ Right - MixProp<V> does accumulate
final mixProp1 = MixProp(BorderMix(color: Prop.value(Colors.red)));
final mixProp2 = MixProp(BorderMix(width: Prop.value(2.0)));
final mergedMix = mixProp1.merge(mixProp2);
final resolvedMix = mergedMix.value;
expectProp(resolvedMix.color, Colors.red); // Accumulated from first
expectProp(resolvedMix.width, 2.0);        // Accumulated from second
```

## 📈 **Best Practices**

1. **Test both structure and resolution** for comprehensive coverage
2. **Use MockBuildContext** when testing resolution that requires context
3. **Provide explicit token mappings** in MixScopeData for token tests
4. **Test merge behavior** separately from resolution behavior
5. **Use descriptive test names** that clearly indicate what's being tested
6. **Group related tests** using `group()` for better organization
7. **Test edge cases** like null props, empty merges, and missing tokens

## 🔧 **Migration from Old Matchers**

If you have old test code, here's how to migrate:

```dart
// Old way
expect(prop.getValue(), Colors.red);
expect(prop, hasValue(Colors.red));
expect(mix.resolve(context), isA<Border>());

// New way
expectProp(prop, Colors.red);
// For simple types, use resolvesTo with specific values
expect(colorProp, resolvesTo(Colors.red));
// For complex types, resolve and test specific properties
final resolved = borderMix.resolve(context);
expect(resolved.top.color, expectedColor);
```

This unified approach makes testing more consistent, easier to understand, and simpler to maintain across the entire Mix codebase.