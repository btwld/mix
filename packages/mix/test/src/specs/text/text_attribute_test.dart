import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('TextSpecAttribute', () {
    final textSpecAttribute = TextSpecAttribute.only(
      overflow: TextOverflow.ellipsis,
      strutStyle: StrutStyleMix.only(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
      textScaler: const TextScaler.linear(1.5),
      maxLines: 2,
      style: TextStyleMix.only(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      textWidthBasis: TextWidthBasis.longestLine,
      textHeightBehavior: TextHeightBehaviorMix.only(
        applyHeightToFirstAscent: true,
        applyHeightToLastDescent: true,
      ),
      textDirection: TextDirection.rtl,
      softWrap: true,
    );

    // Constructor
    test('constructor', () {
      expect(textSpecAttribute.overflow, TextOverflow.ellipsis);
      expect(textSpecAttribute.strutStyle, isA<StrutStyleMix>());
      expect(textSpecAttribute.textAlign, TextAlign.center);
      expect(textSpecAttribute.textScaler, const TextScaler.linear(1.5));
      expect(textSpecAttribute.maxLines, isA<Prop<int>>());
      expect(textSpecAttribute.maxLines.value, 2);
      expect(textSpecAttribute.style, isA<TextStyleMix>());
      expect(textSpecAttribute.textWidthBasis, TextWidthBasis.longestLine);
      expect(
        textSpecAttribute.textHeightBehavior,
        isA<TextHeightBehaviorMix>(),
      );
      expect(textSpecAttribute.textDirection, TextDirection.rtl);
      expect(textSpecAttribute.softWrap, isA<Prop<bool>>());
      expect(textSpecAttribute.softWrap.value, true);
    });

    //  merge
    test('merge', () {
      final other = TextSpecAttribute.only(
        overflow: TextOverflow.clip,
        strutStyle: StrutStyleMix.only(
          fontFamily: 'Helvetica',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        textScaler: const TextScaler.linear(1.5),
        maxLines: 2,
        style: TextStyleMix.only(
          fontSize: 16,
          fontWeight: FontWeight.w200,
          fontFamily: 'Helvetica',
        ),
        textWidthBasis: TextWidthBasis.longestLine,
        textHeightBehavior: TextHeightBehaviorMix.only(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        textDirection: TextDirection.ltr,
        softWrap: false,
      );

      final merged = textSpecAttribute.merge(other);

      expect(merged.overflow, TextOverflow.clip);
      expect(
        merged.strutStyle,
        resolvesTo(
          const StrutStyle(
            fontFamily: 'Helvetica',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
      expect(merged.textAlign, TextAlign.center);
      expect(merged.textScaler, const TextScaler.linear(1.5));
      expect(merged.maxLines, isA<Prop<int>>());
      expect(merged.maxLines.value, 2);
      expect(
        merged.style,
        resolvesTo(
          const TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 16,
            fontWeight: FontWeight.w200,
          ),
        ),
      );
      expect(merged.textWidthBasis, TextWidthBasis.longestLine);
      expect(
        merged.textHeightBehavior.applyHeightToFirstAscent,
        resolvesTo(false),
      );
      expect(
        merged.textHeightBehavior.applyHeightToLastDescent,
        resolvesTo(false),
      );
      expect(merged.textDirection, TextDirection.ltr);
      expect(merged.softWrap, isA<Prop<bool>>());
      expect(merged.softWrap.value, false);
    });

    // resolve
    test('resolve', () {
      final resolved = textSpecAttribute.resolve(EmptyMixData);
      expect(resolved, isA<TextSpec>());
      expect(resolved.overflow, TextOverflow.ellipsis);
      expect(resolved.strutStyle?.fontFamily, 'Roboto');
      expect(resolved.strutStyle?.fontSize, 12);
      expect(resolved.strutStyle?.fontWeight, FontWeight.w500);
      expect(resolved.textAlign, TextAlign.center);
      expect(resolved.textScaler, const TextScaler.linear(1.5));
      expect(resolved.maxLines, 2);
      expect(resolved.style?.fontFamily, 'Roboto');
      expect(resolved.style?.fontSize, 12);
      expect(resolved.style?.fontWeight, FontWeight.w500);
      expect(resolved.textWidthBasis, TextWidthBasis.longestLine);
      expect(resolved.textHeightBehavior?.applyHeightToFirstAscent, true);
      expect(resolved.textHeightBehavior?.applyHeightToLastDescent, true);
      expect(resolved.textDirection, TextDirection.rtl);
      expect(resolved.softWrap, true);
    });
  });
}
