import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/attributes/decoration/image/decoration_image_dto.dart';

import '../../../../helpers/testing_utils.dart';

void main() {
  group('DecorationImageDto', () {
    const imageProvider = AssetImage('assets/images/test.png');
    final dto = DecorationImageDto(
      image: imageProvider,
      fit: BoxFit.cover,
      alignment: Alignment.topLeft,
      centerSlice: const Rect.fromLTRB(10, 20, 30, 40),
      repeat: ImageRepeat.repeat,
      filterQuality: FilterQuality.high,
      invertColors: true,
      isAntiAlias: true,
    );

    test('maybeFrom', () {
      const decorationImage = DecorationImage(
        image: imageProvider,
        fit: BoxFit.cover,
        alignment: Alignment.topLeft,
        centerSlice: Rect.fromLTRB(10, 20, 30, 40),
        repeat: ImageRepeat.repeat,
        filterQuality: FilterQuality.high,
        invertColors: true,
        isAntiAlias: true,
      );
      final result = DecorationImageDto.value(decorationImage);
      expect(result, isNotNull);
      expect(result.image, equals(imageProvider));
      expect(result.fit, equals(BoxFit.cover));
      expect(result.alignment, equals(Alignment.topLeft));
      expect(result.centerSlice, equals(const Rect.fromLTRB(10, 20, 30, 40)));
      expect(result.repeat, equals(ImageRepeat.repeat));
      expect(result.filterQuality, equals(FilterQuality.high));
      expect(result.invertColors, equals(true));
      expect(result.isAntiAlias, equals(true));
    });

    test('merge', () {
      final otherDto = DecorationImageDto(
        image: imageProvider,
        fit: BoxFit.fill,
        alignment: Alignment.bottomRight,
        centerSlice: const Rect.fromLTRB(50, 60, 70, 80),
        repeat: ImageRepeat.repeatX,
        filterQuality: FilterQuality.low,
        invertColors: false,
        isAntiAlias: false,
      );

      final mergedDto = dto.merge(otherDto);

      expect(mergedDto.image, equals(imageProvider));
      expect(mergedDto.fit, equals(BoxFit.fill));
      expect(mergedDto.alignment, equals(Alignment.bottomRight));
      expect(
        mergedDto.centerSlice,
        equals(const Rect.fromLTRB(50, 60, 70, 80)),
      );
      expect(mergedDto.repeat, equals(ImageRepeat.repeatX));
      expect(mergedDto.filterQuality, equals(FilterQuality.low));
      expect(mergedDto.invertColors, equals(false));
      expect(mergedDto.isAntiAlias, equals(false));
    });

    test('resolve with default values', () {
      final dto = DecorationImageDto(image: imageProvider);
      final result = dto.resolve(EmptyMixData);

      expect(result.image, equals(imageProvider));
      expect(result.alignment, equals(dto.defaultValue.alignment));
      expect(result.repeat, equals(dto.defaultValue.repeat));
      expect(result.filterQuality, equals(dto.defaultValue.filterQuality));
      expect(result.invertColors, equals(dto.defaultValue.invertColors));
      expect(result.isAntiAlias, equals(dto.defaultValue.isAntiAlias));
    });

    test('resolve with custom values', () {
      final dto = DecorationImageDto(
        image: imageProvider,
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomCenter,
        centerSlice: const Rect.fromLTRB(5, 10, 15, 20),
        repeat: ImageRepeat.repeatY,
        filterQuality: FilterQuality.medium,
        invertColors: true,
        isAntiAlias: true,
      );
      final result = dto.resolve(EmptyMixData);

      expect(result.image, equals(imageProvider));
      expect(result.fit, equals(BoxFit.scaleDown));
      expect(result.alignment, equals(Alignment.bottomCenter));
      expect(result.centerSlice, equals(const Rect.fromLTRB(5, 10, 15, 20)));
      expect(result.repeat, equals(ImageRepeat.repeatY));
      expect(result.filterQuality, equals(FilterQuality.medium));
      expect(result.invertColors, equals(true));
      expect(result.isAntiAlias, equals(true));
    });

    test('equality', () {
      final dto1 = DecorationImageDto(
        image: imageProvider,
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomCenter,
        centerSlice: const Rect.fromLTRB(5, 10, 15, 20),
        repeat: ImageRepeat.repeatY,
        filterQuality: FilterQuality.medium,
        invertColors: true,
        isAntiAlias: true,
      );

      final dto2 = DecorationImageDto(
        image: imageProvider,
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomCenter,
        centerSlice: const Rect.fromLTRB(5, 10, 15, 20),
        repeat: ImageRepeat.repeatY,
        filterQuality: FilterQuality.medium,
        invertColors: true,
        isAntiAlias: true,
      );

      expect(dto1, equals(dto2));

      final dto3 = DecorationImageDto(
        image: imageProvider,
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomCenter,
        centerSlice: const Rect.fromLTRB(5, 10, 15, 20),
        repeat: ImageRepeat.repeatY,
        filterQuality: FilterQuality.medium,
        invertColors: true,
        isAntiAlias: false,
      );

      expect(dto1, isNot(equals(dto3)));
      expect(dto2, isNot(equals(dto3)));
    });
  });
}
