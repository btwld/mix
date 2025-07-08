import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

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
    return _TestSpec(dto: dto ?? this.dto);
  }

  @override
  get props => [dto];

  const _TestSpec({this.dto});
}

final class _TestAttribute extends SpecAttribute<_TestSpec> {
  final DecorationImageDto? dto;

  @override
  _TestAttribute merge(covariant _TestAttribute? other) {
    return other == null ? this : _TestAttribute(dto?.merge(other.dto));
  }

  @override
  _TestSpec resolve(MixContext mix) {
    return _TestSpec(dto: dto?.resolve(mix));
  }

  @override
  get props => [dto];

  const _TestAttribute(this.dto);
}

void main() {
  group('DecorationImageUtility', () {
    late DecorationImageUtility<_TestAttribute> utility;

    setUp(() {
      utility =
          DecorationImageUtility<_TestAttribute>((dto) => _TestAttribute(dto));
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
        image: const Mixable.value(image),
        fit: const Mixable.value(fit),
        alignment: const Mixable.value(alignment),
        centerSlice: const Mixable.value(centerSlice),
        repeat: const Mixable.value(repeat),
        filterQuality: const Mixable.value(filterQuality),
        invertColors: const Mixable.value(invertColors),
        isAntiAlias: const Mixable.value(isAntiAlias),
      );

      expect(result.dto?.image, equals(image));
      expect(result.dto?.fit, equals(fit));
      expect(result.dto?.alignment, equals(alignment));
      expect(result.dto?.centerSlice, equals(centerSlice));
      expect(result.dto?.repeat, equals(repeat));
      expect(result.dto?.filterQuality, equals(filterQuality));
      expect(result.dto?.invertColors, equals(invertColors));
      expect(result.dto?.isAntiAlias, equals(isAntiAlias));
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

      expect(result.dto?.image, equals(image));
      expect(result.dto?.fit, equals(fit));
      expect(result.dto?.alignment, equals(alignment));
      expect(result.dto?.centerSlice, equals(centerSlice));
      expect(result.dto?.repeat, equals(repeat));
      expect(result.dto?.filterQuality, equals(filterQuality));
      expect(result.dto?.invertColors, equals(invertColors));
      expect(result.dto?.isAntiAlias, equals(isAntiAlias));
    });

    test('provider method should create TestAttribute with provided image', () {
      const image = NetworkImage('https://example.com/image.png');

      final result = utility.provider(image);

      expect(result.dto?.image, equals(image));
    });

    test('fit method should create TestAttribute with provided fit', () {
      const fit = BoxFit.contain;

      final result = utility.fit(fit);

      expect(result.dto?.fit, equals(fit));
    });

    test('alignment method should create TestAttribute with provided alignment',
        () {
      const alignment = Alignment.topLeft;

      final result = utility.alignment(alignment);

      expect(result.dto?.alignment, equals(alignment));
    });

    test(
        'centerSlice method should create TestAttribute with provided centerSlice',
        () {
      const centerSlice = Rect.fromLTRB(10, 10, 90, 90);

      final result = utility.centerSlice(centerSlice);

      expect(result.dto?.centerSlice, equals(centerSlice));
    });

    test('repeat method should create TestAttribute with provided repeat', () {
      const repeat = ImageRepeat.repeat;

      final result = utility.repeat();

      expect(result.dto?.repeat, equals(repeat));
    });

    test(
        'filterQuality method should create TestAttribute with provided filterQuality',
        () {
      const filterQuality = FilterQuality.medium;

      final result = utility.filterQuality(filterQuality);

      expect(result.dto?.filterQuality, equals(filterQuality));
    });

    test(
        'invertColors method should create TestAttribute with provided invertColors',
        () {
      const invertColors = false;

      final result = utility.invertColors(invertColors);

      expect(result.dto?.invertColors, equals(invertColors));
    });

    test(
        'isAntiAlias method should create TestAttribute with provided isAntiAlias',
        () {
      const isAntiAlias = true;

      final result = utility.isAntiAlias(isAntiAlias);

      expect(result.dto?.isAntiAlias, equals(isAntiAlias));
    });
  });
}
