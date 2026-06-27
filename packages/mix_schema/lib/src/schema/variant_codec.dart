import 'package:ack/ack.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
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
      variantKindContextNotWidgetState: _notWidgetStateVariantCodec(
        rootStyleSchema,
      ),
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
        'minWidth': numberAsDoubleCodec().optional(),
        'maxWidth': numberAsDoubleCodec().optional(),
        'style': rootStyleSchema,
      })
      .constrain(
        const _BreakpointBoundsConstraint('context_breakpoint variant'),
      )
      .codec<VariantStyle<S>>(
        decode: (data) {
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
          final breakpoint = variant.breakpoint;
          if (breakpoint is BreakpointRef ||
              breakpoint.minHeight != null ||
              breakpoint.maxHeight != null ||
              (breakpoint.minWidth == null && breakpoint.maxWidth == null)) {
            throw UnsupportedEncodeValueError(
              breakpoint,
              'Only concrete width breakpoint variants are representable.',
            );
          }

          return {
            'minWidth': breakpoint.minWidth,
            'maxWidth': breakpoint.maxWidth,
            'style': value.value,
          };
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

final class _BreakpointBoundsConstraint extends Constraint<JsonMap>
    with Validator<JsonMap> {
  const _BreakpointBoundsConstraint(this.subject)
    : super(
        constraintKey: 'mix_schema_breakpoint_bounds',
        description: 'Breakpoint variants require at least one width bound.',
      );

  final String subject;

  @override
  bool isValid(JsonMap value) {
    return value['minWidth'] != null || value['maxWidth'] != null;
  }

  @override
  String buildMessage(JsonMap value) {
    return 'A $subject requires minWidth or maxWidth.';
  }
}
