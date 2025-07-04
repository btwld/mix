// ignore_for_file: non_constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('MixData', () {
    const autoApplyVariant = MockContextVariantCondition(true);
    test('MixData create', () {
      final mixData = MixContext.create(
        MockBuildContext(),
        Style(
          const MockSpecIntAttribute(1),
          const MockSpecStringAttribute('test'),
          const MockSpecDoubleAttribute(3.0),
          const MockSpecBooleanAttribute(false),
          autoApplyVariant(const MockSpecDoubleAttribute(2.0)),
        ),
      );

      // Test that the `MixData` object is created with the correct properties.
      expect(mixData, isInstanceOf<MixContext>());

      // Add any other additional assertions that are specific to your use case.
      // If you become able to access properties _attributes and _scope you would assert:
      expect(mixData.attributes, isInstanceOf<AttributeMap>());
      expect(mixData.scope, isInstanceOf<MixScopeData>());
      expect(mixData.attributes.length, 4);
      expect(
        mixData.attributeOf<MockSpecIntAttribute>(),
        isInstanceOf<MockSpecIntAttribute>(),
      );
      expect(
        mixData.attributeOf<MockSpecStringAttribute>(),
        const MockSpecStringAttribute('test'),
      );
      expect(
        mixData.attributeOf<MockSpecStringAttribute>(),
        isInstanceOf<MockSpecStringAttribute>(),
      );
      expect(
        mixData.attributeOf<MockSpecDoubleAttribute>(),
        const MockSpecDoubleAttribute(2.0),
      );

      expect(
        mixData.attributeOf<MockSpecBooleanAttribute>(),
        const MockSpecBooleanAttribute(false),
      );
    });

    test('MixData merge', () {
      final mixData = MixContext.create(
        MockBuildContext(),
        Style(
          const MockSpecIntAttribute(1),
          const MockSpecStringAttribute('test'),
          const MockSpecDoubleAttribute(3.0),
          const MockSpecBooleanAttribute(true),
          autoApplyVariant(const MockSpecDoubleAttribute(2.0)),
        ),
      );

      final mixData2 = MixContext.create(
        MockBuildContext(),
        Style(
          const MockSpecDoubleAttribute(5.0),
          autoApplyVariant(const MockSpecDoubleAttribute(4.0)),
        ),
      );

      final mergedMixData = mixData.merge(mixData2);

      expect(mergedMixData, isInstanceOf<MixContext>());
      expect(mergedMixData.attributes.length, 4);
      expect(
        mergedMixData.attributeOf<MockSpecIntAttribute>(),
        isInstanceOf<MockSpecIntAttribute>(),
      );
      expect(
        mergedMixData.attributeOf<MockSpecStringAttribute>(),
        isInstanceOf<MockSpecStringAttribute>(),
      );
      expect(
        mergedMixData.attributeOf<MockSpecDoubleAttribute>(),
        isInstanceOf<MockSpecDoubleAttribute>(),
      );

      expect(
        mergedMixData.attributeOf<MockSpecBooleanAttribute>(),
        const MockSpecBooleanAttribute(true),
      );

      expect(
        mergedMixData.attributeOf<MockSpecIntAttribute>(),
        const MockSpecIntAttribute(1),
      );
      expect(
        mergedMixData.attributeOf<MockSpecStringAttribute>(),
        const MockSpecStringAttribute('test'),
      );
      expect(
        mergedMixData.attributeOf<MockSpecDoubleAttribute>(),
        const MockSpecDoubleAttribute(4.0),
      );
    });

    test(
        'modifiers.whereType returns a list of resolved WidgetModifierSpec of the specified type',
        () {
      final style = Style(
        $with.scale(2.0),
        $with.opacity(0.5),
        $with.visibility.on(),
        $with.clipOval(),
        $with.aspectRatio(2.0),
      );

      final mixData = MixContext.create(MockBuildContext(), style);

      final modifiers = mixData.modifiers;

      expect(modifiers.length, 5);

      final scaleModifiers =
          mixData.modifiers.whereType<TransformModifierSpec>().toList();
      expect(scaleModifiers, [
        TransformModifierSpec(
          transform: Matrix4.diagonal3Values(2.0, 2.0, 1.0),
          alignment: Alignment.center,
        ),
      ]);

      final opacityModifiers =
          mixData.modifiers.whereType<OpacityModifierSpec>().toList();
      expect(opacityModifiers, [const OpacityModifierSpec(0.5)]);

      final visibilityModifiers =
          mixData.modifiers.whereType<VisibilityModifierSpec>().toList();
      expect(visibilityModifiers, [const VisibilityModifierSpec(true)]);

      final clipModifiers =
          mixData.modifiers.whereType<ClipOvalModifierSpec>().toList();
      expect(clipModifiers, [const ClipOvalModifierSpec()]);

      final aspectRatioModifiers =
          mixData.modifiers.whereType<AspectRatioModifierSpec>().toList();
      expect(aspectRatioModifiers, [const AspectRatioModifierSpec(2.0)]);

      final customModifiers =
          mixData.modifiers.whereType<ClipPathModifierSpec>().toList();
      expect(customModifiers, isEmpty);

      final nonExistentModifiers =
          mixData.modifiers.whereType<ClipRectModifierSpec>().toList();
      expect(nonExistentModifiers, isEmpty);
    });

    group('applyContextToVisualAttributes', () {
      test(
          'must return the same Style that was inputted when there is not ContextVariant in the Style (simple variant)',
          () {
        final style = Style(
          $icon.color.black(),
        );

        final attributeList =
            applyContextToVisualAttributes(MockBuildContext(), style);

        expect(attributeList, style.styles.values);
      });

      test(
          'ContextVariantBuilder should apply Style based on when() return value',
          () {
        for (var whenReturnValue in [true, false]) {
          final variant = _MockContextVariant(whenReturnValue: whenReturnValue);
          final style = Style(const MockIntScalarAttribute(1));
          final builder = ContextVariantBuilder((_) => style, variant);

          final attributesList = applyContextToVisualAttributes(
            MockBuildContext(),
            Style(builder),
          );

          if (whenReturnValue) {
            expect(attributesList, equals([const MockIntScalarAttribute(1)]));
          } else {
            expect(attributesList, isEmpty);
          }
        }
      });

      test(
          'must return the same Style that was inputted when is only Variants in the Style',
          () {
        _testApplyContextToVisualAttributes(
          condition: MultiVariant.or(const [Variant('1'), Variant('2')]),
          isExpectedToApply: false,
        );

        _testApplyContextToVisualAttributes(
          condition: MultiVariant.and(const [Variant('1'), Variant('2')]),
          isExpectedToApply: false,
        );

        _testApplyContextToVisualAttributes(
          condition: MultiVariant.or([
            const Variant('1'),
            MultiVariant.or(const [Variant('2'), Variant('3')])
          ]),
          isExpectedToApply: false,
        );

        _testApplyContextToVisualAttributes(
          condition: MultiVariant.or([
            const Variant('1'),
            MultiVariant.and(const [Variant('2'), Variant('3')])
          ]),
          isExpectedToApply: false,
        );

        _testApplyContextToVisualAttributes(
          condition: MultiVariant.and([
            const Variant('1'),
            MultiVariant.or(const [Variant('2'), Variant('3')])
          ]),
          isExpectedToApply: false,
        );

        _testApplyContextToVisualAttributes(
          condition: MultiVariant.and([
            const Variant('1'),
            MultiVariant.and(const [Variant('2'), Variant('3')])
          ]),
          isExpectedToApply: false,
        );
      });

      group('must respect the condition', () {
        test('with single ContextVariant', () {
          _testApplyContextToVisualAttributes(
            condition: const MockContextVariantCondition(false),
            isExpectedToApply: false,
          );

          _testApplyContextToVisualAttributes(
            condition: const MockContextVariantCondition(true),
            isExpectedToApply: true,
          );
        });

        test('with MultiVariant.or(ContextVariant, ContextVariant)', () {
          void testCase(
            bool v1,
            bool v2, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.or([
                MockContextVariantCondition(v1),
                MockContextVariantCondition(v2)
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, true, equalsTo: true);
          testCase(true, false, equalsTo: true);
          testCase(false, true, equalsTo: true);
          testCase(false, false, equalsTo: false);
        });

        test('with MultiVariant.and(ContextVariant, ContextVariant)', () {
          void testCase(
            bool v1,
            bool v2, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.and([
                MockContextVariantCondition(v1),
                MockContextVariantCondition(v2)
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, true, equalsTo: true);
          testCase(true, false, equalsTo: false);
          testCase(false, true, equalsTo: false);
          testCase(false, false, equalsTo: false);
        });

        test(
            'with MultiVariant.and(MultiVariant.and(ContextVariant, ContextVariant), ContextVariant)',
            () {
          void testCase(
            bool v1,
            bool v2,
            bool v3, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.and([
                MockContextVariantCondition(v1),
                MultiVariant.and([
                  MockContextVariantCondition(v2),
                  MockContextVariantCondition(v3)
                ]),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, true, true, equalsTo: true);
          testCase(true, true, false, equalsTo: false);
          testCase(true, false, true, equalsTo: false);
          testCase(true, false, false, equalsTo: false);
          testCase(false, true, true, equalsTo: false);
          testCase(false, true, false, equalsTo: false);
          testCase(false, false, true, equalsTo: false);
          testCase(false, false, false, equalsTo: false);
        });

        test(
            'with MultiVariant.or(MultiVariant.or(ContextVariant, ContextVariant), ContextVariant)',
            () {
          void testCase(
            bool v1,
            bool v2,
            bool v3, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.or([
                MockContextVariantCondition(v1),
                MultiVariant.or([
                  MockContextVariantCondition(v2),
                  MockContextVariantCondition(v3)
                ]),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, true, true, equalsTo: true);
          testCase(true, true, false, equalsTo: true);
          testCase(true, false, true, equalsTo: true);
          testCase(true, false, false, equalsTo: true);
          testCase(false, true, true, equalsTo: true);
          testCase(false, true, false, equalsTo: true);
          testCase(false, false, true, equalsTo: true);
          testCase(false, false, false, equalsTo: false);
        });

        test(
            'with MultiVariant.and(MultiVariant.or(ContextVariant, ContextVariant), ContextVariant)',
            () {
          void testCase(
            bool v1,
            bool v2,
            bool v3, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.and([
                MockContextVariantCondition(v1),
                MultiVariant.or([
                  MockContextVariantCondition(v2),
                  MockContextVariantCondition(v3)
                ]),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, true, true, equalsTo: true);
          testCase(true, true, false, equalsTo: true);
          testCase(true, false, true, equalsTo: true);
          testCase(true, false, false, equalsTo: false);
          testCase(false, true, true, equalsTo: false);
          testCase(false, true, false, equalsTo: false);
          testCase(false, false, true, equalsTo: false);
          testCase(false, false, false, equalsTo: false);
        });

        test(
            'with MultiVariant.or(MultiVariant.and(ContextVariant, ContextVariant), ContextVariant)',
            () {
          void testCase(
            bool v1,
            bool v2,
            bool v3, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.or([
                MockContextVariantCondition(v1),
                MultiVariant.and([
                  MockContextVariantCondition(v2),
                  MockContextVariantCondition(v3)
                ]),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, true, true, equalsTo: true);
          testCase(true, true, false, equalsTo: true);
          testCase(true, false, true, equalsTo: true);
          testCase(true, false, false, equalsTo: true);
          testCase(false, true, true, equalsTo: true);
          testCase(false, true, false, equalsTo: false);
          testCase(false, false, true, equalsTo: false);
          testCase(false, false, false, equalsTo: false);
        });

        test('with MultiVariant.or(Variant, ContextVariant)', () {
          void testCase(
            bool v1, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.or([
                const Variant('1'),
                MockContextVariantCondition(v1),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, equalsTo: true);
          testCase(false, equalsTo: false);
        });

        test('with MultiVariant.or(Variant, ContextVariant)', () {
          void testCase(
            bool v1, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.or([
                const Variant('1'),
                MockContextVariantCondition(v1),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, equalsTo: true);
          testCase(false, equalsTo: false);
        });

        test('with MultiVariant.and(Variant, ContextVariant)', () {
          void testCase(
            bool v1, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.and([
                const Variant('1'),
                MockContextVariantCondition(v1),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, equalsTo: false);
          testCase(false, equalsTo: false);
        });

        test(
            'with MultiVariant.and(Variant, MultiVariant.and(Variant, ContextVariant))',
            () {
          void testCase(
            bool v1, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.and([
                const Variant('1'),
                MultiVariant.and([
                  const Variant('2'),
                  MockContextVariantCondition(v1),
                ]),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, equalsTo: false);
          testCase(false, equalsTo: false);
        });

        test(
            'with MultiVariant.and(ContextVariant, MultiVariant.and(Variant, ContextVariant))',
            () {
          void testCase(
            bool v1,
            bool v2, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.and([
                MockContextVariantCondition(v1),
                MultiVariant.and([
                  const Variant('1'),
                  MockContextVariantCondition(v2),
                ]),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, true, equalsTo: false);
          testCase(true, false, equalsTo: false);
          testCase(false, true, equalsTo: false);
          testCase(false, false, equalsTo: false);
        });

        test(
            'with MultiVariant.and(ContextVariant, MultiVariant.or(Variant, ContextVariant))',
            () {
          void testCase(
            bool v1,
            bool v2, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.and([
                MockContextVariantCondition(v1),
                MultiVariant.or([
                  const Variant('1'),
                  MockContextVariantCondition(v2),
                ]),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, true, equalsTo: true);
          testCase(true, false, equalsTo: false);
          testCase(false, true, equalsTo: false);
          testCase(false, false, equalsTo: false);
        });

        test(
            'with MultiVariant.or(ContextVariant, MultiVariant.or(Variant, ContextVariant))',
            () {
          void testCase(
            bool v1,
            bool v2, {
            required bool equalsTo,
          }) {
            _testApplyContextToVisualAttributes(
              condition: MultiVariant.or([
                MockContextVariantCondition(v1),
                MultiVariant.or([
                  const Variant('1'),
                  MockContextVariantCondition(v2),
                ]),
              ]),
              isExpectedToApply: equalsTo,
            );
          }

          testCase(true, true, equalsTo: true);
          testCase(true, false, equalsTo: true);
          testCase(false, true, equalsTo: true);
          testCase(false, false, equalsTo: false);
        });
      });
    });
  });
}

void _testApplyContextToVisualAttributes({
  required dynamic condition,
  required bool isExpectedToApply,
}) {
  final style = Style(
    $box.color.black(),
    condition(
      $icon.color.black(),
    ),
  );

  final attributeList = applyContextToVisualAttributes(
    MockBuildContext(),
    style,
  );

  final expectedStyle = Style.create([
    $box.color.black(),
    if (isExpectedToApply) $icon.color.black(),
  ]);

  expect(attributeList, expectedStyle.styles.values);
}

class _MockContextVariant extends ContextVariant {
  final bool whenReturnValue;
  const _MockContextVariant({this.whenReturnValue = true});

  @override
  bool when(BuildContext context) => whenReturnValue;
}
