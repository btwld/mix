import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/src/core/schema_wire_types.dart';
import 'package:mix_schema/src/schema/metadata/modifier_definition.dart';
import 'package:mix_schema/src/schema/metadata/modifier_schema.dart';

void main() {
  group('modifierDefinitions', () {
    test('cover every wire enum value', () {
      expect(modifierDefinitions.keys, unorderedEquals(SchemaModifier.values));
    });

    test('encode and decode every modifier definition', () {
      final schema = buildModifierSchema();

      for (final type in SchemaModifier.values) {
        final definition = modifierDefinitions[type]!;
        final sample = _sampleModifier(type);
        final payload = definition.encode(sample);
        final result = schema.safeParse(payload);

        expect(result.isOk, isTrue, reason: 'Failed to decode $type: $payload');
        expect(
          result.getOrNull(),
          sample,
          reason: 'Round-trip failed for $type',
        );
      }
    });

    test('schema encodes every modifier definition through Ack codecs', () {
      final schema = buildModifierSchema();

      for (final type in SchemaModifier.values) {
        final definition = modifierDefinitions[type]!;
        final sample = _sampleModifier(type);

        expect(
          schema.encode(sample),
          definition.encode(sample),
          reason: 'Failed to encode $type through buildModifierSchema()',
        );
      }
    });

    test('rejects unknown modifierOrder wire values', () {
      expect(
        () => buildWidgetModifierConfigFromFields({
          'modifierOrder': ['padding', 'unknown_modifier'],
        }),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('Unknown modifierOrder value'),
          ),
        ),
      );
    });
  });
}

ModifierMix _sampleModifier(SchemaModifier type) {
  return switch (type) {
    SchemaModifier.reset => const ResetModifierMix(),
    SchemaModifier.blur => BlurModifierMix(sigma: 4),
    SchemaModifier.opacity => OpacityModifierMix(opacity: 0.5),
    SchemaModifier.visibility => VisibilityModifierMix(visible: false),
    SchemaModifier.align => AlignModifierMix(
      alignment: const Alignment(-1, 0.5),
      widthFactor: 2,
      heightFactor: 3,
    ),
    SchemaModifier.padding => PaddingModifierMix(
      padding: EdgeInsetsMix(top: 1, bottom: 2, left: 3, right: 4),
    ),
    SchemaModifier.scale => ScaleModifierMix(
      x: 1.25,
      y: 0.75,
      alignment: .topLeft,
    ),
    SchemaModifier.rotate => RotateModifierMix(
      radians: 0.25,
      alignment: .bottomRight,
    ),
    SchemaModifier.defaultTextStyle => DefaultTextStyleModifierMix(
      style: TextStyleMix(
        color: const Color(0xFF112233),
        fontSize: 14,
        fontWeight: .w700,
        fontStyle: .italic,
        letterSpacing: 0.5,
        wordSpacing: 1.5,
        textBaseline: .alphabetic,
        decoration: .underline,
        decorationColor: const Color(0xFF445566),
        decorationStyle: .dashed,
        height: 1.25,
        decorationThickness: 2,
        fontFamily: 'Inter',
        fontFamilyFallback: const ['Roboto', 'Arial'],
        inherit: false,
      ),
      textAlign: .center,
      softWrap: false,
      overflow: .ellipsis,
      maxLines: 2,
      textWidthBasis: .longestLine,
      textHeightBehavior: TextHeightBehaviorMix(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: true,
        leadingDistribution: .even,
      ),
    ),
  };
}
