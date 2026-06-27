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
    'duration': _durationMillisCodec(),
    'curve': curveCodec(),
    'delay': _durationMillisCodec(),
    'onEnd': registryValueCodec<VoidCallback>(
      registry,
      MixSchemaScope.animationOnEnd,
    ).optional(),
  }).codec<AnimationConfig>(
    decode: (data) => CurveAnimationConfig(
      duration: Duration(milliseconds: data['duration']! as int),
      curve: data['curve']! as Curve,
      delay: Duration(milliseconds: data['delay']! as int),
      onEnd: data['onEnd'] as VoidCallback?,
    ),
    encode: _encodeAnimationConfig,
  );
}

CodecSchema<String, Curve> curveCodec() {
  return enumCodec(_namedCurves, debugName: 'Curve');
}

AckSchema<int, int> _durationMillisCodec() {
  return Ack.integer().min(0);
}

JsonMap _encodeAnimationConfig(AnimationConfig value) {
  if (value is! CurveAnimationConfig) {
    throw UnsupportedEncodeValueError(
      value,
      'Only CurveAnimationConfig is representable.',
    );
  }

  return {
    'duration': value.duration.inMilliseconds,
    'curve': value.curve,
    'delay': value.delay.inMilliseconds,
    'onEnd': value.onEnd,
  };
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
