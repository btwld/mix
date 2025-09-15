import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('VariantBuilder', () {
    group('Constructor', () {
      test('creates builder with function', () {
        final builder = VariantBuilder((context) => BoxStyler().width(100.0));

        expect(builder, isA<VariantBuilder>());
        expect(builder.builder, isA<Function>());
      });

      test('accepts different Style types', () {
        final boxBuilder = VariantBuilder(
          (context) => BoxStyler().width(100.0),
        );

        final flexBuilder = VariantBuilder((context) => FlexStyler());

        expect(boxBuilder, isA<VariantBuilder>());
        expect(flexBuilder, isA<VariantBuilder>());
      });

      test('stores function correctly', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(200.0);
        }

        final builder = VariantBuilder(builderFunction);

        expect(builder.builder, same(builderFunction));
      });

      test('accepts anonymous functions', () {
        final builder = VariantBuilder((context) => BoxStyler().height(50.0));

        expect(builder.builder, isA<Function>());
      });

      test('accepts closures with captured variables', () {
        const capturedWidth = 150.0;
        final builder = VariantBuilder(
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

        final builder = VariantBuilder(builderFunction);

        expect(builder.key, builderFunction.hashCode.toString());
      });

      test('different functions have different keys', () {
        final builder1 = VariantBuilder((context) => BoxStyler().width(100.0));
        final builder2 = VariantBuilder((context) => BoxStyler().width(200.0));

        expect(builder1.key, isNot(equals(builder2.key)));
      });

      test('same function reference has same key', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(100.0);
        }

        final builder1 = VariantBuilder(builderFunction);
        final builder2 = VariantBuilder(builderFunction);

        expect(builder1.key, equals(builder2.key));
      });

      test('key is consistent across calls', () {
        final builder = VariantBuilder((context) => BoxStyler().width(100.0));

        final key1 = builder.key;
        final key2 = builder.key;

        expect(key1, equals(key2));
      });
    });

    group('Equality and hashCode', () {
      test('equality based on function reference', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(100.0);
        }

        final builder1 = VariantBuilder(builderFunction);
        final builder2 = VariantBuilder(builderFunction);

        expect(builder1, equals(builder2));
        expect(builder1.hashCode, equals(builder2.hashCode));
      });

      test('different functions are not equal', () {
        final builder1 = VariantBuilder((context) => BoxStyler().width(100.0));
        final builder2 = VariantBuilder((context) => BoxStyler().width(100.0));

        expect(builder1, isNot(equals(builder2)));
        expect(builder1.hashCode, isNot(equals(builder2.hashCode)));
      });

      test('identical instances are equal', () {
        final builder = VariantBuilder((context) => BoxStyler().width(100.0));

        expect(builder, equals(builder));
        expect(identical(builder, builder), isTrue);
      });

      test('hashCode is consistent', () {
        final builder = VariantBuilder((context) => BoxStyler().width(100.0));

        final hashCode1 = builder.hashCode;
        final hashCode2 = builder.hashCode;

        expect(hashCode1, equals(hashCode2));
      });

      test('hashCode matches function hashCode', () {
        BoxStyler builderFunction(BuildContext context) {
          return BoxStyler().width(100.0);
        }

        final builder = VariantBuilder(builderFunction);

        expect(builder.hashCode, equals(builderFunction.hashCode));
      });
    });

    group('build method', () {
      test('calls function with provided context', () {
        BuildContext? capturedContext;
        final builder = VariantBuilder((context) {
          capturedContext = context;
          return BoxStyler().width(100.0);
        });

        final mockContext = MockBuildContext();
        builder.resolve(mockContext);

        expect(capturedContext, same(mockContext));
      });

      test('returns function result', () {
        final expectedAttribute = BoxStyler().width(150.0);
        final builder = VariantBuilder((context) => expectedAttribute);

        final result = builder.resolve(MockBuildContext());

        expect(result, same(expectedAttribute));
      });

      test('works with different Style types', () {
        final boxBuilder = VariantBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final flexBuilder = VariantBuilder((context) => FlexStyler());

        final context = MockBuildContext();
        final boxResult = boxBuilder.resolve(context);
        final flexResult = flexBuilder.resolve(context);

        expect(boxResult, isA<BoxStyler>());
        expect(flexResult, isA<FlexStyler>());
      });

      test('function can access context properties', () {
        final builder = VariantBuilder((context) {
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
        final builder = VariantBuilder((context) {
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
        final builder = VariantBuilder((context) => BoxStyler().width(100.0));

        final result = builder.resolve(MockBuildContext());
        expect(result, isA<BoxStyler>());
      });

      test('different generic types create different builder types', () {
        final boxBuilder = VariantBuilder(
          (context) => BoxStyler().width(100.0),
        );
        final flexBuilder = VariantBuilder((context) => FlexStyler());

        expect(boxBuilder.runtimeType, isNot(equals(flexBuilder.runtimeType)));
      });

      test('can work with base BoxSpec type', () {
        final builder = VariantBuilder<BoxSpec>(
          (context) => BoxStyler().width(100.0),
        );

        final result = builder.resolve(MockBuildContext());
        expect(result, isA<Style<BoxSpec>>());
        expect(result, isA<BoxStyler>());
      });
    });

    group('MultiVariant integration', () {
      test('can be used with other variants', () {
        final builder = VariantBuilder((context) => BoxStyler().width(100.0));
        final trigger = ContextTrigger('test', (context) => true);

        // Both are separate variants that can be used independently
        expect(builder, isA<VariantBuilder>());
        expect(trigger, isA<ContextTrigger>());
        expect(builder, isNot(equals(trigger)));
      });

      test('can be used alongside named variants', () {
        final builder = VariantBuilder((context) => BoxStyler().width(100.0));
        final namedVariant = NamedVariant('primary', BoxStyler().width(100));

        // Both can be used independently
        expect(builder, isA<VariantBuilder>());
        expect(namedVariant, isA<NamedVariant>());
        expect(builder.key, isNot(equals(namedVariant.key)));
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
          final builder = VariantBuilder((context) {
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
        final builder = VariantBuilder((context) {
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
        final builder = VariantBuilder((context) {
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

        final builder = VariantBuilder((context) {
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
        final builder = VariantBuilder((context) => BoxStyler());

        final result = builder.resolve(MockBuildContext());
        expect(result, isA<BoxStyler>());
      });

      test('function parameters are properly typed', () {
        final builder = VariantBuilder((context) {
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

        expect(() => VariantBuilder(builderFunction), returnsNormally);
      });
    });

    group('Integration with other Mix components', () {
      test('can be used in Style resolution context', () {
        final builder = VariantBuilder((context) => BoxStyler().width(100.0));

        // VariantBuilder should integrate with the broader Mix system
        expect(builder, isA<VariantBuilder>());
        expect(builder.key, isA<String>());
        expect(builder.key.isNotEmpty, isTrue);
      });

      test('works with VariantStyle wrapper', () {
        final builder = VariantBuilder((context) => BoxStyler().width(100.0));
        final style = BoxStyler().height(200.0);
        final trigger = ContextTrigger('test', (context) => true);
        final variantStyle = TriggerVariant(trigger, style);

        expect(variantStyle.trigger, trigger);
        expect(variantStyle.style, style);
        expect(variantStyle.key, trigger.key);
      });

      test('key works as mergeKey for VariantStyle', () {
        final builder1 = VariantBuilder((context) => BoxStyler().width(100.0));
        final builder2 = VariantBuilder((context) => BoxStyler().width(200.0));

        final trigger1 = ContextTrigger('test1', (context) => true);
        final trigger2 = ContextTrigger('test2', (context) => true);
        final style1 = TriggerVariant(trigger1, BoxStyler().height(100.0));
        final style2 = TriggerVariant(trigger2, BoxStyler().height(200.0));

        expect(style1.key, trigger1.key);
        expect(style2.key, trigger2.key);
        expect(style1.key, isNot(equals(style2.key)));
      });
    });

    group('Documentation and usage patterns', () {
      test('demonstrates context-based styling pattern', () {
        // This test documents common usage patterns
        final responsiveBuilder = VariantBuilder((context) {
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
        final themeBuilder = VariantBuilder((context) {
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
        final conditionalBuilder = VariantBuilder((context) {
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
