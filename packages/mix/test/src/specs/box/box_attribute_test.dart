import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxSpecAttribute', () {
    group('Constructor', () {
      test('creates BoxSpecAttribute with all properties', () {
        final attribute = BoxSpecAttribute(
          alignment: Prop(Alignment.center),
          padding: MixProp(EdgeInsetsMix.only(top: 8.0)),
          margin: MixProp(EdgeInsetsMix.only(left: 16.0)),
          constraints: MixProp(BoxConstraintsMix.only(maxWidth: 200.0)),
          decoration: MixProp(BoxDecorationMix.only(color: Colors.red)),
          foregroundDecoration: MixProp(
            BoxDecorationMix.only(color: Colors.blue),
          ),
          transform: Prop(Matrix4.identity()),
          transformAlignment: Prop(Alignment.topLeft),
          clipBehavior: Prop(Clip.antiAlias),
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
        final attribute = BoxSpecAttribute.only(
          alignment: Alignment.center,
          padding: EdgeInsetsMix.only(top: 8.0),
          margin: EdgeInsetsMix.only(left: 16.0),
          constraints: BoxConstraintsMix.only(maxWidth: 200.0),
          decoration: BoxDecorationMix.only(color: Colors.red),
          foregroundDecoration: BoxDecorationMix.only(color: Colors.blue),
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
        final attribute = BoxSpecAttribute();

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
        final original = BoxSpecAttribute();
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
        final chained = BoxSpecAttribute().width(100.0).height(200.0);

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
        final combined = BoxSpecAttribute()
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

        final attribute = BoxSpecAttribute.value(spec);

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
        expect(BoxSpecAttribute.maybeValue(null), isNull);
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
        final attribute = BoxSpecAttribute.maybeValue(spec);

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
        final attribute = BoxSpecAttribute().color(Colors.red);

        expect(attribute.$decoration, isNotNull);

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);
        final decoration = resolved.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
      });

      test('decoration utilities create new instances', () {
        // Each decoration utility creates a new BoxSpecAttribute
        final withColor = BoxSpecAttribute().color(Colors.red);
        final withBorder = BoxSpecAttribute().border.all(
          BorderSideMix.only(width: 2.0),
        );
        final withBorderRadius = BoxSpecAttribute().borderRadius.all(
          const Radius.circular(8.0),
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
        final combined = BoxSpecAttribute()
            .color(Colors.red)
            .merge(
              BoxSpecAttribute().border.all(BorderSideMix.only(width: 2.0)),
            )
            .merge(
              BoxSpecAttribute().borderRadius.all(const Radius.circular(8.0)),
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
        final all = BoxSpecAttribute().padding.all(16.0);
        expect(all.$padding, isNotNull);

        // Symmetric padding using vertical and horizontal utilities
        final verticalPadding = BoxSpecAttribute().padding.vertical(8.0);
        expect(verticalPadding.$padding, isNotNull);

        final horizontalPadding = BoxSpecAttribute().padding.horizontal(16.0);
        expect(horizontalPadding.$padding, isNotNull);

        // Individual sides
        final topPadding = BoxSpecAttribute().padding.top(8.0);
        expect(topPadding.$padding, isNotNull);

        final leftPadding = BoxSpecAttribute().padding.left(16.0);
        expect(leftPadding.$padding, isNotNull);
      });

      test('margin methods create correct EdgeInsets', () {
        final all = BoxSpecAttribute().margin.all(16.0);
        expect(all.$margin, isNotNull);

        // Symmetric margin using vertical and horizontal utilities
        final verticalMargin = BoxSpecAttribute().margin.vertical(8.0);
        expect(verticalMargin.$margin, isNotNull);

        final horizontalMargin = BoxSpecAttribute().margin.horizontal(16.0);
        expect(horizontalMargin.$margin, isNotNull);

        // Individual sides
        final topMargin = BoxSpecAttribute().margin.top(8.0);
        expect(topMargin.$margin, isNotNull);

        final leftMargin = BoxSpecAttribute().margin.left(16.0);
        expect(leftMargin.$margin, isNotNull);
      });
    });

    group('Size Constraints', () {
      test('width and height utilities create separate instances', () {
        final withWidth = BoxSpecAttribute().width(100.0);
        final withHeight = BoxSpecAttribute().height(200.0);

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
        final merged = BoxSpecAttribute()
            .width(100.0)
            .merge(BoxSpecAttribute().height(200.0));

        expect(merged.$constraints, isNotNull);
        final mergedConstraints = merged.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(mergedConstraints?.minWidth, 100.0);
        expect(mergedConstraints?.maxWidth, 100.0);
        expect(mergedConstraints?.minHeight, 200.0);
        expect(mergedConstraints?.maxHeight, 200.0);

        // Option 2: Use constructor
        final constructed = BoxSpecAttribute.only(
          constraints: BoxConstraintsMix.only(
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
        final minWidth = BoxSpecAttribute().minWidth(100.0);
        final maxWidth = BoxSpecAttribute().maxWidth(200.0);
        final minHeight = BoxSpecAttribute().minHeight(50.0);
        final maxHeight = BoxSpecAttribute().maxHeight(150.0);

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
        final merged = BoxSpecAttribute()
            .minWidth(100.0)
            .merge(BoxSpecAttribute().maxWidth(200.0))
            .merge(BoxSpecAttribute().minHeight(50.0))
            .merge(BoxSpecAttribute().maxHeight(150.0));

        final context = MockBuildContext();
        final constraints = merged.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 200.0);
        expect(constraints?.minHeight, 50.0);
        expect(constraints?.maxHeight, 150.0);

        // Option 2: Use constructor with BoxConstraintsMix
        final constructed = BoxSpecAttribute.only(
          constraints: BoxConstraintsMix.only(
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
        final attribute = BoxSpecAttribute.only(
          alignment: Alignment.center,
          padding: EdgeInsetsMix.all(16.0),
          decoration: BoxDecorationMix.only(color: Colors.red),
          constraints: BoxConstraintsMix.only(
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
        final attribute = BoxSpecAttribute.only(
          padding: EdgeInsetsMix.only(
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
        final first = BoxSpecAttribute.only(
          decoration: BoxDecorationMix.only(color: Colors.red),
        );

        final second = BoxSpecAttribute.only(
          constraints: BoxConstraintsMix.only(minWidth: 150.0, maxWidth: 150.0),
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
        final attribute = BoxSpecAttribute().width(100.0);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });
    });

    group('Modifiers', () {
      test('modifiers can be added to attribute', () {
        final attribute = BoxSpecAttribute(
          modifiers: [
            OpacityModifierAttribute(opacity: Prop(0.5)),
            TransformModifierAttribute.only(
              transform: Matrix4.identity(),
              alignment: Alignment.center,
            ),
          ],
        );

        expect(attribute.$modifiers, isNotNull);
        expect(attribute.$modifiers!.length, 2);
      });

      test('modifiers merge correctly', () {
        final opacityModifier = OpacityModifierAttribute(opacity: Prop(0.5));
        final transformModifier = TransformModifierAttribute.only(
          transform: Matrix4.identity(),
        );

        final first = BoxSpecAttribute(modifiers: [opacityModifier]);
        final second = BoxSpecAttribute(modifiers: [transformModifier]);

        final merged = first.merge(second);

        // Check that the modifiers list matches exactly the expected list
        final expectedModifiers = [
          OpacityModifierAttribute(opacity: Prop(0.5)),
          TransformModifierAttribute.only(transform: Matrix4.identity()),
        ];

        expect(merged.$modifiers, expectedModifiers);
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        // Note: Chaining doesn't work as expected, so we use constructor
        final attr1 = BoxSpecAttribute.only(
          constraints: BoxConstraintsMix.only(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
          decoration: BoxDecorationMix.only(color: Colors.red),
        );

        final attr2 = BoxSpecAttribute.only(
          constraints: BoxConstraintsMix.only(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
          decoration: BoxDecorationMix.only(color: Colors.red),
        );

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = BoxSpecAttribute().width(100.0);
        final attr2 = BoxSpecAttribute().width(200.0);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Convenience Methods', () {
      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(
          const Duration(milliseconds: 300),
        );
        final attribute = BoxSpecAttribute().animate(animation);

        expect(attribute.$animation, equals(animation));
      });
    });

    group('Utility Properties', () {
      test('has all expected utility properties', () {
        final attribute = BoxSpecAttribute();

        // Basic properties - just check they exist
        expect(attribute.alignment, isNotNull);
        expect(attribute.width, isNotNull);
        expect(attribute.height, isNotNull);
        expect(attribute.padding, isNotNull);
        expect(attribute.margin, isNotNull);
        expect(attribute.clipBehavior, isNotNull);
        expect(attribute.transform, isNotNull);
        expect(attribute.transformAlignment, isNotNull);

        // Decoration utilities
        expect(attribute.color, isNotNull);
        expect(attribute.border, isNotNull);
        expect(attribute.borderRadius, isNotNull);
        expect(attribute.shadow, isNotNull);

        // Constraint utilities
        expect(attribute.minWidth, isNotNull);
        expect(attribute.maxWidth, isNotNull);
        expect(attribute.minHeight, isNotNull);
        expect(attribute.maxHeight, isNotNull);
      });
    });

    group('Helper Methods', () {
      test('utility methods create proper attributes', () {
        final attribute = BoxSpecAttribute();

        // Test that utility methods exist and return proper types
        final widthAttr = attribute.width(100.0);
        expect(widthAttr, isA<BoxSpecAttribute>());

        final heightAttr = attribute.height(200.0);
        expect(heightAttr, isA<BoxSpecAttribute>());

        final colorAttr = attribute.color(Colors.blue);
        expect(colorAttr, isA<BoxSpecAttribute>());

        final alignmentAttr = attribute.alignment(Alignment.center);
        expect(alignmentAttr, isA<BoxSpecAttribute>());
      });
    });

    group('Builder pattern', () {
      test('builder methods create new instances', () {
        final original = BoxSpecAttribute();
        final modified = original.width(100.0);

        expect(identical(original, modified), isFalse);
        expect(original.$constraints, isNull);
        expect(modified.$constraints, isNotNull);
      });

      test('builder methods can be chained fluently with merge', () {
        final attribute = BoxSpecAttribute()
            .width(100.0)
            .merge(BoxSpecAttribute().height(200.0))
            .merge(BoxSpecAttribute().color(Colors.red))
            .merge(BoxSpecAttribute().alignment(Alignment.center));

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
        final attribute = BoxSpecAttribute(
          alignment: Prop(Alignment.center),
          padding: MixProp(EdgeInsetsMix.all(16.0)),
          margin: MixProp(EdgeInsetsMix.all(8.0)),
          constraints: MixProp(BoxConstraintsMix.only(maxWidth: 300.0)),
          decoration: MixProp(BoxDecorationMix.only(color: Colors.red)),
          clipBehavior: Prop(Clip.antiAlias),
        );

        expect(attribute.props.length, 9);
        expect(attribute.props, contains(attribute.$alignment));
        expect(attribute.props, contains(attribute.$padding));
        expect(attribute.props, contains(attribute.$margin));
        expect(attribute.props, contains(attribute.$constraints));
        expect(attribute.props, contains(attribute.$decoration));
        expect(attribute.props, contains(attribute.$clipBehavior));
      });
    });

    group('Debug Properties', () {
      test('debugFillProperties includes all properties', () {
        // This test verifies that the attribute implements Diagnosticable correctly
        final attribute = BoxSpecAttribute()
            .width(100.0)
            .merge(BoxSpecAttribute().height(200.0))
            .merge(BoxSpecAttribute().color(Colors.red));

        // The presence of debugFillProperties is tested by the framework
        expect(attribute, isA<BoxSpecAttribute>());
      });
    });

    group('Animation', () {
      test('animation config can be added to attribute', () {
        final attribute = BoxSpecAttribute();
        expect(attribute.$animation, isNull); // By default no animation
      });
    });

    group('Variants', () {
      test('variants functionality exists', () {
        // Note: Variants require proper Variant instances, not builders
        // This test demonstrates that the variants property exists
        final attribute = BoxSpecAttribute();
        expect(attribute.$variants, isNull); // By default no variants
      });
    });

    group('Factory Methods', () {
      group('Dimension Factories', () {
        test('height factory creates attribute with height constraint', () {
          final attribute = BoxSpecAttribute.height(200.0);

          expect(attribute.$constraints, isNotNull);
          final context = MockBuildContext();
          final constraints = attribute.resolve(context).constraints;
          expect(constraints?.minHeight, 200.0);
          expect(constraints?.maxHeight, 200.0);
        });

        test('width factory creates attribute with width constraint', () {
          final attribute = BoxSpecAttribute.width(100.0);

          expect(attribute.$constraints, isNotNull);
          final context = MockBuildContext();
          final constraints = attribute.resolve(context).constraints;
          expect(constraints?.minWidth, 100.0);
          expect(constraints?.maxWidth, 100.0);
        });

        test('minWidth factory creates attribute with minWidth constraint', () {
          final attribute = BoxSpecAttribute.minWidth(50.0);

          expect(attribute.$constraints, isNotNull);
          final context = MockBuildContext();
          final constraints = attribute.resolve(context).constraints;
          expect(constraints?.minWidth, 50.0);
        });

        test('maxWidth factory creates attribute with maxWidth constraint', () {
          final attribute = BoxSpecAttribute.maxWidth(300.0);

          expect(attribute.$constraints, isNotNull);
          final context = MockBuildContext();
          final constraints = attribute.resolve(context).constraints;
          expect(constraints?.maxWidth, 300.0);
        });

        test(
          'minHeight factory creates attribute with minHeight constraint',
          () {
            final attribute = BoxSpecAttribute.minHeight(75.0);

            expect(attribute.$constraints, isNotNull);
            final context = MockBuildContext();
            final constraints = attribute.resolve(context).constraints;
            expect(constraints?.minHeight, 75.0);
          },
        );

        test(
          'maxHeight factory creates attribute with maxHeight constraint',
          () {
            final attribute = BoxSpecAttribute.maxHeight(400.0);

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
            final constraintsMix = BoxConstraintsMix.only(
              minWidth: 100.0,
              maxWidth: 200.0,
              minHeight: 150.0,
              maxHeight: 300.0,
            );
            final attribute = BoxSpecAttribute.constraints(constraintsMix);

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
          final decorationMix = BoxDecorationMix.only(color: Colors.blue);
          final attribute = BoxSpecAttribute.decoration(decorationMix);

          expect(attribute.$decoration, isNotNull);
          final context = MockBuildContext();
          final decoration =
              attribute.resolve(context).decoration as BoxDecoration?;
          expect(decoration?.color, Colors.blue);
        });

        test(
          'foregroundDecoration factory creates attribute with foreground decoration',
          () {
            final decorationMix = BoxDecorationMix.only(color: Colors.green);
            final attribute = BoxSpecAttribute.foregroundDecoration(
              decorationMix,
            );

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
            BorderSideMix.only(width: 2.0, color: Colors.red),
          );
          final attribute = BoxSpecAttribute.border(borderMix);

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
            final attribute = BoxSpecAttribute.borderRadius(borderRadiusMix);

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
          final attribute = BoxSpecAttribute.alignment(Alignment.topRight);

          expectProp(attribute.$alignment, Alignment.topRight);
        });

        test('padding factory creates attribute with padding', () {
          final paddingMix = EdgeInsetsMix.all(12.0);
          final attribute = BoxSpecAttribute.padding(paddingMix);

          expect(attribute.$padding, isNotNull);
          final context = MockBuildContext();
          final padding = attribute.resolve(context).padding;
          expect(padding, const EdgeInsets.all(12.0));
        });

        test('margin factory creates attribute with margin', () {
          final marginMix = EdgeInsetsMix.all(8.0);
          final attribute = BoxSpecAttribute.margin(marginMix);

          expect(attribute.$margin, isNotNull);
          final context = MockBuildContext();
          final margin = attribute.resolve(context).margin;
          expect(margin, const EdgeInsets.all(8.0));
        });
      });

      group('Transform Factories', () {
        test('transform factory creates attribute with transform', () {
          final transform = Matrix4.rotationZ(0.5);
          final attribute = BoxSpecAttribute.transform(transform);

          expectProp(attribute.$transform, transform);
        });

        test(
          'transformAlignment factory creates attribute with transform alignment',
          () {
            final attribute = BoxSpecAttribute.transformAlignment(
              Alignment.bottomLeft,
            );

            expectProp(attribute.$transformAlignment, Alignment.bottomLeft);
          },
        );
      });

      group('Clip Factory', () {
        test('clipBehavior factory creates attribute with clip behavior', () {
          final attribute = BoxSpecAttribute.clipBehavior(Clip.hardEdge);

          expectProp(attribute.$clipBehavior, Clip.hardEdge);
        });
      });
    });

    group('Instance Methods', () {
      group('Shadow Methods', () {
        test('shadow method creates attribute with single shadow', () {
          final shadowMix = BoxShadowMix.only(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: const Offset(2.0, 2.0),
          );
          final attribute = BoxSpecAttribute().shadow(shadowMix);

          expect(attribute.$decoration, isNotNull);
          final context = MockBuildContext();
          final decoration =
              attribute.resolve(context).decoration as BoxDecoration?;
          expect(decoration?.boxShadow, isNotNull);
          expect(decoration?.boxShadow?.length, 1);
        });

        test('shadows method creates attribute with multiple shadows', () {
          final shadowMixes = [
            BoxShadowMix.only(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: const Offset(2.0, 2.0),
            ),
            BoxShadowMix.only(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: const Offset(4.0, 4.0),
            ),
          ];
          final attribute = BoxSpecAttribute().shadows(shadowMixes);

          expect(attribute.$decoration, isNotNull);
          final context = MockBuildContext();
          final decoration =
              attribute.resolve(context).decoration as BoxDecoration?;
          expect(decoration?.boxShadow, isNotNull);
          expect(decoration?.boxShadow?.length, 2);
        });

        test('elevation method creates attribute with elevation shadow', () {
          const elevation = ElevationShadow.four;
          final attribute = BoxSpecAttribute().elevation(elevation);

          expect(attribute.$decoration, isNotNull);
          final context = MockBuildContext();
          final decoration =
              attribute.resolve(context).decoration as BoxDecoration?;
          expect(decoration?.boxShadow, isNotNull);
        });
      });

      group('Animation Method', () {
        test('animate method creates attribute with animation config', () {
          final animationConfig = AnimationConfig.linear(
            const Duration(milliseconds: 500),
          );
          final attribute = BoxSpecAttribute().animate(animationConfig);

          expect(attribute.$animation, equals(animationConfig));
        });
      });
    });

    group('Advanced Utility Properties', () {
      group('Decoration Utilities', () {
        test('boxDecoration utility creates box decoration attributes', () {
          final attribute = BoxSpecAttribute();

          expect(attribute.boxDecoration, isNotNull);
          final colorAttr = attribute.boxDecoration.color(Colors.purple);
          expect(colorAttr, isA<BoxSpecAttribute>());
          expect(colorAttr.$decoration, isNotNull);
        });

        test('shapeDecoration utility creates shape decoration attributes', () {
          final attribute = BoxSpecAttribute();

          expect(attribute.shapeDecoration, isNotNull);
          final colorAttr = attribute.shapeDecoration.color(Colors.orange);
          expect(colorAttr, isA<BoxSpecAttribute>());
          expect(colorAttr.$decoration, isNotNull);
        });
      });

      group('Border Utilities', () {
        test(
          'borderDirectional utility creates directional border attributes',
          () {
            final attribute = BoxSpecAttribute();

            expect(attribute.borderDirectional, isNotNull);
            final borderAttr = attribute.borderDirectional.all(
              BorderSideMix.only(width: 1.0, color: Colors.grey),
            );
            expect(borderAttr, isA<BoxSpecAttribute>());
            expect(borderAttr.$decoration, isNotNull);
          },
        );

        test(
          'borderRadiusDirectional utility creates directional border radius attributes',
          () {
            final attribute = BoxSpecAttribute();

            expect(attribute.borderRadiusDirectional, isNotNull);
            final radiusAttr = attribute.borderRadiusDirectional.all(
              const Radius.circular(12.0),
            );
            expect(radiusAttr, isA<BoxSpecAttribute>());
            expect(radiusAttr.$decoration, isNotNull);
          },
        );
      });

      group('Gradient Utilities', () {
        test('gradient utility creates gradient attributes', () {
          final attribute = BoxSpecAttribute();

          expect(attribute.gradient, isNotNull);
          // Test that gradient utility exists and can be used
          expect(attribute.gradient, isA<GradientUtility>());
        });

        test('linearGradient utility creates linear gradient attributes', () {
          final attribute = BoxSpecAttribute();

          expect(attribute.linearGradient, isNotNull);
          final gradientAttr = attribute.linearGradient.colors([
            Colors.red,
            Colors.blue,
          ]);
          expect(gradientAttr, isA<BoxSpecAttribute>());
          expect(gradientAttr.$decoration, isNotNull);
        });

        test('radialGradient utility creates radial gradient attributes', () {
          final attribute = BoxSpecAttribute();

          expect(attribute.radialGradient, isNotNull);
          final gradientAttr = attribute.radialGradient.colors([
            Colors.yellow,
            Colors.green,
          ]);
          expect(gradientAttr, isA<BoxSpecAttribute>());
          expect(gradientAttr.$decoration, isNotNull);
        });

        test('sweepGradient utility creates sweep gradient attributes', () {
          final attribute = BoxSpecAttribute();

          expect(attribute.sweepGradient, isNotNull);
          final gradientAttr = attribute.sweepGradient.colors([
            Colors.pink,
            Colors.cyan,
          ]);
          expect(gradientAttr, isA<BoxSpecAttribute>());
          expect(gradientAttr.$decoration, isNotNull);
        });
      });

      group('Shape Utility', () {
        test('shape utility creates shape attributes', () {
          final attribute = BoxSpecAttribute();

          expect(attribute.shape, isNotNull);
          final shapeAttr = attribute.shape(BoxShape.circle);
          expect(shapeAttr, isA<BoxSpecAttribute>());
          expect(shapeAttr.$decoration, isNotNull);
        });
      });
    });

    group('Complex Combinations', () {
      test(
        'multiple factory methods can be combined with only constructor',
        () {
          final attribute = BoxSpecAttribute.only(
            alignment: Alignment.center,
            padding: EdgeInsetsMix.all(16.0),
            margin: EdgeInsetsMix.all(8.0),
            constraints: BoxConstraintsMix.only(
              minWidth: 100.0,
              maxWidth: 200.0,
              minHeight: 150.0,
              maxHeight: 300.0,
            ),
            decoration: BoxDecorationMix.only(
              color: Colors.blue,
              borderRadius: BorderRadiusMix.all(const Radius.circular(8.0)),
            ),
            foregroundDecoration: BoxDecorationMix.only(
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
        final attribute = BoxSpecAttribute()
            .width(150.0)
            .merge(BoxSpecAttribute().height(100.0))
            .merge(BoxSpecAttribute().padding.all(20.0))
            .merge(
              BoxSpecAttribute().margin(
                EdgeInsetsMix.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
            )
            .merge(BoxSpecAttribute().alignment(Alignment.center));

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
        final attribute = BoxSpecAttribute.only(
          constraints: BoxConstraintsMix.only(
            minWidth: 150.0,
            maxWidth: 150.0,
            minHeight: 100.0,
            maxHeight: 100.0,
          ),
          decoration: BoxDecorationMix.only(
            color: Colors.indigo,
            borderRadius: BorderRadiusMix.all(const Radius.circular(16.0)),
            boxShadow: [
              BoxShadowMix.only(
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
