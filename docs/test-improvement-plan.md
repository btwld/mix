# Mix Test Suite Improvement Plan

## Current Test Analysis

After reviewing the test suite, here are the key findings:

### Test Distribution
- **Widget Modifiers**: 19 test files (align, opacity, padding, transform, etc.)
- **DTOs**: 15 test files (already covered)
- **Utilities**: 12 test files (already covered)
- **Specs**: ~15 test files (box, flex, flexbox, icon, image, text, stack)
- **Variants**: ~10 test files (context variants, widget state variants)
- **Core**: ~15 test files (attributes, mix data, styled widget, etc.)

### Most Impactful Improvements

## 1. Widget Modifier Test Consolidation (HIGH IMPACT)

**Problem**: 19 nearly identical test files with massive duplication

**Current Pattern** (repeated 19 times):
```dart
// Every modifier test has:
- Constructor test
- Lerp test (for animation)
- Equality/hashcode test
- Build widget test
- Attribute merge/resolve/equality tests
```

**Solution**: Create shared modifier test framework

```dart
// test/helpers/modifier_test_framework.dart
abstract class ModifierTestCase<TSpec extends WidgetModifierSpec, TAttr extends WidgetModifierSpecAttribute> {
  String get modifierName;
  TSpec createSpec();
  TAttr createAttribute();
  Type get expectedWidgetType;
  void validateWidget(Widget widget);
  
  void runAllTests() {
    group('$modifierName Tests', () {
      // Spec tests
      test('Constructor', () => testConstructor());
      test('Lerp', () => testLerp());
      test('Equality', () => testEquality());
      testWidgets('Build', (tester) => testBuild(tester));
      
      // Attribute tests
      test('Attribute merge', () => testAttrMerge());
      test('Attribute resolve', () => testAttrResolve());
      test('Attribute equality', () => testAttrEquality());
    });
  }
}
```

**Usage Example**:
```dart
// test/src/modifiers/opacity_modifier_test.dart - AFTER
class OpacityModifierTest extends ModifierTestCase<OpacityModifierSpec, OpacityModifierSpecAttribute> {
  @override
  String get modifierName => 'OpacityModifier';
  
  @override
  OpacityModifierSpec createSpec() => OpacityModifierSpec(0.5);
  
  @override
  OpacityModifierSpecAttribute createAttribute() => OpacityModifierSpecAttribute(opacity: 0.5);
  
  @override
  Type get expectedWidgetType => Opacity;
  
  @override
  void validateWidget(Widget widget) {
    expect((widget as Opacity).opacity, 0.5);
  }
}

void main() => OpacityModifierTest().runAllTests();
```

**Impact**: Reduce 19 files from ~80 lines each to ~20 lines each = **~1,140 lines saved**

## 2. Spec Test Consolidation (MEDIUM IMPACT)

**Problem**: Similar patterns across spec tests (resolve, copyWith, lerp)

**Solution**: Create spec test helpers

```dart
// test/helpers/spec_test_helpers.dart
class SpecTestHelpers {
  static void testCopyWith<T extends Spec>(
    String specName,
    T original,
    T Function() createModified,
    void Function(T) validateUnchanged,
  ) {
    test('$specName copyWith preserves unchanged values', () {
      final modified = createModified();
      validateUnchanged(modified);
    });
  }
  
  static void testResolve<T extends Spec>(
    String specName,
    StyleMix attributes,
    void Function(T) validate,
  ) {
    test('$specName resolves correctly', () {
      final mix = MixContext.create(MockBuildContext(), Style(attributes));
      final spec = mix.attributeOf<T>()!.resolve(mix);
      validate(spec);
    });
  }
}
```

## 3. Variant Test Patterns (MEDIUM IMPACT)

**Problem**: Each variant test repeats the same structure

**Solution**: Shared variant test utilities

```dart
// test/helpers/variant_test_helpers.dart
class VariantTestHelpers {
  static void testContextVariant({
    required String name,
    required ContextVariant variant,
    required Widget Function() createTrueContext,
    required Widget Function() createFalseContext,
  }) {
    testWidgets('$name variant responds to context', (tester) async {
      // Test true case
      await tester.pumpWidget(createTrueContext());
      final trueContext = tester.element(find.byType(Container));
      expect(variant.when(trueContext), isTrue);
      
      // Test false case
      await tester.pumpWidget(createFalseContext());
      final falseContext = tester.element(find.byType(Container));
      expect(variant.when(falseContext), isFalse);
    });
  }
}
```

## 4. Create Test Suites (LOW EFFORT, HIGH VALUE)

```dart
// test/suites/all_modifiers_test.dart
import 'all modifier tests...';

void main() {
  group('All Widget Modifiers', () {
    align.main();
    opacity.main();
    padding.main();
    // ... etc
  });
}
```

## 5. Remove Deprecated Tests

**Files to remove**:
- `test/src/deprecated/text_attribute_test.dart`
- `test/src/deprecated/text_spec_test.dart`
- `test/src/deprecated/text_widget_test.dart`

## Implementation Priority

### Phase 1: Quick Wins (1 day)
1. Create test suite files for easy grouped execution
2. Remove deprecated tests
3. Move DTO/Utility tests as already planned

### Phase 2: Modifier Consolidation (2 days)
1. Create `ModifierTestCase` base class
2. Migrate 2-3 modifier tests as proof of concept
3. If successful, migrate remaining modifiers

### Phase 3: Helper Extraction (1 day)
1. Extract common spec test helpers
2. Extract variant test helpers
3. Update a few tests to use helpers

### Phase 4: Documentation (few hours)
1. Add test/README.md explaining the structure
2. Document test patterns and conventions
3. Create test writing guidelines

## Expected Benefits

1. **Code Reduction**: ~1,500+ lines removed
2. **Maintainability**: Changes to test patterns in one place
3. **Consistency**: All similar tests follow same structure
4. **Discoverability**: Easy to find and run test groups
5. **Onboarding**: New contributors understand test patterns quickly

## Success Metrics

- Can run all modifier tests with one command
- Adding a new modifier test takes <5 minutes
- Test patterns are documented and consistent
- No duplicated test logic across files

## Alternative: Super Simple Approach

If the above is too much change, just:
1. Create test suite files (no code changes)
2. Add a simple test helper file with 5-6 shared functions
3. Use helpers only in new tests going forward