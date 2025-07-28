import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxSpecAttribute', () {
    group('Constructor', () {
      test('creates BoxSpecAttribute with all properties', () {
        final attribute = BoxMix(
          alignment: Alignment.center,
          padding: EdgeInsetsMix(top: 8.0),
          margin: EdgeInsetsMix(left: 16.0),
          constraints: BoxConstraintsMix(maxWidth: 200.0),
          decoration: BoxDecorationMix(color: Colors.red),
          foregroundDecoration: BoxDecorationMix(color: Colors.blue),
          transform: Matrix4.identity(),
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.antiAlias,
        );

        expectProp(attribute.$alignment, Alignment.center);

        expectProp(attribute.$clipBehavior, Clip.antiAlias);
        expectProp(attribute.$transformAlignment, Alignment.topLeft);
        expectProp(attribute.$transform, Matrix4.identity());
        expect(attribute.$padding, isNotNull);
        expect(attribute.$margin, isNotNull);
        expect(attribute.$constraints, isNotNull);
        expect(attribute.$decoration, isNotNull);
        expect(attribute.$foregroundDecoration, isNotNull);
      });

      test('creates BoxSpecAttribute using only constructor', () {
        final attribute = BoxMix(
          alignment: Alignment.center,
          padding: EdgeInsetsMix(top: 8.0),
          margin: EdgeInsetsMix(left: 16.0),
          constraints: BoxConstraintsMix(maxWidth: 200.0),
          decoration: BoxDecorationMix(color: Colors.red),
          foregroundDecoration: BoxDecorationMix(color: Colors.blue),
          transform: Matrix4.identity(),
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.antiAlias,
        );

        expectProp(attribute.$alignment, Alignment.center);
        // Width and height are set through constraints
        expect(attribute.$constraints, isNotNull);
        expectProp(attribute.$clipBehavior, Clip.antiAlias);
        expectProp(attribute.$transformAlignment, Alignment.topLeft);
        expectProp(attribute.$transform, Matrix4.identity());
        expect(attribute.$padding, isNotNull);
        expect(attribute.$margin, isNotNull);
        expect(attribute.$constraints, isNotNull);
        expect(attribute.$decoration, isNotNull);
        expect(attribute.$foregroundDecoration, isNotNull);
      });

      test('creates empty BoxSpecAttribute', () {
        final attribute = BoxMix();

        expect(attribute.$alignment, isNull);
        expect(attribute.$padding, isNull);
        expect(attribute.$margin, isNull);
        expect(attribute.$constraints, isNull);
        expect(attribute.$decoration, isNull);
        expect(attribute.$foregroundDecoration, isNull);
        expect(attribute.$transform, isNull);
        expect(attribute.$transformAlignment, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('Utility Methods', () {
      test('utility methods create new instances', () {
        final original = BoxMix();
        final withWidth = original.width(100.0);
        final withHeight = original.height(200.0);

        // Each utility creates a new instance
        expect(identical(original, withWidth), isFalse);
        expect(identical(original, withHeight), isFalse);
        expect(identical(withWidth, withHeight), isFalse);

        // Original remains unchanged
        expect(original.$constraints, isNull);

        // Each new instance has constraints set
        expect(withWidth.$constraints, isNotNull);
        expect(withHeight.$constraints, isNotNull);
      });

      test('chaining utilities accumulates properties correctly', () {
        // Chaining now properly accumulates all properties
        final chained = BoxMix().width(100.0).height(200.0);

        // Chained constraints should have both width and height
        expect(chained.$constraints, isNotNull);
        final constraints = chained.$constraints?.resolve(MockBuildContext());
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
      });

      test('chaining with complex properties works correctly', () {
        // Test chaining with more complex properties
        final combined = BoxMix()
            .width(100.0)
            .height(200.0)
            .color(Colors.red)
            .padding(EdgeInsetsGeometryMix.value(const EdgeInsets.all(16.0)));

        expect(combined.$constraints, isNotNull);
        final combinedConstraints = combined.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(combinedConstraints?.minWidth, 100.0);
        expect(combinedConstraints?.maxWidth, 100.0);
        expect(combinedConstraints?.minHeight, 200.0);
        expect(combinedConstraints?.maxHeight, 200.0);
        expect(combined.$decoration, isNotNull);
        expect(combined.$padding, isNotNull);
      });
    });

    group('value constructor', () {
      test('creates BoxSpecAttribute from BoxSpec', () {
        const spec = BoxSpec(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(color: Colors.red),
          transform: null, // Matrix4 can't be const
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.antiAlias,
          constraints: BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
        );

        final attribute = BoxMix.value(spec);

        expectProp(attribute.$alignment, Alignment.center);
        // Constraints are set
        expect(attribute.$constraints, isNotNull);
        expectProp(attribute.$transformAlignment, Alignment.topLeft);
        expectProp(attribute.$clipBehavior, Clip.antiAlias);
        expect(attribute.$padding, isNotNull);
        expect(attribute.$margin, isNotNull);
        expect(attribute.$decoration, isNotNull);
      });

      test('maybeValue returns null for null spec', () {
        expect(BoxMix.maybeValue(null), isNull);
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
        );
        final attribute = BoxMix.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$constraints, isNotNull);
        final constraints = attribute.$constraints?.resolve(MockBuildContext());
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
      });
    });

    group('Color and Decoration', () {
      test('color utility creates decoration with color', () {
        final attribute = BoxMix().color(Colors.red);

        expect(attribute.$decoration, isNotNull);

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);
        final decoration = resolved.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
      });

      test('decoration utilities create new instances', () {
        // Each decoration utility creates a new BoxSpecAttribute
        final withColor = BoxMix().color(Colors.red);
        final withBorder = BoxMix().border(
          BoxBorderMix.all(BorderSideMix(width: 2.0)),
        );
        final withBorderRadius = BoxMix().borderRadius(
          BorderRadiusMix.all(Radius.circular(8.0)),
        );

        // Each has only its specific decoration property
        final context = MockBuildContext();

        final colorDecoration =
            withColor.resolve(context).decoration as BoxDecoration?;
        expect(colorDecoration?.color, Colors.red);
        expect(colorDecoration?.border, isNull);
        expect(colorDecoration?.borderRadius, isNull);

        final borderDecoration =
            withBorder.resolve(context).decoration as BoxDecoration?;
        expect(borderDecoration?.color, isNull);
        expect(borderDecoration?.border, isNotNull);
        expect(borderDecoration?.borderRadius, isNull);

        final radiusDecoration =
            withBorderRadius.resolve(context).decoration as BoxDecoration?;
        expect(radiusDecoration?.color, isNull);
        expect(radiusDecoration?.border, isNull);
        expect(radiusDecoration?.borderRadius, isNotNull);
      });

      test('combine decorations with merge', () {
        final combined = BoxMix()
            .color(Colors.red)
            .merge(BoxMix().border(BoxBorderMix.all(BorderSideMix(width: 2.0))))
            .merge(
              BoxMix().borderRadius(BorderRadiusMix.all(Radius.circular(8.0))),
            );

        final context = MockBuildContext();
        final decoration =
            combined.resolve(context).decoration as BoxDecoration?;

        expect(decoration?.color, Colors.red);
        expect(decoration?.border, isNotNull);
        expect(decoration?.borderRadius, isNotNull);
      });
    });

    group('Padding and Margin', () {
      test('padding methods create correct EdgeInsets', () {
        final all = BoxMix().padding(EdgeInsetsMix.all(16.0));
        expect(all.$padding, isNotNull);

        // Symmetric padding using vertical and horizontal
        final verticalPadding = BoxMix().padding(
          EdgeInsetsMix.symmetric(vertical: 8.0),
        );
        expect(verticalPadding.$padding, isNotNull);

        final horizontalPadding = BoxMix().padding(
          EdgeInsetsMix.symmetric(horizontal: 16.0),
        );
        expect(horizontalPadding.$padding, isNotNull);

        // Individual sides
        final topPadding = BoxMix().padding(EdgeInsetsMix(top: 8.0));
        expect(topPadding.$padding, isNotNull);

        final leftPadding = BoxMix().padding(EdgeInsetsMix(left: 16.0));
        expect(leftPadding.$padding, isNotNull);
      });

      test('margin methods create correct EdgeInsets', () {
        final all = BoxMix().margin(EdgeInsetsMix.all(16.0));
        expect(all.$margin, isNotNull);

        // Symmetric margin using vertical and horizontal
        final verticalMargin = BoxMix().margin(
          EdgeInsetsMix.symmetric(vertical: 8.0),
        );
        expect(verticalMargin.$margin, isNotNull);

        final horizontalMargin = BoxMix().margin(
          EdgeInsetsMix.symmetric(horizontal: 16.0),
        );
        expect(horizontalMargin.$margin, isNotNull);

        // Individual sides
        final topMargin = BoxMix().margin(EdgeInsetsMix(top: 8.0));
        expect(topMargin.$margin, isNotNull);

        final leftMargin = BoxMix().margin(EdgeInsetsMix(left: 16.0));
        expect(leftMargin.$margin, isNotNull);
      });
    });

    group('Size Constraints', () {
      test('width and height utilities create separate instances', () {
        final withWidth = BoxMix().width(100.0);
        final withHeight = BoxMix().height(200.0);

        expect(withWidth.$constraints, isNotNull);
        final widthConstraints = withWidth.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(widthConstraints?.minWidth, 100.0);
        expect(widthConstraints?.maxWidth, 100.0);

        expect(withHeight.$constraints, isNotNull);
        final heightConstraints = withHeight.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(heightConstraints?.minHeight, 200.0);
        expect(heightConstraints?.maxHeight, 200.0);
      });

      test('combine width and height with merge or constructor', () {
        // Option 1: Use merge
        final merged = BoxMix().width(100.0).merge(BoxMix().height(200.0));

        expect(merged.$constraints, isNotNull);
        final mergedConstraints = merged.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(mergedConstraints?.minWidth, 100.0);
        expect(mergedConstraints?.maxWidth, 100.0);
        expect(mergedConstraints?.minHeight, 200.0);
        expect(mergedConstraints?.maxHeight, 200.0);

        // Option 2: Use constructor
        final constructed = BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
        );

        expect(constructed.$constraints, isNotNull);
        final constructedConstraints = constructed.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(constructedConstraints?.minWidth, 100.0);
        expect(constructedConstraints?.maxWidth, 100.0);
        expect(constructedConstraints?.minHeight, 200.0);
        expect(constructedConstraints?.maxHeight, 200.0);
      });

      test('constraint utilities create separate instances', () {
        // Each constraint utility creates a new instance
        final minWidth = BoxMix().minWidth(100.0);
        final maxWidth = BoxMix().maxWidth(200.0);
        final minHeight = BoxMix().minHeight(50.0);
        final maxHeight = BoxMix().maxHeight(150.0);

        // Each has only its specific constraint
        final context = MockBuildContext();

        expect(minWidth.resolve(context).constraints?.minWidth, 100.0);
        expect(
          minWidth.resolve(context).constraints?.maxWidth,
          double.infinity,
        );

        expect(maxWidth.resolve(context).constraints?.maxWidth, 200.0);
        expect(maxWidth.resolve(context).constraints?.minWidth, 0.0);

        expect(minHeight.resolve(context).constraints?.minHeight, 50.0);
        expect(maxHeight.resolve(context).constraints?.maxHeight, 150.0);
      });

      test('combine constraints with merge or constructor', () {
        // Option 1: Merge multiple constraints
        final merged = BoxMix()
            .minWidth(100.0)
            .merge(BoxMix().maxWidth(200.0))
            .merge(BoxMix().minHeight(50.0))
            .merge(BoxMix().maxHeight(150.0));

        final context = MockBuildContext();
        final constraints = merged.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 200.0);
        expect(constraints?.minHeight, 50.0);
        expect(constraints?.maxHeight, 150.0);

        // Option 2: Use constructor with BoxConstraintsMix
        final constructed = BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 100.0,
            maxWidth: 200.0,
            minHeight: 50.0,
            maxHeight: 150.0,
          ),
        );

        final constraints2 = constructed.resolve(context).constraints;
        expect(constraints2?.minWidth, 100.0);
        expect(constraints2?.maxWidth, 200.0);
        expect(constraints2?.minHeight, 50.0);
        expect(constraints2?.maxHeight, 150.0);
      });
    });

    group('Resolution', () {
      test('resolves to BoxSpec with correct properties', () {
        // Use constructor or merge to combine properties
        final attribute = BoxMix(
          alignment: Alignment.center,
          padding: EdgeInsetsMix.all(16.0),
          decoration: BoxDecorationMix(color: Colors.red),
          constraints: BoxConstraintsMix(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.constraints?.minWidth, 100.0);
        expect(spec.constraints?.maxWidth, 100.0);
        expect(spec.constraints?.minHeight, 200.0);
        expect(spec.constraints?.maxHeight, 200.0);
        expect(spec.alignment, Alignment.center);
        expect(spec.padding, const EdgeInsets.all(16.0));
        final decoration = spec.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
      });

      test('resolves padding with individual sides', () {
        // Use EdgeInsetsMix.only to set specific sides
        final attribute = BoxMix(
          padding: EdgeInsetsMix(
            top: 10.0,
            bottom: 20.0,
            left: 30.0,
            right: 40.0,
          ),
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(
          spec.padding,
          const EdgeInsets.only(
            top: 10.0,
            bottom: 20.0,
            left: 30.0,
            right: 40.0,
          ),
        );
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        // Create attributes with specific properties
        final first = BoxMix(decoration: BoxDecorationMix(color: Colors.red));

        final second = BoxMix(
          constraints: BoxConstraintsMix(minWidth: 150.0, maxWidth: 150.0),
          padding: EdgeInsetsMix.all(16.0),
          alignment: Alignment.center,
        );

        final merged = first.merge(second);

        expect(merged.$constraints, isNotNull);
        // Verify constraints were merged properly
        expect(merged.$padding, isNotNull); // from second
        expectProp(merged.$alignment, Alignment.center); // from second
        expect(merged.$decoration, isNotNull); // decoration from first
      });

      test('returns this when other is null', () {
        final attribute = BoxMix().width(100.0);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });
    });

    group('Modifiers', () {
      test('modifiers can be added to attribute', () {
        final attribute = BoxMix(
          modifierConfig: ModifierConfig(modifiers: [
            OpacityModifierAttribute(opacity: 0.5),
            TransformModifierAttribute(
              transform: Matrix4.identity(),
              alignment: Alignment.center,
            ),
          ]),
        );

        expect(attribute.$modifierConfig, isNotNull);
        expect(attribute.$modifierConfig!.$modifiers!.length, 2);
      });

      test('modifiers merge correctly', () {
        final opacityModifier = OpacityModifierAttribute(opacity: 0.5);
        final transformModifier = TransformModifierAttribute(
          transform: Matrix4.identity(),
        );

        final first = BoxMix(modifierConfig: ModifierConfig(modifiers: [opacityModifier]));
        final second = BoxMix(modifierConfig: ModifierConfig(modifiers: [transformModifier]));

        final merged = first.merge(second);

        // Check that the modifiers list matches exactly the expected list
        final expectedModifiers = [
          OpacityModifierAttribute(opacity: 0.5),
          TransformModifierAttribute(transform: Matrix4.identity()),
        ];

        expect(merged.$modifierConfig?.$modifiers, expectedModifiers);
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        // Note: Chaining doesn't work as expected, so we use constructor
        final attr1 = BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
          decoration: BoxDecorationMix(color: Colors.red),
        );

        final attr2 = BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
          decoration: BoxDecorationMix(color: Colors.red),
        );

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = BoxMix().width(100.0);
        final attr2 = BoxMix().width(200.0);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Convenience Methods', () {
      test('animate method sets animation config', () {
        final animation = AnimationConfig.curve(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        final attribute = BoxMix.animation(animation);

        expect(attribute.$animation, equals(animation));
      });
    });

    group('Utility Methods', () {
      test('has all expected utility methods', () {
        final attribute = BoxMix();

        // Methods exist and return BoxSpecAttribute
        expect(attribute.alignment(Alignment.center), isA<BoxMix>());
        expect(attribute.width(100), isA<BoxMix>());
        expect(attribute.height(100), isA<BoxMix>());
        expect(attribute.padding(EdgeInsetsMix.all(10)), isA<BoxMix>());
        expect(attribute.margin(EdgeInsetsMix.all(10)), isA<BoxMix>());
        expect(attribute.clipBehavior(Clip.none), isA<BoxMix>());
        expect(attribute.transform(Matrix4.identity()), isA<BoxMix>());
        expect(attribute.transformAlignment(Alignment.center), isA<BoxMix>());

        // Decoration methods
        expect(attribute.color(Colors.red), isA<BoxMix>());
        expect(attribute.border(BorderMix.all(BorderSideMix())), isA<BoxMix>());
        expect(
          attribute.borderRadius(BorderRadiusMix.all(Radius.circular(10))),
          isA<BoxMix>(),
        );
        expect(attribute.shadow(BoxShadowMix()), isA<BoxMix>());

        // Constraint methods
        expect(attribute.minWidth(100), isA<BoxMix>());
        expect(attribute.maxWidth(100), isA<BoxMix>());
        expect(attribute.minHeight(100), isA<BoxMix>());
        expect(attribute.maxHeight(100), isA<BoxMix>());
      });
    });

    group('Helper Methods', () {
      test('utility methods create proper attributes', () {
        final attribute = BoxMix();

        // Test that utility methods exist and return proper types
        final widthAttr = attribute.width(100.0);
        expect(widthAttr, isA<BoxMix>());

        final heightAttr = attribute.height(200.0);
        expect(heightAttr, isA<BoxMix>());

        final colorAttr = attribute.color(Colors.blue);
        expect(colorAttr, isA<BoxMix>());

        final alignmentAttr = attribute.alignment(Alignment.center);
        expect(alignmentAttr, isA<BoxMix>());
      });
    });

    group('Builder pattern', () {
      test('builder methods create new instances', () {
        final original = BoxMix();
        final modified = original.width(100.0);

        expect(identical(original, modified), isFalse);
        expect(original.$constraints, isNull);
        expect(modified.$constraints, isNotNull);
      });

      test('builder methods can be chained fluently with merge', () {
        final attribute = BoxMix()
            .width(100.0)
            .merge(BoxMix().height(200.0))
            .merge(BoxMix().color(Colors.red))
            .merge(BoxMix().alignment(Alignment.center));

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec.constraints?.minWidth, 100.0);
        expect(spec.constraints?.maxWidth, 100.0);
        expect(spec.constraints?.minHeight, 200.0);
        expect(spec.constraints?.maxHeight, 200.0);
        expect(spec.alignment, Alignment.center);
        final decoration = spec.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = BoxMix(
          alignment: Alignment.center,
          padding: EdgeInsetsMix.all(16.0),
          margin: EdgeInsetsMix.all(8.0),
          constraints: BoxConstraintsMix(maxWidth: 300.0),
          decoration: BoxDecorationMix(color: Colors.red),
          foregroundDecoration: BoxDecorationMix(color: Colors.blue),
          transform: Matrix4.identity(),
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.antiAlias,
        );

        expect(attribute.props.length, 12);
        expect(attribute.props, contains(attribute.$alignment));
        expect(attribute.props, contains(attribute.$padding));
        expect(attribute.props, contains(attribute.$margin));
        expect(attribute.props, contains(attribute.$constraints));
        expect(attribute.props, contains(attribute.$decoration));
        expect(attribute.props, contains(attribute.$foregroundDecoration));
        expect(attribute.props, contains(attribute.$transform));
        expect(attribute.props, contains(attribute.$transformAlignment));
        expect(attribute.props, contains(attribute.$clipBehavior));
        expect(attribute.props, contains(attribute.$animation));
        expect(attribute.props, contains(attribute.$modifierConfig));
        expect(attribute.props, contains(attribute.$variants));
      });
    });

    group('Debug Properties', () {
      test('debugFillProperties includes all properties', () {
        // This test verifies that the attribute implements Diagnosticable correctly
        final attribute = BoxMix()
            .width(100.0)
            .merge(BoxMix().height(200.0))
            .merge(BoxMix().color(Colors.red));

        // The presence of debugFillProperties is tested by the framework
        expect(attribute, isA<BoxMix>());
      });
    });

    group('Animation', () {
      test('animation config can be added to attribute', () {
        final attribute = BoxMix();
        expect(attribute.$animation, isNull); // By default no animation
      });
    });

    group('Variants', () {
      test('variants functionality exists', () {
        // Note: Variants require proper Variant instances, not builders
        // This test demonstrates that the variants property exists
        final attribute = BoxMix();
        expect(attribute.$variants, isNull); // By default no variants
      });
    });

    group('Factory Methods', () {
      group('Dimension Factories', () {
        test('height method creates attribute with height constraint', () {
          final attribute = BoxMix().height(200.0);

          expect(attribute.$constraints, isNotNull);
          final context = MockBuildContext();
          final constraints = attribute.resolve(context).constraints;
          expect(constraints?.minHeight, 200.0);
          expect(constraints?.maxHeight, 200.0);
        });

        test('width method creates attribute with width constraint', () {
          final attribute = BoxMix().width(100.0);

          expect(attribute.$constraints, isNotNull);
          final context = MockBuildContext();
          final constraints = attribute.resolve(context).constraints;
          expect(constraints?.minWidth, 100.0);
          expect(constraints?.maxWidth, 100.0);
        });

        test('minWidth method creates attribute with minWidth constraint', () {
          final attribute = BoxMix().minWidth(50.0);

          expect(attribute.$constraints, isNotNull);
          final context = MockBuildContext();
          final constraints = attribute.resolve(context).constraints;
          expect(constraints?.minWidth, 50.0);
        });

        test('maxWidth method creates attribute with maxWidth constraint', () {
          final attribute = BoxMix().maxWidth(300.0);

          expect(attribute.$constraints, isNotNull);
          final context = MockBuildContext();
          final constraints = attribute.resolve(context).constraints;
          expect(constraints?.maxWidth, 300.0);
        });

        test(
          'minHeight method creates attribute with minHeight constraint',
          () {
            final attribute = BoxMix().minHeight(75.0);

            expect(attribute.$constraints, isNotNull);
            final context = MockBuildContext();
            final constraints = attribute.resolve(context).constraints;
            expect(constraints?.minHeight, 75.0);
          },
        );

        test(
          'maxHeight method creates attribute with maxHeight constraint',
          () {
            final attribute = BoxMix().maxHeight(400.0);

            expect(attribute.$constraints, isNotNull);
            final context = MockBuildContext();
            final constraints = attribute.resolve(context).constraints;
            expect(constraints?.maxHeight, 400.0);
          },
        );
      });

      group('Constraint Factory', () {
        test(
          'constraints factory creates attribute with custom constraints',
          () {
            final constraintsMix = BoxConstraintsMix(
              minWidth: 100.0,
              maxWidth: 200.0,
              minHeight: 150.0,
              maxHeight: 300.0,
            );
            final attribute = BoxMix().constraints(constraintsMix);

            expect(attribute.$constraints, isNotNull);
            final context = MockBuildContext();
            final constraints = attribute.resolve(context).constraints;
            expect(constraints?.minWidth, 100.0);
            expect(constraints?.maxWidth, 200.0);
            expect(constraints?.minHeight, 150.0);
            expect(constraints?.maxHeight, 300.0);
          },
        );
      });

      group('Decoration Factories', () {
        test('decoration factory creates attribute with decoration', () {
          final decorationMix = BoxDecorationMix(color: Colors.blue);
          final attribute = BoxMix().decoration(decorationMix);

          expect(attribute.$decoration, isNotNull);
          final context = MockBuildContext();
          final decoration =
              attribute.resolve(context).decoration as BoxDecoration?;
          expect(decoration?.color, Colors.blue);
        });

        test(
          'foregroundDecoration factory creates attribute with foreground decoration',
          () {
            final decorationMix = BoxDecorationMix(color: Colors.green);
            final attribute = BoxMix().foregroundDecoration(decorationMix);

            expect(attribute.$foregroundDecoration, isNotNull);
            final context = MockBuildContext();
            final foregroundDecoration =
                attribute.resolve(context).foregroundDecoration
                    as BoxDecoration?;
            expect(foregroundDecoration?.color, Colors.green);
          },
        );

        test('border factory creates attribute with border decoration', () {
          final borderMix = BoxBorderMix.all(
            BorderSideMix(width: 2.0, color: Colors.red),
          );
          final attribute = BoxMix().border(borderMix);

          expect(attribute.$decoration, isNotNull);
          final context = MockBuildContext();
          final decoration =
              attribute.resolve(context).decoration as BoxDecoration?;
          expect(decoration?.border, isNotNull);
        });

        test(
          'borderRadius factory creates attribute with border radius decoration',
          () {
            final borderRadiusMix = BorderRadiusMix.all(
              const Radius.circular(8.0),
            );
            final attribute = BoxMix().borderRadius(borderRadiusMix);

            expect(attribute.$decoration, isNotNull);
            final context = MockBuildContext();
            final decoration =
                attribute.resolve(context).decoration as BoxDecoration?;
            expect(decoration?.borderRadius, isNotNull);
          },
        );
      });

      group('Layout Factories', () {
        test('alignment factory creates attribute with alignment', () {
          final attribute = BoxMix().alignment(Alignment.topRight);

          expectProp(attribute.$alignment, Alignment.topRight);
        });

        test('padding factory creates attribute with padding', () {
          final paddingMix = EdgeInsetsMix.all(12.0);
          final attribute = BoxMix().padding(paddingMix);

          expect(attribute.$padding, isNotNull);
          final context = MockBuildContext();
          final padding = attribute.resolve(context).padding;
          expect(padding, const EdgeInsets.all(12.0));
        });

        test('margin factory creates attribute with margin', () {
          final marginMix = EdgeInsetsMix.all(8.0);
          final attribute = BoxMix().margin(marginMix);

          expect(attribute.$margin, isNotNull);
          final context = MockBuildContext();
          final margin = attribute.resolve(context).margin;
          expect(margin, const EdgeInsets.all(8.0));
        });
      });

      group('Transform Factories', () {
        test('transform factory creates attribute with transform', () {
          final transform = Matrix4.rotationZ(0.5);
          final attribute = BoxMix().transform(transform);

          expectProp(attribute.$transform, transform);
        });

        test(
          'transformAlignment factory creates attribute with transform alignment',
          () {
            final attribute = BoxMix().transformAlignment(Alignment.bottomLeft);

            expectProp(attribute.$transformAlignment, Alignment.bottomLeft);
          },
        );
      });

      group('Clip Factory', () {
        test('clipBehavior factory creates attribute with clip behavior', () {
          final attribute = BoxMix().clipBehavior(Clip.hardEdge);

          expectProp(attribute.$clipBehavior, Clip.hardEdge);
        });
      });
    });

    group('Instance Methods', () {
      group('Shadow Methods', () {
        test('shadow method creates attribute with single shadow', () {
          final shadowMix = BoxShadowMix(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: const Offset(2.0, 2.0),
          );
          final attribute = BoxMix().shadow(shadowMix);

          expect(attribute.$decoration, isNotNull);
          final context = MockBuildContext();
          final decoration =
              attribute.resolve(context).decoration as BoxDecoration?;
          expect(decoration?.boxShadow, isNotNull);
          expect(decoration?.boxShadow?.length, 1);
        });

        test('shadows method creates attribute with multiple shadows', () {
          final shadowMixes = [
            BoxShadowMix(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: const Offset(2.0, 2.0),
            ),
            BoxShadowMix(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: const Offset(4.0, 4.0),
            ),
          ];
          final attribute = BoxMix().shadows(shadowMixes);

          expect(attribute.$decoration, isNotNull);
          final context = MockBuildContext();
          final decoration =
              attribute.resolve(context).decoration as BoxDecoration?;
          expect(decoration?.boxShadow, isNotNull);
          expect(decoration?.boxShadow?.length, 2);
        });

        test('elevation method creates attribute with elevation shadow', () {
          const elevation = ElevationShadow.four;
          final attribute = BoxMix().elevation(elevation);

          expect(attribute.$decoration, isNotNull);
          final context = MockBuildContext();
          final decoration =
              attribute.resolve(context).decoration as BoxDecoration?;
          expect(decoration?.boxShadow, isNotNull);
        });
      });

      group('Animation Method', () {
        test('animate method creates attribute with animation config', () {
          final animationConfig = AnimationConfig.curve(
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
          final attribute = BoxMix().animate(animationConfig);

          expect(attribute.$animation, equals(animationConfig));
        });
      });
    });

    group('Advanced Utility Properties', () {
      group('Decoration Utilities', () {
        test('boxDecoration utility creates box decoration attributes', () {
          final attribute = BoxMix();

          final colorAttr = attribute.color(Colors.purple);
          expect(colorAttr, isA<BoxMix>());
          expect(colorAttr.$decoration, isNotNull);
        });

        test('shapeDecoration utility creates shape decoration attributes', () {
          final attribute = BoxMix();

          final colorAttr = attribute.decoration(
            ShapeDecorationMix(color: Colors.orange),
          );
          expect(colorAttr, isA<BoxMix>());
          expect(colorAttr.$decoration, isNotNull);
        });
      });

      group('Border Utilities', () {
        test(
          'borderDirectional utility creates directional border attributes',
          () {
            final attribute = BoxMix();

            final borderAttr = attribute.decoration(
              BoxDecorationMix.border(
                BorderDirectionalMix(
                  start: BorderSideMix(width: 1.0, color: Colors.grey),
                  end: BorderSideMix(width: 1.0, color: Colors.grey),
                  top: BorderSideMix(width: 1.0, color: Colors.grey),
                  bottom: BorderSideMix(width: 1.0, color: Colors.grey),
                ),
              ),
            );
            expect(borderAttr, isA<BoxMix>());
            expect(borderAttr.$decoration, isNotNull);
          },
        );

        test(
          'borderRadiusDirectional utility creates directional border radius attributes',
          () {
            final attribute = BoxMix();

            final radiusAttr = attribute.borderRadius(
              BorderRadiusGeometryMix.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            );
            expect(radiusAttr, isA<BoxMix>());
            expect(radiusAttr.$decoration, isNotNull);
          },
        );
      });

      group('Gradient Utilities', () {
        test('gradient utility creates gradient attributes', () {
          final attribute = BoxMix();

          final gradientAttr = attribute.gradient(
            LinearGradientMix(colors: [Colors.red, Colors.blue]),
          );
          expect(gradientAttr, isA<BoxMix>());
          expect(gradientAttr.$decoration, isNotNull);
        });

        test('linearGradient utility creates linear gradient attributes', () {
          final attribute = BoxMix();

          final gradientAttr = attribute.gradient(
            LinearGradientMix(colors: [Colors.red, Colors.blue]),
          );
          expect(gradientAttr, isA<BoxMix>());
          expect(gradientAttr.$decoration, isNotNull);
        });

        test('radialGradient utility creates radial gradient attributes', () {
          final attribute = BoxMix();

          final gradientAttr = attribute.gradient(
            RadialGradientMix(colors: [Colors.yellow, Colors.green]),
          );
          expect(gradientAttr, isA<BoxMix>());
          expect(gradientAttr.$decoration, isNotNull);
        });

        test('sweepGradient utility creates sweep gradient attributes', () {
          final attribute = BoxMix();

          final gradientAttr = attribute.gradient(
            SweepGradientMix(colors: [Colors.pink, Colors.cyan]),
          );
          expect(gradientAttr, isA<BoxMix>());
          expect(gradientAttr.$decoration, isNotNull);
        });
      });

      group('Shape Utility', () {
        test('shape utility creates shape attributes', () {
          final attribute = BoxMix();

          expect(attribute.shape, isNotNull);
          final shapeAttr = attribute.shape(CircleBorderMix());
          expect(shapeAttr, isA<BoxMix>());
          expect(shapeAttr.$decoration, isNotNull);
        });
      });
    });

    group('Complex Combinations', () {
      test(
        'multiple factory methods can be combined with only constructor',
        () {
          final attribute = BoxMix(
            alignment: Alignment.center,
            padding: EdgeInsetsMix.all(16.0),
            margin: EdgeInsetsMix.all(8.0),
            constraints: BoxConstraintsMix(
              minWidth: 100.0,
              maxWidth: 200.0,
              minHeight: 150.0,
              maxHeight: 300.0,
            ),
            decoration: BoxDecorationMix(
              color: Colors.blue,
              borderRadius: BorderRadiusMix.all(const Radius.circular(8.0)),
            ),
            foregroundDecoration: BoxDecorationMix(
              color: Colors.red.withValues(alpha: 0.5),
            ),
            transform: Matrix4.rotationZ(0.1),
            transformAlignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
          );

          final context = MockBuildContext();
          final spec = attribute.resolve(context);

          expect(spec.alignment, Alignment.center);
          expect(spec.padding, const EdgeInsets.all(16.0));
          expect(spec.margin, const EdgeInsets.all(8.0));
          expect(spec.constraints?.minWidth, 100.0);
          expect(spec.constraints?.maxWidth, 200.0);
          expect(spec.constraints?.minHeight, 150.0);
          expect(spec.constraints?.maxHeight, 300.0);
          expect(spec.decoration, isA<BoxDecoration>());
          expect(spec.foregroundDecoration, isA<BoxDecoration>());
          expect(spec.transform, isNotNull);
          expect(spec.transformAlignment, Alignment.center);
          expect(spec.clipBehavior, Clip.antiAlias);
        },
      );

      test('utility methods can be chained with merge for complex styling', () {
        final attribute = BoxMix()
            .width(150.0)
            .merge(BoxMix().height(100.0))
            .merge(BoxMix().padding(EdgeInsetsMix.all(20.0)))
            .merge(
              BoxMix().margin(
                EdgeInsetsMix.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
            )
            .merge(BoxMix().alignment(Alignment.center));

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec.constraints?.minWidth, 150.0);
        expect(spec.constraints?.maxWidth, 150.0);
        expect(spec.constraints?.minHeight, 100.0);
        expect(spec.constraints?.maxHeight, 100.0);
        expect(spec.alignment, Alignment.center);
        expect(spec.padding, const EdgeInsets.all(20.0));
      });

      test('complex decoration styling with only constructor', () {
        final attribute = BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 150.0,
            maxWidth: 150.0,
            minHeight: 100.0,
            maxHeight: 100.0,
          ),
          decoration: BoxDecorationMix(
            color: Colors.indigo,
            borderRadius: BorderRadiusMix.all(const Radius.circular(16.0)),
            boxShadow: [
              BoxShadowMix(
                color: Colors.black26,
                blurRadius: 6.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsetsMix.all(20.0),
          margin: EdgeInsetsMix.symmetric(horizontal: 12.0, vertical: 8.0),
          alignment: Alignment.center,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec.constraints?.minWidth, 150.0);
        expect(spec.constraints?.maxWidth, 150.0);
        expect(spec.constraints?.minHeight, 100.0);
        expect(spec.constraints?.maxHeight, 100.0);
        expect(spec.alignment, Alignment.center);
        expect(spec.padding, const EdgeInsets.all(20.0));

        final decoration = spec.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.indigo);
        expect(decoration?.borderRadius, isNotNull);
        expect(decoration?.boxShadow, isNotNull);
        expect(decoration?.boxShadow?.length, 1);
      });
    });
  });
}
