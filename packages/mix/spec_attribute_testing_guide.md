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

**Key Insight**: Utility methods create NEW instances that merge with existing properties, accumulating all values!

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

    // New instances have their properties set
    expect(withProp1.$property1, hasValue(value1));
    expect(withProp2.$property2, hasValue(value2));
  });

  test('chaining utilities accumulates properties correctly', () {
    // CRITICAL: Chaining accumulates all properties via internal merge
    final chained = MySpecAttribute().property1(value1).property2(value2);

    // Both properties are set because utilities merge with previous state
    expect(chained.$property1, hasValue(value1));
    expect(chained.$property2, hasValue(value2));
  });

  test('complex chaining works as expected', () {
    // Multiple properties accumulate through the chain
    final complex = MySpecAttribute()
        .property1(value1)
        .property2(value2)
        .property3(value3);

    expect(complex.$property1, hasValue(value1));
    expect(complex.$property2, hasValue(value2));
    expect(complex.$property3, hasValue(value3));
  });

  test('property overrides in chains', () {
    // Later values override earlier ones for the same property
    final overridden = MySpecAttribute()
        .property1(value1)
        .property2(value2)
        .property1(newValue1); // This overrides the first property1

    expect(overridden.$property1, hasValue(newValue1));
    expect(overridden.$property2, hasValue(value2));
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

  test('decoration utilities can be chained', () {
    // Chaining decoration utilities accumulates all properties
    final chained = MySpecAttribute()
        .color(Colors.red)
        .border.all(BorderSideMix.only(width: 2.0))
        .borderRadius.all(const Radius.circular(8.0));

    final context = MockBuildContext();
    final decoration = chained.resolve(context).spec?.decoration as BoxDecoration?;
    
    // All decoration properties are accumulated
    expect(decoration?.color, Colors.red);
    expect(decoration?.border, isNotNull);
    expect(decoration?.borderRadius, isNotNull);
  });

  test('separate decoration utilities start fresh', () {
    // Creating separate instances doesn't accumulate
    final withColor = MySpecAttribute().color(Colors.red);
    final withBorder = MySpecAttribute().border.all(BorderSideMix.only(width: 2.0));

    final context = MockBuildContext();

    // Each instance only has its own properties
    final colorDecoration = withColor.resolve(context).spec?.decoration as BoxDecoration?;
    expect(colorDecoration?.color, Colors.red);
    expect(colorDecoration?.border, isNull);

    final borderDecoration = withBorder.resolve(context).spec?.decoration as BoxDecoration?;
    expect(borderDecoration?.color, isNull);
    expect(borderDecoration?.border, isNotNull);
  });
});

