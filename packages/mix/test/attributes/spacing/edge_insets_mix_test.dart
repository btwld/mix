import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';

void main() {
  group('EdgeInsetsGeometryMix', () {
    test(
      'only creates EdgeInsetsMix when directional values are not provided',
      () {
        final mix = EdgeInsetsGeometryMix.only(
          top: 10,
          bottom: 20,
          left: 30,
          right: 40,
        );
        expect(mix, isA<EdgeInsetsMix>());
        expect(mix.top, resolvesTo(10.0));
        expect(mix.bottom, resolvesTo(20.0));
        expect((mix as EdgeInsetsMix).left, resolvesTo(30.0));
        expect((mix).right, resolvesTo(40.0));
      },
    );

    test(
      'only creates EdgeInsetsDirectionalMix when directional values are provided',
      () {
        final mix = EdgeInsetsGeometryMix.only(
          top: 10,
          bottom: 20,
          start: 30,
          end: 40,
        );
        expect(mix, isA<EdgeInsetsDirectionalMix>());
        expect(mix.top, resolvesTo(10.0));
        expect(mix.bottom, resolvesTo(20.0));
        expect((mix as EdgeInsetsDirectionalMix).start, resolvesTo(30.0));
        expect((mix).end, resolvesTo(40.0));
      },
    );

    test('tryToMerge returns first mix if second is null', () {
      final mix1 = EdgeInsetsMix.only(
        top: 10.0,
        bottom: 20.0,
        left: 30.0,
        right: 40.0,
      );
      final merged = EdgeInsetsGeometryMix.tryToMerge(mix1, null);
      expect(merged, equals(mix1));
    });

    test('tryToMerge returns second mix if first is null', () {
      final mix2 = EdgeInsetsDirectionalMix.only(
        top: 10.0,
        bottom: 20.0,
        start: 30.0,
        end: 40.0,
      );
      final merged = EdgeInsetsGeometryMix.tryToMerge(null, mix2);
      expect(merged, equals(mix2));
    });

    test('tryToMerge merges mix objects of the same type', () {
      final mix1 = EdgeInsetsMix.only(top: 10.0, bottom: 20.0);
      final mix2 = EdgeInsetsMix.only(left: 30.0, right: 40.0);
      final merged = EdgeInsetsGeometryMix.tryToMerge(mix1, mix2);
      expect(merged, isA<EdgeInsetsMix>());
      expect(merged!.top, resolvesTo(10.0));
      expect(merged.bottom, resolvesTo(20.0));
      expect((merged as EdgeInsetsMix).left, resolvesTo(30.0));
      expect((merged).right, resolvesTo(40.0));
    });

    test('tryToMerge merges mix objects of different types', () {
      final mix1 = EdgeInsetsMix.only(top: 10.0, bottom: 20.0);
      final mix2 = EdgeInsetsDirectionalMix.only(start: 30.0, end: 40.0);
      final merged = EdgeInsetsGeometryMix.tryToMerge(mix1, mix2);
      expect(merged, isA<EdgeInsetsDirectionalMix>());
      expect(merged!.top, resolvesTo(10.0));
      expect(merged.bottom, resolvesTo(20.0));
      expect((merged as EdgeInsetsDirectionalMix).start, resolvesTo(30.0));
      expect((merged).end, resolvesTo(40.0));
    });
  });

  group('EdgeInsetsMix', () {
    test('all constructor sets all values', () {
      final mix = EdgeInsetsMix.all(10);
      expect(mix.top, resolvesTo(10.0));
      expect(mix.bottom, resolvesTo(10.0));
      expect(mix.left, resolvesTo(10.0));
      expect(mix.right, resolvesTo(10.0));
    });

    test('none constructor sets all values to 0', () {
      final mix = EdgeInsetsMix.none();
      expect(mix.top, resolvesTo(0.0));
      expect(mix.bottom, resolvesTo(0.0));
      expect(mix.left, resolvesTo(0.0));
      expect(mix.right, resolvesTo(0.0));
    });

    test('resolve returns EdgeInsets with token values', () {
      final mix = EdgeInsetsMix.only(
        top: 10.0,
        bottom: 20.0,
        left: 30.0,
        right: 40.0,
      );
      expect(
        dto,
        resolvesTo(
          const EdgeInsets.only(top: 10, bottom: 20, left: 30, right: 40),
        ),
      );
    });
  });

  group('EdgeInsetsDirectionalMix', () {
    test('all constructor sets all values', () {
      final mix = EdgeInsetsDirectionalMix.all(10);
      expect(mix.top, resolvesTo(10.0));
      expect(mix.bottom, resolvesTo(10.0));
      expect(mix.start, resolvesTo(10.0));
      expect(mix.end, resolvesTo(10.0));
    });

    test('none constructor sets all values to 0', () {
      final mix = EdgeInsetsDirectionalMix.none();
      expect(mix.top, resolvesTo(0.0));
      expect(mix.bottom, resolvesTo(0.0));
      expect(mix.start, resolvesTo(0.0));
      expect(mix.end, resolvesTo(0.0));
    });

    test('resolve returns EdgeInsetsDirectional with token values', () {
      final mix = EdgeInsetsDirectionalMix.only(
        top: 10.0,
        bottom: 20.0,
        start: 30.0,
        end: 40.0,
      );
      expect(
        dto,
        resolvesTo(
          const EdgeInsetsDirectional.only(
            top: 10,
            bottom: 20,
            start: 30,
            end: 40,
          ),
        ),
      );
    });
  });

  group('EdgeInsetsGeometryExt', () {
    test('toMix converts EdgeInsets to EdgeInsetsMix', () {
      const edgeInsets = EdgeInsets.only(
        top: 10,
        bottom: 20,
        left: 30,
        right: 40,
      );
      final mix = EdgeInsetsMix.value(edgeInsets);
      expect(mix, isA<EdgeInsetsMix>());
      expect(mix.top, resolvesTo(10.0));
      expect(mix.bottom, resolvesTo(20.0));
      expect(mix.left, resolvesTo(30.0));
      expect((mix).right, resolvesTo(40.0));
    });

    test(
      'toMix converts EdgeInsetsDirectional to EdgeInsetsDirectionalMix',
      () {
        const edgeInsetsDirectional = EdgeInsetsDirectional.only(
          top: 10,
          bottom: 20,
          start: 30,
          end: 40,
        );
        final mix = EdgeInsetsDirectionalMix.value(edgeInsetsDirectional);
        expect(mix, isA<EdgeInsetsDirectionalMix>());
        expect(mix.top, resolvesTo(10.0));
        expect(mix.bottom, resolvesTo(20.0));
        expect(mix.start, resolvesTo(30.0));
        expect((mix).end, resolvesTo(40.0));
      },
    );
  });
}
