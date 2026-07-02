import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart'
    show
        JsonMap,
        MixSchemaContractBuilder,
        MixSchemaDecodeFailure,
        MixSchemaDecodeSuccess,
        MixSchemaEncodeFailure,
        MixSchemaEncodeSuccess,
        MixSchemaError,
        MixSchemaErrorCode,
        MixSchemaValidationFailure,
        MixSchemaValidationResult,
        MixSchemaValidationSuccess;
import 'package:mix_schema/src/errors/mix_schema_error.dart'
    show UnsupportedEncodeValueError;
import 'package:mix_schema/src/schema/common_codecs.dart';

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
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    for (final color in [
      'rgb(999,0,0)',
      'rgb(-1,0,0)',
      'rgb(1000,0,0)',
      'rgba(0,0,0,1.5)',
      'rgba(0,0,0,-0.1)',
    ]) {
      final errors = _validationErrors(
        contract.validate({
          'type': 'box',
          'decoration': {'color': color},
        }),
      );
      final codes = errors.map((error) => error.code);

      expect(codes, contains(MixSchemaErrorCode.constraintViolation));
      expect(codes, isNot(contains(MixSchemaErrorCode.transformFailed)));
      expect(codes, isNot(contains(MixSchemaErrorCode.unsupportedEncodeValue)));
    }
  });

  test('CSS color forms decode through the public contract', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = {
      'type': 'box',
      'decoration': {'color': 'rgba(51, 102, 153, 0.8)'},
    };

    final box = switch (contract.decode<BoxStyler>(payload)) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final encoded = switch (contract.encode(box)) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
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
    final result = MixSchemaContractBuilder()
        .builtIn()
        .freeze()
        .decode<BoxStyler>({
          'type': 'box',
          'constraints': {'minWidth': null},
        });

    expect(result, isA<MixSchemaDecodeFailure<BoxStyler>>());
  });

  test('box constraints reject invalid min and max ordering', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    for (final constraints in [
      {'minWidth': 20, 'maxWidth': 10},
      {'minHeight': 20, 'maxHeight': 10},
    ]) {
      final errors = _validationErrors(
        contract.validate({'type': 'box', 'constraints': constraints}),
      );

      expect(
        errors.map((error) => error.code),
        contains(MixSchemaErrorCode.constraintViolation),
      );
    }
  });

  test('multi-source props fail encode explicitly', () {
    final prop = Prop.value(1.0).mergeProp(Prop.value(2.0));

    expect(
      () => singleValueProp(prop, 'width'),
      throwsA(isA<UnsupportedEncodeValueError>()),
    );
  });
}

List<MixSchemaError> _validationErrors(MixSchemaValidationResult result) {
  return switch (result) {
    MixSchemaValidationFailure(:final errors) => errors,
    MixSchemaValidationSuccess() => fail('expected validation failure'),
  };
}

JsonMap _encodeBox(BoxStyler style) {
  final result = MixSchemaContractBuilder().builtIn().freeze().encode(style);

  return switch (result) {
    MixSchemaEncodeSuccess(:final value) => value,
    MixSchemaEncodeFailure(:final errors) => fail('$errors'),
  };
}

BoxConstraintsMix _decodeBoxConstraints(JsonMap payload) {
  final result = MixSchemaContractBuilder()
      .builtIn()
      .freeze()
      .decode<BoxStyler>(payload);
  final box = switch (result) {
    MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
    MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
  };

  return singleMixProp<BoxConstraintsMix, BoxConstraints>(
    box.$constraints,
    'constraints',
  )!;
}
