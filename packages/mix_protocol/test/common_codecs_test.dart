import 'dart:ui' show ColorSpace;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart'
    show
        JsonMap,
        mixProtocol,
        MixProtocolFailure,
        MixProtocolResult,
        MixProtocolSuccess,
        MixProtocolError,
        MixProtocolErrorCode;
import 'package:mix_protocol/src/errors/mix_protocol_error.dart'
    show UnsupportedEncodeValueError;
import 'package:mix_protocol/src/schema/common_codecs.dart';

void main() {
  test('numberAsDouble parses ints and encodes doubles', () {
    final schema = numberAsDoubleCodec();

    expect(schema.safeParse(2).getOrThrow(), 2.0);
    expect(schema.safeEncode(2.5).getOrThrow(), 2.5);
  });

  test('color codec parses CSS-like input and encodes Ack canonical hex', () {
    final schema = colorCodec();

    final color = schema.safeParse('rgba(51, 102, 153, 0.8)').getOrThrow()!;

    expect(color.toARGB32(), 0xCC336699);
    expect(schema.safeEncode(color).getOrThrow(), '#CC336699');
    expect(schema.safeEncode(const Color(0xFF336699)).getOrThrow(), '#336699');
  });

  test('color codec rejects malformed color strings', () {
    final result = colorCodec().safeParse('336699');

    expect(result.isFail, isTrue);
  });

  test('color channel bounds fail as constraint violations', () {
    final contract = mixProtocol;

    for (final color in [
      'rgb(999,0,0)',
      'rgb(-1,0,0)',
      'rgb(1000,0,0)',
      'rgba(0,0,0,1.5)',
      'rgba(0,0,0,-0.1)',
    ]) {
      final errors = _validationErrors(
        contract.decodeStyle<Object>({
          'v': 1,
          'type': 'box',
          'decoration': {'color': color},
        }),
      );
      final codes = errors.map((error) => error.code);

      expect(codes, contains(MixProtocolErrorCode.constraintViolation));
      expect(codes, isNot(contains(MixProtocolErrorCode.transformFailed)));
      expect(
        codes,
        isNot(contains(MixProtocolErrorCode.unsupportedEncodeValue)),
      );
    }
  });

  test('CSS color forms decode through the public contract', () {
    final contract = mixProtocol;
    final payload = {
      'v': 1,
      'type': 'box',
      'decoration': {'color': 'rgba(51, 102, 153, 0.8)'},
    };

    final box = switch (contract.decodeStyle<BoxStyler>(payload)) {
      MixProtocolSuccess<BoxStyler>(:final value) => value,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final encoded = switch (contract.encodeStyle(box)) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };

    expect(encoded, {
      'v': 1,
      'type': 'box',
      'decoration': {'color': '#CC336699'},
    });
  });

  test('alignment codec round-trips named and arbitrary alignments', () {
    final schema = alignmentCodec();
    final value = schema.safeParse({'x': -1, 'y': 0.5}).getOrThrow()!;

    expect(value, const Alignment(-1, 0.5));
    expect(schema.safeEncode(value).getOrThrow(), {'x': -1.0, 'y': 0.5});
    expect(schema.safeParse('center').getOrThrow(), Alignment.center);
    expect(schema.safeEncode(Alignment.center).getOrThrow(), 'center');
  });

  test(
    'edgeInsets codec supports scalar shorthand without defaulting sides',
    () {
      final schema = edgeInsetsCodec();
      final value = schema.safeParse({'top': 8}).getOrThrow()!;

      expect(singleValueProp(value.$top, 'top'), 8);
      expect(schema.safeEncode(value).getOrThrow(), {'top': 8.0});
      expect(
        singleValueProp(schema.safeParse(4).getOrThrow()!.$left, 'left'),
        4,
      );
      expect(schema.safeEncode(EdgeInsetsMix.all(4)).getOrThrow(), 4.0);
    },
  );

  test('wire enum codec rejects integer indexes', () {
    final schema = enumCodec({'clip': Clip.hardEdge});

    expect(schema.safeParse('clip').getOrThrow(), Clip.hardEdge);
    expect(schema.safeParse(0).isFail, isTrue);
  });

  test('directive table round-trips every core directive key', () {
    _expectDirectiveRoundTrip<Color>([
      const OpacityColorDirective(0.5),
      const WithValuesColorDirective(
        alpha: 0.8,
        red: 0.1,
        green: 0.2,
        blue: 0.3,
        colorSpace: ColorSpace.displayP3,
      ),
      const AlphaColorDirective(128),
      const DarkenColorDirective(8),
      const LightenColorDirective(9),
      const SaturateColorDirective(10),
      const DesaturateColorDirective(11),
      const TintColorDirective(12),
      const ShadeColorDirective(13),
      const BrightenColorDirective(14),
      const WithRedColorDirective(15),
      const WithGreenColorDirective(16),
      const WithBlueColorDirective(17),
    ]);
    _expectDirectiveRoundTrip<String>(const [
      UppercaseStringDirective(),
      LowercaseStringDirective(),
      CapitalizeStringDirective(),
      TitleCaseStringDirective(),
      SentenceCaseStringDirective(),
    ]);
    _expectDirectiveRoundTrip<num>([
      MultiplyNumberDirective(2),
      AddNumberDirective(3),
      SubtractNumberDirective(4),
      DivideNumberDirective(5),
      ClampNumberDirective(6, 7),
      const AbsNumberDirective(),
      const RoundNumberDirective(),
      const FloorNumberDirective(),
      const CeilNumberDirective(),
    ]);
  });

  test('box constraints preserve absent payload fields', () {
    final payload = _encodeBox(
      BoxStyler(constraints: BoxConstraintsMix.minWidth(12)),
    );

    expect(payload['constraints'], {'minWidth': 12.0});

    final constraints = _decodeBoxConstraints({
      'type': 'box',
      'constraints': {'minWidth': 12},
    });

    expect(singleValueProp(constraints.$minWidth, 'minWidth'), 12);
    expect(constraints.$maxWidth, isNull);
    expect(constraints.$minHeight, isNull);
    expect(constraints.$maxHeight, isNull);
  });

  test('box constraints support max-only and fixed dimensions', () {
    expect(
      _encodeBox(
        BoxStyler(constraints: BoxConstraintsMix.maxWidth(48)),
      )['constraints'],
      {'maxWidth': 48.0},
    );
    expect(
      _encodeBox(
        BoxStyler(constraints: BoxConstraintsMix.width(32)),
      )['constraints'],
      {'minWidth': 32.0, 'maxWidth': 32.0},
    );

    final constraints = _decodeBoxConstraints({
      'type': 'box',
      'constraints': {'minWidth': 32, 'maxWidth': 32},
    });

    expect(singleValueProp(constraints.$minWidth, 'minWidth'), 32);
    expect(singleValueProp(constraints.$maxWidth, 'maxWidth'), 32);
  });

  test('unbounded max constraints use infinity sentinel only when present', () {
    final payload = _encodeBox(
      BoxStyler(constraints: BoxConstraintsMix.maxWidth(double.infinity)),
    );

    expect(payload['constraints'], {'maxWidth': 'infinity'});

    final constraints = _decodeBoxConstraints({
      'type': 'box',
      'constraints': {'maxWidth': 'infinity', 'maxHeight': 'infinity'},
    });

    expect(singleValueProp(constraints.$maxWidth, 'maxWidth'), double.infinity);
    expect(
      singleValueProp(constraints.$maxHeight, 'maxHeight'),
      double.infinity,
    );
    expect(constraints.$minWidth, isNull);
    expect(constraints.$minHeight, isNull);
  });

  test('min constraints cannot decode to infinity', () {
    final result = mixProtocol.decodeStyle<BoxStyler>({
      'v': 1,
      'type': 'box',
      'constraints': {'minWidth': null},
    });

    expect(result, isA<MixProtocolFailure<BoxStyler>>());
  });

  test('box constraints reject invalid min and max ordering', () {
    final contract = mixProtocol;

    for (final constraints in [
      {'minWidth': 20, 'maxWidth': 10},
      {'minHeight': 20, 'maxHeight': 10},
    ]) {
      final errors = _validationErrors(
        contract.decodeStyle<Object>({
          'v': 1,
          'type': 'box',
          'constraints': constraints,
        }),
      );

      expect(
        errors.map((error) => error.code),
        contains(MixProtocolErrorCode.constraintViolation),
      );
    }
  });

  test('field-specific numeric bounds fail validation', () {
    final contract = mixProtocol;
    final cases = <String, JsonMap>{
      'text maxLines zero': {'type': 'text', 'maxLines': 0},
      'text maxLines negative': {'type': 'text', 'maxLines': -1},
      'default text maxLines zero': {
        'type': 'box',
        'modifiers': [
          {'type': 'default_text_style', 'maxLines': 0},
        ],
      },
      'aspect ratio zero': {
        'type': 'box',
        'modifiers': [
          {'type': 'aspect_ratio', 'aspectRatio': 0},
        ],
      },
      'aspect ratio negative': {
        'type': 'box',
        'modifiers': [
          {'type': 'aspect_ratio', 'aspectRatio': -1},
        ],
      },
      'flex negative': {
        'type': 'box',
        'modifiers': [
          {'type': 'flexible', 'flex': -1},
        ],
      },
      'modifier opacity negative': {
        'type': 'box',
        'modifiers': [
          {'type': 'opacity', 'opacity': -0.1},
        ],
      },
      'modifier opacity above one': {
        'type': 'box',
        'modifiers': [
          {'type': 'opacity', 'opacity': 1.1},
        ],
      },
      'icon opacity above one': {
        'type': 'icon',
        'icon': {'codePoint': 0xe88a, 'fontFamily': 'MaterialIcons'},
        'opacity': 1.1,
      },
      'icon theme opacity above one': {
        'type': 'box',
        'modifiers': [
          {'type': 'icon_theme', 'opacity': 1.1},
        ],
      },
    };

    for (final entry in cases.entries) {
      final errors = _validationErrors(
        contract.decodeStyle<Object>({'v': 1, ...entry.value}),
      );

      expect(
        errors.map((error) => error.code),
        contains(MixProtocolErrorCode.constraintViolation),
        reason: entry.key,
      );
    }
  });

  test('numeric lower-bound edges that are allowed still decode', () {
    final contract = mixProtocol;

    expect(
      contract.decodeStyle<Object>({
        'v': 1,
        'type': 'box',
        'modifiers': [
          {'type': 'flexible', 'flex': 0},
          {'type': 'opacity', 'opacity': 0},
        ],
      }),
      isA<MixProtocolSuccess<Object>>(),
    );
    expect(
      contract.decodeStyle<Object>({
        'v': 1,
        'type': 'box',
        'modifiers': [
          {'type': 'opacity', 'opacity': 1},
        ],
      }),
      isA<MixProtocolSuccess<Object>>(),
    );
  });

  test('multi-source props fail encode explicitly', () {
    final prop = Prop.value(1.0).mergeProp(Prop.value(2.0));

    expect(
      () => singleValueProp(prop, 'width'),
      throwsA(isA<UnsupportedEncodeValueError>()),
    );
  });
}

void _expectDirectiveRoundTrip<T extends Object>(
  List<Directive<T>> directives,
) {
  final encoded = encodeDirectiveList<T>(directives, 'field');
  final decoded = decodeDirectiveList<T>(encoded, 'field');

  expect(decoded, directives);
  expect(encodeDirectiveList<T>(decoded, 'field'), encoded);
}

List<MixProtocolError> _validationErrors(MixProtocolResult<Object> result) {
  return switch (result) {
    MixProtocolFailure<Object>(:final errors) => errors,
    MixProtocolSuccess<Object>() => fail('expected validation failure'),
  };
}

JsonMap _encodeBox(BoxStyler style) {
  final result = mixProtocol.encodeStyle(style);

  return switch (result) {
    MixProtocolSuccess<JsonMap>(:final value) => value,
    MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
  };
}

BoxConstraintsMix _decodeBoxConstraints(JsonMap payload) {
  final result = mixProtocol.decodeStyle<BoxStyler>({'v': 1, ...payload});
  final box = switch (result) {
    MixProtocolSuccess<BoxStyler>(:final value) => value,
    MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
  };

  return singleMixProp<BoxConstraintsMix, BoxConstraints>(
    box.$constraints,
    'constraints',
  )!;
}
