// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('TextSpec', () {
    test('resolve', () {
      final mix = MixContext.create(
        MockBuildContext(),
        Style(
          TextSpecAttribute(
            overflow: TextOverflow.ellipsis,
            strutStyle: const StrutStyleDto(fontSize: 20.0),
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
            maxLines: 2,
            style: TextStyleDto(color: Colors.red),
            textWidthBasis: TextWidthBasis.longestLine,
            textHeightBehavior: const TextHeightBehaviorDto(
              applyHeightToFirstAscent: true,
              applyHeightToLastDescent: true,
            ),
            textDirection: TextDirection.ltr,
            softWrap: true,
          ),
        ),
      );

      final spec =
          mix.attributeOf<TextSpecAttribute>()?.resolve(mix) ??
          const TextSpec();

      expect(spec.overflow, TextOverflow.ellipsis);
      expect(spec.strutStyle, const StrutStyle(fontSize: 20.0));
      expect(spec.textAlign, TextAlign.center);
      expect(spec.textScaleFactor, 1.0);
      expect(spec.maxLines, 2);
      expect(spec.style, const TextStyle(color: Colors.red));
      expect(spec.textWidthBasis, TextWidthBasis.longestLine);
      expect(
        spec.textHeightBehavior,
        const TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
        ),
      );
      expect(spec.textDirection, TextDirection.ltr);
      expect(spec.softWrap, true);
    });

    test('copyWith', () {
      const spec = TextSpec(
        overflow: TextOverflow.ellipsis,
        strutStyle: StrutStyle(fontSize: 20.0),
        textAlign: TextAlign.center,
        textScaleFactor: 1.0,
        maxLines: 2,
        style: TextStyle(color: Colors.red),
        textWidthBasis: TextWidthBasis.longestLine,
        textHeightBehavior: TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
        ),
        textDirection: TextDirection.ltr,
        softWrap: true,
      );

      final copiedSpec = spec.copyWith(
        softWrap: false,
        overflow: TextOverflow.fade,
        strutStyle: const StrutStyle(fontSize: 30.0),
        textAlign: TextAlign.start,
        textScaleFactor: 2.0,
        maxLines: 3,
        style: const TextStyle(color: Colors.blue),
        textWidthBasis: TextWidthBasis.parent,
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        textDirection: TextDirection.rtl,
      );

      expect(copiedSpec.overflow, TextOverflow.fade);
      expect(copiedSpec.strutStyle, const StrutStyle(fontSize: 30.0));
      expect(copiedSpec.textAlign, TextAlign.start);
      expect(copiedSpec.textScaleFactor, 2.0);
      expect(copiedSpec.maxLines, 3);
      expect(copiedSpec.style, const TextStyle(color: Colors.blue));
      expect(copiedSpec.textWidthBasis, TextWidthBasis.parent);
      expect(
        copiedSpec.textHeightBehavior,
        const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
      );

      expect(copiedSpec.textDirection, TextDirection.rtl);
      expect(copiedSpec.softWrap, false);
    });

    test('lerp', () {
      const spec1 = TextSpec(
        overflow: TextOverflow.ellipsis,
        strutStyle: StrutStyle(fontSize: 20.0),
        textAlign: TextAlign.center,
        textScaleFactor: 1.0,
        maxLines: 2,
        style: TextStyle(color: Colors.red),
        textWidthBasis: TextWidthBasis.longestLine,
        textHeightBehavior: TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
        ),
        textDirection: TextDirection.ltr,
        softWrap: true,
      );

      const spec2 = TextSpec(
        overflow: TextOverflow.fade,
        strutStyle: StrutStyle(fontSize: 30.0),
        textAlign: TextAlign.start,
        textScaleFactor: 2.0,
        maxLines: 3,
        style: TextStyle(color: Colors.blue),
        textWidthBasis: TextWidthBasis.parent,
        textHeightBehavior: TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        textDirection: TextDirection.rtl,
        softWrap: false,
      );

      const t = 0.5;

      final lerpedSpec = spec1.lerp(spec2, t);

      expect(lerpedSpec.overflow, TextOverflow.fade);
      expect(lerpedSpec.strutStyle, const StrutStyle(fontSize: 25));
      expect(lerpedSpec.textAlign, TextAlign.start);
      expect(lerpedSpec.textScaleFactor, 1.5);
      expect(lerpedSpec.maxLines, 3);
      expect(
        lerpedSpec.style,
        TextStyle.lerp(
          const TextStyle(color: Colors.red),
          const TextStyle(color: Colors.blue),
          t,
        ),
      );
      expect(lerpedSpec.textWidthBasis, TextWidthBasis.parent);

      expect(
        lerpedSpec.textHeightBehavior,
        const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
      );
      expect(lerpedSpec.textDirection, TextDirection.rtl);
      expect(lerpedSpec.softWrap, false);

      expect(lerpedSpec, isNot(spec1));
    });

    test('TextSpec.empty() constructor', () {
      const spec = TextSpec();

      expect(spec.overflow, isNull);
      expect(spec.strutStyle, isNull);
      expect(spec.textAlign, isNull);
      expect(spec.textScaleFactor, isNull);
      expect(spec.maxLines, isNull);
      expect(spec.style, isNull);
      expect(spec.textWidthBasis, isNull);
      expect(spec.textHeightBehavior, isNull);
      expect(spec.textDirection, isNull);
      expect(spec.softWrap, isNull);
      expect(spec.directive, isNull);
    });

    test('TextSpec.from(MixData mix)', () {
      final mixData = MixContext.create(
        MockBuildContext(),
        Style(
          TextSpecAttribute(
            overflow: TextOverflow.ellipsis,
            strutStyle: const StrutStyleDto(fontSize: 20.0),
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
            maxLines: 2,
            style: TextStyleDto(color: Colors.red),
            textWidthBasis: TextWidthBasis.longestLine,
            textHeightBehavior: const TextHeightBehaviorDto(
              applyHeightToFirstAscent: true,
              applyHeightToLastDescent: true,
            ),
            textDirection: TextDirection.ltr,
            softWrap: true,
          ),
        ),
      );

      final spec = TextSpec.from(mixData);

      expect(spec.overflow, TextOverflow.ellipsis);
      expect(spec.strutStyle, const StrutStyle(fontSize: 20.0));
      expect(spec.textAlign, TextAlign.center);
      expect(spec.textScaleFactor, 1.0);
      expect(spec.maxLines, 2);
      expect(spec.style, const TextStyle(color: Colors.red));
      expect(spec.textWidthBasis, TextWidthBasis.longestLine);
      expect(
        spec.textHeightBehavior,
        const TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
        ),
      );
      expect(spec.textDirection, TextDirection.ltr);
      expect(spec.softWrap, true);
    });

    test('TextSpecTween lerp', () {
      const spec1 = TextSpec(
        overflow: TextOverflow.ellipsis,
        strutStyle: StrutStyle(fontSize: 20.0),
        textAlign: TextAlign.center,
        textScaleFactor: 1.0,
        maxLines: 2,
        style: TextStyle(color: Colors.red),
        textWidthBasis: TextWidthBasis.longestLine,
        textHeightBehavior: TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
        ),
        textDirection: TextDirection.ltr,
        softWrap: true,
      );

      const spec2 = TextSpec(
        overflow: TextOverflow.fade,
        strutStyle: StrutStyle(fontSize: 30.0),
        textAlign: TextAlign.start,
        textScaleFactor: 2.0,
        maxLines: 3,
        style: TextStyle(color: Colors.blue),
        textWidthBasis: TextWidthBasis.parent,
        textHeightBehavior: TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        textDirection: TextDirection.rtl,
        softWrap: false,
      );

      final tween = TextSpecTween(begin: spec1, end: spec2);

      final lerpedSpec = tween.lerp(0.5);
      expect(lerpedSpec.overflow, TextOverflow.fade);
      expect(lerpedSpec.strutStyle, const StrutStyle(fontSize: 25));
      expect(lerpedSpec.textAlign, TextAlign.start);
      expect(lerpedSpec.textScaleFactor, 1.5);
      expect(lerpedSpec.maxLines, 3);
      expect(
        lerpedSpec.style,
        TextStyle.lerp(
          const TextStyle(color: Colors.red),
          const TextStyle(color: Colors.blue),
          0.5,
        ),
      );
      expect(lerpedSpec.textWidthBasis, TextWidthBasis.parent);
      expect(
        lerpedSpec.textHeightBehavior,
        const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
      );
      expect(lerpedSpec.textDirection, TextDirection.rtl);
      expect(lerpedSpec.softWrap, false);
    });
  });
}
