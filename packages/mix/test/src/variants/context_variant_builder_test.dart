import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('VariantBuilder', () {
    group('Constructor', () {
      test('creates builder with function', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );

        expect(builder, isA<VariantStyleBuilder>());
        expect(builder.builder, isA<Function>());
      });

      test('accepts different Style types', () {
        final boxBuilder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );

        final flexBuilder = VariantStyleBuilder((context) => FlexStyler());

        expect(boxBuilder, isA<VariantStyleBuilder>());
        expect(flexBuilder, isA<VariantStyleBuilder>());
      });

      test('stores function correctly', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(200.0);
        }

        final builder = VariantStyleBuilder(builderFunction);

        expect(builder.builder, same(builderFunction));
      });

      test('accepts anonymous functions', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().height(50.0),
        );

        expect(builder.builder, isA<Function>());
      });

      test('accepts closures with captured variables', () {
        const capturedWidth = 150.0;
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(capturedWidth),
        );

        expect(builder.builder, isA<Function>());
        final result = builder.resolve(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, capturedWidth);
        expect(constraints?.maxWidth, capturedWidth);
      });
    });

    group('Key generation', () {
      test('key is based on function hashCode', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(100.0);
        }

        final builder = VariantStyleBuilder(builderFunction);

        expect(builder.variantKey, builderFunction.hashCode.toString());
      });

      test('different functions have different keys', () {
        final builder1 = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final builder2 = VariantStyleBuilder(
          (context) => BoxStyler().width(200.0),
        );

        expect(builder1.variantKey, isNot(equals(builder2.variantKey)));
      });

      test('same function reference has same key', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(100.0);
        }

        final builder1 = VariantStyleBuilder(builderFunction);
        final builder2 = VariantStyleBuilder(builderFunction);

        expect(builder1.variantKey, equals(builder2.variantKey));
      });

      test('key is consistent across calls', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );

        final key1 = builder.variantKey;
        final key2 = builder.variantKey;

        expect(key1, equals(key2));
      });
    });

    group('Equality and hashCode', () {
      test('equality based on function reference', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(100.0);
        }

        final builder1 = VariantStyleBuilder(builderFunction);
        final builder2 = VariantStyleBuilder(builderFunction);

        expect(builder1, equals(builder2));
        expect(builder1.hashCode, equals(builder2.hashCode));
      });

      test('different functions are not equal', () {
        final builder1 = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final builder2 = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );

        expect(builder1, isNot(equals(builder2)));
        expect(builder1.hashCode, isNot(equals(builder2.hashCode)));
      });

      test('identical instances are equal', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );

        expect(builder, equals(builder));
        expect(identical(builder, builder), isTrue);
      });

      test('hashCode is consistent', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );

        final hashCode1 = builder.hashCode;
        final hashCode2 = builder.hashCode;

        expect(hashCode1, equals(hashCode2));
      });

      test('hashCode matches function hashCode', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(100.0);
        }

        final builder = VariantStyleBuilder(builderFunction);

        expect(builder.hashCode, equals(builderFunction.hashCode));
      });
    });

    group('build method', () {
      test('calls function with provided context', () {
        BuildContext? capturedContext;
        final builder = VariantStyleBuilder((context) {
          capturedContext = context;
          return BoxStyler().width(100.0);
        });

        final mockContext = MockBuildContext();
        builder.resolve(mockContext);

        expect(capturedContext, same(mockContext));
      });

      test('returns function result', () {
        final expectedAttribute = BoxStyler().width(150.0);
        final builder = VariantStyleBuilder((context) => expectedAttribute);

        final result = builder.resolve(MockBuildContext());

        expect(result, same(expectedAttribute));
      });

      test('works with different Style types', () {
        final boxBuilder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final flexBuilder = VariantStyleBuilder((context) => FlexStyler());

        final context = MockBuildContext();
        final boxResult = boxBuilder.resolve(context);
        final flexResult = flexBuilder.resolve(context);

        expect(boxResult, isA<BoxStyler>());
        expect(flexResult, isA<FlexStyler>());
      });

      test('function can access context properties', () {
        final builder = VariantStyleBuilder((context) {
          final size = context.size ?? const Size(800, 600);
          return BoxStyler().width(size.width);
        });

        final result = builder.resolve(MockBuildContext());

        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 800.0);
        expect(constraints?.maxWidth, 800.0);
      });

      test('can create different attributes based on context', () {
        final builder = VariantStyleBuilder((context) {
          final size = context.size ?? const Size(800, 600);
          return size.width > 1000
              ? BoxStyler().width(200.0)
              : BoxStyler().width(100.0);
        });

        final smallContext = MockBuildContext();
        final result = builder.resolve(smallContext);

        // MockBuildContext has size (800, 600) which is <= 1000
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
      });
    });

    group('Generic type handling', () {
      test('maintains generic type information', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );

        final result = builder.resolve(MockBuildContext());
        expect(result, isA<BoxStyler>());
      });

      test('different generic types create different builder types', () {
        final boxBuilder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final flexBuilder = VariantStyleBuilder((context) => FlexStyler());

        expect(boxBuilder.runtimeType, isNot(equals(flexBuilder.runtimeType)));
      });

      test('can work with base BoxSpec type', () {
        final builder = VariantStyleBuilder<BoxSpec>(
          (context) => BoxStyler().width(100.0),
        );

        final result = builder.resolve(MockBuildContext());
        expect(result, isA<Style<BoxSpec>>());
        expect(result, isA<BoxStyler>());
      });
    });

    group('MultiVariant integration', () {
      test('can be used with other variants', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final trigger = ContextTrigger('test', (context) => true);

        // Both are separate variants that can be used independently
        expect(builder, isA<VariantStyleBuilder>());
        expect(trigger, isA<ContextTrigger>());
        expect(builder, isNot(equals(trigger)));
      });

      test('can be used alongside trigger variants', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final triggerVariant = EventVariantStyle(
          ContextTrigger.widgetState(WidgetState.hovered),
          BoxStyler().width(100),
        );

        // Both can be used independently
        expect(builder, isA<VariantStyleBuilder>());
        expect(triggerVariant, isA<EventVariantStyle>());
        expect(builder.variantKey, isNot(equals(triggerVariant.variantKey)));
      });

      test('can use Trigger.not for negation', () {
        final trigger = ContextTrigger.widgetState(WidgetState.disabled);
        final notTrigger = ContextTrigger.not(trigger);

        expect(notTrigger, isA<ContextTrigger>());
        expect(notTrigger.key, contains('not'));
      });
    });

    group('Complex scenarios', () {
      test(
        'function can return different attributes based on complex logic',
        () {
          final builder = VariantStyleBuilder((context) {
            final size = context.size ?? const Size(800, 600);
            final width = switch (size.width) {
              <= 480 => 50.0,
              <= 768 => 100.0,
              <= 1024 => 150.0,
              _ => 200.0,
            };
            return BoxStyler().width(width);
          });

          final result = builder.resolve(MockBuildContext());
          // MockBuildContext has width 800, which falls in 768 < width <= 1024
          final context = MockBuildContext();
          final constraints = result.resolve(context).constraints;
          expect(constraints?.minWidth, 150.0);
          expect(constraints?.maxWidth, 150.0);
        },
      );

      test('can create attributes with multiple properties', () {
        final builder = VariantStyleBuilder((context) {
          return BoxStyler(
            constraints: BoxConstraintsMix(
              minWidth: 100.0,
              maxWidth: 100.0,
              minHeight: 200.0,
              maxHeight: 200.0,
            ),
          );
        });

        final result = builder.resolve(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
      });

      test('function can throw exceptions', () {
        final builder = VariantStyleBuilder((context) {
          if (true) {
            throw Exception('Test exception');
          }
          // ignore: dead_code
          return BoxStyler().width(100.0);
        });

        expect(() => builder.resolve(MockBuildContext()), throwsException);
      });

      test('can capture variables from outer scope', () {
        const baseWidth = 50.0;
        const multiplier = 3;

        final builder = VariantStyleBuilder((context) {
          return BoxStyler().width(baseWidth * multiplier);
        });

        final result = builder.resolve(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 150.0);
        expect(constraints?.maxWidth, 150.0);
      });
    });

    group('Edge cases', () {
      test('handles function that returns const attributes', () {
        final builder = VariantStyleBuilder((context) => BoxStyler());

        final result = builder.resolve(MockBuildContext());
        expect(result, isA<BoxStyler>());
      });

      test('function parameters are properly typed', () {
        final builder = VariantStyleBuilder((context) {
          // This should compile without issues - context is properly typed
          expect(context, isA<BuildContext>());
          return BoxStyler().width(100.0);
        });

        builder.resolve(MockBuildContext());
      });

      test('maintains const constructor', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(100.0);
        }

        expect(() => VariantStyleBuilder(builderFunction), returnsNormally);
      });
    });

    group('Integration with other Mix components', () {
      test('can be used in Style resolution context', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );

        // VariantStyleBuilder should integrate with the broader Mix system
        expect(builder, isA<VariantStyleBuilder>());
        expect(builder.variantKey, isA<String>());
        expect(builder.variantKey.isNotEmpty, isTrue);
      });

      test('works with VariantStyle wrapper', () {
        final builder = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final style = BoxStyler().height(200.0);
        final trigger = ContextTrigger('test', (context) => true);
        final variantStyle = EventVariantStyle(trigger, style);

        expect(builder, isA<VariantStyleBuilder>());
        expect(variantStyle.trigger, trigger);
        expect(variantStyle.style, style);
        expect(variantStyle.variantKey, trigger.key);
      });

      test('key works as mergeKey for VariantStyle', () {
        final builder1 = VariantStyleBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final builder2 = VariantStyleBuilder(
          (context) => BoxStyler().width(200.0),
        );

        expect(builder1, isA<VariantStyleBuilder>());
        expect(builder2, isA<VariantStyleBuilder>());

        final trigger1 = ContextTrigger('test1', (context) => true);
        final trigger2 = ContextTrigger('test2', (context) => true);
        final style1 = EventVariantStyle(trigger1, BoxStyler().height(100.0));
        final style2 = EventVariantStyle(trigger2, BoxStyler().height(200.0));

        expect(style1.variantKey, trigger1.key);
        expect(style2.variantKey, trigger2.key);
        expect(style1.variantKey, isNot(equals(style2.variantKey)));
      });
    });

    group('Documentation and usage patterns', () {
      test('demonstrates context-based styling pattern', () {
        // This test documents common usage patterns
        final responsiveBuilder = VariantStyleBuilder((context) {
          final size = context.size ?? const Size(800, 600);
          return BoxStyler().width(size.width > 768 ? 200.0 : 100.0);
        });

        final result = responsiveBuilder.resolve(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 200.0);
        expect(constraints?.maxWidth, 200.0); // MockBuildContext width is 800
      });

      test('demonstrates theme-based styling pattern', () {
        final themeBuilder = VariantStyleBuilder((context) {
          // In a real scenario, this would access Theme.of(context)
          // For testing, we'll simulate theme-based logic
          return BoxStyler().width(120.0);
        });

        final result = themeBuilder.resolve(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 120.0);
        expect(constraints?.maxWidth, 120.0);
      });

      test('demonstrates utility for conditional attribute creation', () {
        final conditionalBuilder = VariantStyleBuilder((context) {
          // Always return fixed size for this test
          return BoxStyler(
            constraints: BoxConstraintsMix(
              minWidth: 100.0,
              maxWidth: 100.0,
              minHeight: 100.0,
              maxHeight: 100.0,
            ),
          );
        });

        final result = conditionalBuilder.resolve(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 100.0);
        expect(constraints?.maxHeight, 100.0);
      });
    });
  });
}
