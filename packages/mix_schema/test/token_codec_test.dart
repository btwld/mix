import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  MixSchemaContract contract() => MixSchemaContractBuilder().builtIn().freeze();

  BoxStyler decodeBox(JsonMap payload) {
    final result = contract().decode<BoxStyler>(payload);

    return switch (result) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
  }

  TextStyler decodeText(JsonMap payload) {
    final result = contract().decode<TextStyler>(payload);

    return switch (result) {
      MixSchemaDecodeSuccess<TextStyler>(:final value) => value,
      MixSchemaDecodeFailure<TextStyler>(:final errors) => fail('$errors'),
    };
  }

  group('token reference decode', () {
    test('decodes canonical token kinds from typed field positions', () {
      final box = decodeBox({
        'v': 1,
        'type': 'box',
        'padding': {
          'top': {r'$token': 'space.stack.sm'},
          'bottom': {r'$token': 'double.opacity', 'kind': 'double'},
        },
        'decoration': {
          'color': {r'$token': 'color.surface'},
          'borderRadius': {r'$token': 'radius.card'},
          'border': {
            'top': {r'$token': 'border.focus'},
          },
          'boxShadow': {r'$token': 'shadow.box.raised'},
        },
        'animation': {
          'duration': {r'$token': 'duration.fast'},
          'curve': 'linear',
          'delay': 0,
        },
      });
      final decoration = _mixOf<BoxDecorationMix, Decoration>(box.$decoration);
      final padding = _mixOf<EdgeInsetsMix, EdgeInsetsGeometry>(box.$padding);
      final radius = _mixOf<BorderRadiusMix, BorderRadiusGeometry>(
        decoration.$borderRadius,
      );
      final border = _mixOf<BorderMix, BoxBorder>(decoration.$border);
      final animation = box.$animation as CurveAnimationConfig;

      expect(_tokenOf(padding.$top), const SpaceToken('space.stack.sm'));
      expect(_tokenOf(padding.$bottom), const DoubleToken('double.opacity'));
      expect(_tokenOf(decoration.$color), const ColorToken('color.surface'));
      expect(_tokenOf(radius.$topLeft), const RadiusToken('radius.card'));
      expect(_tokenOf(border.$top), const BorderSideToken('border.focus'));
      expect(
        _tokenOf(decoration.$boxShadow),
        const BoxShadowToken('shadow.box.raised'),
      );
      expect(
        _tokenOf(animation.duration as Prop<Duration>),
        const DurationToken('duration.fast'),
      );
    });

    test('decodes text, font weight, and shadow token kinds', () {
      final text = decodeText({
        'v': 1,
        'type': 'text',
        'style': {r'$token': 'type.body'},
      });
      final richText = decodeText({
        'v': 1,
        'type': 'text',
        'style': {
          'fontWeight': {r'$token': 'font.weight.strong'},
          'shadows': {r'$token': 'shadow.text.soft'},
        },
      });
      final style = _mixOf<TextStyleMix, TextStyle>(richText.$style);

      expect(_tokenOf(text.$style), const TextStyleToken('type.body'));
      expect(
        _tokenOf(style.$fontWeight),
        const FontWeightToken('font.weight.strong'),
      );
      expect(_tokenOf(style.$shadows), const ShadowToken('shadow.text.soft'));
    });

    test('decodes breakpoint token variants', () {
      final box = decodeBox({
        'v': 1,
        'type': 'box',
        'variants': [
          {
            'kind': 'context_breakpoint',
            'token': 'breakpoint.sidebar',
            'style': {'type': 'box'},
          },
        ],
      });
      final variant = box.$variants!.single.variant as BreakpointVariant;

      expect(variant.breakpoint, isA<BreakpointRef>());
      expect(
        (variant.breakpoint as BreakpointRef).token,
        const BreakpointToken('breakpoint.sidebar'),
      );
    });
  });

  group('token reference validation', () {
    test('rejects invalid token names with a typed error', () {
      final result = contract().decode<BoxStyler>({
        'v': 1,
        'type': 'box',
        'decoration': {
          'color': {r'$token': ''},
        },
      });
      final errors = switch (result) {
        MixSchemaDecodeFailure<BoxStyler>(:final errors) => errors,
        MixSchemaDecodeSuccess<BoxStyler>() => fail('expected failure'),
      };

      expect(errors.single.code, MixSchemaErrorCode.invalidTokenName);
      expect(errors.single.path, '/decoration/color/\$token');
    });

    test('rejects unknown control markers', () {
      final result = contract().decode<BoxStyler>({
        'v': 1,
        'type': 'box',
        'decoration': {
          'color': {r'$bogus': []},
        },
      });
      final errors = switch (result) {
        MixSchemaDecodeFailure<BoxStyler>(:final errors) => errors,
        MixSchemaDecodeSuccess<BoxStyler>() => fail('expected failure'),
      };

      expect(errors.single.code, MixSchemaErrorCode.unknownField);
      expect(errors.single.path, '/decoration/color/\$bogus');
    });

    test('rejects malformed merge terms', () {
      final result = contract().decode<BoxStyler>({
        'v': 1,
        'type': 'box',
        'decoration': {
          'color': {r'$merge': []},
        },
      });
      final errors = switch (result) {
        MixSchemaDecodeFailure<BoxStyler>(:final errors) => errors,
        MixSchemaDecodeSuccess<BoxStyler>() => fail('expected failure'),
      };

      expect(errors.single.code, MixSchemaErrorCode.unsupportedEncodeValue);
      expect(errors.single.path, '/decoration/color');
    });
  });

  group('token reference encode', () {
    test('encodes canonical token kinds from typed field positions', () {
      final style = BoxStyler(
        padding: EdgeInsetsMix(
          top: SpaceToken('space.stack.sm')(),
          bottom: DoubleToken('double.opacity')(),
        ),
        decoration: BoxDecorationMix.create(
          color: Prop.token(const ColorToken('color.surface')),
          borderRadius: Prop.mix(
            BorderRadiusMix.all(const RadiusToken('radius.card')()),
          ),
          border: Prop.mix(
            BorderMix.create(
              top: Prop.token(const BorderSideToken('border.focus')),
            ),
          ),
          boxShadow: Prop.token(const BoxShadowToken('shadow.box.raised')),
        ),
        animation: CurveAnimationConfig(
          duration: const DurationToken('duration.fast')(),
          curve: Curves.linear,
        ),
      );

      final payload = _encode(contract(), style);

      expect(payload['padding'], {
        'top': {r'$token': 'space.stack.sm', 'kind': 'space'},
        'bottom': {r'$token': 'double.opacity', 'kind': 'double'},
      });
      expect(payload['decoration'], {
        'color': {r'$token': 'color.surface'},
        'border': {
          'top': {r'$token': 'border.focus'},
        },
        'borderRadius': {r'$token': 'radius.card'},
        'boxShadow': {r'$token': 'shadow.box.raised'},
      });
      expect(payload['animation'], {
        'duration': {r'$token': 'duration.fast'},
        'curve': 'linear',
        'delay': 0,
      });
    });

    test('encodes text, font weight, and shadow token kinds', () {
      final text = TextStyler.create(
        style: Prop.token(const TextStyleToken('type.body')),
      );
      final richText = TextStyler(
        style: TextStyleMix.create(
          fontWeight: Prop.token(const FontWeightToken('font.weight.strong')),
          shadows: Prop.token(const ShadowToken('shadow.text.soft')),
        ),
      );

      expect(_encode(contract(), text)['style'], {r'$token': 'type.body'});
      expect(_encode(contract(), richText)['style'], {
        'fontWeight': {r'$token': 'font.weight.strong'},
        'shadows': {r'$token': 'shadow.text.soft'},
      });
    });

    test('encodes breakpoint token variants', () {
      final style = BoxStyler(
        variants: [
          VariantStyle(
            ContextVariant.breakpoint(
              const BreakpointToken('breakpoint.sidebar')(),
            ),
            BoxStyler(),
          ),
        ],
      );

      expect(_encode(contract(), style)['variants'], [
        {
          'kind': 'context_breakpoint',
          'token': 'breakpoint.sidebar',
          'style': {'type': 'box'},
        },
      ]);
    });

    testWidgets('round-trips token references and resolves from MixScope', (
      tester,
    ) async {
      final originalBox = BoxStyler(
        padding: EdgeInsetsMix(
          top: SpaceToken('space.stack.sm')(),
          bottom: DoubleToken('double.opacity')(),
        ),
        decoration: BoxDecorationMix.create(
          color: Prop.token(const ColorToken('color.surface')),
          borderRadius: Prop.mix(
            BorderRadiusMix.all(const RadiusToken('radius.card')()),
          ),
          border: Prop.mix(
            BorderMix.create(
              top: Prop.token(const BorderSideToken('border.focus')),
            ),
          ),
          boxShadow: Prop.token(const BoxShadowToken('shadow.box.raised')),
        ),
        animation: CurveAnimationConfig(
          duration: const DurationToken('duration.fast')(),
          curve: Curves.linear,
        ),
        variants: [
          VariantStyle(
            ContextVariant.breakpoint(
              const BreakpointToken('breakpoint.sidebar')(),
            ),
            BoxStyler(),
          ),
        ],
      );
      final originalText = TextStyler.create(
        style: Prop.token(const TextStyleToken('type.body')),
      );
      final originalRichText = TextStyler(
        style: TextStyleMix.create(
          fontWeight: Prop.token(const FontWeightToken('font.weight.strong')),
          shadows: Prop.token(const ShadowToken('shadow.text.soft')),
        ),
      );
      final decodedBox = decodeBox(_encode(contract(), originalBox));
      final decodedText = decodeText(_encode(contract(), originalText));
      final decodedRichText = decodeText(_encode(contract(), originalRichText));
      final context = await _pumpTokenScope(tester);
      final decoration = _mixOf<BoxDecorationMix, Decoration>(
        decodedBox.$decoration,
      );
      final padding = _mixOf<EdgeInsetsMix, EdgeInsetsGeometry>(
        decodedBox.$padding,
      );
      final radius = _mixOf<BorderRadiusMix, BorderRadiusGeometry>(
        decoration.$borderRadius,
      );
      final border = _mixOf<BorderMix, BoxBorder>(decoration.$border);
      final animation = decodedBox.$animation as CurveAnimationConfig;
      final richStyle = _mixOf<TextStyleMix, TextStyle>(decodedRichText.$style);
      final breakpoint =
          decodedBox.$variants!.single.variant as BreakpointVariant;

      expect(_tokenOf(padding.$top), const SpaceToken('space.stack.sm'));
      expect(
        _tokenOf(padding.$top).resolve(context),
        _TokenFixture.spaceStackSm,
      );
      expect(_tokenOf(padding.$bottom), const DoubleToken('double.opacity'));
      expect(
        _tokenOf(padding.$bottom).resolve(context),
        _TokenFixture.doubleOpacity,
      );
      expect(_tokenOf(decoration.$color), const ColorToken('color.surface'));
      expect(
        _tokenOf(decoration.$color).resolve(context),
        _TokenFixture.colorSurface,
      );
      expect(_tokenOf(radius.$topLeft), const RadiusToken('radius.card'));
      expect(
        _tokenOf(radius.$topLeft).resolve(context),
        _TokenFixture.radiusCard,
      );
      expect(_tokenOf(border.$top), const BorderSideToken('border.focus'));
      expect(_tokenOf(border.$top).resolve(context), _TokenFixture.borderFocus);
      expect(
        _tokenOf(decoration.$boxShadow),
        const BoxShadowToken('shadow.box.raised'),
      );
      expect(
        _tokenOf(decoration.$boxShadow).resolve(context),
        _TokenFixture.boxShadowRaised,
      );
      expect(
        _tokenOf(animation.duration as Prop<Duration>),
        const DurationToken('duration.fast'),
      );
      expect(
        _tokenOf(animation.duration as Prop<Duration>).resolve(context),
        _TokenFixture.durationFast,
      );
      expect(_tokenOf(decodedText.$style), const TextStyleToken('type.body'));
      expect(
        _tokenOf(decodedText.$style).resolve(context),
        _TokenFixture.typeBody,
      );
      expect(
        _tokenOf(richStyle.$fontWeight),
        const FontWeightToken('font.weight.strong'),
      );
      expect(
        _tokenOf(richStyle.$fontWeight).resolve(context),
        _TokenFixture.fontWeightStrong,
      );
      expect(
        _tokenOf(richStyle.$shadows),
        const ShadowToken('shadow.text.soft'),
      );
      expect(
        _tokenOf(richStyle.$shadows).resolve(context),
        _TokenFixture.shadowTextSoft,
      );
      expect(breakpoint.breakpoint, isA<BreakpointRef>());
      expect(
        (breakpoint.breakpoint as BreakpointRef).token,
        const BreakpointToken('breakpoint.sidebar'),
      );
      expect(
        (breakpoint.breakpoint as BreakpointRef).token.resolve(context),
        _TokenFixture.breakpointSidebar,
      );
    });

    test('encodes flex, icon, and image numeric/color token refs', () {
      final flexPayload = _encode(
        contract(),
        FlexStyler(spacing: const SpaceToken('space.flex.gap')()),
      );
      final flexBoxPayload = _encode(
        contract(),
        FlexBoxStyler(spacing: const SpaceToken('space.flex_box.gap')()),
      );
      final iconPayload = _encode(
        contract(),
        IconStyler(
          color: const ColorToken('color.icon')(),
          size: const SpaceToken('space.icon.size')(),
          opacity: const DoubleToken('double.icon.opacity')(),
        ),
      );
      final imagePayload = _encode(
        contract(),
        ImageStyler(
          width: const SpaceToken('space.image.width')(),
          height: const DoubleToken('double.image.height')(),
          color: const ColorToken('color.image.tint')(),
        ),
      );

      expect(flexPayload['spacing'], {
        r'$token': 'space.flex.gap',
        'kind': 'space',
      });
      expect(flexBoxPayload['spacing'], {
        r'$token': 'space.flex_box.gap',
        'kind': 'space',
      });
      expect(iconPayload['color'], {r'$token': 'color.icon'});
      expect(iconPayload['size'], {
        r'$token': 'space.icon.size',
        'kind': 'space',
      });
      expect(iconPayload['opacity'], {
        r'$token': 'double.icon.opacity',
        'kind': 'double',
      });
      expect(imagePayload['width'], {
        r'$token': 'space.image.width',
        'kind': 'space',
      });
      expect(imagePayload['height'], {
        r'$token': 'double.image.height',
        'kind': 'double',
      });
      expect(imagePayload['color'], {r'$token': 'color.image.tint'});
    });

    test('custom token subclasses fail encode explicitly with path', () {
      final result = contract().encode(
        BoxStyler(
          decoration: BoxDecorationMix.create(
            color: Prop.token(const _CustomColorToken('color.custom')),
          ),
        ),
      );
      final errors = switch (result) {
        MixSchemaEncodeFailure(:final errors) => errors,
        MixSchemaEncodeSuccess() => fail('expected failure'),
      };

      expect(
        errors,
        contains(
          isA<MixSchemaError>()
              .having(
                (error) => error.code,
                'code',
                MixSchemaErrorCode.unsupportedEncodeValue,
              )
              .having((error) => error.path, 'path', '/decoration/color')
              .having(
                (error) => error.message,
                'message',
                contains('custom token'),
              ),
        ),
      );
    });

    test('invalid token names fail encode with the token-name code', () {
      final result = contract().encode(
        BoxStyler(
          decoration: BoxDecorationMix.create(
            color: Prop.token(const ColorToken('color/bad')),
          ),
        ),
      );
      final errors = switch (result) {
        MixSchemaEncodeFailure(:final errors) => errors,
        MixSchemaEncodeSuccess() => fail('expected failure'),
      };

      expect(
        errors,
        contains(
          isA<MixSchemaError>()
              .having(
                (error) => error.code,
                'code',
                MixSchemaErrorCode.invalidTokenName,
              )
              .having((error) => error.path, 'path', '/decoration/color'),
        ),
      );
    });
  });
}

