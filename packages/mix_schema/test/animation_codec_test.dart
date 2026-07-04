import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  test('animation rejects callback ids in v1 wire', () {
    final decoded = MixSchemaContractBuilder()
        .builtIn()
        .freeze()
        .decode<BoxStyler>({
          'type': 'box',
          'animation': {
            'duration': 250,
            'delay': 50,
            'curve': 'easeInOut',
            'onEnd': 'done',
          },
        });

    final errors = switch (decoded) {
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => errors,
      MixSchemaDecodeSuccess<BoxStyler>() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixSchemaErrorCode.unknownField),
    );
    expect(errors.map((error) => error.path), contains('/animation/onEnd'));
  });

  test('animation delay defaults to zero on decode', () {
    final result = MixSchemaContractBuilder()
        .builtIn()
        .freeze()
        .decode<BoxStyler>({
          'type': 'box',
          'animation': {'duration': 250, 'curve': 'easeInOut'},
        });

    final style = switch (result) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final animation = style.$animation as CurveAnimationConfig;

    expect(animation.delay, Duration.zero);
  });

  test('animation duration and delay must be non-negative', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    for (final animation in [
      {'duration': -1, 'curve': 'easeInOut', 'delay': 0},
      {'duration': 250, 'curve': 'easeInOut', 'delay': -1},
    ]) {
      final result = contract.validate({'type': 'box', 'animation': animation});
      final errors = switch (result) {
        MixSchemaValidationFailure(:final errors) => errors,
        MixSchemaValidationSuccess() => fail('expected failure'),
      };

      expect(
        errors.map((error) => error.code),
        contains(MixSchemaErrorCode.constraintViolation),
      );
    }
  });

  test('animation encodes named curves without callbacks', () {
    final encoded = MixSchemaContractBuilder().builtIn().freeze().encode(
      BoxStyler(
        animation: CurveAnimationConfig.easeInOut(
          const Duration(milliseconds: 250),
          delay: const Duration(milliseconds: 50),
        ),
      ),
    );

    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'box',
      'animation': {'duration': 250, 'curve': 'easeInOut', 'delay': 50},
    });
  });

  test('spring animations round-trip physical parameters', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    final decoded = contract.decode<BoxStyler>({
      'type': 'box',
      'animation': {
        'spring': {'mass': 1.5, 'stiffness': 220, 'damping': 18},
      },
    });

    final decodedStyle = switch (decoded) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final animation = decodedStyle.$animation as SpringAnimationConfig;

    expect(animation.spring.mass, 1.5);
    expect(animation.spring.stiffness, 220);
    expect(animation.spring.damping, 18);

    final encoded = contract.encode(
      BoxStyler(
        animation: SpringAnimationConfig(
          spring: const SpringDescription(
            mass: 1.5,
            stiffness: 220,
            damping: 18,
          ),
        ),
      ),
    );

    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'box',
      'animation': {
        'spring': {'mass': 1.5, 'stiffness': 220.0, 'damping': 18.0},
      },
    });
  });

  test('cubic curves round-trip explicit control points', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final encoded = contract.encode(
      BoxStyler(
        animation: const CurveAnimationConfig(
          duration: Duration(milliseconds: 250),
          curve: Cubic(0.1, 0.2, 0.3, 0.4),
        ),
      ),
    );

    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'box',
      'animation': {
        'duration': 250,
        'curve': {
          'cubic': [0.1, 0.2, 0.3, 0.4],
        },
        'delay': 0,
      },
    });

    final decoded = contract.decode<BoxStyler>(payload);
    final style = switch (decoded) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final animation = style.$animation as CurveAnimationConfig;
    final curve = animation.curve as Cubic;

    expect(curve.a, 0.1);
    expect(curve.b, 0.2);
    expect(curve.c, 0.3);
    expect(curve.d, 0.4);
  });

  test('unsupported curve subclasses fail encode explicitly', () {
    final result = MixSchemaContractBuilder().builtIn().freeze().encode(
      BoxStyler(
        animation: const CurveAnimationConfig(
          duration: Duration(milliseconds: 250),
          curve: _CustomCurve(),
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

  test('phase animation configs fail encode explicitly', () {
    final result = MixSchemaContractBuilder().builtIn().freeze().encode(
      const BoxStyler.create(
        animation: PhaseAnimationConfig<BoxSpec, BoxStyler>(
          styles: [BoxStyler.create()],
          curveConfigs: [
            CurveAnimationConfig.linear(Duration(milliseconds: 250)),
          ],
          trigger: null,
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

  test('keyframe animation configs fail encode explicitly', () {
    final result = MixSchemaContractBuilder().builtIn().freeze().encode(
      BoxStyler.create(
        animation: KeyframeAnimationConfig<BoxSpec>(
          trigger: null,
          timeline: [
            KeyframeTrack<double>('opacity', [
              const Keyframe.linear(1.0, Duration(milliseconds: 250)),
            ], initial: 0.0),
          ],
          styleBuilder: (result, style) => style,
          initialStyle: const BoxStyler.create(),
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

  test('animation callbacks fail encode instead of serializing closures', () {
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
      contains(MixSchemaErrorCode.unsupportedEncodeValue),
    );
  });
}

final class _CustomCurve extends Curve {
  const _CustomCurve();

  @override
  double transform(double t) => t;
}
