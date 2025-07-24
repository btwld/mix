# SpecAttribute Testing Guide

A comprehensive guide for creating complete and reliable tests for SpecAttribute classes in the Mix framework.

## Overview

SpecAttribute tests should verify constructor behavior, utility method patterns, property resolution, merging logic, and framework-specific behaviors. This guide is based on analysis of `BoxSpecAttribute` tests and Mix framework patterns.

## Core Testing Structure

### Essential Test Groups

Organize tests into these logical groups:

```dart
void main() {
  group('MySpecAttribute', () {
    group('Constructor', () { /* ... */ });
    group('Utility Methods', () { /* ... */ });
    group('[Property Groups]', () { /* ... */ }); // e.g., "Color and Decoration"
    group('Resolution', () { /* ... */ });
    group('Merge', () { /* ... */ });
    group('Equality', () { /* ... */ });
    group('Modifiers', () { /* ... */ }); // if applicable
    group('Animation', () { /* ... */ }); // if applicable
    group('Variants', () { /* ... */ }); // if applicable
  });
}
```

## Testing Patterns

### 1. Constructor Testing

Test all construction methods thoroughly:

```dart
group('Constructor', () {
  test('creates MySpecAttribute with all properties', () {
    final attribute = MySpecAttribute(
      property1: Prop(value1),
      property2: MixProp(mixValue2),
      property3: Prop(value3),
      // ... include all properties
    );

    // Verify all properties using $property syntax
    expect(attribute.$property1?.getValue(), value1);
    expect(attribute.$property1, hasValue(value1));
    expect(attribute.$property2, isNotNull);
    expect(attribute.$property3, hasValue(value3));
  });

  test('creates MySpecAttribute using only constructor', () {
    final attribute = MySpecAttribute.only(
      property1: value1,
      property2: mixValue2,
      property3: value3,
      // ... all properties with direct values
    );

    // Same assertions as above
    expect(attribute.$property1?.getValue(), value1);
    expect(attribute.$property2, isNotNull);
    expect(attribute.$property3, hasValue(value3));
  });

  test('creates empty MySpecAttribute', () {
    final attribute = MySpecAttribute();

    // Verify all properties are null in default state
    expect(attribute.$property1, isNull);
    expect(attribute.$property2, isNull);
    expect(attribute.$property3, isNull);
  });
});
```

### 2. Utility Methods - Critical Pattern

**Key Insight**: Utility methods create NEW instances and don't accumulate properties!

```dart
group('Utility Methods', () {
  test('utility methods create new instances', () {
    final original = MySpecAttribute();
    final withProp1 = original.property1(value1);
    final withProp2 = original.property2(value2);

    // Each utility creates a new instance
    expect(identical(original, withProp1), isFalse);
    expect(identical(original, withProp2), isFalse);
    expect(identical(withProp1, withProp2), isFalse);

    // Original remains unchanged
    expect(original.$property1, isNull);
    expect(original.$property2, isNull);

    // Each new instance has only its specific property
    expect(withProp1.$property1, hasValue(value1));
    expect(withProp1.$property2, isNull);

    expect(withProp2.$property2, hasValue(value2));
    expect(withProp2.$property1, isNull);
  });

  test('chaining utilities does not accumulate properties', () {
    // CRITICAL: This is the key behavior to test
    final chained = MySpecAttribute().property1(value1).property2(value2);

    // Only the last property is set because each utility creates a new instance
    expect(chained.$property1, isNull);
    expect(chained.$property2, hasValue(value2));
  });

  test('use merge to combine utilities', () {
    // Show the correct way to combine multiple utilities
    final combined = MySpecAttribute()
        .property1(value1)
        .merge(MySpecAttribute().property2(value2))
        .merge(MySpecAttribute().property3(value3));

    expect(combined.$property1, hasValue(value1));
    expect(combined.$property2, hasValue(value2));
    expect(combined.$property3, hasValue(value3));
  });
});
```

### 3. Property-Specific Groups

Group related properties and test their specific behaviors:

