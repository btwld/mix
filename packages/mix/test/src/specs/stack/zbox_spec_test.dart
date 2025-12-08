import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Helper functions to create StyleSpec wrappers for testing
StyleSpec<BoxSpec> wrapBoxSpec(BoxSpec spec) => StyleSpec(spec: spec);
StyleSpec<StackSpec> wrapStackSpec(StackSpec spec) => StyleSpec(spec: spec);

void main() {
  group('StackBoxSpec', () {
    group('Constructor', () {
      test('creates StackBoxSpec with all properties', () {
        const boxSpec = BoxSpec(
          constraints: BoxConstraints.tightFor(width: 200.0, height: 100.0),
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
        );
        const stackSpec = StackSpec(
          alignment: Alignment.topLeft,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        );

        final spec = StackBoxSpec(
          box: wrapBoxSpec(boxSpec),
          stack: wrapStackSpec(stackSpec),
        );
        final actualBoxSpec = spec.box?.spec;
        final actualStackSpec = spec.stack?.spec;

        expect(actualBoxSpec, boxSpec);
        expect(actualStackSpec, stackSpec);
        expect(
          actualBoxSpec?.constraints,
          BoxConstraints.tightFor(width: 200.0, height: 100.0),
        );
        expect(actualBoxSpec?.alignment, Alignment.center);
        expect(actualBoxSpec?.padding, const EdgeInsets.all(16.0));
        expect(actualStackSpec?.alignment, Alignment.topLeft);
        expect(actualStackSpec?.fit, StackFit.expand);
        expect(actualStackSpec?.textDirection, TextDirection.ltr);
        expect(actualStackSpec?.clipBehavior, Clip.antiAlias);
      });

      test('creates StackBoxSpec with default values', () {
        const spec = StackBoxSpec();

        expect(spec.box, isNull);
        expect(spec.stack, isNull);
        expect(spec.box?.spec.constraints, isNull);
        expect(spec.stack?.spec.alignment, isNull);
        expect(spec.stack?.spec.fit, isNull);
      });

      test('creates StackBoxSpec with only box', () {
        const boxSpec = BoxSpec(margin: EdgeInsets.all(8.0));
        final spec = StackBoxSpec(box: wrapBoxSpec(boxSpec));

        expect(spec.box?.spec, boxSpec);
        expect(spec.stack, isNull);
        expect(spec.box?.spec.margin, const EdgeInsets.all(8.0));
        expect(spec.stack?.spec.alignment, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const originalBox = BoxSpec(
          constraints: BoxConstraints.tightFor(width: 100.0, height: 50.0),
        );
        const originalStack = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.loose,
        );
        final original = StackBoxSpec(
          box: wrapBoxSpec(originalBox),
          stack: wrapStackSpec(originalStack),
        );

        const newBox = BoxSpec(
          constraints: BoxConstraints.tightFor(width: 200.0, height: 100.0),
        );
        final updated = original.copyWith(box: wrapBoxSpec(newBox));
        final updatedBoxSpec = updated.box?.spec;
        final updatedStackSpec = updated.stack?.spec;

        expect(updatedBoxSpec, newBox);
        expect(updatedStackSpec, originalStack);
        expect(updatedBoxSpec?.constraints?.minWidth, 200.0);
        expect(updatedBoxSpec?.constraints?.maxHeight, 100.0);
        expect(updatedStackSpec?.alignment, Alignment.center);
        expect(updatedStackSpec?.fit, StackFit.loose);
      });

      test('updates stack and preserves box', () {
        const originalBox = BoxSpec(alignment: Alignment.topLeft);
        const originalStack = StackSpec(alignment: Alignment.center);
        final original = StackBoxSpec(
          box: wrapBoxSpec(originalBox),
          stack: wrapStackSpec(originalStack),
        );

        const newStack = StackSpec(alignment: Alignment.bottomRight);
        final updated = original.copyWith(stack: wrapStackSpec(newStack));
        final updatedBoxSpec = updated.box?.spec;
        final updatedStackSpec = updated.stack?.spec;

        expect(updatedBoxSpec?.alignment, Alignment.topLeft);
        expect(updatedStackSpec?.alignment, Alignment.bottomRight);
      });

      test('handles null values correctly', () {
        const originalBox = BoxSpec(alignment: Alignment.center);
        const originalStack = StackSpec(fit: StackFit.expand);
        final original = StackBoxSpec(
          box: wrapBoxSpec(originalBox),
          stack: wrapStackSpec(originalStack),
        );

        final updated = original.copyWith();
        final updatedBoxSpec = updated.box?.spec;
        final updatedStackSpec = updated.stack?.spec;

        expect(updatedBoxSpec, originalBox);
        expect(updatedStackSpec, originalStack);
      });
    });

    group('lerp', () {
      test('interpolates between two StackBoxSpecs correctly', () {
        const spec1Box = BoxSpec(
          constraints: BoxConstraints.tightFor(width: 100.0, height: 100.0),
          alignment: Alignment.topLeft,
        );
        const spec1Stack = StackSpec(
          alignment: Alignment.topLeft,
          fit: StackFit.loose,
        );
        final spec1 = StackBoxSpec(
          box: wrapBoxSpec(spec1Box),
          stack: wrapStackSpec(spec1Stack),
        );

        const spec2Box = BoxSpec(
          constraints: BoxConstraints.tightFor(width: 200.0, height: 200.0),
          alignment: Alignment.bottomRight,
        );
        const spec2Stack = StackSpec(
          alignment: Alignment.bottomRight,
          fit: StackFit.expand,
        );
        final spec2 = StackBoxSpec(
          box: wrapBoxSpec(spec2Box),
          stack: wrapStackSpec(spec2Stack),
        );

        final lerped = spec1.lerp(spec2, 0.5);
        final lerpedBoxSpec = lerped.box?.spec;
        final lerpedStackSpec = lerped.stack?.spec;

        expect(lerpedBoxSpec?.constraints?.minWidth, 150.0);
        expect(lerpedBoxSpec?.constraints?.minHeight, 150.0);
        expect(lerpedBoxSpec?.alignment, Alignment.center);
        expect(lerpedStackSpec?.alignment, Alignment.center);
        expect(lerpedStackSpec?.fit, StackFit.expand); // step function at t=0.5
      });

      test('handles null other parameter correctly', () {
        const spec1Box = BoxSpec(
          constraints: BoxConstraints.tightFor(width: 100.0, height: 100.0),
        );
        const spec1Stack = StackSpec(alignment: Alignment.topLeft);
        final spec1 = StackBoxSpec(
          box: wrapBoxSpec(spec1Box),
          stack: wrapStackSpec(spec1Stack),
        );

        final lerped = spec1.lerp(null, 0.5);
        final lerpedBoxSpec = lerped.box?.spec;
        final lerpedStackSpec = lerped.stack?.spec;

        expect(lerpedBoxSpec?.constraints?.minWidth, 50.0);
        expect(lerpedBoxSpec?.constraints?.minHeight, 50.0);
        expect(
          lerpedStackSpec?.alignment,
          Alignment(-0.5, -0.5),
        ); // lerped from topLeft to null at t=0.5
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const boxSpec = BoxSpec(alignment: Alignment.center);
        const stackSpec = StackSpec(fit: StackFit.expand);
        final spec1 = StackBoxSpec(
          box: wrapBoxSpec(boxSpec),
          stack: wrapStackSpec(stackSpec),
        );
        final spec2 = StackBoxSpec(
          box: wrapBoxSpec(boxSpec),
          stack: wrapStackSpec(stackSpec),
        );

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different box properties are not equal', () {
        const boxSpec1 = BoxSpec(alignment: Alignment.center);
        const boxSpec2 = BoxSpec(alignment: Alignment.topLeft);
        const stackSpec = StackSpec(fit: StackFit.expand);
        final spec1 = StackBoxSpec(
          box: wrapBoxSpec(boxSpec1),
          stack: wrapStackSpec(stackSpec),
        );
        final spec2 = StackBoxSpec(
          box: wrapBoxSpec(boxSpec2),
          stack: wrapStackSpec(stackSpec),
        );

        expect(spec1, isNot(spec2));
      });

      test('specs with different stack properties are not equal', () {
        const boxSpec = BoxSpec(alignment: Alignment.center);
        const stackSpec1 = StackSpec(fit: StackFit.expand);
        const stackSpec2 = StackSpec(fit: StackFit.loose);
        final spec1 = StackBoxSpec(
          box: wrapBoxSpec(boxSpec),
          stack: wrapStackSpec(stackSpec1),
        );
        final spec2 = StackBoxSpec(
          box: wrapBoxSpec(boxSpec),
          stack: wrapStackSpec(stackSpec2),
        );

        expect(spec1, isNot(spec2));
      });

      test('specs with null properties are equal', () {
        const spec1 = StackBoxSpec();
        const spec2 = StackBoxSpec();

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        const boxSpec = BoxSpec(alignment: Alignment.center);
        const stackSpec = StackSpec(fit: StackFit.expand);
        final spec = StackBoxSpec(
          box: wrapBoxSpec(boxSpec),
          stack: wrapStackSpec(stackSpec),
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'box'), isTrue);
        expect(properties.any((p) => p.name == 'stack'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        const boxSpec = BoxSpec(alignment: Alignment.center);
        const stackSpec = StackSpec(fit: StackFit.expand);
        final spec = StackBoxSpec(
          box: wrapBoxSpec(boxSpec),
          stack: wrapStackSpec(stackSpec),
        );

        expect(spec.props.length, 2);
        expect(spec.props, contains(spec.box));
        expect(spec.props, contains(spec.stack));
      });
    });

    group('Real-world scenarios', () {
      test('creates overlay spec', () {
        final overlaySpec = StackBoxSpec(
          box: wrapBoxSpec(
            const BoxSpec(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(color: Colors.black54),
            ),
          ),
          stack: wrapStackSpec(
            const StackSpec(alignment: Alignment.center, fit: StackFit.expand),
          ),
        );

        final overlayBoxSpec = overlaySpec.box?.spec;
        final overlayStackSpec = overlaySpec.stack?.spec;

        expect(overlayBoxSpec?.constraints, const BoxConstraints.expand());
        expect(
          (overlayBoxSpec?.decoration as BoxDecoration?)?.color,
          Colors.black54,
        );
        expect(overlayStackSpec?.alignment, Alignment.center);
        expect(overlayStackSpec?.fit, StackFit.expand);
      });

      test('creates card with floating action button spec', () {
        final cardSpec = StackBoxSpec(
          box: wrapBoxSpec(
            BoxSpec(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          stack: wrapStackSpec(const StackSpec(alignment: Alignment.topRight)),
        );

        final cardBoxSpec = cardSpec.box?.spec;
        final cardStackSpec = cardSpec.stack?.spec;

        expect(cardBoxSpec?.padding, const EdgeInsets.all(16.0));
        expect(
          (cardBoxSpec?.decoration as BoxDecoration?)?.color,
          Colors.white,
        );
        expect(cardStackSpec?.alignment, Alignment.topRight);
      });

      test('creates badge spec', () {
        final badgeSpec = StackBoxSpec(
          box: wrapBoxSpec(
            const BoxSpec(
              constraints: BoxConstraints.tightFor(width: 24.0, height: 24.0),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          stack: wrapStackSpec(
            const StackSpec(alignment: Alignment.center, fit: StackFit.loose),
          ),
        );

        final badgeBoxSpec = badgeSpec.box?.spec;
        final badgeStackSpec = badgeSpec.stack?.spec;

        expect(badgeBoxSpec?.constraints?.minWidth, 24.0);
        expect(badgeBoxSpec?.constraints?.minHeight, 24.0);
        expect((badgeBoxSpec?.decoration as BoxDecoration?)?.color, Colors.red);
        expect(
          (badgeBoxSpec?.decoration as BoxDecoration?)?.shape,
          BoxShape.circle,
        );
        expect(badgeStackSpec?.alignment, Alignment.center);
        expect(badgeStackSpec?.fit, StackFit.loose);
      });

      test('creates floating action button spec', () {
        final fabSpec = StackBoxSpec(
          box: wrapBoxSpec(
            BoxSpec(
              constraints: BoxConstraints.tightFor(width: 56.0, height: 56.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          stack: wrapStackSpec(
            StackSpec(
              alignment: Alignment.center,
              fit: StackFit.expand,
              clipBehavior: Clip.antiAlias,
            ),
          ),
        );

        final fabBoxSpec = fabSpec.box?.spec;
        final fabStackSpec = fabSpec.stack?.spec;

        expect(fabBoxSpec?.constraints?.minWidth, 56.0);
        expect(fabBoxSpec?.constraints?.maxHeight, 56.0);
        expect(fabBoxSpec?.decoration, isA<BoxDecoration>());
        expect(fabStackSpec?.alignment, Alignment.center);
        expect(fabStackSpec?.fit, StackFit.expand);
        expect(fabStackSpec?.clipBehavior, Clip.antiAlias);
      });
    });
  });
}
