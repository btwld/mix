import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart'
    show
        MixSchemaContractBuilder,
        MixSchemaError,
        MixSchemaErrorCode,
        MixSchemaValidationFailure,
        MixSchemaValidationResult,
        MixSchemaValidationSuccess;
import 'package:mix_schema/src/errors/mix_schema_error.dart'
    show UnsupportedEncodeValueError;
import 'package:mix_schema/src/schema/common_codecs.dart';

void main() {
  test('R-4 numberAsDouble parses ints and encodes doubles', () {
    final schema = numberAsDoubleCodec();

    expect(schema.safeParse(2).getOrThrow(), 2.0);
    expect(schema.safeEncode(2.5).getOrThrow(), 2.5);
  });

  test(
    'R-4 color codec parses CSS-like input and encodes Ack canonical hex',
    () {
      final schema = colorCodec();

      final color = schema.safeParse('rgba(51, 102, 153, 0.8)').getOrThrow()!;

      expect(color.toARGB32(), 0xCC336699);
      expect(schema.safeEncode(color).getOrThrow(), '#CC336699');
      expect(
        schema.safeEncode(const Color(0xFF336699)).getOrThrow(),
        '#336699',
      );
    },
  );

  test('R-4 color codec rejects malformed color strings', () {
    final result = colorCodec().safeParse('336699');

    expect(result.isFail, isTrue);
  });

  test('R-7 color channel bounds fail as constraint violations', () {
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

  test('R-4 alignment codec round-trips named and arbitrary alignments', () {
    final schema = alignmentCodec();
    final value = schema.safeParse({'x': -1, 'y': 0.5}).getOrThrow()!;

    expect(value, const Alignment(-1, 0.5));
    expect(schema.safeEncode(value).getOrThrow(), {'x': -1.0, 'y': 0.5});
    expect(schema.safeParse('center').getOrThrow(), Alignment.center);
    expect(schema.safeEncode(Alignment.center).getOrThrow(), 'center');
  });

  test(
    'R-4 edgeInsets codec supports scalar shorthand without defaulting sides',
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

  test('R-4 strict string enum rejects integer indexes', () {
    final schema = strictEnumCodec({'clip': Clip.hardEdge});

    expect(schema.safeParse('clip').getOrThrow(), Clip.hardEdge);
    expect(schema.safeParse(0).isFail, isTrue);
  });

  test('R-5 token and multi-source props fail encode explicitly', () {
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
