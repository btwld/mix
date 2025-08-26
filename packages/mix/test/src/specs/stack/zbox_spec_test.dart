import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexWidgetSpecUtility', () {
    group('Constructor', () {
      test('', () {
        const boxSpec = ContainerSpec(
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

        const spec = ZBoxSpec(box: boxSpec, stack: stackSpec);

        expect(spec.box, boxSpec);
        expect(spec.stack, stackSpec);
        expect(
          spec.box!.constraints,
          BoxConstraints.tightFor(width: 200.0, height: 100.0),
        );
        expect(spec.box!.alignment, Alignment.center);
        expect(spec.box!.padding, const EdgeInsets.all(16.0));
        expect(spec.stack.alignment, Alignment.topLeft);
        expect(spec.stack.fit, StackFit.expand);
        expect(spec.stack.textDirection, TextDirection.ltr);
        expect(spec.stack.clipBehavior, Clip.antiAlias);
      });

      test('', () {
        const spec = ZBoxSpec();

        expect(spec.box, isNull); // ZBoxSpec.box is nullable ContainerSpec
        expect(spec.stack, const StackSpec());
        expect(spec.box?.constraints, isNull);
        expect(spec.stack.alignment, isNull);
        expect(spec.stack.fit, isNull);
      });

      test('', () {
        const boxSpec = ContainerSpec(margin: EdgeInsets.all(8.0));
        const spec = ZBoxSpec(box: boxSpec);

        expect(spec.box, boxSpec);
        expect(spec.stack, const StackSpec());
        expect(spec.box?.margin, const EdgeInsets.all(8.0));
        expect(spec.stack.alignment, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const originalBox = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 100.0, height: 50.0),
        );
        const originalStack = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.loose,
        );
        const original = ZBoxSpec(box: originalBox, stack: originalStack);

        const newBox = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 200.0, height: 100.0),
        );
        final updated = original.copyWith(box: newBox);

        expect(updated.box, newBox);
        expect(updated.stack, originalStack);
        expect(updated.box?.constraints?.minWidth, 200.0);
        expect(updated.box?.constraints?.maxHeight, 100.0);
        expect(updated.stack.alignment, Alignment.center);
        expect(updated.stack.fit, StackFit.loose);
      });

      test('preserves original properties when not specified', () {
        const originalBox = ContainerSpec(alignment: Alignment.topLeft);
        const originalStack = StackSpec(fit: StackFit.expand);
        const original = ZBoxSpec(box: originalBox, stack: originalStack);

        const newStack = StackSpec(alignment: Alignment.bottomRight);
        final updated = original.copyWith(stack: newStack);

        expect(updated.box, originalBox);
        expect(updated.stack, newStack);
        expect(updated.box?.alignment, Alignment.topLeft);
        expect(updated.stack.alignment, Alignment.bottomRight);
      });

      test('handles null values correctly', () {
        const originalBox = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 150.0),
        );
        const originalStack = StackSpec(fit: StackFit.passthrough);
        const original = ZBoxSpec(box: originalBox, stack: originalStack);

        final updated = original.copyWith();

        expect(updated.box, originalBox);
        expect(updated.stack, originalStack);
      });
    });

    group('lerp', () {
      test('', () {
        const spec1Box = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 100.0, height: 50.0),
        );
        const spec1Stack = StackSpec(alignment: Alignment.topLeft);
        const spec1 = ZBoxSpec(box: spec1Box, stack: spec1Stack);

        const spec2Box = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 200.0, height: 100.0),
        );
        const spec2Stack = StackSpec(alignment: Alignment.bottomRight);
        const spec2 = ZBoxSpec(box: spec2Box, stack: spec2Stack);

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.box?.constraints?.minWidth, 150.0); // (100 + 200) / 2
        expect(lerped.box?.constraints?.maxHeight, 75.0); // (50 + 100) / 2
        expect(
          lerped.stack.alignment,
          Alignment.center,
        ); // interpolated alignment
      });

      test('handles null other parameter correctly', () {
        const boxSpec = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 100.0),
        );
        const stackSpec = StackSpec(fit: StackFit.loose);
        const spec = ZBoxSpec(box: boxSpec, stack: stackSpec);

        // When t < 0.5, constraints interpolate towards null, fit preserves value
        final lerped1 = spec.lerp(null, 0.3);
        final expectedConstraints1 = BoxConstraints.lerp(
          const BoxConstraints.tightFor(width: 100.0),
          null,
          0.3,
        );
        expect(lerped1.box?.constraints, expectedConstraints1);
        expect(
          lerped1.stack.fit,
          MixOps.lerpSnap(StackFit.loose, null, 0.3),
        ); // lerpSnap behavior

        // When t >= 0.5, constraints continue interpolating, fit snaps to null
        final lerped2 = spec.lerp(null, 0.7);
        final expectedConstraints2 = BoxConstraints.lerp(
          const BoxConstraints.tightFor(width: 100.0),
          null,
          0.7,
        );
        expect(lerped2.box?.constraints, expectedConstraints2);
        expect(
          lerped2.stack.fit,
          MixOps.lerpSnap(StackFit.loose, null, 0.7),
        ); // fit snaps to null when t >= 0.5
      });

      test('handles edge cases (t=0, t=1)', () {
        const spec1Box = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 100.0),
        );
        const spec1Stack = StackSpec(fit: StackFit.loose);
        const spec1 = ZBoxSpec(box: spec1Box, stack: spec1Stack);

        const spec2Box = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 200.0),
        );
        const spec2Stack = StackSpec(fit: StackFit.expand);
        const spec2 = ZBoxSpec(box: spec2Box, stack: spec2Stack);

        final lerpedAt0 = spec1.lerp(spec2, 0.0);
        final lerpedAt1 = spec1.lerp(spec2, 1.0);

        final expectedConstraints0 = BoxConstraints.lerp(
          const BoxConstraints.tightFor(width: 100.0),
          const BoxConstraints.tightFor(width: 200.0),
          0.0,
        );
        final expectedConstraints1 = BoxConstraints.lerp(
          const BoxConstraints.tightFor(width: 100.0),
          const BoxConstraints.tightFor(width: 200.0),
          1.0,
        );
        expect(lerpedAt0.box?.constraints, expectedConstraints0);
        expect(
          lerpedAt0.stack.fit,
          MixOps.lerpSnap(StackFit.loose, StackFit.expand, 0.0),
        ); // lerpSnap behavior
        expect(lerpedAt1.box?.constraints, expectedConstraints1);
        expect(
          lerpedAt1.stack.fit,
          MixOps.lerpSnap(StackFit.loose, StackFit.expand, 1.0),
        ); // lerpSnap behavior
      });

      test('interpolates complex properties correctly', () {
        const spec1Box = ContainerSpec(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(8.0),
        );
        const spec1Stack = StackSpec(
          alignment: Alignment.topLeft,
          fit: StackFit.loose,
          textDirection: TextDirection.ltr,
        );
        const spec1 = ZBoxSpec(box: spec1Box, stack: spec1Stack);

        const spec2Box = ContainerSpec(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(16.0),
        );
        const spec2Stack = StackSpec(
          alignment: Alignment.bottomRight,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
        );
        const spec2 = ZBoxSpec(box: spec2Box, stack: spec2Stack);

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.box?.alignment, Alignment.center);
        expect(lerped.box?.padding, const EdgeInsets.all(12.0));
        expect(lerped.stack.alignment, Alignment.center);
        // Discrete properties use step function
        expect(lerped.stack.fit, StackFit.expand); // t >= 0.5
        expect(lerped.stack.textDirection, TextDirection.rtl); // t >= 0.5
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const boxSpec = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 100.0, height: 50.0),
        );
        const stackSpec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.loose,
        );
        const spec1 = ZBoxSpec(box: boxSpec, stack: stackSpec);
        const spec2 = ZBoxSpec(box: boxSpec, stack: stackSpec);

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different box properties are not equal', () {
        const boxSpec1 = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 100.0),
        );
        const boxSpec2 = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 200.0),
        );
        const stackSpec = StackSpec(fit: StackFit.loose);
        const spec1 = ZBoxSpec(box: boxSpec1, stack: stackSpec);
        const spec2 = ZBoxSpec(box: boxSpec2, stack: stackSpec);

        expect(spec1, isNot(spec2));
      });

      test('specs with different stack properties are not equal', () {
        const boxSpec = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 100.0),
        );
        const stackSpec1 = StackSpec(alignment: Alignment.topLeft);
        const stackSpec2 = StackSpec(alignment: Alignment.bottomRight);
        const spec1 = ZBoxSpec(box: boxSpec, stack: stackSpec1);
        const spec2 = ZBoxSpec(box: boxSpec, stack: stackSpec2);

        expect(spec1, isNot(spec2));
      });

      test('default specs are equal', () {
        const spec1 = ZBoxSpec();
        const spec2 = ZBoxSpec();

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        const boxSpec = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 100.0, height: 50.0),
        );
        const stackSpec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.loose,
        );
        const spec = ZBoxSpec(box: boxSpec, stack: stackSpec);

        final diagnostics = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'box'), isTrue);
        expect(properties.any((p) => p.name == 'stack'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        const boxSpec = ContainerSpec(
          constraints: BoxConstraints.tightFor(width: 100.0, height: 50.0),
        );
        const stackSpec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.loose,
        );
        const spec = ZBoxSpec(box: boxSpec, stack: stackSpec);

        // 2 ZBoxSpec properties (box, stack)
        expect(spec.props.length, 2);
        expect(spec.props, contains(boxSpec));
        expect(spec.props, contains(stackSpec));
      });
    });

    group('Real-world scenarios', () {
      test('creates overlay container spec', () {
        const overlaySpec = ZBoxSpec(
          box: ContainerSpec(
            constraints: BoxConstraints.tightFor(
              width: double.infinity,
              height: double.infinity,
            ),
            decoration: BoxDecoration(color: Colors.black54),
          ),
          stack: StackSpec(alignment: Alignment.center, fit: StackFit.expand),
        );

        expect(overlaySpec.box?.constraints?.minWidth, double.infinity);
        expect(overlaySpec.box?.constraints?.maxHeight, double.infinity);
        expect(overlaySpec.box?.decoration, isA<BoxDecoration>());
        expect(overlaySpec.stack.alignment, Alignment.center);
        expect(overlaySpec.stack.fit, StackFit.expand);
      });

      test('creates positioned card spec', () {
        final cardSpec = ZBoxSpec(
          box: ContainerSpec(
            constraints: BoxConstraints.tightFor(width: 300.0, height: 200.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 4),
                  blurRadius: 8.0,
                ),
              ],
            ),
          ),
          stack: StackSpec(
            alignment: Alignment.topLeft,
            fit: StackFit.loose,
            clipBehavior: Clip.antiAlias,
          ),
        );

        expect(cardSpec.box?.constraints?.minWidth, 300.0);
        expect(cardSpec.box?.constraints?.maxHeight, 200.0);
        expect(cardSpec.box?.padding, const EdgeInsets.all(16.0));
        expect(cardSpec.box?.decoration, isA<BoxDecoration>());
        expect(cardSpec.stack.alignment, Alignment.topLeft);
        expect(cardSpec.stack.fit, StackFit.loose);
        expect(cardSpec.stack.clipBehavior, Clip.antiAlias);
      });

      test('creates badge container spec', () {
        final badgeSpec = ZBoxSpec(
          box: ContainerSpec(
            constraints: BoxConstraints(minWidth: 20.0, minHeight: 20.0),
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          stack: StackSpec(alignment: Alignment.center, fit: StackFit.loose),
        );

        expect(
          badgeSpec.box?.constraints,
          const BoxConstraints(minWidth: 20.0, minHeight: 20.0),
        );
        expect(
          badgeSpec.box?.padding,
          const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        );
        expect(badgeSpec.stack.alignment, Alignment.center);
        expect(badgeSpec.stack.fit, StackFit.loose);
      });

      test('creates floating action button spec', () {
        const fabSpec = ZBoxSpec(
          box: ContainerSpec(
            constraints: BoxConstraints.tightFor(width: 56.0, height: 56.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4.0,
                ),
              ],
            ),
          ),
          stack: StackSpec(
            alignment: Alignment.center,
            fit: StackFit.expand,
            clipBehavior: Clip.antiAlias,
          ),
        );

        expect(fabSpec.box?.constraints?.minWidth, 56.0);
        expect(fabSpec.box?.constraints?.maxHeight, 56.0);
        expect(fabSpec.box?.decoration, isA<BoxDecoration>());
        expect(fabSpec.stack.alignment, Alignment.center);
        expect(fabSpec.stack.fit, StackFit.expand);
        expect(fabSpec.stack.clipBehavior, Clip.antiAlias);
      });
    });
  });
}
