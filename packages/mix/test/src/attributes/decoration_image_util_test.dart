import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';

final class _TestSpec extends Spec<_TestSpec> {
  final DecorationImage? dto;

  // lerp
  @override
  _TestSpec lerp(covariant _TestSpec? other, double t) {
    return const _TestSpec();
  }

  @override
  //copyWith
  _TestSpec copyWith({DecorationImage? dto}) {
    return _TestSpec(mix: dto ?? this.dto);
  }

  @override
  get props => [dto];

  const _TestSpec({this.dto});
}

final class _TestAttribute extends SpecAttribute<_TestSpec> {
  final DecorationImageMix? dto;

  @override
  _TestAttribute merge(covariant _TestAttribute? other) {
    return other == null ? this : _TestAttribute(mix?.merge(other.dto));
  }

  @override
  _TestSpec resolve(BuildContext mix) {
    return _TestSpec(mix: dto?.resolve(mix));
  }

  @override
  get props => [dto];

  const _TestAttribute(this.dto);
}

void main() {
  group('DecorationImageUtility', () {
    late DecorationImageUtility<_TestAttribute> utility;

    setUp(() {
      utility = DecorationImageUtility<_TestAttribute>(
        (mix) => _TestAttribute(mix),
      );
    });

    test('only method should create TestAttribute with provided values', () {
      const image = NetworkImage('https://example.com/image.png');
      const fit = BoxFit.cover;
      const alignment = Alignment.center;
      const centerSlice = Rect.fromLTRB(0, 0, 100, 100);
      const repeat = ImageRepeat.repeatX;
      const filterQuality = FilterQuality.high;
      const invertColors = true;
      const isAntiAlias = false;

      final result = utility.only(
        image: image,
        fit: fit,
        alignment: alignment,
        centerSlice: centerSlice,
        repeat: repeat,
        filterQuality: filterQuality,
        invertColors: invertColors,
        isAntiAlias: isAntiAlias,
      );

      expect(result.dto?.image, resolvesTo(image));
      expect(result.dto?.fit, resolvesTo(fit));
      expect(result.dto?.alignment, resolvesTo(alignment));
      expect(result.dto?.centerSlice, resolvesTo(centerSlice));
      expect(result.dto?.repeat, resolvesTo(repeat));
      expect(result.dto?.filterQuality, resolvesTo(filterQuality));
      expect(result.dto?.invertColors, resolvesTo(invertColors));
      expect(result.dto?.isAntiAlias, resolvesTo(isAntiAlias));
    });

    test('call method should create TestAttribute with provided values', () {
      const image = NetworkImage('https://example.com/image.png');
      const fit = BoxFit.cover;
      const alignment = Alignment.center;
      const centerSlice = Rect.fromLTRB(0, 0, 100, 100);
      const repeat = ImageRepeat.repeatX;
      const filterQuality = FilterQuality.high;
      const invertColors = true;
      const isAntiAlias = false;

      final result = utility(
        image: image,
        fit: fit,
        alignment: alignment,
        centerSlice: centerSlice,
        repeat: repeat,
        filterQuality: filterQuality,
        invertColors: invertColors,
        isAntiAlias: isAntiAlias,
      );

      expect(result.dto?.image, resolvesTo(image));
      expect(result.dto?.fit, resolvesTo(fit));
      expect(result.dto?.alignment, resolvesTo(alignment));
      expect(result.dto?.centerSlice, resolvesTo(centerSlice));
      expect(result.dto?.repeat, resolvesTo(repeat));
      expect(result.dto?.filterQuality, resolvesTo(filterQuality));
      expect(result.dto?.invertColors, resolvesTo(invertColors));
      expect(result.dto?.isAntiAlias, resolvesTo(isAntiAlias));
    });

    test('provider method should create TestAttribute with provided image', () {
      const image = NetworkImage('https://example.com/image.png');

      final result = utility.provider(image);

      expect(result.dto?.image, resolvesTo(image));
    });

    test('fit method should create TestAttribute with provided fit', () {
      const fit = BoxFit.contain;

      final result = utility.fit(fit);

      expect(result.dto?.fit, resolvesTo(fit));
    });

    test(
      'alignment method should create TestAttribute with provided alignment',
      () {
        const alignment = Alignment.topLeft;

        final result = utility.alignment(alignment);

        expect(result.dto?.alignment, resolvesTo(alignment));
      },
    );

    test(
      'centerSlice method should create TestAttribute with provided centerSlice',
      () {
        const centerSlice = Rect.fromLTRB(10, 10, 90, 90);

        final result = utility.centerSlice(centerSlice);

        expect(result.dto?.centerSlice, resolvesTo(centerSlice));
      },
    );

    test('repeat method should create TestAttribute with provided repeat', () {
      const repeat = ImageRepeat.repeat;

      final result = utility.repeat();

      expect(result.dto?.repeat, resolvesTo(repeat));
    });

    test(
      'filterQuality method should create TestAttribute with provided filterQuality',
      () {
        const filterQuality = FilterQuality.medium;

        final result = utility.filterQuality(filterQuality);

        expect(result.dto?.filterQuality, resolvesTo(filterQuality));
      },
    );

    test(
      'invertColors method should create TestAttribute with provided invertColors',
      () {
        const invertColors = false;

        final result = utility.invertColors(invertColors);

        expect(result.dto?.invertColors, resolvesTo(invertColors));
      },
    );

    test(
      'isAntiAlias method should create TestAttribute with provided isAntiAlias',
      () {
        const isAntiAlias = true;

        final result = utility.isAntiAlias(isAntiAlias);

        expect(result.dto?.isAntiAlias, resolvesTo(isAntiAlias));
      },
    );
  });
}