```dart
group('Color and Decoration', () {
  test('color utility creates decoration with color', () {
    final attribute = MySpecAttribute().color(Colors.red);

    expect(attribute.$decoration, isNotNull);

    final context = MockBuildContext();
    final resolved = attribute.resolve(context);
    final decoration = resolved.spec?.decoration as BoxDecoration?;
    expect(decoration?.color, Colors.red);
  });

  test('decoration utilities create new instances', () {
    // Test each decoration utility creates separate instances
    final withColor = MySpecAttribute().color(Colors.red);
    final withBorder = MySpecAttribute().border.all(BorderSideMix.only(width: 2.0));

    // Verify each has only its specific decoration property
    final context = MockBuildContext();

    final colorDecoration = withColor.resolve(context).spec?.decoration as BoxDecoration?;
    expect(colorDecoration?.color, Colors.red);
    expect(colorDecoration?.border, isNull);

    final borderDecoration = withBorder.resolve(context).spec?.decoration as BoxDecoration?;
    expect(borderDecoration?.color, isNull);
    expect(borderDecoration?.border, isNotNull);
  });

  test('combine decorations with merge', () {
    final combined = MySpecAttribute()
        .color(Colors.red)
        .merge(MySpecAttribute().border.all(BorderSideMix.only(width: 2.0)))
        .merge(MySpecAttribute().borderRadius.all(const Radius.circular(8.0)));

    final context = MockBuildContext();
    final decoration = combined.resolve(context).spec?.decoration as BoxDecoration?;

    expect(decoration?.color, Colors.red);
    expect(decoration?.border, isNotNull);
    expect(decoration?.borderRadius, isNotNull);
  });
});

group('Size Constraints', () {
  test('width and height utilities create separate instances', () {
    final withWidth = MySpecAttribute().width(100.0);
    final withHeight = MySpecAttribute().height(200.0);

    expect(withWidth.$width, hasValue(100.0));
    expect(withWidth.$height, isNull);

    expect(withHeight.$height, hasValue(200.0));
    expect(withHeight.$width, isNull);
  });

  test('combine width and height with merge or constructor', () {
    // Option 1: Use merge
    final merged = MySpecAttribute()
        .width(100.0)
        .merge(MySpecAttribute().height(200.0));

    expect(merged.$width, hasValue(100.0));
    expect(merged.$height, hasValue(200.0));

    // Option 2: Use constructor
    final constructed = MySpecAttribute.only(width: 100.0, height: 200.0);

    expect(constructed.$width, hasValue(100.0));
    expect(constructed.$height, hasValue(200.0));
  });
});
```

### 4. Resolution Testing

Always test context resolution to verify the attribute resolves to the correct spec:

```dart
group('Resolution', () {
  test('resolves to MySpec with correct properties', () {
    // Use constructor or merge to combine properties for testing
    final attribute = MySpecAttribute.only(
      property1: value1,
      property2: value2,
      property3: value3,
    );

    final context = MockBuildContext();
    final resolved = attribute.resolve(context);

    expect(resolved.spec, isNotNull);
    expect(resolved.spec!.property1, value1);
    expect(resolved.spec!.property2, value2);
    expect(resolved.spec!.property3, value3);
  });

  test('resolves complex properties correctly', () {
    // Test resolution of Mix-type properties
    final attribute = MySpecAttribute.only(
      padding: EdgeInsetsMix.only(
        top: 10.0,
        bottom: 20.0,
        left: 30.0,
        right: 40.0,
      ),
    );

    final context = MockBuildContext();
    final resolved = attribute.resolve(context);

    expect(resolved.spec, isNotNull);
    expect(
      resolved.spec!.padding,
      const EdgeInsets.only(
        top: 10.0,
        bottom: 20.0,
        left: 30.0,
        right: 40.0,
      ),
    );
  });
});
```

### 5. Merge Testing

Test the merge behavior thoroughly:

```dart
group('Merge', () {
  test('merges properties correctly', () {
    // Create attributes with different properties
    final first = MySpecAttribute.only(
      property1: value1,
      property2: value2,
      property3: value3,
    );

    final second = MySpecAttribute.only(
      property1: newValue1, // This should override
      property4: value4,    // This should be added
      property5: value5,    // This should be added
    );

    final merged = first.merge(second);

    expect(merged.$property1, hasValue(newValue1)); // second overrides first
    expect(merged.$property2, hasValue(value2));    // from first
    expect(merged.$property3, hasValue(value3));    // from first
    expect(merged.$property4, hasValue(value4));    // from second
    expect(merged.$property5, hasValue(value5));    // from second
  });

  test('returns this when other is null', () {
    final attribute = MySpecAttribute().property1(value1);
    final merged = attribute.merge(null);

    expect(identical(attribute, merged), isTrue);
  });
});
```

### 6. Equality Testing

Test equality and hashCode behavior:

