import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  test('animation decodes registry-backed onEnd callbacks', () {
    void onEnd() {}
    final builder = MixSchemaContractBuilder();
    builder.registry.animationOnEnd('done', onEnd);
    final contract = builder.builtIn().freeze();

    final decoded = contract.decode<BoxStyler>({
      'type': 'box',
      'animation': {
        'duration': 250,
        'delay': 50,
        'curve': 'easeInOut',
        'onEnd': 'done',
      },
    });

    final style = switch (decoded) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final animation = style.$animation as CurveAnimationConfig;

    expect(animation.duration, const Duration(milliseconds: 250));
    expect(animation.delay, const Duration(milliseconds: 50));
    expect(animation.curve, Curves.easeInOut);
    expect(animation.onEnd, same(onEnd));
  });

  test('animation delay is explicit and not defaulted', () {
    final result = MixSchemaContractBuilder().builtIn().freeze().validate({
      'type': 'box',
      'animation': {'duration': 250, 'curve': 'easeInOut'},
    });

    final errors = switch (result) {
      MixSchemaValidationFailure(:final errors) => errors,
      MixSchemaValidationSuccess() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixSchemaErrorCode.requiredField),
    );
  });

  test('animation encodes named curves and registry callbacks', () {
    void onEnd() {}
    final builder = MixSchemaContractBuilder();
    builder.registry.animationOnEnd('done', onEnd);
    final contract = builder.builtIn().freeze();

    final encoded = contract.encode(
      BoxStyler(
        animation: CurveAnimationConfig.easeInOut(
          const Duration(milliseconds: 250),
          delay: const Duration(milliseconds: 50),
          onEnd: onEnd,
        ),
      ),
    );

    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'type': 'box',
      'animation': {
        'duration': 250,
        'curve': 'easeInOut',
        'delay': 50,
        'onEnd': 'done',
      },
    });
  });

  test('spring animations fail encode explicitly', () {
    final result = MixSchemaContractBuilder().builtIn().freeze().encode(
      BoxStyler(
        animation: AnimationConfig.spring(const Duration(milliseconds: 250)),
      ),
    );

    final errors = switch (result) {
      MixSchemaEncodeFailure(:final errors) => errors,
      MixSchemaEncodeSuccess() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixSchemaErrorCode.unsupportedEncodeValue),
    );
  });

  test('arbitrary curves fail encode explicitly', () {
    final result = MixSchemaContractBuilder().builtIn().freeze().encode(
      BoxStyler(
        animation: const CurveAnimationConfig(
          duration: Duration(milliseconds: 250),
          curve: Cubic(0.1, 0.2, 0.3, 0.4),
        ),
      ),
    );

    final errors = switch (result) {
      MixSchemaEncodeFailure(:final errors) => errors,
      MixSchemaEncodeSuccess() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixSchemaErrorCode.unsupportedEncodeValue),
    );
  });

  test('unregistered animation callbacks do not serialize closures', () {
    void onEnd() {}
    final result = MixSchemaContractBuilder().builtIn().freeze().encode(
      BoxStyler(
        animation: CurveAnimationConfig.linear(
          const Duration(milliseconds: 250),
          onEnd: onEnd,
        ),
      ),
    );

    final errors = switch (result) {
      MixSchemaEncodeFailure(:final errors) => errors,
      MixSchemaEncodeSuccess() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixSchemaErrorCode.unknownRegistryValue),
    );
  });
}
