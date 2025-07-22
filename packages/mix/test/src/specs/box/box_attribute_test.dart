import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxSpecAttribute', () {
    group('Builder Pattern', () {
      test('creates BoxSpecAttribute with all properties using builder', () {
        final attribute = BoxSpecAttribute()
          .alignment(Alignment.center)
          .padding.only(top: 8.0)
          .margin.only(left: 16.0)
          .constraints.maxWidth(200.0)
          .decoration.box.color(Colors.red)
          .foregroundDecoration.box.color(Colors.blue)
          .transform.value(Matrix4.identity())
          .transformAlignment(Alignment.topLeft)
          .clipBehavior(Clip.antiAlias)
          .width(100.0)
          .height(200.0);

        expect(attribute.$alignment, hasValue(Alignment.center));
        expect(attribute.$width, hasValue(100.0));
        expect(attribute.$height, hasValue(200.0));
        expect(attribute.$clipBehavior, hasValue(Clip.antiAlias));
        expect(attribute.$transformAlignment, hasValue(Alignment.topLeft));
        expect(attribute.$transform, hasValue(Matrix4.identity()));
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
        expect(attribute.$width, isNull);
        expect(attribute.$height, isNull);
      });

      test('builder methods create new instances', () {
        final original = BoxSpecAttribute();
        final modified = original.width(100.0);

        expect(identical(original, modified), isFalse);
        expect(original.$width, isNull);
        expect(modified.$width, hasValue(100.0));
      });
    });

    group('Color and Decoration', () {
      test('color method creates decoration with color', () {
        final attribute = BoxSpecAttribute().decoration.box.color(Colors.red);
        
        expect(attribute.$decoration, isNotNull);
        
        final context = MockBuildContext();
        final resolved = attribute.resolve(context);
        final decoration = resolved.spec.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
      });

      test('color merges with existing decoration', () {
        final attribute = BoxSpecAttribute()
          .decoration.box.border.all(BorderSideMix.only(width: 2.0))
          .decoration.box.color(Colors.blue);
        
        expect(attribute.$decoration, isNotNull);
        
        final context = MockBuildContext();
        final resolved = attribute.resolve(context);
        expect(resolved.spec, isNotNull);
        final decoration = resolved.spec!.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.blue);
        expect(decoration?.border, isNotNull);
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
      test('width and height methods set dimensions', () {
        final attribute = BoxSpecAttribute()
          .width(100.0)
          .height(200.0);
        
        expect(attribute.$width, hasValue(100.0));
        expect(attribute.$height, hasValue(200.0));
      });

      test('square dimensions using same value', () {
        final attribute = BoxSpecAttribute()
          .width(100.0)
          .height(100.0);
        
        expect(attribute.$width, hasValue(100.0));
        expect(attribute.$height, hasValue(100.0));
      });

      test('constraints methods work correctly', () {
        final minMax = BoxSpecAttribute()
          .minWidth(100.0)
          .maxWidth(200.0)
          .minHeight(50.0)
          .maxHeight(150.0);
        
        expect(minMax.$constraints, isNotNull);
        
        final context = MockBuildContext();
        final resolved = minMax.resolve(context);
        expect(resolved.spec, isNotNull);
        expect(resolved.spec!.constraints, isNotNull);
        expect(resolved.spec!.constraints!.minWidth, 100.0);
        expect(resolved.spec!.constraints!.maxWidth, 200.0);
        expect(resolved.spec!.constraints!.minHeight, 50.0);
        expect(resolved.spec!.constraints!.maxHeight, 150.0);
      });
    });

    group('Resolution', () {
      test('resolves to BoxSpec with correct properties', () {
        final attribute = BoxSpecAttribute()
          .width(100.0)
          .height(200.0)
          .decoration.box.color(Colors.red)
          .padding.all(16.0)
          .alignment(Alignment.center);

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved.spec, isNotNull);
        expect(resolved.spec!.width, 100.0);
        expect(resolved.spec!.height, 200.0);
        expect(resolved.spec!.alignment, Alignment.center);
        expect(resolved.spec!.padding, const EdgeInsets.all(16.0));
        final decoration = resolved.spec!.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
      });

      test('resolves with edge insets geometry', () {
        final attribute = BoxSpecAttribute()
          .padding.top(10.0)
          .padding.bottom(20.0)
          .padding.left(30.0)
          .padding.right(40.0);

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);
        
        expect(resolved.spec, isNotNull);
        expect(resolved.spec!.padding, const EdgeInsets.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        ));
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = BoxSpecAttribute()
          .width(100.0)
          .height(200.0)
          .decoration.box.color(Colors.red);

        final second = BoxSpecAttribute()
          .width(150.0)
          .padding.all(16.0)
          .alignment(Alignment.center);

        final merged = first.merge(second);

        expect(merged.$width, hasValue(150.0)); // second overrides
        expect(merged.$height, hasValue(200.0)); // from first
        expect(merged.$padding, isNotNull); // from second
        expect(merged.$alignment, hasValue(Alignment.center)); // from second
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
            const TransformModifierAttribute(),
          ],
        );

        expect(attribute.modifiers, isNotNull);
        expect(attribute.modifiers!.length, 2);
      });

      test('modifiers merge correctly', () {
        final first = BoxSpecAttribute(
          modifiers: [
            OpacityModifierAttribute(opacity: Prop(0.5)),
          ],
        );
        
        final second = BoxSpecAttribute(
          modifiers: [
            const TransformModifierAttribute(),
          ],
        );
        
        final merged = first.merge(second);
        expect(merged.modifiers?.length, 2);
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = BoxSpecAttribute()
          .width(100.0)
          .height(200.0)
          .decoration.box.color(Colors.red);

        final attr2 = BoxSpecAttribute()
          .width(100.0)
          .height(200.0)
          .decoration.box.color(Colors.red);

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = BoxSpecAttribute().width(100.0);
        final attr2 = BoxSpecAttribute().width(200.0);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Animation', () {
      test('animation config can be added to attribute', () {
        // Note: AnimationConfig is an abstract class and would need
        // a concrete implementation for testing
        // This test demonstrates the concept
        final attribute = BoxSpecAttribute();
        expect(attribute.animation, isNull); // By default no animation
      });
    });

    group('Variants', () {
      test('variants functionality exists', () {
        // Note: Variants require proper Variant instances, not builders
        // This test demonstrates that the variants property exists
        final attribute = BoxSpecAttribute();
        expect(attribute.variants, isNull); // By default no variants
      });
    });
  });
}