```dart
group('Equality', () {
  test('equal attributes have same hashCode', () {
    final attr1 = MySpecAttribute.only(
      property1: value1,
      property2: value2,
    );

    final attr2 = MySpecAttribute.only(
      property1: value1,
      property2: value2,
    );

    expect(attr1, equals(attr2));
    expect(attr1.hashCode, equals(attr2.hashCode));
  });

  test('different attributes are not equal', () {
    final attr1 = MySpecAttribute().property1(value1);
    final attr2 = MySpecAttribute().property1(value2);

    expect(attr1, isNot(equals(attr2)));
  });
});
```

### 7. Additional Features Testing

Test modifiers, animation, and variants if applicable:

```dart
group('Modifiers', () {
  test('modifiers can be added to attribute', () {
    final attribute = MySpecAttribute(
      modifiers: [
        OpacityModifierAttribute(opacity: Prop(0.5)),
        TransformModifierAttribute.only(
          transform: Matrix4.identity(),
          alignment: Alignment.center,
        ),
      ],
    );

    expect(attribute.modifiers, isNotNull);
    expect(attribute.modifiers!.length, 2);
  });

  test('modifiers are not merged by MySpecAttribute.merge', () {
    // Note: SpecAttribute.merge typically only merges specific properties,
    // not modifiers or variants
    final first = MySpecAttribute(
      modifiers: [OpacityModifierAttribute(opacity: Prop(0.5))],
    );

    final second = MySpecAttribute(
      modifiers: [TransformModifierAttribute.only(transform: Matrix4.identity())],
    );

    final merged = first.merge(second);

    // The merge method doesn't merge modifiers
    expect(merged.modifiers, isNull);
  });
});

group('Animation', () {
  test('animation config can be added to attribute', () {
    final attribute = MySpecAttribute();
    expect(attribute.animation, isNull); // By default no animation
  });
});

group('Variants', () {
  test('variants functionality exists', () {
    final attribute = MySpecAttribute();
    expect(attribute.variants, isNull); // By default no variants
  });
});
```

## Testing Best Practices

### 1. Use Descriptive Test Names
- Start with what you're testing
- Include the expected behavior
- Be specific about the scenario

### 2. Use Proper Imports
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';
```

### 3. Use Custom Matchers
- `hasValue(expectedValue)` for property values
- `isNotNull` for complex properties that should exist
- `isNull` for properties that should not be set
- Standard matchers for direct comparisons

### 4. Test Both Construction Methods
Always test both:
- Constructor with `Prop`/`MixProp` wrappers
- `.only()` constructor with direct values

### 5. Document Critical Behaviors
Add comments explaining non-obvious behaviors:
```dart
test('chaining utilities does not accumulate properties', () {
  // This is the key behavior: chaining creates new instances
  final chained = MySpecAttribute().property1(value1).property2(value2);

  // Only the last property is set because each utility creates a new instance
  expect(chained.$property1, isNull);
  expect(chained.$property2, hasValue(value2));
});
```

### 6. Group Related Tests Logically
- Keep related functionality together
- Use descriptive group names
- Follow consistent naming patterns

### 7. Test Edge Cases
- Empty/null values
- Boundary conditions
- Default states
- Error conditions (if applicable)

## Common Pitfalls to Avoid

1. **Don't assume chaining works** - Always test that utilities create new instances
2. **Don't skip empty constructor tests** - Verify the default state
3. **Don't forget resolution testing** - Context resolution is critical for SpecAttributes
4. **Don't ignore merge behavior** - Test property precedence and combination
5. **Don't skip equality tests** - Ensure proper equality and hashCode implementation
6. **Don't test implementation details** - Focus on public API behavior
7. **Don't forget to test property-specific behaviors** - Each property type may have unique patterns

## Template Checklist

When creating SpecAttribute tests, ensure you have:

- [ ] Constructor tests (full, .only(), empty)
- [ ] Utility method behavior tests (new instances, chaining, merge)
- [ ] Property-specific group tests
- [ ] Resolution tests with MockBuildContext
- [ ] Merge tests (property precedence, null handling)
- [ ] Equality tests (equal cases, different cases, hashCode)
- [ ] Modifiers/Animation/Variants tests (if applicable)
- [ ] Edge case tests
- [ ] Descriptive test names and comments
- [ ] Proper imports and setup

This guide ensures your SpecAttribute tests are comprehensive, maintainable, and follow the established patterns in the Mix framework.