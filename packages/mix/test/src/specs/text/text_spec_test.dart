import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextSpec', () {
    test('resolve', () {
      final mix = MixContext.create(
        MockBuildContext(),
        Style(
          TextSpecAttribute(
            overflow: TextOverflow.ellipsis,
            strutStyle: StrutStyleDto(fontSize: 20.0),
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(1.0),
            maxLines: 2,
            style: TextStyleDto(color: Colors.red),
            textWidthBasis: TextWidthBasis.longestLine,
            textHeightBehavior: TextHeightBehaviorDto(
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
      expect(spec.textScaler, const TextScaler.linear(1));
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
        textScaler: TextScaler.linear(1.0),
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
        textScaler: const TextScaler.linear(2.0),
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
      expect(copiedSpec.textScaler, const TextScaler.linear(2));
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
        textScaler: TextScaler.linear(1.0),
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
        textScaler: TextScaler.linear(2.0),
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
      expect(lerpedSpec.textScaler, const TextScaler.linear(2));
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
      expect(spec.textScaler, isNull);
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
            strutStyle: StrutStyleDto(fontSize: 20.0),
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(1.0),
            maxLines: 2,
            style: TextStyleDto(color: Colors.red),
            textWidthBasis: TextWidthBasis.longestLine,
            textHeightBehavior: TextHeightBehaviorDto(
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
      expect(spec.textScaler, const TextScaler.linear(1.0));
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
        textScaler: TextScaler.linear(1.0),
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
        textScaler: TextScaler.linear(2.0),
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
      expect(lerpedSpec.textScaler, const TextScaler.linear(2));
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

  group('TextSpecUtility fluent', () {
    test('fluent behavior', () {
      final text = TextSpecUtility.self;

      final util = text
        ..overflow.ellipsis()
        ..textAlign.center()
        ..textScaler(const TextScaler.linear(1.5))
        ..maxLines(3)
        ..style.color.blue()
        ..textWidthBasis.longestLine()
        ..textDirection.rtl()
        ..softWrap(false);

      final attr = util.attribute!;

      expect(util, isA<Style>());
      expect(attr.overflow, TextOverflow.ellipsis);
      expect(attr.textAlign, TextAlign.center);
      expect(attr.textScaler, const TextScaler.linear(1.5));
      expect(attr.maxLines, 3);
      // Check if style is TextStyleDto and access color directly
      expect(attr.style, isA<TextStyleDto>());
      final valueStyle = attr.style;
      expect(valueStyle?.color, isA<Prop<Color>>());
      expect(attr.textWidthBasis, TextWidthBasis.longestLine);
      expect(attr.textDirection, TextDirection.rtl);
      expect(attr.softWrap, false);

      final style = Style(util);

      final textAttribute = style.styles.attributeOfType<TextSpecAttribute>();

      expect(textAttribute?.overflow, TextOverflow.ellipsis);
      expect(textAttribute?.textAlign, TextAlign.center);
      expect(textAttribute?.textScaler, const TextScaler.linear(1.5));
      expect(textAttribute?.maxLines, 3);
      // Access the TextStyleDto and then its color property
      expect(textAttribute?.style, isA<TextStyleDto>());
      final valueStyle2 = textAttribute?.style;
      expect(valueStyle2?.color, isA<Prop<Color>>());
      expect(textAttribute?.textWidthBasis, TextWidthBasis.longestLine);
      expect(textAttribute?.textDirection, TextDirection.rtl);
      expect(textAttribute?.softWrap, false);

      final mixData = style.of(MockBuildContext());
      final textSpec = TextSpec.from(mixData);

      expect(textSpec.overflow, TextOverflow.ellipsis);
      expect(textSpec.textAlign, TextAlign.center);
      expect(textSpec.textScaler, const TextScaler.linear(1.5));
      expect(textSpec.maxLines, 3);
      expect(textSpec.style?.color, Colors.blue);
      expect(textSpec.textWidthBasis, TextWidthBasis.longestLine);
      expect(textSpec.textDirection, TextDirection.rtl);
      expect(textSpec.softWrap, false);
    });

    test('Immutable behavior when having multiple texts', () {
      final text1 = TextSpecUtility((v) => v)..maxLines(3);
      final text2 = TextSpecUtility((v) => v)..maxLines(5);

      final attr1 = text1.attribute!;
      final attr2 = text2.attribute!;

      expect(attr1.maxLines, 3);
      expect(attr2.maxLines, 5);

      final style1 = Style(text1);
      final style2 = Style(text2);

      final textAttribute1 = style1.styles.attributeOfType<TextSpecAttribute>();
      final textAttribute2 = style2.styles.attributeOfType<TextSpecAttribute>();

      expect(textAttribute1?.maxLines, 3);
      expect(textAttribute2?.maxLines, 5);

      final mixData1 = style1.of(MockBuildContext());
      final mixData2 = style2.of(MockBuildContext());

      final textSpec1 = TextSpec.from(mixData1);
      final textSpec2 = TextSpec.from(mixData2);

      expect(textSpec1.maxLines, 3);
      expect(textSpec2.maxLines, 5);
    });

    test('Mutate behavior and not on same utility', () {
      final text = TextSpecUtility.self;

      final textValue = text;
      textValue
        ..maxLines(3)
        ..style.color.red()
        ..textAlign.center();

      final textAttribute = textValue.attribute!;
      final textAttribute2 = text.maxLines(5);

      expect(textAttribute.maxLines, 3);
      // Access the TextStyleDto and then its color property
      expect(textAttribute.style, isA<TextStyleDto>());
      final valueStyle = textAttribute.style;
      expect(valueStyle?.color, isA<Prop<Color>>());
      expect(textAttribute.textAlign, TextAlign.center);

      expect(textAttribute2.maxLines, 5);
      expect(textAttribute2.style, isNull);
      expect(textAttribute2.textAlign, isNull);
    });
  });
}
