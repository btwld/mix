import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/internal/string_ext.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextSpec', () {
    group('TextSpec comprehensive', () {
      test('constructor with all properties', () {
        final spec = TextSpec(
          overflow: TextOverflow.ellipsis,
          strutStyle: const StrutStyle(fontSize: 18),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          softWrap: true,
          textScaler: const TextScaler.linear(1.2),
          maxLines: 3,
          style: const TextStyle(fontSize: 16, color: Colors.red),
          textWidthBasis: TextWidthBasis.parent,
          textHeightBehavior:
              const TextHeightBehavior(applyHeightToFirstAscent: true),
          directive: TextDirective((value) => value.capitalize),
          animated: const AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          modifiers: const WidgetModifiersData([
            OpacityModifierSpec(0.8),
            SizedBoxModifierSpec(width: 200, height: 50),
          ]),
        );

        // Test ALL properties are set correctly
        expect(spec.overflow, TextOverflow.ellipsis);
        expect(spec.strutStyle?.fontSize, 18);
        expect(spec.textAlign, TextAlign.center);
        expect(spec.textDirection, TextDirection.ltr);
        expect(spec.softWrap, true);
        expect(spec.textScaler, const TextScaler.linear(1.2));
        expect(spec.maxLines, 3);
        expect(spec.style?.fontSize, 16);
        expect(spec.style?.color, Colors.red);
        expect(spec.textWidthBasis, TextWidthBasis.parent);
        expect(spec.textHeightBehavior?.applyHeightToFirstAscent, true);
        // Test directive behavior instead of equality since functions can't be compared
        expect(spec.directive, isNotNull);
        expect(spec.directive!.apply('hello'), 'Hello');
        expect(spec.animated?.duration, const Duration(milliseconds: 300));
        expect(spec.animated?.curve, Curves.easeInOut);
        expect(spec.modifiers?.value, [
          const OpacityModifierSpec(0.8),
          const SizedBoxModifierSpec(width: 200, height: 50),
        ]);
      });

      test('call method creates correct widget', () {
        const spec = TextSpec(
          style: TextStyle(fontSize: 16, color: Colors.blue),
          textAlign: TextAlign.center,
        );

        final widget = spec.call('Hello World');

        expect(widget, isA<TextSpecWidget>());
      });

      test('call method creates animated widget when animated', () {
        const spec = TextSpec(
          style: TextStyle(fontSize: 16, color: Colors.blue),
          textAlign: TextAlign.center,
          animated: AnimatedData(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        );

        final widget = spec.call('Hello World');

        expect(widget, isA<AnimatedTextSpecWidget>());
      });

      test('debugFillProperties includes all properties', () {
        const spec = TextSpec(
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: TextStyle(fontSize: 16),
        );

        final builder = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties, isNotEmpty);
      });
    });
    test('resolve', () {
      final mix = MixData.create(
        MockBuildContext(),
        Style(
          TextSpecAttribute(
            overflow: TextOverflow.ellipsis,
            strutStyle: const StrutStyleDto(fontSize: 20.0),
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(1.0),
            maxLines: 2,
            style: TextStyleDto(color: const ColorDto(Colors.red)),
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

      final spec = mix.attributeOf<TextSpecAttribute>()?.resolve(mix) ??
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

    test('copyWith updates correctly and preserves unchanged properties', () {
      const original = TextSpec(
        overflow: TextOverflow.clip,
        textAlign: TextAlign.left,
        maxLines: 2,
        style: TextStyle(fontSize: 14),
        textDirection: TextDirection.ltr,
        softWrap: true,
      );

      final updated = original.copyWith(
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
        // Don't update textAlign, style, textDirection, softWrap - test preservation
      );

      // Test updated properties
      expect(updated.overflow, TextOverflow.ellipsis);
      expect(updated.maxLines, 5);

      // Test preserved properties
      expect(updated.textAlign, TextAlign.left);
      expect(updated.style?.fontSize, 14);
      expect(updated.textDirection, TextDirection.ltr);
      expect(updated.softWrap, true);
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
      final mixData = MixData.create(
        MockBuildContext(),
        Style(
          TextSpecAttribute(
            overflow: TextOverflow.ellipsis,
            strutStyle: const StrutStyleDto(fontSize: 20.0),
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(1.0),
            maxLines: 2,
            style: TextStyleDto(color: const ColorDto(Colors.red)),
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

      final util = text.chain
        ..overflow.ellipsis()
        ..textAlign.center()
        ..textScaleFactor(1.5)
        ..maxLines(3)
        ..style.color.blue()
        ..textWidthBasis.longestLine()
        ..textDirection.rtl()
        ..softWrap(false);

      final attr = util.attributeValue!;

      expect(util, isA<Attribute>());
      expect(attr.overflow, TextOverflow.ellipsis);
      expect(attr.textAlign, TextAlign.center);
      expect(attr.textScaleFactor, 1.5);
      expect(attr.maxLines, 3);
      expect(attr.style?.value.first.color, Colors.blue.toDto());
      expect(attr.textWidthBasis, TextWidthBasis.longestLine);
      expect(attr.textDirection, TextDirection.rtl);
      expect(attr.softWrap, false);

      final style = Style(util);

      final textAttribute = style.styles.attributeOfType<TextSpecAttribute>();

      expect(textAttribute?.overflow, TextOverflow.ellipsis);
      expect(textAttribute?.textAlign, TextAlign.center);
      expect(textAttribute?.textScaleFactor, 1.5);
      expect(textAttribute?.maxLines, 3);
      expect(textAttribute?.style?.value.first.color, Colors.blue.toDto());
      expect(textAttribute?.textWidthBasis, TextWidthBasis.longestLine);
      expect(textAttribute?.textDirection, TextDirection.rtl);
      expect(textAttribute?.softWrap, false);

      final mixData = style.of(MockBuildContext());
      final textSpec = TextSpec.from(mixData);

      expect(textSpec.overflow, TextOverflow.ellipsis);
      expect(textSpec.textAlign, TextAlign.center);
      expect(textSpec.textScaleFactor, 1.5);
      expect(textSpec.maxLines, 3);
      expect(textSpec.style?.color, Colors.blue);
      expect(textSpec.textWidthBasis, TextWidthBasis.longestLine);
      expect(textSpec.textDirection, TextDirection.rtl);
      expect(textSpec.softWrap, false);
    });

    test('Immutable behavior when having multiple texts', () {
      final textUtil = TextSpecUtility.self;
      final text1 = textUtil.chain..maxLines(3);
      final text2 = textUtil.chain..maxLines(5);

      final attr1 = text1.attributeValue!;
      final attr2 = text2.attributeValue!;

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

      final textValue = text.chain;
      textValue
        ..maxLines(3)
        ..style.color.red()
        ..textAlign.center();

      final textAttribute = textValue.attributeValue!;
      final textAttribute2 = text.maxLines(5);

      expect(textAttribute.maxLines, 3);
      expect(textAttribute.style?.value.first.color, Colors.red.toDto());
      expect(textAttribute.textAlign, TextAlign.center);

      expect(textAttribute2.maxLines, 5);
      expect(textAttribute2.style, isNull);
      expect(textAttribute2.textAlign, isNull);
    });
  });
}
