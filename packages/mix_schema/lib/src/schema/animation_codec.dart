import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import '../registry/registry.dart';
import '../registry/registry_value_codec.dart';
import 'common_codecs.dart';

AckSchema<Object, AnimationConfig> animationConfigCodec({
  required FrozenRegistry Function() registry,
}) {
  return Ack.object({
        'type': Ack.literal('curve').optional(),
        'spring': Ack.object({
          'mass': _positiveDoubleCodec(),
          'stiffness': _positiveDoubleCodec(),
          'damping': nonNegativeDoubleCodec(),
        }).optional(),
        'duration': _durationCodec().optional(),
        'curve': curveCodec().optional(),
        'delay': _durationCodec().optional(),
        'onEnd': registryValueCodec<VoidCallback>(
          registry,
          MixSchemaScope.animationOnEnd,
        ).optional(),
      })
      .refine(
        _hasValidAnimationShape,
        message:
            'Animation payloads must contain either spring or duration and curve.',
      )
      .codec<AnimationConfig>(
        decode: _decodeAnimationConfig,
        encode: _encodeAnimationConfig,
      );
}

CodecSchema<Object, Curve> curveCodec() {
  return Ack.codec<Object, Object, Curve>(
    input: Ack.anyOf([
      Ack.enumString(_namedCurves.keys.toList(growable: false)),
      Ack.object({'cubic': Ack.list(numberAsDoubleCodec()).length(4)}),
    ]),
    decode: _decodeCurve,
    encode: _encodeCurve,
  );
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

AnimationConfig _decodeAnimationConfig(Object value) {
  final data = value as JsonMap;
  final spring = data['spring'];

  if (spring != null) {
    final springData = spring as JsonMap;

    return SpringAnimationConfig(
      spring: SpringDescription(
        mass: springData['mass']! as double,
        stiffness: springData['stiffness']! as double,
        damping: springData['damping']! as double,
      ),
      onEnd: data['onEnd'] as VoidCallback?,
    );
  }

  return CurveAnimationConfig(
    duration: data['duration']! as Duration,
    curve: data['curve']! as Curve,
    delay: data['delay'] as Duration? ?? Duration.zero,
    onEnd: data['onEnd'] as VoidCallback?,
  );
}

bool _hasValidAnimationShape(JsonMap data) {
  final hasSpring = data['spring'] != null;
  final hasCurve = data['curve'] != null;
  final hasDuration = data['duration'] != null;
  final hasCurveOnlyField =
      hasCurve || hasDuration || data['delay'] != null || data['type'] != null;

  if (hasSpring) return !hasCurveOnlyField;

  return hasCurve && hasDuration;
}

Curve _decodeCurve(Object value) {
  if (value is String) return _namedCurves[value]!;

  final data = value as JsonMap;
  final values = (data['cubic']! as List).cast<double>();

  return Cubic(values[0], values[1], values[2], values[3]);
}

JsonMap _encodeAnimationConfig(AnimationConfig value) {
  return switch (value) {
    CurveAnimationConfig() => _encodeCurveAnimationConfig(value),
    SpringAnimationConfig() => {
      'spring': {
        'mass': value.spring.mass,
        'stiffness': value.spring.stiffness,
        'damping': value.spring.damping,
      },
      'onEnd': value.onEnd,
    },
    _ => throw UnsupportedEncodeValueError(
      value,
      'Only CurveAnimationConfig and SpringAnimationConfig are representable.',
    ),
  };
}

JsonMap _encodeCurveAnimationConfig(CurveAnimationConfig value) {
  return {
    'duration': value.duration,
    'curve': value.curve,
    'delay': value.delay,
    'onEnd': value.onEnd,
  };
}

Object _encodeCurve(Curve value) {
  final named = _namedCurveWire(value);
  if (named != null) return named;

  return switch (value) {
    Cubic(:final a, :final b, :final c, :final d) => {
      'cubic': [a, b, c, d],
    },
    _ => throw UnsupportedEncodeValueError(
      value,
      'Only named curves and Cubic curves are representable.',
    ),
  };
}

Object _encodeDuration(Duration value) {
  final token = tokenFromReference<Duration>(value);
  if (token != null) return value;

  return value.inMilliseconds;
}

CodecSchema<num, double> _positiveDoubleCodec() {
  return Ack.number()
      .greaterThan(0)
      .codec<double>(
        decode: (value) => value.toDouble(),
        encode: (value) => value,
      );
}

String? _namedCurveWire(Curve value) {
  for (final entry in _namedCurves.entries) {
    if (entry.value == value) return entry.key;
  }

  return null;
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
