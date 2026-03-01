import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  const codec = MixSchemaCodec();

  group('MixSchemaCodec decode', () {
    test('decodes box payload with registry-backed animation callback', () {
      final registryBuilder = RegistryBundleBuilder();
      VoidCallback? callbackTriggered;
      void onEnd() {
        callbackTriggered = () {};
      }

      registryBuilder.animationOnEnd.register('anim_done', onEnd);
      final registries = registryBuilder.freeze();

      final payload = <String, Object?>{
        'schemaVersion': 1,
        'stylerType': 'box',
        'data': <String, Object?>{
          'clipBehavior': 'hardEdge',
          'animation': <String, Object?>{
            'durationMs': 200,
            'curve': 'easeIn',
            'onEnd': 'anim_done',
          },
        },
      };

      final result = codec.decode(payload, registries: registries);
      expect(result, isA<MixSchemaSuccess<DecodedStyler>>());

      final success = result as MixSchemaSuccess<DecodedStyler>;
      final box = success.value.boxStyler!;
      expect(success.value.stylerType, StylerType.box);

      final animation = box.$animation;
      expect(animation, isA<CurveAnimationConfig>());

      final curveAnimation = animation! as CurveAnimationConfig;
      expect(curveAnimation.duration, const Duration(milliseconds: 200));
      expect(curveAnimation.curve, Curves.easeIn);
      expect(identical(curveAnimation.onEnd, onEnd), isTrue);

      curveAnimation.onEnd?.call();
      expect(callbackTriggered, isNotNull);
    });

    test('returns unknown_field for nested extra keys with dot paths', () {
      final payload = <String, Object?>{
        'schemaVersion': 1,
        'stylerType': 'box',
        'data': <String, Object?>{
          'animation': <String, Object?>{
            'durationMs': 100,
            'curve': 'linear',
            'extra': true,
          },
        },
      };

      final result = codec.decode(
        payload,
        registries: FrozenRegistryBundle.empty(),
      );
      expect(result, isA<MixSchemaFailure<DecodedStyler>>());

      final failure = result as MixSchemaFailure<DecodedStyler>;
      expect(failure.errors.first.code, 'unknown_field');
      expect(failure.errors.first.path, 'data.animation.extra');
    });

    test('returns unsupported_schema_version with schemaVersion path', () {
      final payload = <String, Object?>{
        'schemaVersion': 2,
        'stylerType': 'box',
        'data': <String, Object?>{},
      };

      final result = codec.decode(
        payload,
        registries: FrozenRegistryBundle.empty(),
      );
      expect(result, isA<MixSchemaFailure<DecodedStyler>>());

      final failure = result as MixSchemaFailure<DecodedStyler>;
      expect(
        failure.errors.any(
          (error) =>
              error.code == 'unsupported_schema_version' &&
              error.path == 'schemaVersion' &&
              error.value == 2,
        ),
        isTrue,
      );
    });

    test('returns unknown_registry_id for missing decode mapping', () {
      final payload = <String, Object?>{
        'schemaVersion': 1,
        'stylerType': 'box',
        'data': <String, Object?>{
          'animation': <String, Object?>{
            'durationMs': 120,
            'curve': 'linear',
            'onEnd': 'missing_callback',
          },
        },
      };

      final result = codec.decode(
        payload,
        registries: FrozenRegistryBundle.empty(),
      );
      expect(result, isA<MixSchemaFailure<DecodedStyler>>());

      final failure = result as MixSchemaFailure<DecodedStyler>;
      expect(
        failure.errors.any(
          (error) =>
              error.code == 'unknown_registry_id' &&
              error.path == 'data.animation.onEnd' &&
              error.value == 'missing_callback',
        ),
        isTrue,
      );
    });

    test('sorts errors by path then code', () {
      final payload = <String, Object?>{
        'schemaVersion': 1,
        'stylerType': 'box',
        'data': <String, Object?>{'z': true, 'a': 1},
      };

      final result = codec.decode(
        payload,
        registries: FrozenRegistryBundle.empty(),
      );
      expect(result, isA<MixSchemaFailure<DecodedStyler>>());

      final failure = result as MixSchemaFailure<DecodedStyler>;
      expect(failure.errors.length, greaterThanOrEqualTo(2));
      expect(failure.errors[0].path, 'data.a');
      expect(failure.errors[1].path, 'data.z');
    });
  });

  group('MixSchemaCodec encode', () {
    test('encodes box payload with canonical omission of null optionals', () {
      final result = codec.encodeBox(
        BoxStyler(clipBehavior: Clip.hardEdge),
        registries: FrozenRegistryBundle.empty(),
      );
      expect(result, isA<MixSchemaSuccess<Map<String, Object?>>>());

      final payload = (result as MixSchemaSuccess<Map<String, Object?>>).value;
      expect(payload['schemaVersion'], 1);
      expect(payload['stylerType'], 'box');
      expect(payload['data'], <String, Object?>{'clipBehavior': 'hardEdge'});
    });

    test(
      'returns unknown_registry_id for missing encode mapping of animation onEnd',
      () {
        void onEnd() {}

        final style = BoxStyler(
          animation: AnimationConfig.curve(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeIn,
            onEnd: onEnd,
          ),
        );

        final result = codec.encodeBox(
          style,
          registries: FrozenRegistryBundle.empty(),
        );
        expect(result, isA<MixSchemaFailure<Map<String, Object?>>>());

        final failure = result as MixSchemaFailure<Map<String, Object?>>;
        expect(
          failure.errors.any(
            (error) =>
                error.code == 'unknown_registry_id' &&
                error.path == 'data.animation.onEnd',
          ),
          isTrue,
        );
      },
    );
  });
}
