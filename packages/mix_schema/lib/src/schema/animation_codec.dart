import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import '../registry/registry.dart';
import '../registry/registry_value_codec.dart';
import 'common_codecs.dart';

AckSchema<JsonMap, AnimationConfig> animationConfigCodec({
  required FrozenRegistry Function() registry,
}) {
  return Ack.object({
    'duration': _durationCodec(),
    'curve': curveCodec(),
    'delay': _durationCodec(),
    'onEnd': registryValueCodec<VoidCallback>(
      registry,
      MixSchemaScope.animationOnEnd,
    ).optional(),
  }).codec<AnimationConfig>(
    decode: (data) => CurveAnimationConfig(
      duration: data['duration']! as Duration,
      curve: data['curve']! as Curve,
      delay: data['delay']! as Duration,
      onEnd: data['onEnd'] as VoidCallback?,
    ),
    encode: _encodeAnimationConfig,
  );
}

CodecSchema<String, Curve> curveCodec() {
  return enumCodec(_namedCurves, debugName: 'Curve');
}

CodecSchema<Object, Duration> _durationCodec() {
  return Ack.codec<Object, Object, Duration>(
    input: Ack.anyOf([
      tokenReferenceCodec<Duration, Duration>(
        decodeToken: (data) =>
            DurationToken(data[tokenReferenceKey]! as String),
        reference: (token) => token(),
      ),
      Ack.integer().min(0),
    ]),
    decode: (value) {
      if (value is int) return Duration(milliseconds: value);

      return value as Duration;
    },
    encode: _encodeDuration,
  );
}

JsonMap _encodeAnimationConfig(AnimationConfig value) {
  if (value is! CurveAnimationConfig) {
    throw UnsupportedEncodeValueError(
      value,
      'Only CurveAnimationConfig is representable.',
    );
  }

  return {
    'duration': value.duration,
    'curve': value.curve,
    'delay': value.delay,
    'onEnd': value.onEnd,
  };
}

Object _encodeDuration(Duration value) {
  final token = tokenFromReference<Duration>(value);
  if (token != null) return value;

  return value.inMilliseconds;
}

const _namedCurves = <String, Curve>{
  'linear': Curves.linear,
  'decelerate': Curves.decelerate,
  'fastLinearToSlowEaseIn': Curves.fastLinearToSlowEaseIn,
  'fastEaseInToSlowEaseOut': Curves.fastEaseInToSlowEaseOut,
  'ease': Curves.ease,
  'easeIn': Curves.easeIn,
  'easeInToLinear': Curves.easeInToLinear,
  'easeInSine': Curves.easeInSine,
  'easeInQuad': Curves.easeInQuad,
  'easeInCubic': Curves.easeInCubic,
  'easeInQuart': Curves.easeInQuart,
  'easeInQuint': Curves.easeInQuint,
  'easeInExpo': Curves.easeInExpo,
  'easeInCirc': Curves.easeInCirc,
  'easeInBack': Curves.easeInBack,
  'easeOut': Curves.easeOut,
  'linearToEaseOut': Curves.linearToEaseOut,
  'easeOutSine': Curves.easeOutSine,
  'easeOutQuad': Curves.easeOutQuad,
  'easeOutCubic': Curves.easeOutCubic,
  'easeOutQuart': Curves.easeOutQuart,
  'easeOutQuint': Curves.easeOutQuint,
  'easeOutExpo': Curves.easeOutExpo,
  'easeOutCirc': Curves.easeOutCirc,
  'easeOutBack': Curves.easeOutBack,
  'easeInOut': Curves.easeInOut,
  'easeInOutSine': Curves.easeInOutSine,
  'easeInOutQuad': Curves.easeInOutQuad,
  'easeInOutCubic': Curves.easeInOutCubic,
  'easeInOutCubicEmphasized': Curves.easeInOutCubicEmphasized,
  'easeInOutQuart': Curves.easeInOutQuart,
  'easeInOutQuint': Curves.easeInOutQuint,
  'easeInOutExpo': Curves.easeInOutExpo,
  'easeInOutCirc': Curves.easeInOutCirc,
  'easeInOutBack': Curves.easeInOutBack,
  'fastOutSlowIn': Curves.fastOutSlowIn,
  'slowMiddle': Curves.slowMiddle,
  'bounceIn': Curves.bounceIn,
  'bounceOut': Curves.bounceOut,
  'bounceInOut': Curves.bounceInOut,
  'elasticIn': Curves.elasticIn,
  'elasticOut': Curves.elasticOut,
  'elasticInOut': Curves.elasticInOut,
};
