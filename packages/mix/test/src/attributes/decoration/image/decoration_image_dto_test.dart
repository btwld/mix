import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../../helpers/custom_matchers.dart';

void main() {
  group('DecorationImageDto', () {
    const imageProvider = AssetImage('assets/images/test.png');
    final dto = DecorationImageDto(
      image: imageProvider,
      fit: BoxFit.cover,
      alignment: Alignment.topLeft,
      centerSlice: Rect.fromLTRB(10, 20, 30, 40),
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
      expect(result.image, equivalentTo(Prop.value(imageProvider)));
      expect(result.fit, equivalentTo(const Prop.value(BoxFit.cover)));
      expect(result.alignment, equivalentTo(const Prop.value(Alignment.topLeft)));
      expect(
        result.centerSlice,
        equivalentTo(const Prop.value(Rect.fromLTRB(10, 20, 30, 40))),
      );
      expect(result.repeat, equivalentTo(const Prop.value(ImageRepeat.repeat)));
      expect(
        result.filterQuality,
        equivalentTo(const Prop.value(FilterQuality.high)),
      );
      expect(result.invertColors, equivalentTo(const Prop.value(true)));
      expect(result.isAntiAlias, equivalentTo(const Prop.value(true)));
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

      expect(mergedDto.image, equivalentTo(Prop.value(imageProvider)));
      expect(mergedDto.fit, equivalentTo(Prop.value(BoxFit.fill)));
      expect(mergedDto.alignment, equivalentTo(Prop.value(Alignment.bottomRight)));
      expect(
        mergedDto.centerSlice,
        equivalentTo(Prop.value(const Rect.fromLTRB(50, 60, 70, 80))),
      );
      expect(mergedDto.repeat, equivalentTo(Prop.value(ImageRepeat.repeatX)));
      expect(mergedDto.filterQuality, equivalentTo(Prop.value(FilterQuality.low)));
      expect(mergedDto.invertColors, equivalentTo(Prop.value(false)));
      expect(mergedDto.isAntiAlias, equivalentTo(Prop.value(false)));
    });

    test('resolve with default values', () {
      final dto = DecorationImageDto(image: imageProvider);

      const expectedImage = DecorationImage(
        image: imageProvider,
        alignment: Alignment.center,
        repeat: ImageRepeat.noRepeat,
        filterQuality: FilterQuality.low,
        invertColors: false,
        isAntiAlias: false,
      );

      expect(dto, resolvesTo(expectedImage));
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

      const expectedImage = DecorationImage(
        image: imageProvider,
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomCenter,
        centerSlice: Rect.fromLTRB(5, 10, 15, 20),
        repeat: ImageRepeat.repeatY,
        filterQuality: FilterQuality.medium,
        invertColors: true,
        isAntiAlias: true,
      );

      expect(dto, resolvesTo(expectedImage));
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
