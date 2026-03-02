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
          'alignment': <String, Object?>{
            'kind': 'alignment',
            'x': 0.25,
            'y': -0.5,
          },
          'transform': <Object?>[
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0,
            8.0,
            12.0,
            0.0,
            1.0,
          ],
          'transformAlignment': <String, Object?>{
            'kind': 'alignmentDirectional',
            'start': 1.0,
            'y': -1.0,
          },
          'padding': <String, Object?>{
            'kind': 'edgeInsets',
            'left': 8.0,
            'top': 12.0,
            'right': 8.0,
            'bottom': 12.0,
          },
          'margin': <String, Object?>{
            'kind': 'edgeInsetsDirectional',
            'start': 2.0,
            'top': 1.0,
            'end': 2.0,
            'bottom': 1.0,
          },
          'constraints': <String, Object?>{'minWidth': 10.0, 'maxWidth': 100.0},
          'decoration': <String, Object?>{
            'kind': 'boxDecoration',
            'color': 0xFFFF0000,
            'shape': 'rectangle',
            'backgroundBlendMode': 'srcOver',
          },
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
      expect(box.$alignment, isNotNull);
      expect(box.$transform, isNotNull);
      expect(box.$transformAlignment, isNotNull);
      expect(box.$padding, isNotNull);
      expect(box.$margin, isNotNull);
      expect(box.$constraints, isNotNull);
      expect(box.$decoration, isNotNull);

      final animation = box.$animation;
      expect(animation, isA<CurveAnimationConfig>());

      final curveAnimation = animation! as CurveAnimationConfig;
      expect(curveAnimation.duration, const Duration(milliseconds: 200));
      expect(curveAnimation.curve, Curves.easeIn);
      expect(identical(curveAnimation.onEnd, onEnd), isTrue);

      curveAnimation.onEnd?.call();
      expect(callbackTriggered, isNotNull);

      final encodeResult = codec.encode(success.value, registries: registries);
      expect(encodeResult, isA<MixSchemaSuccess<Map<String, Object?>>>());

      final encodedPayload =
          (encodeResult as MixSchemaSuccess<Map<String, Object?>>).value;
      final encodedData = encodedPayload['data'] as Map<String, Object?>;
      final sourceData = payload['data'] as Map<String, Object?>;
      expect(encodedData['alignment'], sourceData['alignment']);
      expect(encodedData['transform'], sourceData['transform']);
      expect(
        encodedData['transformAlignment'],
        sourceData['transformAlignment'],
      );
      expect(encodedData['padding'], sourceData['padding']);
      expect(encodedData['margin'], sourceData['margin']);
      expect(encodedData['constraints'], sourceData['constraints']);
      expect(encodedData['decoration'], sourceData['decoration']);
    });

    test('returns invalid_value when box decoration image is provided', () {
      final payload = <String, Object?>{
        'schemaVersion': 1,
        'stylerType': 'box',
        'data': <String, Object?>{
          'decoration': <String, Object?>{
            'kind': 'boxDecoration',
            'image': <String, Object?>{'provider': 'asset'},
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
              error.code == 'invalid_value' && error.path == 'data.decoration',
        ),
        isTrue,
      );
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

    test('decodes and encodes v1 variants and modifiers subset', () {
      final registryBuilder = RegistryBundleBuilder();
      final shaderCallback = (Rect bounds) {
        return const LinearGradient(
          colors: [Color(0xFF112233), Color(0xFF445566)],
        ).createShader(bounds);
      };
      const clipPath = _TestPathClipper();
      const clipRRect = _TestRRectClipper();
      BoxStyler contextBuilder(BuildContext context) {
        return BoxStyler().color(const Color(0xFFABCDEF));
      }

      registryBuilder.modifierShader.register('shader_primary', shaderCallback);
      registryBuilder.modifierClipper.register('clip_path_primary', clipPath);
      registryBuilder.modifierClipper.register('clip_rrect_primary', clipRRect);
      registryBuilder.contextVariantBuilder.register(
        'ctx_variant_primary',
        contextBuilder,
      );
      final registries = registryBuilder.freeze();

      final payload = <String, Object?>{
        'schemaVersion': 1,
        'stylerType': 'box',
        'data': <String, Object?>{
          'modifier': <String, Object?>{
            'orderOfModifiers': <Object?>[
              'padding',
              'shaderMask',
              'clipPath',
              'clipRRect',
              'opacity',
            ],
            'modifiers': <Object?>[
              <String, Object?>{
                'kind': 'padding',
                'padding': <String, Object?>{
                  'kind': 'edgeInsets',
                  'left': 4.0,
                  'top': 2.0,
                },
              },
              <String, Object?>{
                'kind': 'shaderMask',
                'shaderCallback': 'shader_primary',
                'blendMode': 'srcOver',
              },
              <String, Object?>{
                'kind': 'clipPath',
                'clipper': 'clip_path_primary',
                'clipBehavior': 'antiAlias',
              },
              <String, Object?>{
                'kind': 'clipRRect',
                'borderRadius': <String, Object?>{
                  'kind': 'borderRadius',
                  'topLeft': <String, Object?>{'x': 8.0, 'y': 8.0},
                },
                'clipper': 'clip_rrect_primary',
                'clipBehavior': 'hardEdge',
              },
              <String, Object?>{'kind': 'opacity', 'opacity': 0.5},
              <String, Object?>{'kind': 'reset'},
            ],
          },
          'variants': <Object?>[
            <String, Object?>{
              'kind': 'named',
              'name': 'primary',
              'style': <String, Object?>{
                'padding': <String, Object?>{
                  'kind': 'edgeInsets',
                  'left': 10.0,
                  'top': 6.0,
                },
              },
            },
            <String, Object?>{
              'kind': 'widgetState',
              'state': 'hovered',
              'style': <String, Object?>{'clipBehavior': 'antiAlias'},
            },
            <String, Object?>{
              'kind': 'contextVariantBuilder',
              'fn': 'ctx_variant_primary',
            },
          ],
        },
      };

      final decodeResult = codec.decode(payload, registries: registries);
      expect(decodeResult, isA<MixSchemaSuccess<DecodedStyler>>());

      final decoded = (decodeResult as MixSchemaSuccess<DecodedStyler>).value;
      final encodeResult = codec.encode(decoded, registries: registries);
      expect(encodeResult, isA<MixSchemaSuccess<Map<String, Object?>>>());

      final encodedPayload =
          (encodeResult as MixSchemaSuccess<Map<String, Object?>>).value;
      final sourceData = payload['data'] as Map<String, Object?>;
      final encodedData = encodedPayload['data'] as Map<String, Object?>;

      expect(encodedData['modifier'], sourceData['modifier']);
      expect(encodedData['variants'], sourceData['variants']);
    });

    test('aggregates unknown_registry_id errors for metadata decode', () {
      final payload = <String, Object?>{
        'schemaVersion': 1,
        'stylerType': 'box',
        'data': <String, Object?>{
          'modifier': <String, Object?>{
            'modifiers': <Object?>[
              <String, Object?>{
                'kind': 'shaderMask',
                'shaderCallback': 'missing_shader',
              },
            ],
          },
          'variants': <Object?>[
            <String, Object?>{
              'kind': 'contextVariantBuilder',
              'fn': 'missing_builder',
            },
          ],
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
              error.path == 'data.modifier.modifiers[0].shaderCallback' &&
              error.value == 'missing_shader',
        ),
        isTrue,
      );
      expect(
        failure.errors.any(
          (error) =>
              error.code == 'unknown_registry_id' &&
              error.path == 'data.variants[0].fn' &&
              error.value == 'missing_builder',
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

    test(
      'returns invalid_value when clipper resolves to incompatible type',
      () {
        final registryBuilder = RegistryBundleBuilder();
        // Register an RRect clipper, but the payload uses clipOval which expects Rect
        registryBuilder.modifierClipper.register(
          'wrong_type_clipper',
          const _TestRRectClipper(),
        );
        final registries = registryBuilder.freeze();

        final payload = <String, Object?>{
          'schemaVersion': 1,
          'stylerType': 'box',
          'data': <String, Object?>{
            'modifier': <String, Object?>{
              'modifiers': <Object?>[
                <String, Object?>{
                  'kind': 'clipOval',
                  'clipper': 'wrong_type_clipper',
                },
              ],
            },
          },
        };

        final result = codec.decode(payload, registries: registries);
        expect(result, isA<MixSchemaFailure<DecodedStyler>>());

        final failure = result as MixSchemaFailure<DecodedStyler>;
        expect(
          failure.errors.any(
            (error) =>
                error.code == 'invalid_value' &&
                error.path == 'data.modifier.modifiers[0].clipper' &&
                error.value == 'wrong_type_clipper',
          ),
          isTrue,
        );
      },
    );

    test(
      'returns invalid_value when context variant builder resolves to incompatible type',
      () {
        final registryBuilder = RegistryBundleBuilder();
        // Register a function with wrong return type (String instead of BoxStyler)
        String wrongBuilder(BuildContext context) => 'not a styler';
        registryBuilder.contextVariantBuilder.register(
          'wrong_type_builder',
          wrongBuilder,
        );
        final registries = registryBuilder.freeze();

        final payload = <String, Object?>{
          'schemaVersion': 1,
          'stylerType': 'box',
          'data': <String, Object?>{
            'variants': <Object?>[
              <String, Object?>{
                'kind': 'contextVariantBuilder',
                'fn': 'wrong_type_builder',
              },
            ],
          },
        };

        final result = codec.decode(payload, registries: registries);
        expect(result, isA<MixSchemaFailure<DecodedStyler>>());

        final failure = result as MixSchemaFailure<DecodedStyler>;
        expect(
          failure.errors.any(
            (error) =>
                error.code == 'invalid_value' &&
                error.path == 'data.variants[0].fn' &&
                error.value == 'wrong_type_builder',
          ),
          isTrue,
        );
      },
    );

    test('returns unknown_field for nested extra key in padding dto', () {
      final payload = <String, Object?>{
        'schemaVersion': 1,
        'stylerType': 'box',
        'data': <String, Object?>{
          'padding': <String, Object?>{
            'kind': 'edgeInsets',
            'left': 4.0,
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
      expect(
        failure.errors.any(
          (error) =>
              error.code == 'unknown_field' &&
              error.path == 'data.padding.extra',
        ),
        isTrue,
      );
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

    test(
      'returns unknown_registry_id for missing encode mapping of modifier shader callback',
      () {
        final shaderCallback = (Rect bounds) {
          return const LinearGradient(
            colors: [Color(0xFF000000), Color(0xFFFFFFFF)],
          ).createShader(bounds);
        };

        final style = BoxStyler(
          modifier: WidgetModifierConfig.modifier(
            ShaderMaskModifierMix(shaderCallback: shaderCallback),
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
                error.path == 'data.modifier.modifiers[0].shaderCallback',
          ),
          isTrue,
        );
      },
    );

    test(
      'returns unknown_registry_id for missing encode mapping of context variant builder',
      () {
        BoxStyler contextBuilder(BuildContext context) {
          return BoxStyler().color(const Color(0xFFAA5500));
        }

        final style = BoxStyler(
          variants: [
            VariantStyle<BoxSpec>(
              ContextVariantBuilder<BoxStyler>(contextBuilder),
              BoxStyler(),
            ),
          ],
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
                error.path == 'data.variants[0].fn',
          ),
          isTrue,
        );
      },
    );

    test(
      'returns unknown_registry_id for missing encode mapping of modifier clipper',
      () {
        const clipper = _TestRectClipper();
        final style = BoxStyler(
          modifier: WidgetModifierConfig.modifier(
            ClipOvalModifierMix(clipper: clipper),
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
                error.path == 'data.modifier.modifiers[0].clipper',
          ),
          isTrue,
        );
      },
    );
  });
}

class _TestRectClipper extends CustomClipper<Rect> {
  const _TestRectClipper();

  @override
  Rect getClip(Size size) => Offset.zero & size;

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}

class _TestPathClipper extends CustomClipper<Path> {
  const _TestPathClipper();

  @override
  Path getClip(Size size) {
    return Path()..addRect(Offset.zero & size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _TestRRectClipper extends CustomClipper<RRect> {
  const _TestRRectClipper();

  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(8.0),
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}
