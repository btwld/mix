import 'dart:convert';

import 'package:ack/ack.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import '../registry/registry.dart';
import '../registry/registry_value_codec.dart';
import 'common_codecs.dart';

const _allOfPrefix = 'mix_schema_all_of:';

AckSchema<JsonMap, VariantStyle<BoxSpec>> boxVariantCodec(
  AckSchema<JsonMap, Object> rootStyleSchema,
  FrozenRegistry Function() registry,
) {
  return Ack.discriminated<VariantStyle<BoxSpec>>(
    discriminatorKey: 'kind',
    schemas: {
      'named': _namedVariantCodec(rootStyleSchema),
      'widget_state': _widgetStateVariantCodec(rootStyleSchema),
      'enabled': _enabledVariantCodec(rootStyleSchema),
      'context_brightness': _brightnessVariantCodec(rootStyleSchema),
      'context_breakpoint': _breakpointVariantCodec(rootStyleSchema),
      'context_not_widget_state': _notWidgetStateVariantCodec(rootStyleSchema),
      'context_all_of': _allOfVariantCodec(rootStyleSchema),
      'context_variant_builder': _contextVariantBuilderCodec(registry),
    },
  );
}

AckSchema<JsonMap, VariantStyle<BoxSpec>> _namedVariantCodec(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'name': Ack.string().notEmpty(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<BoxSpec>>(
    decode: (data) => VariantStyle<BoxSpec>(
      NamedVariant(data['name']! as String),
      _boxStyle(data['style']!),
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

AckSchema<JsonMap, VariantStyle<BoxSpec>> _widgetStateVariantCodec(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'state': _widgetStateCodec(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<BoxSpec>>(
    decode: (data) => VariantStyle<BoxSpec>(
      ContextVariant.widgetState(data['state']! as WidgetState),
      _boxStyle(data['style']!),
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

AckSchema<JsonMap, VariantStyle<BoxSpec>> _enabledVariantCodec(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({'style': rootStyleSchema}).codec<VariantStyle<BoxSpec>>(
    decode: (data) => VariantStyle<BoxSpec>(
      ContextVariant.not(ContextVariant.widgetState(WidgetState.disabled)),
      _boxStyle(data['style']!),
    ),
    encode: (value) {
      final variant = value.variant;
      if (variant.key != 'not_widget_state_disabled') {
        throw UnsupportedEncodeValueError(variant, 'Expected enabled variant.');
      }

      return {'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<BoxSpec>> _brightnessVariantCodec(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'brightness': _brightnessCodec(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<BoxSpec>>(
    decode: (data) => VariantStyle<BoxSpec>(
      ContextVariant.brightness(data['brightness']! as Brightness),
      _boxStyle(data['style']!),
    ),
    encode: (value) {
      final brightness = _brightnessFromKey(value.variant.key);
      if (brightness == null) {
        throw UnsupportedEncodeValueError(
          value.variant,
          'Expected brightness context variant.',
        );
      }

      return {'brightness': brightness, 'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<BoxSpec>> _breakpointVariantCodec(
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
      .codec<VariantStyle<BoxSpec>>(
        decode: (data) {
          final minWidth = data['minWidth'] as double?;
          final maxWidth = data['maxWidth'] as double?;

          return VariantStyle<BoxSpec>(
            ContextVariant.breakpoint(
              Breakpoint(minWidth: minWidth, maxWidth: maxWidth),
            ),
            _boxStyle(data['style']!),
          );
        },
        encode: (value) {
          final breakpoint = _breakpointFromKey(value.variant.key);
          if (breakpoint == null) {
            throw UnsupportedEncodeValueError(
              value.variant,
              'Expected breakpoint context variant.',
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

AckSchema<JsonMap, VariantStyle<BoxSpec>> _notWidgetStateVariantCodec(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'state': _widgetStateCodec(),
    'style': rootStyleSchema,
  }).codec<VariantStyle<BoxSpec>>(
    decode: (data) {
      final state = data['state']! as WidgetState;

      return VariantStyle<BoxSpec>(
        ContextVariant.not(ContextVariant.widgetState(state)),
        _boxStyle(data['style']!),
      );
    },
    encode: (value) {
      final state = _notWidgetStateFromKey(value.variant.key);
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

AckSchema<JsonMap, VariantStyle<BoxSpec>> _allOfVariantCodec(
  AckSchema<JsonMap, Object> rootStyleSchema,
) {
  return Ack.object({
    'conditions': Ack.list(_contextConditionCodec()),
    'style': rootStyleSchema,
  }).codec<VariantStyle<BoxSpec>>(
    decode: (data) {
      final conditions = data['conditions']! as List<_ContextCondition>;

      return VariantStyle<BoxSpec>(
        _allOfVariant(conditions),
        _boxStyle(data['style']!),
      );
    },
    encode: (value) {
      final conditions = _conditionsFromAllOfKey(value.variant.key);
      if (conditions == null) {
        throw UnsupportedEncodeValueError(
          value.variant,
          'Expected context_all_of variant.',
        );
      }

      return {'conditions': conditions, 'style': value.value};
    },
  );
}

AckSchema<JsonMap, VariantStyle<BoxSpec>> _contextVariantBuilderCodec(
  FrozenRegistry Function() registry,
) {
  return Ack.object({
    'builder': registryValueCodecFrom<BoxStyler Function(BuildContext)>(
      registry,
      MixSchemaScope.contextVariantBuilder,
    ),
  }).codec<VariantStyle<BoxSpec>>(
    decode: (data) {
      final builder = data['builder']! as BoxStyler Function(BuildContext);

      return VariantStyle<BoxSpec>(
        ContextVariantBuilder<BoxStyler>(builder),
        BoxStyler(),
      );
    },
    encode: (value) {
      final variant = value.variant;
      if (variant is! ContextVariantBuilder) {
        throw UnsupportedEncodeValueError(
          variant,
          'Expected context variant builder.',
        );
      }

      return {'builder': variant.fn};
    },
  );
}

AckSchema<JsonMap, _ContextCondition> _contextConditionCodec() {
  return Ack.discriminated<_ContextCondition>(
    discriminatorKey: 'kind',
    schemas: {
      'widget_state': Ack.object({'state': _widgetStateCodec()})
          .codec<_ContextCondition>(
            decode: (data) =>
                _ContextCondition.widgetState(data['state']! as WidgetState),
            encode: (value) {
              final state = value.widgetState;
              if (state == null || value.negated) {
                throw UnsupportedEncodeValueError(
                  value,
                  'Expected widget_state condition.',
                );
              }

              return {'state': state};
            },
          ),
      'enabled': Ack.object({}).codec<_ContextCondition>(
        decode: (_) => _ContextCondition.notWidgetState(WidgetState.disabled),
        encode: (value) {
          if (value.widgetState != WidgetState.disabled || !value.negated) {
            throw UnsupportedEncodeValueError(
              value,
              'Expected enabled condition.',
            );
          }

          return const {};
        },
      ),
      'context_not_widget_state': Ack.object({'state': _widgetStateCodec()})
          .codec<_ContextCondition>(
            decode: (data) =>
                _ContextCondition.notWidgetState(data['state']! as WidgetState),
            encode: (value) {
              final state = value.widgetState;
              if (state == null ||
                  !value.negated ||
                  state == WidgetState.disabled) {
                throw UnsupportedEncodeValueError(
                  value,
                  'Expected not-widget-state condition.',
                );
              }

              return {'state': state};
            },
          ),
      'context_brightness': Ack.object({'brightness': _brightnessCodec()})
          .codec<_ContextCondition>(
            decode: (data) =>
                _ContextCondition.brightness(data['brightness']! as Brightness),
            encode: (value) {
              final brightness = value.brightness;
              if (brightness == null) {
                throw UnsupportedEncodeValueError(
                  value,
                  'Expected brightness condition.',
                );
              }

              return {'brightness': brightness};
            },
          ),
      'context_breakpoint':
          Ack.object({
                'minWidth': numberAsDoubleCodec().optional(),
                'maxWidth': numberAsDoubleCodec().optional(),
              })
              .constrain(
                const _BreakpointBoundsConstraint('breakpoint condition'),
              )
              .codec<_ContextCondition>(
                decode: (data) {
                  final minWidth = data['minWidth'] as double?;
                  final maxWidth = data['maxWidth'] as double?;

                  return _ContextCondition.breakpoint(
                    Breakpoint(minWidth: minWidth, maxWidth: maxWidth),
                  );
                },
                encode: (value) {
                  final breakpoint = value.breakpoint;
                  if (breakpoint == null) {
                    throw UnsupportedEncodeValueError(
                      value,
                      'Expected breakpoint condition.',
                    );
                  }

                  return {
                    'minWidth': breakpoint.minWidth,
                    'maxWidth': breakpoint.maxWidth,
                  };
                },
              ),
    },
  );
}

CodecSchema<String, WidgetState> _widgetStateCodec() {
  return strictEnumCodec(_widgetStateByWire, debugName: 'WidgetState');
}

CodecSchema<String, Brightness> _brightnessCodec() {
  return strictEnumCodec({
    'light': Brightness.light,
    'dark': Brightness.dark,
  }, debugName: 'Brightness');
}

Style<BoxSpec> _boxStyle(Object value) {
  if (value is Style<BoxSpec>) return value;

  throw UnsupportedEncodeValueError(
    value,
    'Nested variant style must decode to a Box style.',
  );
}

Brightness? _brightnessFromKey(String key) {
  return switch (key) {
    'media_query_platform_brightness_light' => Brightness.light,
    'media_query_platform_brightness_dark' => Brightness.dark,
    _ => null,
  };
}

Breakpoint? _breakpointFromKey(String key) {
  final match = RegExp(r'^breakpoint_(.+)_(.+)$').firstMatch(key);
  if (match == null) return null;
  final min = match.group(1)!;
  final max = match.group(2)!;

  return Breakpoint(
    minWidth: min == '0.0' ? null : double.tryParse(min),
    maxWidth: max == 'infinity' ? null : double.tryParse(max),
  );
}

WidgetState? _notWidgetStateFromKey(String key) {
  const prefix = 'not_widget_state_';
  if (!key.startsWith(prefix)) return null;
  final wire = key.substring(prefix.length);

  return _widgetStateByWire[wire];
}

const Map<String, WidgetState> _widgetStateByWire = {
  'hovered': WidgetState.hovered,
  'focused': WidgetState.focused,
  'pressed': WidgetState.pressed,
  'dragged': WidgetState.dragged,
  'selected': WidgetState.selected,
  'scrolled_under': WidgetState.scrolledUnder,
  'disabled': WidgetState.disabled,
  'error': WidgetState.error,
};

ContextVariant _allOfVariant(List<_ContextCondition> conditions) {
  if (conditions.any((condition) => condition.kind == 'context_all_of')) {
    throw const UnsupportedEncodeValueError(
      null,
      'Nested context_all_of variants are not supported.',
    );
  }

  final encoded = jsonEncode(conditions.map((c) => c.toJson()).toList());

  return ContextVariant('$_allOfPrefix$encoded', (context) {
    return conditions.every((condition) => condition.variant.when(context));
  });
}

List<_ContextCondition>? _conditionsFromAllOfKey(String key) {
  if (!key.startsWith(_allOfPrefix)) return null;
  final raw = jsonDecode(key.substring(_allOfPrefix.length));
  if (raw is! List) return null;

  return raw
      .map((item) {
        if (item is! JsonMap) {
          throw UnsupportedEncodeValueError(
            item,
            'Invalid all_of condition key.',
          );
        }

        return _ContextCondition.fromJson(item);
      })
      .toList(growable: false);
}

final class _ContextCondition {
  const _ContextCondition._({
    required this.kind,
    required this.variant,
    this.widgetState,
    this.brightness,
    this.breakpoint,
    this.negated = false,
  });

  factory _ContextCondition.widgetState(WidgetState state) {
    return _ContextCondition._(
      kind: 'widget_state',
      variant: ContextVariant.widgetState(state),
      widgetState: state,
    );
  }

  factory _ContextCondition.notWidgetState(WidgetState state) {
    return _ContextCondition._(
      kind: state == WidgetState.disabled
          ? 'enabled'
          : 'context_not_widget_state',
      variant: ContextVariant.not(ContextVariant.widgetState(state)),
      widgetState: state,
      negated: true,
    );
  }

  factory _ContextCondition.brightness(Brightness brightness) {
    return _ContextCondition._(
      kind: 'context_brightness',
      variant: ContextVariant.brightness(brightness),
      brightness: brightness,
    );
  }

  factory _ContextCondition.breakpoint(Breakpoint breakpoint) {
    return _ContextCondition._(
      kind: 'context_breakpoint',
      variant: ContextVariant.breakpoint(breakpoint),
      breakpoint: breakpoint,
    );
  }

  factory _ContextCondition.fromJson(JsonMap json) {
    return switch (json['kind']) {
      'widget_state' => _ContextCondition.widgetState(
        _widgetStateByWire[json['state']]!,
      ),
      'enabled' => _ContextCondition.notWidgetState(WidgetState.disabled),
      'context_not_widget_state' => _ContextCondition.notWidgetState(
        _widgetStateByWire[json['state']]!,
      ),
      'context_brightness' => _ContextCondition.brightness(
        json['brightness'] == 'dark' ? Brightness.dark : Brightness.light,
      ),
      'context_breakpoint' => _ContextCondition.breakpoint(
        Breakpoint(
          minWidth: json['minWidth'] as double?,
          maxWidth: json['maxWidth'] as double?,
        ),
      ),
      _ => throw UnsupportedEncodeValueError(
        json,
        'Unknown all_of condition kind.',
      ),
    };
  }

  final String kind;
  final ContextVariant variant;
  final WidgetState? widgetState;
  final Brightness? brightness;
  final Breakpoint? breakpoint;
  final bool negated;

  JsonMap toJson() {
    return switch (kind) {
      'widget_state' => {'kind': kind, 'state': _widgetStateWire(widgetState!)},
      'enabled' => {'kind': kind},
      'context_not_widget_state' => {
        'kind': kind,
        'state': _widgetStateWire(widgetState!),
      },
      'context_brightness' => {
        'kind': kind,
        'brightness': brightness == Brightness.dark ? 'dark' : 'light',
      },
      'context_breakpoint' => {
        'kind': kind,
        'minWidth': breakpoint!.minWidth,
        'maxWidth': breakpoint!.maxWidth,
      },
      _ => throw UnsupportedEncodeValueError(
        this,
        'Unknown all_of condition kind.',
      ),
    };
  }
}

String _widgetStateWire(WidgetState state) {
  for (final entry in _widgetStateByWire.entries) {
    if (entry.value == state) return entry.key;
  }

  throw UnsupportedEncodeValueError(state, 'Unknown widget state.');
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