Future<BuildContext> _pumpTokenScope(WidgetTester tester) async {
  late BuildContext scopeContext;
  await tester.pumpWidget(
    MixScope(
      tokens: _TokenFixture.tokens,
      child: Builder(
        builder: (context) {
          scopeContext = context;

          return const SizedBox.shrink();
        },
      ),
    ),
  );

  return scopeContext;
}

abstract final class _TokenFixture {
  static const colorSurface = Color(0xFF101820);
  static const radiusCard = Radius.circular(12);
  static const spaceStackSm = 8.0;
  static const doubleOpacity = 0.64;
  static const borderFocus = BorderSide(color: Color(0xFF008577), width: 2);
  static const boxShadowRaised = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 1,
    ),
  ];
  static const durationFast = Duration(milliseconds: 120);
  static const typeBody = TextStyle(fontSize: 14, height: 1.4);
  static const fontWeightStrong = FontWeight.w700;
  static const shadowTextSoft = [
    Shadow(color: Color(0x33000000), offset: Offset(0, 1), blurRadius: 2),
  ];
  static final breakpointSidebar = Breakpoint.minWidth(960);
  static final tokens = <MixToken, Object>{
    const ColorToken('color.surface'): colorSurface,
    const RadiusToken('radius.card'): radiusCard,
    const SpaceToken('space.stack.sm'): spaceStackSm,
    const DoubleToken('double.opacity'): doubleOpacity,
    const BorderSideToken('border.focus'): borderFocus,
    const BoxShadowToken('shadow.box.raised'): boxShadowRaised,
    const DurationToken('duration.fast'): durationFast,
    const TextStyleToken('type.body'): typeBody,
    const FontWeightToken('font.weight.strong'): fontWeightStrong,
    const ShadowToken('shadow.text.soft'): shadowTextSoft,
    const BreakpointToken('breakpoint.sidebar'): breakpointSidebar,
  };
}

T _mixOf<T extends Object, V extends Object>(Prop<V>? prop) {
  final source = prop!.sources.single;
  if (source is MixSource<V> && source.mix is T) return source.mix as T;
  fail('Expected MixSource<$T>, got $source.');
}

MixToken<V> _tokenOf<V extends Object>(Prop<V>? prop) {
  final source = prop!.sources.single;
  if (source is TokenSource<V>) return source.token;
  fail('Expected TokenSource, got $source.');
}

JsonMap _encode(MixSchemaContract contract, Object value) {
  return switch (contract.encode(value)) {
    MixSchemaEncodeSuccess(:final value) => value,
    MixSchemaEncodeFailure(:final errors) => fail('$errors'),
  };
}

final class _CustomColorToken extends MixToken<Color> {
  const _CustomColorToken(super.name);

  @override
  ColorRef call() => ColorRef(Prop.token(this));
}
