import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackBoxSpecAttribute', () {
    group('Constructor', () {
      test('creates StackBoxSpecAttribute with all properties', () {
        final boxAttribute = BoxSpecAttribute.width(200.0).height(200.0);

        final stackAttribute = StackSpecAttribute(
          alignment: Alignment.center,
          fit: StackFit.expand,
        );

        final attribute = StackBoxSpecAttribute(
          box: boxAttribute,
          stack: stackAttribute,
        );

        expect(attribute.box, boxAttribute);
        expect(attribute.stack, stackAttribute);
        expect(
          attribute.box!.$constraints,
          resolvesTo(BoxConstraints.tightFor(width: 200.0, height: 200.0)),
        );
        expect(attribute.stack!.$alignment, resolvesTo(Alignment.center));
        expect(attribute.stack!.$fit, resolvesTo(StackFit.expand));
      });

      test('creates StackBoxSpecAttribute with default values', () {
        final attribute = StackBoxSpecAttribute();

        expect(attribute.box, isNull);
        expect(attribute.stack, isNull);
      });
    });

    group('value constructor', () {
      test('creates StackBoxSpecAttribute from ZBoxSpec', () {
        const spec = ZBoxSpec(
          box: BoxSpec(
            constraints: BoxConstraints.tightFor(width: 200.0, height: 100.0),
          ),
          stack: StackSpec(alignment: Alignment.center, fit: StackFit.expand),
        );

        final attribute = StackBoxSpecAttribute.value(spec);

        expect(attribute.box, isNotNull);
        expect(attribute.stack, isNotNull);
        expect(
          attribute.box!.$constraints,
          resolvesTo(BoxConstraints.tightFor(width: 200.0, height: 100.0)),
        );
        expect(attribute.stack!.$alignment, resolvesTo(Alignment.center));
        expect(attribute.stack!.$fit, resolvesTo(StackFit.expand));
      });

      test('handles null properties in spec', () {
        const spec = ZBoxSpec(
          box: BoxSpec(constraints: BoxConstraints.tightFor(width: 200.0)),
          stack: StackSpec(),
        );
        final attribute = StackBoxSpecAttribute.value(spec);

        expect(attribute.box, isNotNull);
        expect(attribute.stack, isNotNull);
        expect(
          attribute.box!.$constraints,
          resolvesTo(BoxConstraints.tightFor(width: 200.0)),
        );
        expect(attribute.stack!.$alignment, isNull);
        expect(attribute.stack!.$fit, isNull);
      });
    });

    group('maybeValue static method', () {
      test('returns StackBoxSpecAttribute when spec is not null', () {
        const spec = ZBoxSpec(
          box: BoxSpec(constraints: BoxConstraints.tightFor(width: 200.0)),
          stack: StackSpec(alignment: Alignment.center),
        );
        final attribute = StackBoxSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.box, isNotNull);
        expect(attribute.stack, isNotNull);
        expect(
          attribute.box!.$constraints,
          resolvesTo(BoxConstraints.tightFor(width: 200.0)),
        );
        expect(attribute.stack!.$alignment, resolvesTo(Alignment.center));
      });

      test('returns null when spec is null', () {
        final attribute = StackBoxSpecAttribute.maybeValue(null);
        expect(attribute, isNull);
      });
    });

    group('Resolution', () {
      test('resolves to ZBoxSpec with correct properties', () {
        final boxAttribute = BoxSpecAttribute.width(
          200.0,
        ).height(100.0).merge(BoxSpecAttribute(alignment: Alignment.center));
        final stackAttribute = StackSpecAttribute(
          alignment: Alignment.topLeft,
          fit: StackFit.expand,
          clipBehavior: Clip.antiAlias,
        );

        final attribute = StackBoxSpecAttribute(
          box: boxAttribute,
          stack: stackAttribute,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(
          spec.box.constraints,
          BoxConstraints.tightFor(width: 200.0, height: 100.0),
        );
        expect(spec.box.alignment, Alignment.center);
        expect(spec.stack.alignment, Alignment.topLeft);
        expect(spec.stack.fit, StackFit.expand);
        expect(spec.stack.clipBehavior, Clip.antiAlias);
      });

      test('resolves to ZBoxSpec with null properties when not set', () {
        final attribute = StackBoxSpecAttribute();
        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.box.constraints, isNull);
        expect(spec.stack.alignment, isNull);
        expect(spec.stack.fit, isNull);
      });
    });

    group('merge', () {
      test('merges two StackBoxSpecAttributes correctly', () {
        final attr1 = StackBoxSpecAttribute(
          box: BoxSpecAttribute.width(100.0).height(50.0),
          stack: StackSpecAttribute(alignment: Alignment.topLeft),
        );

        final attr2 = StackBoxSpecAttribute(
          box: BoxSpecAttribute.width(200.0).merge(
            BoxSpecAttribute(
              padding: EdgeInsetsGeometryMix.only(
                top: 8.0,
                bottom: 8.0,
                left: 8.0,
                right: 8.0,
              ),
            ),
          ),
          stack: StackSpecAttribute(fit: StackFit.expand),
        );

        final merged = attr1.merge(attr2);

        // Check that constraints were merged properly
        expect(merged.box!.$constraints, isNotNull);
        final constraints = merged.box!.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(constraints?.minWidth, 200.0); // from attr2
        expect(constraints?.maxWidth, 200.0); // from attr2
        expect(constraints?.minHeight, 50.0); // from attr1
        expect(constraints?.maxHeight, 50.0); // from attr1
        expect(merged.box!.$padding, isNotNull); // from attr2
        expect(
          merged.stack!.$alignment,
          resolvesTo(Alignment.topLeft),
        ); // from attr1
        expect(merged.stack!.$fit, resolvesTo(StackFit.expand)); // from attr2
      });

      test('returns original when merging with null', () {
        final original = StackBoxSpecAttribute(
          box: BoxSpecAttribute.width(200.0),
          stack: StackSpecAttribute(alignment: Alignment.center),
        );
        final merged = original.merge(null);

        expect(merged, original);
      });

      test('handles complex merge scenarios', () {
        final attr1 = StackBoxSpecAttribute(
          box: BoxSpecAttribute.width(100.0),
          stack: StackSpecAttribute(alignment: Alignment.topLeft),
        );

        final attr2 = StackBoxSpecAttribute(
          box: BoxSpecAttribute.height(200.0),
          stack: StackSpecAttribute(fit: StackFit.expand),
        );

        final merged = attr1.merge(attr2);

        // Check that constraints were merged properly
        expect(merged.box!.$constraints, isNotNull);
        final constraints = merged.box!.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(constraints?.minWidth, 100.0); // from attr1
        expect(constraints?.maxWidth, 100.0); // from attr1
        expect(constraints?.minHeight, 200.0); // from attr2
        expect(constraints?.maxHeight, 200.0); // from attr2
        expect(
          merged.stack!.$alignment,
          resolvesTo(Alignment.topLeft),
        ); // from attr1
        expect(merged.stack!.$fit, resolvesTo(StackFit.expand)); // from attr2
      });

      test('handles null attributes in merge', () {
        final attr1 = StackBoxSpecAttribute(box: BoxSpecAttribute.width(100.0));

        final attr2 = StackBoxSpecAttribute(
          stack: StackSpecAttribute(fit: StackFit.expand),
        );

        final merged = attr1.merge(attr2);

        expect(merged.box!.$constraints, isNotNull);
        final constraints = merged.box!.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(constraints?.minWidth, 100.0); // from attr1
        expect(constraints?.maxWidth, 100.0); // from attr1
        expect(merged.stack!.$fit, resolvesTo(StackFit.expand)); // from attr2
      });
    });

    group('equality', () {
      test('attributes with same properties are equal', () {
        final boxAttr = BoxSpecAttribute.width(200.0).height(100.0);
        final stackAttr = StackSpecAttribute(alignment: Alignment.center);

        final attr1 = StackBoxSpecAttribute(box: boxAttr, stack: stackAttr);
        final attr2 = StackBoxSpecAttribute(box: boxAttr, stack: stackAttr);

        expect(attr1, attr2);
        expect(attr1.hashCode, attr2.hashCode);
      });

      test('attributes with different box properties are not equal', () {
        final boxAttr1 = BoxSpecAttribute.width(100.0);
        final boxAttr2 = BoxSpecAttribute.width(200.0);
        final stackAttr = StackSpecAttribute(alignment: Alignment.center);

        final attr1 = StackBoxSpecAttribute(box: boxAttr1, stack: stackAttr);
        final attr2 = StackBoxSpecAttribute(box: boxAttr2, stack: stackAttr);

        expect(attr1, isNot(attr2));
      });

      test('attributes with different stack properties are not equal', () {
        final boxAttr = BoxSpecAttribute.width(100.0);
        final stackAttr1 = StackSpecAttribute(alignment: Alignment.topLeft);
        final stackAttr2 = StackSpecAttribute(alignment: Alignment.bottomRight);

        final attr1 = StackBoxSpecAttribute(box: boxAttr, stack: stackAttr1);
        final attr2 = StackBoxSpecAttribute(box: boxAttr, stack: stackAttr2);

        expect(attr1, isNot(attr2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        final boxAttribute = BoxSpecAttribute.width(200.0).height(100.0);
        final stackAttribute = StackSpecAttribute(
          alignment: Alignment.center,
          fit: StackFit.expand,
        );

        final attribute = StackBoxSpecAttribute(
          box: boxAttribute,
          stack: stackAttribute,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        attribute.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'box'), isTrue);
        expect(properties.any((p) => p.name == 'stack'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        final boxAttribute = BoxSpecAttribute.width(200.0).height(100.0);
        final stackAttribute = StackSpecAttribute(
          alignment: Alignment.center,
          fit: StackFit.expand,
        );

        final attribute = StackBoxSpecAttribute(
          box: boxAttribute,
          stack: stackAttribute,
        );

        expect(attribute.props.length, 2);
        expect(attribute.props, contains(boxAttribute));
        expect(attribute.props, contains(stackAttribute));
      });
    });

    group('Real-world scenarios', () {
      test('creates overlay container attribute', () {
        final overlayAttr = StackBoxSpecAttribute(
          box: BoxSpecAttribute.width(double.infinity).height(double.infinity),
          stack: StackSpecAttribute(
            alignment: Alignment.center,
            fit: StackFit.expand,
          ),
        );

        expect(overlayAttr.box!.$constraints, isNotNull);
        final constraints = overlayAttr.box!.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(constraints?.minWidth, double.infinity);
        expect(constraints?.maxWidth, double.infinity);
        expect(constraints?.minHeight, double.infinity);
        expect(constraints?.maxHeight, double.infinity);
        expect(overlayAttr.stack!.$alignment, resolvesTo(Alignment.center));
        expect(overlayAttr.stack!.$fit, resolvesTo(StackFit.expand));
      });

      test('creates positioned card attribute', () {
        final cardAttr = StackBoxSpecAttribute(
          box: BoxSpecAttribute.width(300.0).height(200.0),
          stack: StackSpecAttribute(
            alignment: Alignment.topLeft,
            fit: StackFit.loose,
            clipBehavior: Clip.antiAlias,
          ),
        );

        expect(cardAttr.box!.$constraints, isNotNull);
        final constraints = cardAttr.box!.$constraints?.resolve(
          MockBuildContext(),
        );
        expect(constraints?.minWidth, 300.0);
        expect(constraints?.maxWidth, 300.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
        expect(cardAttr.stack!.$alignment, resolvesTo(Alignment.topLeft));
        expect(cardAttr.stack!.$fit, resolvesTo(StackFit.loose));
        expect(cardAttr.stack!.$clipBehavior, resolvesTo(Clip.antiAlias));
      });

      test('creates badge container attribute', () {
        final badgeAttr = StackBoxSpecAttribute(
          stack: StackSpecAttribute(
            alignment: Alignment.center,
            fit: StackFit.loose,
          ),
        );

        expect(badgeAttr.box, isNull);
        expect(badgeAttr.stack!.$alignment, resolvesTo(Alignment.center));
        expect(badgeAttr.stack!.$fit, resolvesTo(StackFit.loose));
      });
    });
  });
}
