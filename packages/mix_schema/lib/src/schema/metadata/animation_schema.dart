import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../contract/mix_schema_limits.dart';
import '../../registry/registry_catalog.dart';
import '../../registry/registry_value_codec.dart';

const Map<String, Curve> _curveByName = {
  'linear': Curves.linear,
  'ease': Curves.ease,
  'easeIn': Curves.easeIn,
  'easeOut': Curves.easeOut,
  'easeInOut': Curves.easeInOut,
  'decelerate': Curves.decelerate,
  'fastLinearToSlowEaseIn': Curves.fastLinearToSlowEaseIn,
  'fastEaseInToSlowEaseOut': Curves.fastEaseInToSlowEaseOut,
  'easeInToLinear': Curves.easeInToLinear,
  'easeInSine': Curves.easeInSine,
  'easeInQuad': Curves.easeInQuad,
  'easeInCubic': Curves.easeInCubic,
  'easeInQuart': Curves.easeInQuart,
  'easeInQuint': Curves.easeInQuint,
  'easeInExpo': Curves.easeInExpo,
  'easeInCirc': Curves.easeInCirc,
  'easeInBack': Curves.easeInBack,
  'linearToEaseOut': Curves.linearToEaseOut,
  'easeOutSine': Curves.easeOutSine,
  'easeOutQuad': Curves.easeOutQuad,
  'easeOutCubic': Curves.easeOutCubic,
  'easeOutQuart': Curves.easeOutQuart,
  'easeOutQuint': Curves.easeOutQuint,
  'easeOutExpo': Curves.easeOutExpo,
  'easeOutCirc': Curves.easeOutCirc,
  'easeOutBack': Curves.easeOutBack,
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

final Map<Curve, String> _curveNameByValue = {
  for (final entry in _curveByName.entries) entry.value: entry.key,
};

CodecSchema<String, VoidCallback> _buildOnEndCallbackCodec({
  required RegistryCatalog registries,
  required MixSchemaLimits limits,
}) {
  return registryValueCodec(
    registries: registries,
    scope: .animationOnEnd,
    limits: limits,
    valueLabel: 'VoidCallback',
  );
}

CodecSchema<JsonMap, CurveAnimationConfig> buildAnimationCodec(
  RegistryCatalog registries, {
  required MixSchemaLimits limits,
}) {
  return Ack.codec<JsonMap, JsonMap, CurveAnimationConfig>(
    input: Ack.object({
      'duration': Ack.integer().min(0),
      'curve': Ack.enumString(_curveByName.keys.toList(growable: false)),
      'delay': Ack.integer().min(0).optional(),
      'onEnd': _buildOnEndCallbackCodec(
        registries: registries,
        limits: limits,
      ).optional(),
    }),
    output: Ack.instance<CurveAnimationConfig>(),
    decode: (data) => CurveAnimationConfig(
      duration: Duration(milliseconds: data['duration']! as int),
      curve: _curveByName[data['curve']! as String]!,
      delay: Duration(milliseconds: (data['delay'] as int?) ?? 0),
      onEnd: data['onEnd'] as VoidCallback?,
    ),
    encode: (value) {
      final curveName = _curveNameByValue[value.curve];
      if (curveName == null) {
        throw ArgumentError('Curve is not supported by mix_schema.');
      }

      final payload = <String, Object?>{
        'duration': value.duration.inMilliseconds,
        'curve': curveName,
      };
      if (value.delay != .zero) {
        payload['delay'] = value.delay.inMilliseconds;
      }
      if (value.onEnd case final onEnd?) {
        payload['onEnd'] = onEnd;
      }

      return payload;
    },
  );
}