group('Size Constraints', () {
  test('width and height can be chained', () {
    // Chaining width and height accumulates both
    final chained = MySpecAttribute().width(100.0).height(200.0);

    expect(chained.$width, hasValue(100.0));
    expect(chained.$height, hasValue(200.0));
  });

  test('separate instances have isolated properties', () {
    // Creating separate instances doesn't accumulate
    final withWidth = MySpecAttribute().width(100.0);
    final withHeight = MySpecAttribute().height(200.0);

    expect(withWidth.$width, hasValue(100.0));
    expect(withWidth.$height, isNull);

    expect(withHeight.$height, hasValue(200.0));
    expect(withHeight.$width, isNull);
  });

  test('multiple ways to set width and height', () {
    // Option 1: Chain utilities
    final chained = MySpecAttribute().width(100.0).height(200.0);

    // Option 2: Use constructor
    final constructed = MySpecAttribute.only(width: 100.0, height: 200.0);

    // Option 3: Explicit merge
    final merged = MySpecAttribute()
        .width(100.0)
        .merge(MySpecAttribute().height(200.0));

    // All three approaches produce the same result
    expect(chained.$width, hasValue(100.0));
    expect(chained.$height, hasValue(200.0));
    
    expect(constructed.$width, hasValue(100.0));
    expect(constructed.$height, hasValue(200.0));
    
    expect(merged.$width, hasValue(100.0));
    expect(merged.$height, hasValue(200.0));
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
test('chaining utilities accumulates properties correctly', () {
  // This is the key behavior: utilities create new instances but merge with existing state
  final chained = MySpecAttribute().property1(value1).property2(value2);

  // Both properties are set because each utility internally uses merge
  expect(chained.$property1, hasValue(value1));
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

1. **Don't forget to test chaining behavior** - Verify that utilities accumulate properties correctly
2. **Don't skip empty constructor tests** - Verify the default state
3. **Don't forget resolution testing** - Context resolution is critical for SpecAttributes
4. **Don't ignore merge behavior** - Test property precedence and combination
5. **Don't skip equality tests** - Ensure proper equality and hashCode implementation
6. **Don't test implementation details** - Focus on public API behavior
7. **Don't forget to test property-specific behaviors** - Each property type may have unique patterns

## Advanced Testing Patterns

### 8. Testing Nested Utilities

Some attributes provide nested utility patterns (e.g., `box.padding.all()`):

```dart
group('Nested Utilities', () {
  test('nested utilities work correctly', () {
    final attribute = BoxSpecAttribute()
      .padding.all(10.0)
      .margin.symmetric(horizontal: 20.0)
      .border.all(BorderSideMix.only(width: 2.0))
      .borderRadius.circular(8.0);
    
    // Verify all nested utilities applied correctly
    final context = MockBuildContext();
    final resolved = attribute.resolve(context);
    
    expect(resolved.padding, const EdgeInsets.all(10.0));
    expect(resolved.margin, const EdgeInsets.symmetric(horizontal: 20.0));
    expect(resolved.decoration, isNotNull);
    final decoration = resolved.decoration as BoxDecoration?;
    expect(decoration?.border, isNotNull);
    expect(decoration?.borderRadius, BorderRadius.circular(8.0));
  });

  test('nested utilities are chainable', () {
    // Complex chaining with nested utilities
    final attribute = BoxSpecAttribute()
      .decoration.box.color(Colors.red)
      .decoration.box.gradient.linear(
        colors: [Colors.blue, Colors.green],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )
      .padding.only(top: 10.0, bottom: 20.0);

    expect(attribute.$decoration, isNotNull);
    expect(attribute.$padding, isNotNull);
  });
});
```

### 9. Testing Factory Methods

Test factory constructors separately from instance methods:

```dart
group('Factory Methods', () {
  test('width factory creates correct constraints', () {
    final attribute = BoxSpecAttribute.width(100.0);
    
    expect(attribute.$constraints, isNotNull);
    final constraints = attribute.$constraints?.resolve(MockBuildContext());
    expect(constraints?.minWidth, 100.0);
    expect(constraints?.maxWidth, 100.0);
    expect(constraints?.minHeight, isNull);
    expect(constraints?.maxHeight, isNull);
  });

  test('height factory creates correct constraints', () {
    final attribute = BoxSpecAttribute.height(200.0);
    
    expect(attribute.$constraints, isNotNull);
    final constraints = attribute.$constraints?.resolve(MockBuildContext());
    expect(constraints?.minHeight, 200.0);
    expect(constraints?.maxHeight, 200.0);
    expect(constraints?.minWidth, isNull);
    expect(constraints?.maxWidth, isNull);
  });

  test('factory methods can be combined', () {
    // Combine factory with instance methods
    final attribute = BoxSpecAttribute.width(100.0)
      .height(200.0)
      .color(Colors.red);
    
    final context = MockBuildContext();
    final resolved = attribute.resolve(context);
    
    expect(resolved.constraints?.minWidth, 100.0);
    expect(resolved.constraints?.minHeight, 200.0);
    expect((resolved.decoration as BoxDecoration?)?.color, Colors.red);
  });
});
```

### 10. Testing Composite Attributes

For attributes combining multiple specs (e.g., FlexBoxSpecAttribute):

```dart
group('Composite Attribute Behavior', () {
  test('composite attribute resolves all specs', () {
    final attribute = FlexBoxSpecAttribute()
      .direction(Axis.horizontal)     // FlexSpec property
      .gap(10.0)                      // FlexSpec property
      .width(100.0)                   // BoxSpec property
      .padding.all(20.0);            // BoxSpec property
    
    final context = MockBuildContext();
    final resolved = attribute.resolve(context);
    
    // Verify both specs are resolved correctly
    expect(resolved.flex.direction, Axis.horizontal);
    expect(resolved.flex.gap, 10.0);
    expect(resolved.box.constraints?.minWidth, 100.0);
    expect(resolved.box.padding, const EdgeInsets.all(20.0));
  });

  test('partial updates preserve other spec', () {
    final initial = FlexBoxSpecAttribute(
      box: BoxSpecAttribute.width(100.0),
      flex: FlexSpecAttribute(direction: Prop(Axis.horizontal)),
    );
    
    final updated = FlexBoxSpecAttribute(
      box: BoxSpecAttribute.height(200.0),
    );
    
    final merged = initial.merge(updated);
    
    // Check that flex is preserved and box is merged
    final context = MockBuildContext();
    final resolved = merged.resolve(context);
    
    expect(resolved.flex.direction, Axis.horizontal); // preserved
    expect(resolved.box.constraints?.minWidth, 100.0); // merged
    expect(resolved.box.constraints?.minHeight, 200.0); // updated
  });

  test('utilities from both specs are accessible', () {
    final utility = FlexBoxSpecUtility();
    
    // Box utilities
    expect(utility.width, isNotNull);
    expect(utility.padding, isNotNull);
    expect(utility.decoration, isNotNull);
    
    // Flex utilities
    expect(utility.flex, isNotNull);
    
    // Can use utilities from both specs
    final attribute = utility.build(
      FlexBoxSpecAttribute()
        .direction(Axis.vertical)
        .width(100.0),
    );
    
    expect(attribute.attribute.$flex, isNotNull);
    expect(attribute.attribute.$box, isNotNull);
  });
});
```

### 11. Special Patterns

#### Directional Properties

Test RTL/LTR behavior for directional properties:

```dart
group('Directional Properties', () {
  test('borderDirectional handles text direction', () {
    final attribute = BoxSpecAttribute()
      .borderDirectional(
        start: BorderSideMix.only(color: Colors.red, width: 2.0),
        end: BorderSideMix.only(color: Colors.blue, width: 3.0),
      );
    
    // Test with LTR
    final ltrContext = MockBuildContext(textDirection: TextDirection.ltr);
    final ltrResolved = attribute.resolve(ltrContext);
    final ltrBorder = (ltrResolved.decoration as BoxDecoration?)?.border as BorderDirectional?;
    
    expect(ltrBorder?.start.color, Colors.red);
    expect(ltrBorder?.end.color, Colors.blue);
    
    // Test with RTL
    final rtlContext = MockBuildContext(textDirection: TextDirection.rtl);
    final rtlResolved = attribute.resolve(rtlContext);
    final rtlBorder = (rtlResolved.decoration as BoxDecoration?)?.border as BorderDirectional?;
    
    expect(rtlBorder?.start.color, Colors.red);
    expect(rtlBorder?.end.color, Colors.blue);
  });
});
```

#### Gradient Utilities

Test complex gradient patterns:

```dart
group('Gradient Utilities', () {
  test('linear gradient utility works correctly', () {
    final attribute = BoxSpecAttribute()
      .linearGradient(
        colors: [Colors.red, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 1.0],
      );
    
    final context = MockBuildContext();
    final decoration = attribute.resolve(context).decoration as BoxDecoration?;
    final gradient = decoration?.gradient as LinearGradient?;
    
    expect(gradient, isNotNull);
    expect(gradient?.colors, [Colors.red, Colors.blue]);
    expect(gradient?.begin, Alignment.topLeft);
    expect(gradient?.end, Alignment.bottomRight);
    expect(gradient?.stops, [0.0, 1.0]);
  });

  test('radial gradient utility works correctly', () {
    final attribute = BoxSpecAttribute()
      .radialGradient(
        colors: [Colors.yellow, Colors.orange],
        center: Alignment.center,
        radius: 0.8,
      );
    
    final context = MockBuildContext();
    final decoration = attribute.resolve(context).decoration as BoxDecoration?;
    final gradient = decoration?.gradient as RadialGradient?;
    
    expect(gradient, isNotNull);
    expect(gradient?.colors, [Colors.yellow, Colors.orange]);
    expect(gradient?.center, Alignment.center);
    expect(gradient?.radius, 0.8);
  });
});
```

#### Token Resolution

Test design token resolution:

```dart
group('Token Resolution', () {
  test('resolves design tokens from context', () {
    final colorToken = ColorToken('primary');
    final spacingToken = SpacingToken('medium');
    
    final attribute = BoxSpecAttribute()
      .color(colorToken)
      .padding.all(spacingToken);
    
    // Create context with token values
    final context = MockBuildContext(
      tokens: {
        'primary': Colors.blue,
        'medium': 16.0,
      },
    );
    
    final resolved = attribute.resolve(context);
    
    expect((resolved.decoration as BoxDecoration?)?.color, Colors.blue);
    expect(resolved.padding, const EdgeInsets.all(16.0));
  });

  test('handles missing tokens gracefully', () {
    final colorToken = ColorToken('undefined');
    final attribute = BoxSpecAttribute().color(colorToken);
    
    final context = MockBuildContext();
    
    // Should not throw, but return null or default
    expect(
      () => attribute.resolve(context),
      returnsNormally,
    );
  });
});
```

### 12. Performance Testing

Test efficiency of utility chains and operations:

```dart
group('Performance', () {
  test('long chains complete in reasonable time', () {
    final stopwatch = Stopwatch()..start();
    
    var attribute = BoxSpecAttribute();
    for (int i = 0; i < 100; i++) {
      attribute = attribute.padding.all(i.toDouble());
    }
    
    stopwatch.stop();
    
    // Should complete in less than 100ms
    expect(stopwatch.elapsedMilliseconds, lessThan(100));
    
    // Final attribute should have last value
    final context = MockBuildContext();
    final resolved = attribute.resolve(context);
    expect(resolved.padding, const EdgeInsets.all(99.0));
  });

  test('merge performance with many properties', () {
    final attr1 = BoxSpecAttribute()
      .width(100.0)
      .height(200.0)
      .padding.all(10.0)
      .margin.all(20.0)
      .color(Colors.red);
    
    final attr2 = BoxSpecAttribute()
      .width(150.0)
      .border.all(BorderSideMix.only(width: 2.0))
      .borderRadius.circular(8.0)
      .elevation(4.0);
    
    final stopwatch = Stopwatch()..start();
    
    for (int i = 0; i < 1000; i++) {
      attr1.merge(attr2);
    }
    
    stopwatch.stop();
    
    // 1000 merges should complete quickly
    expect(stopwatch.elapsedMilliseconds, lessThan(50));
  });
});
```

### 13. Error Handling

Test invalid inputs and edge cases:

```dart
group('Error Handling', () {
  test('handles negative values appropriately', () {
    // Some properties should accept negative values
    final attribute = BoxSpecAttribute()
      .width(-10.0)  // Should this be allowed?
      .elevation(-5.0);  // Definitely should not be allowed
    
    final context = MockBuildContext();
    
    // Test framework behavior with invalid values
    expect(
      () => attribute.resolve(context),
      // Either throws or clamps to valid range
      anyOf(throwsA(anything), returnsNormally),
    );
  });

  test('handles infinity and NaN', () {
    final attribute = BoxSpecAttribute()
      .width(double.infinity)
      .height(double.nan);
    
    final context = MockBuildContext();
    
    // Should handle gracefully
    expect(
      () => attribute.resolve(context),
      returnsNormally,
    );
    
    final resolved = attribute.resolve(context);
    // Check how framework handles these values
    expect(resolved.constraints?.maxWidth, double.infinity);
    expect(resolved.constraints?.maxHeight?.isNaN, isTrue);
  });

  test('handles null in collections', () {
    final attribute = IconSpecAttribute()
      .shadows([
        null, // What happens with null in list?
        ShadowMix.only(color: Colors.black, blurRadius: 2.0),
      ] as List<ShadowMix>);
    
    final context = MockBuildContext();
    
    // Should filter out nulls or handle gracefully
    expect(
      () => attribute.resolve(context),
      returnsNormally,
    );
  });

  test('circular reference handling', () {
    // Test if framework prevents circular references
    // This is more relevant for variants that might reference themselves
    final variant = ContextVariant('recursive', (context) => true);
    
    final attribute = BoxSpecAttribute(
      variants: [
        VariantStyleAttribute(
          variant,
          BoxSpecAttribute(
            variants: [
              VariantStyleAttribute(variant, BoxSpecAttribute()),
            ],
          ),
        ),
      ],
    );
    
    final context = MockBuildContext();
    
    // Should not cause stack overflow
    expect(
      () => attribute.resolve(context),
      returnsNormally,
    );
  });
});
```

## Common Pitfalls to Avoid

1. **Don't forget to test chaining behavior** - Verify that utilities accumulate properties correctly
2. **Don't skip empty constructor tests** - Verify the default state
3. **Don't forget resolution testing** - Context resolution is critical for SpecAttributes
4. **Don't ignore merge behavior** - Test property precedence and combination
5. **Don't skip equality tests** - Ensure proper equality and hashCode implementation
6. **Don't test implementation details** - Focus on public API behavior
7. **Don't forget to test property-specific behaviors** - Each property type may have unique patterns

## Template Checklist

When creating SpecAttribute tests, ensure you have:

### Basic Tests
- [ ] Constructor tests (full, .only(), empty)
- [ ] Utility method behavior tests (new instances, chaining accumulation)
- [ ] Property-specific group tests
- [ ] Resolution tests with MockBuildContext
- [ ] Merge tests (property precedence, null handling)
- [ ] Equality tests (equal cases, different cases, hashCode)
- [ ] Modifiers/Animation/Variants tests (if applicable)

### Advanced Tests (when applicable)
- [ ] Nested utility tests (e.g., `box.padding.all()`)
- [ ] Factory method tests (for attributes with factory constructors)
- [ ] Composite attribute tests (for attributes combining multiple specs)
- [ ] Directional property tests (RTL/LTR behavior)
- [ ] Token resolution tests (if using design tokens)
- [ ] Performance tests (for complex operations)
- [ ] Error handling tests (invalid inputs, edge cases)

### Quality Checks
- [ ] Edge case tests
- [ ] Descriptive test names and comments
- [ ] Proper imports and setup
- [ ] Tests follow the established patterns in this guide

This guide ensures your SpecAttribute tests are comprehensive, maintainable, and follow the established patterns in the Mix framework.