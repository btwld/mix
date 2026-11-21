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
      for (final entry in _contextDefinitions.entries)
        entry.key: entry.value.styleCodec<S>(rootStyleSchema, entry.key),
    },
  );
}

/// One selector definition supplies both nested selectors and styled variants.
final class _ContextVariantDefinition {
  final ObjectSchema schema;
  final ContextVariant Function(JsonMap data) decode;
  final JsonMap Function(ContextVariant value) encode;

  const _ContextVariantDefinition(
    this.schema, {
    required this.decode,
    required this.encode,
  });

  AckSchema<JsonMap, ContextVariant> selectorCodec() =>
      schema.codec<ContextVariant>(decode: decode, encode: encode);

  AckSchema<JsonMap, VariantStyle<S>> styleCodec<S extends Spec<S>>(
    AckSchema<JsonMap, Object> rootStyleSchema,
    String kind,
  ) {
    return schema
        .copyWith(properties: {...schema.properties, 'style': rootStyleSchema})
        .codec<VariantStyle<S>>(
          decode: (data) =>
              VariantStyle<S>(decode(data), _typedStyle<S>(data['style']!)),
          encode: (value) {
            final variant = value.variant;
            if (variant is! ContextVariant ||
                (kind == variantKindContextNot &&
                    _notWidgetState(variant) != null)) {
              throw UnsupportedEncodeValueError(
                variant,
                'Expected $kind context variant.',
              );
            }

            return {...encode(variant), 'style': value.value};
          },
        );
  }
}

final AckSchema<JsonMap, ContextVariant> _contextSelector =
    Ack.lazy<JsonMap, ContextVariant>(
      'mix_protocol_context_variant_selector',
      () => Ack.discriminated<ContextVariant>(
        discriminatorKey: 'kind',
        schemas: {
          for (final entry in _contextDefinitions.entries)
            entry.key: entry.value.selectorCodec(),
        },
      ),
    );

final _contextDefinitions = <String, _ContextVariantDefinition>{
  variantKindWidgetState: _widgetStateDefinition(),
  variantKindEnabled: _enabledDefinition(),
  variantKindContextBrightness: _brightnessDefinition(),
  variantKindContextBreakpoint: _breakpointDefinition(),
  variantKindContextDirectionality: _directionalityDefinition(),
  variantKindContextNot: _notDefinition(_contextSelector),
  variantKindContextNotWidgetState: _notWidgetStateDefinition(),
  variantKindContextOrientation: _orientationDefinition(),
  variantKindContextPlatform: _platformDefinition(),
  variantKindContextWeb: _webDefinition(),
  variantKindContextFocusVisible: _ContextVariantDefinition(
    Ack.object({}),
    decode: (_) => ContextVariant.focusVisible(),
    encode: (variant) {
      if (variant is! FocusVisibleVariant) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected focus-visible context variant.',
        );
      }

      return const {};
    },
  ),
};

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

_ContextVariantDefinition _widgetStateDefinition() {
  return _ContextVariantDefinition(
    Ack.object({'state': _widgetStateCodec()}),
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

_ContextVariantDefinition _enabledDefinition() {
  return _ContextVariantDefinition(
    Ack.object({}),
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

_ContextVariantDefinition _brightnessDefinition() {
  return _ContextVariantDefinition(
    Ack.object({'brightness': _brightnessCodec()}),
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

_ContextVariantDefinition _breakpointDefinition() {
  return _ContextVariantDefinition(
    Ack.object({
      'token': tokenNameCodec().optional(),
      'minWidth': numberAsDoubleCodec().optional(),
      'maxWidth': numberAsDoubleCodec().optional(),
    }).constrain(const _BreakpointBoundsConstraint()),
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

_ContextVariantDefinition _directionalityDefinition() {
  return _ContextVariantDefinition(
    Ack.object({'textDirection': textDirectionCodec()}),
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

_ContextVariantDefinition _notDefinition(
  AckSchema<JsonMap, ContextVariant> selector,
) {
  return _ContextVariantDefinition(
    Ack.object({'variant': selector}),
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

_ContextVariantDefinition _notWidgetStateDefinition() {
  return _ContextVariantDefinition(
    Ack.object({'state': _widgetStateCodec()}),
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

_ContextVariantDefinition _orientationDefinition() {
  return _ContextVariantDefinition(
    Ack.object({'orientation': enumNameCodec(Orientation.values)}),
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

_ContextVariantDefinition _platformDefinition() {
  return _ContextVariantDefinition(
    Ack.object({'platform': enumNameCodec(TargetPlatform.values)}),
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

_ContextVariantDefinition _webDefinition() {
  return _ContextVariantDefinition(
    Ack.object({}),
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
    with Validator<JsonMap>, JsonSchemaSpec<JsonMap> {
  static const _bounds = ['minWidth', 'maxWidth'];

  const _BreakpointBoundsConstraint()
    : super(
        constraintKey: 'mix_protocol_breakpoint_bounds',
        description: 'Breakpoint variants require at least one width bound.',
      );

  @override
  bool isValid(JsonMap value) {
    final hasBounds = _bounds.any((key) => value[key] != null);

    return value['token'] != null ? !hasBounds : hasBounds;
  }

  @override
  JsonMap toJsonSchema() {
    final hasBounds = {
      'anyOf': [
        for (final key in _bounds)
          {
            'required': [key],
          },
      ],
    };

    // Exactly one of a token reference or a width bound. Both present and
    // both absent each match a different branch count, mirroring isValid.
    return {
      'oneOf': [
        {
          'required': ['token'],
        },
        hasBounds,
      ],
    };
  }

  @override
  String buildMessage(JsonMap value) {
    final subject = value.containsKey('style')
        ? 'context_breakpoint variant'
        : 'context_not breakpoint';
    if (value['token'] != null) {
      return 'A $subject cannot mix token and width bounds.';
    }

    return 'A $subject requires a token or minWidth/maxWidth.';
  }
}
