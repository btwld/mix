import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

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
      expect(result.image, equals(Prop.value(imageProvider)));
      expect(result.fit, equals(const Prop.value(BoxFit.cover)));
      expect(result.alignment, equals(const Prop.value(Alignment.topLeft)));
      expect(result.centerSlice, equals(const Prop.value(Rect.fromLTRB(10, 20, 30, 40))));
      expect(result.repeat, equals(const Prop.value(ImageRepeat.repeat)));
      expect(result.filterQuality, equals(const Prop.value(FilterQuality.high)));
      expect(result.invertColors, equals(const Prop.value(true)));
      expect(result.isAntiAlias, equals(const Prop.value(true)));
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

      expect(mergedDto.image, equals(Prop.value(imageProvider)));
      expect(mergedDto.fit, equals(Prop.value(BoxFit.fill)));
      expect(mergedDto.alignment, equals(Prop.value(Alignment.bottomRight)));
      expect(
        mergedDto.centerSlice,
        equals(Prop.value(const Rect.fromLTRB(50, 60, 70, 80))),
      );
      expect(mergedDto.repeat, equals(Prop.value(ImageRepeat.repeatX)));
      expect(mergedDto.filterQuality, equals(Prop.value(FilterQuality.low)));
      expect(mergedDto.invertColors, equals(Prop.value(false)));
      expect(mergedDto.isAntiAlias, equals(Prop.value(false)));
    });

    test('resolve with default values', () {
      final dto = DecorationImageDto(image: imageProvider);
      final result = dto.resolve(EmptyMixData);

      expect(result.image, equals(imageProvider));
      expect(result.alignment, equals(Alignment.center));
      expect(result.repeat, equals(ImageRepeat.noRepeat));
      expect(result.filterQuality, equals(FilterQuality.low));
      expect(result.invertColors, equals(false));
      expect(result.isAntiAlias, equals(false));
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
