import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('IconStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        IconStyler styler = IconStyler.color(Colors.red);
        expect(styler.$color, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = IconStyler.color(Colors.red).size(24).weight(400);
        expect(styler.$color, isNotNull);
        expect(styler.$size, isNotNull);
        expect(styler.$weight, isNotNull);
      });
    });

    group('factory matches instance method', () {
      test('icon', () {
        expect(
          IconStyler.icon(Icons.home),
          equals(IconStyler(icon: Icons.home)),
        );
      });

      test('color', () {
        expect(
          IconStyler.color(Colors.blue),
          equals(IconStyler(color: Colors.blue)),
        );
      });

      test('size', () {
        expect(
          IconStyler.size(24),
          equals(IconStyler(size: 24)),
        );
      });

      test('weight', () {
        expect(
          IconStyler.weight(400),
          equals(IconStyler(weight: 400)),
        );
      });

      test('fill', () {
        expect(
          IconStyler.fill(1.0),
          equals(IconStyler(fill: 1.0)),
        );
      });

      test('opacity', () {
        expect(
          IconStyler.opacity(0.5),
          equals(IconStyler(opacity: 0.5)),
        );
      });

      test('shadows', () {
        final shadows = [ShadowMix(color: Colors.black, blurRadius: 4)];
        expect(
          IconStyler.shadows(shadows),
          equals(IconStyler(shadows: shadows)),
        );
      });
    });

    group('resolved values', () {
      test('color resolves correctly', () {
        final color =
            IconStyler.color(Colors.blue).$color!.resolveProp(
              MockBuildContext(),
            );
        expect(color, Colors.blue);
      });

      test('size resolves correctly', () {
        final size =
            IconStyler.size(24).$size!.resolveProp(MockBuildContext());
        expect(size, 24);
      });
    });
  });
}
