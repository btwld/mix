import 'package:ack/ack.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../errors/mix_protocol_error.dart';
import 'common_codecs.dart';
import 'primitive_wire.dart';
import 'wire_discriminators.dart';

AckSchema<JsonMap, VariantStyle<S>> variantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.discriminated<VariantStyle<S>>(
    discriminatorKey: 'kind',
    schemas: {
      variantKindNamed: _namedVariantCodec(rootStyleSchema),
      variantKindWidgetState: _widgetStateVariantCodec(rootStyleSchema),
      variantKindEnabled: _enabledVariantCodec(rootStyleSchema),
      variantKindContextBrightness: _brightnessVariantCodec(rootStyleSchema),
      variantKindContextBreakpoint: _breakpointVariantCodec(rootStyleSchema),
      variantKindContextDirectionality: _directionalityVariantCodec(
        rootStyleSchema,
      ),
      variantKindContextNot: _notVariantCodec(rootStyleSchema),
      variantKindContextNotWidgetState: _notWidgetStateVariantCodec(
        rootStyleSchema,
      ),
      variantKindContextOrientation: _orientationVariantCodec(rootStyleSchema),
      variantKindContextPlatform: _platformVariantCodec(rootStyleSchema),
      variantKindContextWeb: _webVariantCodec(rootStyleSchema),
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _namedVariantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'name': Ack.string().notEmpty(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<S>>(
    decode: (data) => VariantStyle<S>(
      NamedVariant(data['name']! as String),
      _typedStyle<S>(data['style']!),
    ),
    encode: (value) {
      final variant = value.variant;
      if (variant is! NamedVariant) {
        throw UnsupportedEncodeValueError(variant, 'Expected NamedVariant.');
      }

      return {'name': variant.name, 'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _widgetStateVariantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'state': _widgetStateCodec(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<S>>(
    decode: (data) => VariantStyle<S>(
      ContextVariant.widgetState(data['state']! as WidgetState),
      _typedStyle<S>(data['style']!),
    ),
    encode: (value) {
      final variant = value.variant;
      if (variant is! WidgetStateVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected WidgetStateVariant.',
        );
      }

      return {'state': variant.state, 'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _enabledVariantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({'style': rootStyleSchema}).codec<VariantStyle<S>>(
    decode: (data) => VariantStyle<S>(
      ContextVariant.not(ContextVariant.widgetState(WidgetState.disabled)),
      _typedStyle<S>(data['style']!),
    ),
    encode: (value) {
      final state = _notWidgetState(value.variant);
      if (state != WidgetState.disabled) {
        throw UnsupportedEncodeValueError(
          value.variant,
          'Expected enabled variant.',
        );
      }

      return {'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _brightnessVariantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'brightness': _brightnessCodec(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<S>>(
    decode: (data) => VariantStyle<S>(
      ContextVariant.brightness(data['brightness']! as Brightness),
      _typedStyle<S>(data['style']!),
    ),
    encode: (value) {
      final variant = value.variant;
      if (variant is! BrightnessVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected brightness context variant.',
        );
      }

      return {'brightness': variant.brightness, 'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _breakpointVariantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
        'token': tokenNameCodec().optional(),
        'minWidth': numberAsDoubleCodec().optional(),
        'maxWidth': numberAsDoubleCodec().optional(),
        'style': rootStyleSchema,
      })
      .constrain(
        const _BreakpointBoundsConstraint('context_breakpoint variant'),
      )
      .codec<VariantStyle<S>>(
        decode: (data) {
          final token = data['token'] as String?;
          if (token != null) {
            return VariantStyle<S>(
              ContextVariant.breakpoint(BreakpointToken(token)()),
              _typedStyle<S>(data['style']!),
            );
          }

          final minWidth = data['minWidth'] as double?;
          final maxWidth = data['maxWidth'] as double?;

          return VariantStyle<S>(
            ContextVariant.breakpoint(
              Breakpoint(minWidth: minWidth, maxWidth: maxWidth),
            ),
            _typedStyle<S>(data['style']!),
          );
        },
        encode: (value) {
          final variant = value.variant;
          if (variant is! BreakpointVariant) {
            throw UnsupportedEncodeValueError(
              variant,
              'Expected breakpoint context variant.',
            );
          }

          return {..._breakpointWire(variant.breakpoint), 'style': value.value};
        },
      );
}

AckSchema<JsonMap, VariantStyle<S>> _orientationVariantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'orientation': enumNameCodec(Orientation.values),
    'style': rootStyleSchema,
  }).codec<VariantStyle<S>>(
    decode: (data) => VariantStyle<S>(
      ContextVariant.orientation(data['orientation']! as Orientation),
      _typedStyle<S>(data['style']!),
    ),
    encode: (value) {
      final variant = value.variant;
      if (variant is! OrientationVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected orientation context variant.',
        );
      }

      return {'orientation': variant.orientation, 'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _directionalityVariantCodec<
  S extends Spec<S>
>(AckSchema<JsonMap, Object> rootStyleSchema) {
  return Ack.object({
    'textDirection': textDirectionCodec(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<S>>(
    decode: (data) => VariantStyle<S>(
      ContextVariant.directionality(data['textDirection']! as TextDirection),
      _typedStyle<S>(data['style']!),
    ),
    encode: (value) {
      final variant = value.variant;
      if (variant is! DirectionalityVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected directionality context variant.',
        );
      }

      return {'textDirection': variant.direction, 'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _platformVariantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'platform': enumNameCodec(TargetPlatform.values),
    'style': rootStyleSchema,
  }).codec<VariantStyle<S>>(
    decode: (data) => VariantStyle<S>(
      ContextVariant.platform(data['platform']! as TargetPlatform),
      _typedStyle<S>(data['style']!),
    ),
    encode: (value) {
      final variant = value.variant;
      if (variant is! PlatformVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected platform context variant.',
        );
      }

      return {'platform': variant.platform, 'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _webVariantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({'style': rootStyleSchema}).codec<VariantStyle<S>>(
    decode: (data) =>
        VariantStyle<S>(ContextVariant.web(), _typedStyle<S>(data['style']!)),
    encode: (value) {
      final variant = value.variant;
      if (variant is! WebVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected web context variant.',
        );
      }

      return {'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _notWidgetStateVariantCodec<
  S extends Spec<S>
>(AckSchema<JsonMap, Object> rootStyleSchema) {
  return Ack.object({
    'state': _widgetStateCodec(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<S>>(
    decode: (data) {
      final state = data['state']! as WidgetState;

      return VariantStyle<S>(
        ContextVariant.not(ContextVariant.widgetState(state)),
        _typedStyle<S>(data['style']!),
      );
    },
    encode: (value) {
      final state = _notWidgetState(value.variant);
      if (state == null || state == WidgetState.disabled) {
        throw UnsupportedEncodeValueError(
          value.variant,
          'Expected non-enabled not-widget-state context variant.',
        );
      }

      return {'state': state, 'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<S>> _notVariantCodec<S extends Spec<S>>(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'variant': _contextVariantSelectorCodec(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<S>>(
    decode: (data) => VariantStyle<S>(
      ContextVariant.not(data['variant']! as ContextVariant),
      _typedStyle<S>(data['style']!),
    ),
    encode: (value) {
      final variant = value.variant;
      if (variant is! NotVariant || _notWidgetState(variant) != null) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected recursive non-widget-state not context variant.',
        );
      }

      return {'variant': variant.inner, 'style': value.value};
    },
  );
}

final AckSchema<JsonMap, ContextVariant> _contextVariantSelectorSchema =
    _createContextVariantSelectorCodec();

AckSchema<JsonMap, ContextVariant> _contextVariantSelectorCodec() {
  return _contextVariantSelectorSchema;
}

AckSchema<JsonMap, ContextVariant> _createContextVariantSelectorCodec() {
  late final AckSchema<JsonMap, ContextVariant> selector;
  selector = Ack.lazy<JsonMap, ContextVariant>(
    'mix_protocol_context_variant_selector',
    () => Ack.discriminated<ContextVariant>(
      discriminatorKey: 'kind',
      schemas: {
        variantKindWidgetState: _widgetStateSelectorCodec(),
        variantKindEnabled: _enabledSelectorCodec(),
        variantKindContextBrightness: _brightnessSelectorCodec(),
        variantKindContextBreakpoint: _breakpointSelectorCodec(),
        variantKindContextDirectionality: _directionalitySelectorCodec(),
        variantKindContextNot: _notSelectorCodec(selector),
        variantKindContextNotWidgetState: _notWidgetStateSelectorCodec(),
        variantKindContextOrientation: _orientationSelectorCodec(),
        variantKindContextPlatform: _platformSelectorCodec(),
        variantKindContextWeb: _webSelectorCodec(),
      },
    ),
  );

  return selector;
}

AckSchema<JsonMap, ContextVariant> _widgetStateSelectorCodec() {
  return Ack.object({'state': _widgetStateCodec()}).codec<ContextVariant>(
    decode: (data) => ContextVariant.widgetState(data['state']! as WidgetState),
    encode: (variant) {
      if (variant is! WidgetStateVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected widget-state context variant.',
        );
      }

      return {'state': variant.state};
    },
  );
}

AckSchema<JsonMap, ContextVariant> _enabledSelectorCodec() {
  return Ack.object({}).codec<ContextVariant>(
    decode: (_) =>
        ContextVariant.not(ContextVariant.widgetState(WidgetState.disabled)),
    encode: (variant) {
      final state = _notWidgetState(variant);
      if (state != WidgetState.disabled) {
        throw UnsupportedEncodeValueError(variant, 'Expected enabled variant.');
      }

      return const {};
    },
  );
}

AckSchema<JsonMap, ContextVariant> _brightnessSelectorCodec() {
  return Ack.object({'brightness': _brightnessCodec()}).codec<ContextVariant>(
    decode: (data) =>
        ContextVariant.brightness(data['brightness']! as Brightness),
    encode: (variant) {
      if (variant is! BrightnessVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected brightness context variant.',
        );
      }

      return {'brightness': variant.brightness};
    },
  );
}

AckSchema<JsonMap, ContextVariant> _breakpointSelectorCodec() {
  return Ack.object({
        'token': tokenNameCodec().optional(),
        'minWidth': numberAsDoubleCodec().optional(),
        'maxWidth': numberAsDoubleCodec().optional(),
      })
      .constrain(const _BreakpointBoundsConstraint('context_not breakpoint'))
      .codec<ContextVariant>(
        decode: (data) {
          final token = data['token'] as String?;
          if (token != null) {
            return ContextVariant.breakpoint(BreakpointToken(token)());
          }

          return ContextVariant.breakpoint(
            Breakpoint(
              minWidth: data['minWidth'] as double?,
              maxWidth: data['maxWidth'] as double?,
            ),
          );
        },
        encode: (variant) {
          if (variant is! BreakpointVariant) {
            throw UnsupportedEncodeValueError(
              variant,
              'Expected breakpoint context variant.',
            );
          }

          return _breakpointWire(variant.breakpoint);
        },
      );
}

AckSchema<JsonMap, ContextVariant> _directionalitySelectorCodec() {
  return Ack.object({
    'textDirection': textDirectionCodec(),
  }).codec<ContextVariant>(
    decode: (data) =>
        ContextVariant.directionality(data['textDirection']! as TextDirection),
    encode: (variant) {
      if (variant is! DirectionalityVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected directionality context variant.',
        );
      }

      return {'textDirection': variant.direction};
    },
  );
}

AckSchema<JsonMap, ContextVariant> _notSelectorCodec(
  AckSchema<JsonMap, ContextVariant> selector,
) {
  return Ack.object({'variant': selector}).codec<ContextVariant>(
    decode: (data) => ContextVariant.not(data['variant']! as ContextVariant),
    encode: (variant) {
      if (variant is! NotVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected not context variant.',
        );
      }

      return {'variant': variant.inner};
    },
  );
}

AckSchema<JsonMap, ContextVariant> _notWidgetStateSelectorCodec() {
  return Ack.object({'state': _widgetStateCodec()}).codec<ContextVariant>(
    decode: (data) => ContextVariant.not(
      ContextVariant.widgetState(data['state']! as WidgetState),
    ),
    encode: (variant) {
      final state = _notWidgetState(variant);
      if (state == null || state == WidgetState.disabled) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected non-enabled not-widget-state context variant.',
        );
      }

      return {'state': state};
    },
  );
}

AckSchema<JsonMap, ContextVariant> _orientationSelectorCodec() {
  return Ack.object({
    'orientation': enumNameCodec(Orientation.values),
  }).codec<ContextVariant>(
    decode: (data) =>
        ContextVariant.orientation(data['orientation']! as Orientation),
    encode: (variant) {
      if (variant is! OrientationVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected orientation context variant.',
        );
      }

      return {'orientation': variant.orientation};
    },
  );
}

AckSchema<JsonMap, ContextVariant> _platformSelectorCodec() {
  return Ack.object({
    'platform': enumNameCodec(TargetPlatform.values),
  }).codec<ContextVariant>(
    decode: (data) =>
        ContextVariant.platform(data['platform']! as TargetPlatform),
    encode: (variant) {
      if (variant is! PlatformVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected platform context variant.',
        );
      }

      return {'platform': variant.platform};
    },
  );
}

AckSchema<JsonMap, ContextVariant> _webSelectorCodec() {
  return Ack.object({}).codec<ContextVariant>(
    decode: (_) => ContextVariant.web(),
    encode: (variant) {
      if (variant is! WebVariant) {
        throw UnsupportedEncodeValueError(variant, 'Expected web variant.');
      }

      return const {};
    },
  );
}

CodecSchema<String, WidgetState> _widgetStateCodec() {
  return enumCodec(widgetStateWireValues, debugName: 'WidgetState');
}

CodecSchema<String, Brightness> _brightnessCodec() {
  return enumCodec({
    'light': Brightness.light,
    'dark': Brightness.dark,
  }, debugName: 'Brightness');
}

Style<S> _typedStyle<S extends Spec<S>>(Object value) {
  if (value is Style<S>) return value;

  throw UnsupportedEncodeValueError(
    value,
    'Nested variant style must decode to a $S style.',
  );
}

WidgetState? _notWidgetState(Variant variant) {
  if (variant is! NotVariant) return null;
  final inner = variant.inner;

  return inner is WidgetStateVariant ? inner.state : null;
}

JsonMap _breakpointWire(Breakpoint breakpoint) {
  if (breakpoint is BreakpointRef) {
    final tokenReference = encodeTokenReference(
      breakpoint.token,
      'variant.token',
    );

    return {'token': tokenReference[tokenReferenceKey]};
  }
  if (breakpoint.minHeight != null ||
      breakpoint.maxHeight != null ||
      (breakpoint.minWidth == null && breakpoint.maxWidth == null)) {
    throw UnsupportedEncodeValueError(
      breakpoint,
      'Only concrete width breakpoint variants are representable.',
    );
  }

  return {'minWidth': breakpoint.minWidth, 'maxWidth': breakpoint.maxWidth};
}

final class _BreakpointBoundsConstraint extends Constraint<JsonMap>
    with Validator<JsonMap> {
  const _BreakpointBoundsConstraint(this.subject)
    : super(
        constraintKey: 'mix_protocol_breakpoint_bounds',
        description: 'Breakpoint variants require at least one width bound.',
      );

  final String subject;

  @override
  bool isValid(JsonMap value) {
    if (value['token'] != null) {
      return value['minWidth'] == null && value['maxWidth'] == null;
    }

    return value['minWidth'] != null || value['maxWidth'] != null;
  }

  @override
  String buildMessage(JsonMap value) {
    if (value['token'] != null) {
      return 'A $subject cannot mix token and width bounds.';
    }

    return 'A $subject requires a token or minWidth/maxWidth.';
  }
}
