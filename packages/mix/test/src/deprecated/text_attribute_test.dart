// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('TextSpecAttribute', () {
    final textSpecAttribute = TextSpecAttribute(
      overflow: TextOverflow.ellipsis,
      strutStyle: const StrutStyleDto(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
      textScaleFactor: 1.5,
      maxLines: 2,
      style: TextStyleDto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      textWidthBasis: TextWidthBasis.longestLine,
      textHeightBehavior: const TextHeightBehaviorDto(
        applyHeightToFirstAscent: true,
        applyHeightToLastDescent: true,
      ),
      textDirection: TextDirection.rtl,
      softWrap: true,
    );

    // Constructor
    test('constructor', () {
      expect(textSpecAttribute.overflow, TextOverflow.ellipsis);
      expect(textSpecAttribute.strutStyle, isA<StrutStyleDto>());
      expect(textSpecAttribute.textAlign, TextAlign.center);
      expect(textSpecAttribute.textScaleFactor, 1.5);
      expect(textSpecAttribute.maxLines, 2);
      expect(textSpecAttribute.style, isA<TextStyleDto>());
      expect(textSpecAttribute.textWidthBasis, TextWidthBasis.longestLine);
      expect(
        textSpecAttribute.textHeightBehavior,
        isA<TextHeightBehaviorDto>(),
      );
      expect(textSpecAttribute.textDirection, TextDirection.rtl);
      expect(textSpecAttribute.softWrap, true);
    });

    //  merge
    test('merge', () {
      final other = TextSpecAttribute(
        overflow: TextOverflow.clip,
        strutStyle: const StrutStyleDto(
          fontFamily: 'Helvetica',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        textScaleFactor: 1.5,
        maxLines: 2,
        style: TextStyleDto(
          fontSize: 16,
          fontWeight: FontWeight.w200,
          fontFamily: 'Helvetica',
        ),
        textWidthBasis: TextWidthBasis.longestLine,
        textHeightBehavior: const TextHeightBehaviorDto(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        textDirection: TextDirection.ltr,
        softWrap: false,
      );

      final merged = textSpecAttribute.merge(other);

      expect(merged.overflow, TextOverflow.clip);
      expect(merged.strutStyle!.fontFamily, 'Helvetica');
      expect(merged.strutStyle!.fontSize, 14);
      expect(merged.strutStyle!.fontWeight, FontWeight.w500);
      expect(merged.textAlign, TextAlign.center);
      expect(merged.textScaleFactor, 1.5);
      expect(merged.maxLines, 2);
      expect(merged.style!.resolve(EmptyMixData).fontFamily, 'Helvetica');
      expect(merged.style!.resolve(EmptyMixData).fontSize, 16);
      expect(merged.style!.resolve(EmptyMixData).fontWeight, FontWeight.w200);
      expect(merged.textWidthBasis, TextWidthBasis.longestLine);
      expect(merged.textHeightBehavior!.applyHeightToFirstAscent, false);
      expect(merged.textHeightBehavior!.applyHeightToLastDescent, false);
      expect(merged.textDirection, TextDirection.ltr);
      expect(merged.softWrap, false);
    });

    // resolve
    test('resolve', () {
      final resolved = textSpecAttribute.resolve(EmptyMixData);

      expect(resolved.overflow, TextOverflow.ellipsis);
      expect(resolved.strutStyle!.fontFamily, 'Roboto');
      expect(resolved.strutStyle!.fontSize, 12);
      expect(resolved.strutStyle!.fontWeight, FontWeight.w500);
      expect(resolved.textAlign, TextAlign.center);
      expect(resolved.textScaleFactor, 1.5);
      expect(resolved.maxLines, 2);
      expect(resolved.style!.fontFamily, 'Roboto');
      expect(resolved.style!.fontSize, 12);
      expect(resolved.style!.fontWeight, FontWeight.w500);
      expect(resolved.textWidthBasis, TextWidthBasis.longestLine);
      expect(resolved.textHeightBehavior!.applyHeightToFirstAscent, true);
      expect(resolved.textHeightBehavior!.applyHeightToLastDescent, true);
      expect(resolved.textDirection, TextDirection.rtl);
      expect(resolved.softWrap, true);
    });
  });
}
