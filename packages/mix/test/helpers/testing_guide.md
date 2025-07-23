# Testing Guide - Mix 2.0

This guide explains how to test Mix components using our simplified testing utilities. We've consolidated everything into two core matchers and clear utilities for maximum simplicity and consistency.

## 🎯 **Core Philosophy**

Testing in Mix focuses on two key concepts:
1. **Prop Structure** - What a Prop contains (values, tokens, accumulated values)  
2. **Resolution** - What Resolvable types resolve to in context

## 📦 **What's Available**

All testing utilities are in `/test/helpers/testing_utils.dart`:

### Core Matchers
- `expectProp()` - Tests Prop structure
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
  final colorProp = Prop(Colors.red);
  expectProp(colorProp, Colors.red);
  
  final paddingProp = Prop(EdgeInsetsMix.all(16.0));
  expectProp(paddingProp, EdgeInsetsMix.all(16.0));
});

test('Prop contains tokens', () {
  const colorToken = MixToken<Color>('primary');
  final tokenProp = Prop.token(colorToken);
  expectProp(tokenProp, colorToken);
});

test('Prop contains accumulated values from merging', () {
  final prop1 = Prop(Colors.red);
  final prop2 = Prop(Colors.blue);
  final merged = prop1.merge(prop2);
  
  expectProp(merged, [Colors.red, Colors.blue]);
});

test('Prop contains mixed values and tokens', () {
  const token = MixToken<Color>('primary');
  final prop1 = Prop(Colors.red);
  final prop2 = Prop.token(token);
  final prop3 = Prop(Colors.blue);
  
  final merged = prop1.merge(prop2).merge(prop3);
  expectProp(merged, [Colors.red, token, Colors.blue]);
});
```

### **2. Testing Resolution with `resolvesTo()`**

Use `resolvesTo()` to test what Resolvable types actually resolve to in context.

```dart
test('Props resolve to their values', () {
  final colorProp = Prop(Colors.red);
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
  expect(attribute, resolvesTo(isA<OpacityModifier>()));
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
  final attribute = SomeAttribute(color: Prop(Colors.red));
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
// ❌ Wrong - testing resolution with expectProp
expectProp(colorProp, Colors.red); // This tests structure, not resolution

// ✅ Right - testing what the Prop contains
expectProp(colorProp, Colors.red); // If Prop(Colors.red)
expect(colorProp, resolvesTo(Colors.red)); // If testing resolution

// ❌ Wrong - testing structure with resolvesTo  
expect(mergedProp, resolvesTo([Colors.red, Colors.blue])); // Won't work

// ✅ Right - testing accumulated structure
expectProp(mergedProp, [Colors.red, Colors.blue]); // Tests what it contains
expect(mergedProp, resolvesTo(Colors.blue)); // Tests what it resolves to (last wins)
```

## 🧭 **Common Testing Scenarios**

### **Testing Attributes**

```dart
test('attribute properties are set correctly', () {
  final attribute = BorderAttribute(
    color: Prop(Colors.red),
    width: Prop(2.0),
  );
  
  expectProp(attribute.color, Colors.red);
  expectProp(attribute.width, 2.0);
});

test('attribute merging works', () {
  final base = BorderAttribute(color: Prop(Colors.red));
  final override = BorderAttribute(width: Prop(3.0));
  
  final merged = base.merge(override);
  
  expectProp(merged.color, Colors.red);
  expectProp(merged.width, 3.0);
});

test('attribute resolves to spec', () {
  final attribute = BorderAttribute(
    color: Prop(Colors.blue),
    width: Prop(1.0),
  );
  
  expect(attribute, resolvesTo(isA<BorderSpec>()));
});
```

### **Testing Mix Types**

```dart
test('Mix properties are set', () {
  final borderMix = BorderMix(
    color: Prop(Colors.green),
    width: Prop(4.0),
  );
  
  expectProp(borderMix.color, Colors.green);
  expectProp(borderMix.width, 4.0);
});

test('Mix resolves to Flutter type', () {
  final borderSide = BorderSideMix(
    color: Prop(Colors.red),
    width: Prop(2.0),
  );
  
  expect(borderSide, resolvesTo(isA<BorderSide>()));
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
test('props merge and accumulate correctly', () {
  final prop1 = Prop(100.0);
  final prop2 = Prop(200.0);
  final prop3 = Prop(300.0);
  
  final merged = prop1.merge(prop2).merge(prop3);
  
  // Test structure (what it contains)
  expectProp(merged, [100.0, 200.0, 300.0]);
  
  // Test resolution (what wins)
  expect(merged, resolvesTo(300.0)); // Last value wins for non-Mix types
});
```

## 🚫 **Common Mistakes**

### **1. Using the wrong matcher**
```dart
// ❌ Wrong - expectProp doesn't test resolution
expectProp(borderMix, isA<Border>());

// ✅ Right - use resolvesTo for resolution
expect(borderMix, resolvesTo(isA<Border>()));
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

### **3. Expecting wrong accumulation behavior**
```dart
// ❌ Wrong - Mix types accumulate, non-Mix types don't
expectProp(mergedDoubleProp, [10.0, 20.0]); // Structure test
expect(mergedDoubleProp, resolvesTo([10.0, 20.0])); // Wrong - resolves to 20.0

// ✅ Right - understand the difference
expectProp(mergedDoubleProp, [10.0, 20.0]); // What it contains
expect(mergedDoubleProp, resolvesTo(20.0)); // What it resolves to
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
expect(mix, resolvesTo(isA<Border>()));
```

This unified approach makes testing more consistent, easier to understand, and simpler to maintain across the entire Mix codebase.