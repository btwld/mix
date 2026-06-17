/// Tailwind candidate to Mix styler translator.
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/mix_schema.dart';

import '../parser/candidate_parser.dart';
import '../parser/data/parser_registry.g.dart';
import '../parser/diagnostics.dart';
import '../parser/model.dart';
import '../theme/data/default_theme.g.dart';
import '../tw_config.dart';
import '../tw_types.dart';
import '../tw_utils.dart';
import 'tw_accumulators.dart';
import 'tw_gradient.dart';
import 'tw_presets.dart';
import 'tw_routing.dart';
import 'tw_target.dart';

final class TwTranslator {
  TwTranslator({required this.config, this.onUnsupported})
    : _parser = TailwindCandidateParser(
        registry: defaultTailwindParserRegistry,
      );

  final TwConfig config;
  final TokenWarningCallback? onUnsupported;
  final TailwindCandidateParser _parser;
  final MixSchemaContract _schema = MixSchemaContractBuilder()
      .builtIn()
      .freeze();

  List<String> listTokens(String classNames) {
    final trimmed = classNames.trim();
    if (trimmed.isEmpty) return const [];
    return trimmed.split(RegExp(r'\s+'));
  }

  BoxStyler translateBox(String classNames) {
    return _translate<BoxStyler>(
      classNames,
      target: TwTarget.box,
      empty: BoxStyler.new,
      decode: _decodePayload<BoxStyler>,
      merge: (base, other) => base.merge(other),
      wrapVariant: _wrapBoxVariant,
      applyGradient: (style, gradient) => style.gradient(gradient),
    );
  }

  FlexBoxStyler translateFlex(String classNames) {
    return _translate<FlexBoxStyler>(
      classNames,
      target: TwTarget.flexBox,
      empty: FlexBoxStyler.new,
      decode: _decodePayload<FlexBoxStyler>,
      merge: (base, other) => base.merge(other),
      wrapVariant: _wrapFlexVariant,
      applyGradient: (style, gradient) => style.gradient(gradient),
      afterBasePayload: (payload, context) {
        if (!context.hasBaseFlex) payload['direction'] = Axis.vertical.name;
      },
    );
  }

  TextStyler translateText(String classNames) {
    return _translate<TextStyler>(
      classNames,
      target: TwTarget.text,
      empty: TextStyler.new,
      decode: _decodePayload<TextStyler>,
      merge: (base, other) => base.merge(other),
      wrapVariant: _wrapTextVariant,
      applyGradient: (style, _) => style,
      seedPayload: () => {
        'type': SchemaStyler.text.wireValue,
        'style': <String, Object?>{'height': config.textDefaults.lineHeight},
      },
    );
  }

  JsonMap payloadBox(String classNames) {
    return _payloadFor(classNames, target: TwTarget.box);
  }

  JsonMap payloadFlex(String classNames) {
    return _payloadFor(classNames, target: TwTarget.flexBox);
  }

  JsonMap payloadText(String classNames) {
    return _payloadFor(classNames, target: TwTarget.text);
  }

  CurveAnimationConfig? parseAnimationFromTokens(List<String> tokens) {
    var hasTransition = false;
    var hasTransitionNone = false;
    var duration = const Duration(milliseconds: 150);
    Curve curve = Curves.easeOut;
    var delay = Duration.zero;

    for (final token in tokens) {
      final base = baseTokenOutsideBrackets(token);
      if (_transitionTriggerTokens.contains(base)) {
        hasTransition = true;
      } else if (base == 'transition-none') {
        hasTransitionNone = true;
      } else if (base.startsWith('duration-')) {
        final ms = config.durationOf(base.substring(9));
        if (ms != null) {
          duration = Duration(milliseconds: ms);
        } else {
          onUnsupported?.call(token);
        }
      } else if (_easeTokens.containsKey(base)) {
        curve = _easeTokens[base]!;
      } else if (base.startsWith('delay-')) {
        final ms = config.delayOf(base.substring(6));
        if (ms != null) {
          delay = Duration(milliseconds: ms);
        } else {
          onUnsupported?.call(token);
        }
      }
    }

    if (hasTransitionNone || !hasTransition) return null;
    return CurveAnimationConfig(duration: duration, curve: curve, delay: delay);
  }

  JsonMap _payloadFor(String classNames, {required TwTarget target}) {
    final groups = _buildGroups(classNames, target);
    final base = groups[_VariantPath.base] ?? _GroupContext(target);
    _finalizeGroupPayload(base);
    return base.payload;
  }

  S _translate<S>(
    String classNames, {
    required TwTarget target,
    required S Function() empty,
    required S Function(JsonMap payload) decode,
    required S Function(S base, S other) merge,
    required S Function(List<_VariantPart> path, S style) wrapVariant,
    required S Function(S style, LinearGradientMix gradient) applyGradient,
    JsonMap Function()? seedPayload,
    void Function(JsonMap payload, _GroupContext context)? afterBasePayload,
  }) {
    final groups = _buildGroups(classNames, target, seedPayload: seedPayload);
    final baseContext =
        groups[_VariantPath.base] ??
        _GroupContext(target, seedPayload: seedPayload);
    afterBasePayload?.call(baseContext.payload, baseContext);

    final hasVariantTransform = groups.entries.any(
      (entry) =>
          entry.key != _VariantPath.base &&
          entry.value.transform.hasAnyTransform,
    );
    if (hasVariantTransform && !baseContext.transform.hasAnyTransform) {
      baseContext.transform.needsIdentity = true;
    }

    _finalizeGroupPayload(baseContext);
    var result = decode(baseContext.payload);
    final baseGradient = baseContext.gradient.toGradientMix(
      config.gradientStrategy,
    );
    if (baseGradient != null) result = applyGradient(result, baseGradient);

    for (final entry in groups.entries) {
      if (entry.key == _VariantPath.base) continue;
      final context = entry.value;
      if (context.transform.hasAnyTransform &&
          baseContext.transform.hasAnyTransform) {
        context.transform.inheritUnsetFrom(baseContext.transform);
      }
      if (context.border.hasStructure && baseContext.border.hasStructure) {
        context.border.inheritUnsetFrom(baseContext.border);
      }
      if (context.gradient.hasAnyPart && baseContext.gradient.hasAnyPart) {
        context.gradient.inheritUnsetFrom(baseContext.gradient);
      }
      _finalizeGroupPayload(context);
      var child = decode(context.payload);
      final gradient = context.gradient.toGradientMix(config.gradientStrategy);
      if (gradient != null) child = applyGradient(child, gradient);
      result = merge(result, wrapVariant(entry.key.parts, child));
    }

    return result;
  }

  Map<_VariantPath, _GroupContext> _buildGroups(
    String classNames,
    TwTarget target, {
    JsonMap Function()? seedPayload,
  }) {
    final groups = <_VariantPath, _GroupContext>{};
    _GroupContext groupFor(_VariantPath path) {
      return groups.putIfAbsent(path, () {
        final context = _GroupContext(target, seedPayload: seedPayload);
        return context;
      });
    }

    for (final token in listTokens(classNames)) {
      final parsed = _parser.parseCandidate(token);
      if (parsed is TailwindParseFailure) {
        onUnsupported?.call(token);
        continue;
      }

      final candidate = (parsed as TailwindParseSuccess).candidate;
      final route = routeCandidate(candidate);
      if (route.kind == TwRouteKind.ignored) {
        if (route.reason == 'important modifier') onUnsupported?.call(token);
        continue;
      }
      if (route.kind == TwRouteKind.unsupported) {
        if (!_applyWidgetLayerToken(token, target)) onUnsupported?.call(token);
        continue;
      }

      final path = _variantPath(candidate.variants);
      if (path == null) continue;
      final group = groupFor(path);

      if (route.kind == TwRouteKind.gradient) {
        if (!_applyGradient(group.gradient, candidate)) {
          onUnsupported?.call(token);
        }
        continue;
      }

      final handled = _applySchemaCandidate(group, candidate, target);
      if (!handled && !_applyWidgetLayerToken(token, target)) {
        onUnsupported?.call(token);
      }
    }

    return groups;
  }

  bool _applySchemaCandidate(
    _GroupContext group,
    TailwindCandidate candidate,
    TwTarget target,
  ) {
    final utility = candidate.utility;
    final raw = utility.raw;
    final root = _utilityRoot(utility);
    final value = _utilityValue(utility);
    final modifier = _utilityModifier(utility);
    final negative = _utilityNegative(utility);

    if (target == TwTarget.flexBox) {
      if (_applyFlexUtility(group, raw, root, value, modifier, negative)) {
        return true;
      }
    }

    if (target == TwTarget.text) {
      return _applyTextUtility(group.payload, raw, root, value, modifier);
    }

    return _applyBoxLikeUtility(group, raw, root, value, modifier, negative);
  }

  bool _applyFlexUtility(
    _GroupContext group,
    String raw,
    String root,
    TailwindValue? value,
    TailwindModifier? modifier,
    bool negative,
  ) {
    final payload = group.payload;
    switch (raw) {
      case 'flex':
      case 'flex-row':
        payload['direction'] = Axis.horizontal.name;
        group.hasBaseFlex = true;
        return true;
      case 'flex-col':
        payload['direction'] = Axis.vertical.name;
        group.hasBaseFlex = true;
        return true;
      case 'items-start':
        payload['crossAxisAlignment'] = CrossAxisAlignment.start.name;
        return true;
      case 'items-center':
        payload['crossAxisAlignment'] = CrossAxisAlignment.center.name;
        return true;
      case 'items-end':
        payload['crossAxisAlignment'] = CrossAxisAlignment.end.name;
        return true;
      case 'items-stretch':
        payload['crossAxisAlignment'] = CrossAxisAlignment.stretch.name;
        return true;
      case 'items-baseline':
        payload['crossAxisAlignment'] = CrossAxisAlignment.baseline.name;
        payload['textBaseline'] = TextBaseline.alphabetic.name;
        return true;
      case 'justify-start':
        payload['mainAxisAlignment'] = MainAxisAlignment.start.name;
        return true;
      case 'justify-center':
        payload['mainAxisAlignment'] = MainAxisAlignment.center.name;
        return true;
      case 'justify-end':
        payload['mainAxisAlignment'] = MainAxisAlignment.end.name;
        return true;
      case 'justify-between':
        payload['mainAxisAlignment'] = MainAxisAlignment.spaceBetween.name;
        return true;
      case 'justify-around':
        payload['mainAxisAlignment'] = MainAxisAlignment.spaceAround.name;
        return true;
      case 'justify-evenly':
        payload['mainAxisAlignment'] = MainAxisAlignment.spaceEvenly.name;
        return true;
    }

    if (root == 'gap') {
      final length = _spaceLength(value, negative: negative);
      if (length == null) return false;
      payload['spacing'] = length;
      return true;
    }

    return false;
  }

  bool _applyBoxLikeUtility(
    _GroupContext group,
    String raw,
    String root,
    TailwindValue? value,
    TailwindModifier? modifier,
    bool negative,
  ) {
    final payload = group.payload;

    if (_applySpacing(payload, root, value, negative: negative)) return true;
    if (_applySizing(payload, root, value, negative: negative)) return true;
    if (_applyBorder(group, raw, root, value, modifier)) return true;
    if (_applyRadius(payload, root, value)) return true;
    if (_applyTransform(group.transform, root, value, negative)) return true;

    switch (root) {
      case 'bg':
        final color = _color(value, modifier);
        if (color == null) return false;
        _decoration(payload)['color'] = payloadColor(color);
        return true;
      case 'opacity':
        final opacity = _opacity(value);
        if (opacity == null) return false;
        _modifiers(payload).add({'type': 'opacity', 'opacity': opacity});
        return true;
      case 'blur':
        final sigma = _blur(value);
        if (sigma == null) return false;
        _modifiers(payload).add({'type': 'blur', 'sigma': sigma});
        return true;
      case 'shadow':
        final shadows = _boxShadowPayload(raw, value);
        if (shadows == null) return false;
        _decoration(payload)['boxShadow'] = shadows;
        return true;
      case 'text':
      case 'size':
        return _applyDefaultTextUtility(payload, root, value, modifier);
    }

    if (raw == 'overflow-hidden' || raw == 'overflow-clip') {
      payload['clipBehavior'] = Clip.hardEdge.name;
      return true;
    }
    if (raw == 'overflow-visible') {
      payload['clipBehavior'] = Clip.none.name;
      return true;
    }
    if (_applyDefaultTextStatic(payload, raw)) return true;

    return false;
  }

  bool _applyTextUtility(
    JsonMap payload,
    String raw,
    String root,
    TailwindValue? value,
    TailwindModifier? modifier,
  ) {
    if (root == 'text' || root == 'size') {
      if (_applyTextStyleUtility(() => _textStyle(payload), value, modifier)) {
        return true;
      }
    }

    switch (raw) {
      case 'text-left':
        payload['textAlign'] = TextAlign.left.name;
        return true;
      case 'text-center':
        payload['textAlign'] = TextAlign.center.name;
        return true;
      case 'text-right':
        payload['textAlign'] = TextAlign.right.name;
        return true;
      case 'text-justify':
        payload['textAlign'] = TextAlign.justify.name;
        return true;
      case 'text-start':
        payload['textAlign'] = TextAlign.start.name;
        return true;
      case 'text-end':
        payload['textAlign'] = TextAlign.end.name;
        return true;
      case 'uppercase':
      case 'lowercase':
      case 'capitalize':
        _textDirectives(payload).add(raw);
        return true;
      case 'truncate':
        payload['overflow'] = TextOverflow.ellipsis.name;
        payload['maxLines'] = 1;
        payload['softWrap'] = false;
        return true;
      case 'leading-even':
        payload['textHeightBehavior'] = {
          'leadingDistribution': TextLeadingDistribution.even.name,
        };
        return true;
      case 'leading-trim':
        payload['textHeightBehavior'] = {
          'leadingDistribution': TextLeadingDistribution.even.name,
          'applyHeightToFirstAscent': false,
          'applyHeightToLastDescent': false,
        };
        return true;
    }

    if (_applyFontWeight(_textStyle(payload), raw)) return true;
    if (_applyLineHeight(_textStyle(payload), raw)) return true;
    if (_applyTracking(_textStyle(payload), raw)) return true;
    if (_applyTextShadow(_textStyle(payload), raw)) return true;

    return false;
  }

  bool _applyDefaultTextUtility(
    JsonMap payload,
    String root,
    TailwindValue? value,
    TailwindModifier? modifier,
  ) {
    if (root == 'text' || root == 'size') {
      return _applyTextStyleUtility(
        () => _defaultTextStyle(payload),
        value,
        modifier,
      );
    }

    return false;
  }

  bool _applyTextStyleUtility(
    JsonMap Function() style,
    TailwindValue? value,
    TailwindModifier? modifier,
  ) {
    final key = _valueKey(value);
    final size = key == null ? null : config.fontSizes[key];
    if (size != null) {
      final target = style();
      target['fontSize'] = size;
      final lineHeight = twDefaultLineHeights[key];
      if (lineHeight != null) target['height'] = lineHeight;
      return true;
    }

    final arbitraryLength = _arbitraryLength(value);
    if (arbitraryLength != null) {
      style()['fontSize'] = arbitraryLength;
      return true;
    }

    final color = _color(value, modifier);
    if (color != null) {
      style()['color'] = payloadColor(color);
      return true;
    }

    return false;
  }

  bool _applyDefaultTextStatic(JsonMap payload, String raw) {
    final style = _defaultTextStyle(payload);
    if (_applyFontWeight(style, raw)) return true;
    if (_applyTextShadow(style, raw)) return true;
    return false;
  }

  bool _applySpacing(
    JsonMap payload,
    String root,
    TailwindValue? value, {
    required bool negative,
  }) {
    final field = switch (root) {
      'p' || 'px' || 'py' || 'pt' || 'pr' || 'pb' || 'pl' => 'padding',
      'm' || 'mx' || 'my' || 'mt' || 'mr' || 'mb' || 'ml' => 'margin',
      _ => null,
    };
    if (field == null) return false;
    final length = _spaceLength(value, negative: negative);
    if (length == null) return false;
    if (field == 'margin' && length < 0) return true;
    _setEdge(payload, field, length, sides: _axisOrSide(root));
    return true;
  }

  bool _applySizing(
    JsonMap payload,
    String root,
    TailwindValue? value, {
    required bool negative,
  }) {
    if (!_sizingRoots.contains(root)) return false;
    if (negative) return false;
    final length =
        _spaceLength(value, negative: false) ?? _arbitraryLength(value);
    if (length == null) return _isWidgetLayerSize(value);

    final constraints = _objectField(payload, 'constraints');
    switch (root) {
      case 'w':
        constraints['minWidth'] = length;
        constraints['maxWidth'] = length;
        return true;
      case 'h':
        constraints['minHeight'] = length;
        constraints['maxHeight'] = length;
        return true;
      case 'min-w':
        constraints['minWidth'] = length;
        return true;
      case 'min-h':
        constraints['minHeight'] = length;
        return true;
      case 'max-w':
        constraints['maxWidth'] = length;
        return true;
      case 'max-h':
        constraints['maxHeight'] = length;
        return true;
    }

    return false;
  }

  bool _applyRadius(JsonMap payload, String root, TailwindValue? value) {
    if (!root.startsWith('rounded')) return false;
    final key = _valueKey(value) ?? '';
    final radius = config.radii[key];
    if (radius == null) return false;
    final borderRadius = _objectField(_decoration(payload), 'borderRadius');
    switch (root) {
      case 'rounded':
        borderRadius
          ..['topLeft'] = radius
          ..['topRight'] = radius
          ..['bottomLeft'] = radius
          ..['bottomRight'] = radius;
      case 'rounded-t':
        borderRadius
          ..['topLeft'] = radius
          ..['topRight'] = radius;
      case 'rounded-b':
        borderRadius
          ..['bottomLeft'] = radius
          ..['bottomRight'] = radius;
      case 'rounded-l':
        borderRadius
          ..['topLeft'] = radius
          ..['bottomLeft'] = radius;
      case 'rounded-r':
        borderRadius
          ..['topRight'] = radius
          ..['bottomRight'] = radius;
      case 'rounded-tl':
        borderRadius['topLeft'] = radius;
      case 'rounded-tr':
        borderRadius['topRight'] = radius;
      case 'rounded-bl':
        borderRadius['bottomLeft'] = radius;
      case 'rounded-br':
        borderRadius['bottomRight'] = radius;
      default:
        return false;
    }
    return true;
  }

  bool _applyBorder(
    _GroupContext group,
    String raw,
    String root,
    TailwindValue? value,
    TailwindModifier? modifier,
  ) {
    if (!root.startsWith('border')) return false;
    final key = _valueKey(value) ?? '';
    final color = _color(value, modifier);
    final width = config.borderWidths[key] ?? (key.isEmpty ? 1.0 : null);

    if (color != null && width == null) {
      group.border.setColor(color, root);
      return true;
    }
    if (width == null) return false;

    switch (root) {
      case 'border':
        group.border.setAll(width);
      case 'border-t':
        group.border.topWidth = width;
      case 'border-r':
        group.border.rightWidth = width;
      case 'border-b':
        group.border.bottomWidth = width;
      case 'border-l':
        group.border.leftWidth = width;
      case 'border-x':
        group.border.setHorizontal(width);
      case 'border-y':
        group.border.setVertical(width);
      default:
        return raw.startsWith('border-') && color != null;
    }
    return true;
  }

  bool _applyTransform(
    TransformAccum transform,
    String root,
    TailwindValue? value,
    bool negative,
  ) {
    final key = _valueKey(value);
    switch (root) {
      case 'scale':
        final scale = key == null ? null : config.scaleOf(key);
        if (scale == null) return false;
        transform.scale = scale;
        return true;
      case 'rotate':
        final rotate = key == null ? null : config.rotationOf(key);
        if (rotate == null) return false;
        transform.rotateDeg = negative ? -rotate : rotate;
        return true;
      case 'translate-x':
        final length = _spaceLength(value, negative: negative);
        if (length == null) return false;
        transform.translateX = length;
        return true;
      case 'translate-y':
        final length = _spaceLength(value, negative: negative);
        if (length == null) return false;
        transform.translateY = length;
        return true;
    }
    return false;
  }

  bool _applyGradient(GradientAccum gradient, TailwindCandidate candidate) {
    final utility = candidate.utility;
    final raw = utility.raw;
    final root = _utilityRoot(utility);
    final value = _utilityValue(utility);
    final key = _valueKey(value);

    if (raw.startsWith('bg-gradient-')) {
      final directionKey = raw.substring(12);
      final direction = gradientDirections[directionKey];
      if (direction == null) return false;
      gradient.directionKey = directionKey;
      gradient.direction = direction;
      return true;
    } else if (root == 'bg-linear' || raw.startsWith('bg-linear-')) {
      final directionKey = key ?? raw.substring(10);
      final direction = gradientDirections[directionKey];
      if (direction == null) return false;
      gradient.directionKey = directionKey;
      gradient.direction = direction;
      return true;
    } else if (root == 'from') {
      final color = _color(value, _utilityModifier(utility));
      if (color == null) return false;
      gradient.fromColor = color;
      return true;
    } else if (root == 'via') {
      final color = _color(value, _utilityModifier(utility));
      if (color == null) return false;
      gradient.viaColor = color;
      return true;
    } else if (root == 'to') {
      final color = _color(value, _utilityModifier(utility));
      if (color == null) return false;
      gradient.toColor = color;
      return true;
    }
    return false;
  }

  void _finalizeGroupPayload(_GroupContext group) {
    if (group.transform.hasAnyTransform) {
      group.payload['transform'] = group.transform.toPayload();
    }
    if (group.border.hasStructure) {
      _decoration(group.payload)['border'] = group.border.toPayload(
        defaultColor: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
      );
    }
  }

  T _decodePayload<T extends Object>(JsonMap payload) {
    final result = _schema.decode<T>(payload);
    return switch (result) {
      MixSchemaDecodeSuccess<T>(:final value) => value,
      MixSchemaDecodeFailure<T>(:final errors) => throw StateError(
        'Tailwinds emitted an invalid schema payload: $errors',
      ),
    };
  }

  S _wrapBoxVariant<S>(List<_VariantPart> path, S style) {
    var wrapped = style as BoxStyler;
    for (final part in path.reversed) {
      wrapped = _newBoxVariant(part, wrapped);
    }
    return wrapped as S;
  }

  S _wrapFlexVariant<S>(List<_VariantPart> path, S style) {
    var wrapped = style as FlexBoxStyler;
    for (final part in path.reversed) {
      wrapped = _newFlexVariant(part, wrapped);
    }
    return wrapped as S;
  }

  S _wrapTextVariant<S>(List<_VariantPart> path, S style) {
    var wrapped = style as TextStyler;
    for (final part in path.reversed) {
      wrapped = _newTextVariant(part, wrapped);
    }
    return wrapped as S;
  }

  BoxStyler _newBoxVariant(_VariantPart part, BoxStyler style) {
    return switch (part.kind) {
      _VariantKind.hover => BoxStyler().onHovered(style),
      _VariantKind.focus => BoxStyler().onFocused(style),
      _VariantKind.pressed => BoxStyler().onPressed(style),
      _VariantKind.disabled => BoxStyler().onDisabled(style),
      _VariantKind.enabled => BoxStyler().onEnabled(style),
      _VariantKind.dark => BoxStyler().onDark(style),
      _VariantKind.light => BoxStyler().onLight(style),
      _VariantKind.breakpoint => BoxStyler().onBreakpoint(
        Breakpoint(minWidth: part.breakpoint!),
        style,
      ),
      _VariantKind.notHover => BoxStyler().onNot(
        ContextVariant.widgetState(WidgetState.hovered),
        style,
      ),
    };
  }

  FlexBoxStyler _newFlexVariant(_VariantPart part, FlexBoxStyler style) {
    return switch (part.kind) {
      _VariantKind.hover => FlexBoxStyler().onHovered(style),
      _VariantKind.focus => FlexBoxStyler().onFocused(style),
      _VariantKind.pressed => FlexBoxStyler().onPressed(style),
      _VariantKind.disabled => FlexBoxStyler().onDisabled(style),
      _VariantKind.enabled => FlexBoxStyler().onEnabled(style),
      _VariantKind.dark => FlexBoxStyler().onDark(style),
      _VariantKind.light => FlexBoxStyler().onLight(style),
      _VariantKind.breakpoint => FlexBoxStyler().onBreakpoint(
        Breakpoint(minWidth: part.breakpoint!),
        style,
      ),
      _VariantKind.notHover => FlexBoxStyler().onNot(
        ContextVariant.widgetState(WidgetState.hovered),
        style,
      ),
    };
  }

  TextStyler _newTextVariant(_VariantPart part, TextStyler style) {
    return switch (part.kind) {
      _VariantKind.hover => TextStyler().onHovered(style),
      _VariantKind.focus => TextStyler().onFocused(style),
      _VariantKind.pressed => TextStyler().onPressed(style),
      _VariantKind.disabled => TextStyler().onDisabled(style),
      _VariantKind.enabled => TextStyler().onEnabled(style),
      _VariantKind.dark => TextStyler().onDark(style),
      _VariantKind.light => TextStyler().onLight(style),
      _VariantKind.breakpoint => TextStyler().onBreakpoint(
        Breakpoint(minWidth: part.breakpoint!),
        style,
      ),
      _VariantKind.notHover => TextStyler().onNot(
        ContextVariant.widgetState(WidgetState.hovered),
        style,
      ),
    };
  }

  _VariantPath? _variantPath(List<TailwindVariant> variants) {
    final parts = <_VariantPart>[];
    for (final variant in variants) {
      final part = _variantPart(variant);
      if (part == null) return null;
      parts.add(part);
    }
    return parts.isEmpty ? _VariantPath.base : _VariantPath(parts);
  }

  _VariantPart? _variantPart(TailwindVariant variant) {
    if (variant is TailwindStaticVariant) {
      final breakpoint = config.breakpoints[variant.root];
      if (breakpoint != null) {
        return _VariantPart.breakpoint(variant.root, breakpoint);
      }
      return switch (variant.root) {
        'hover' => const _VariantPart(_VariantKind.hover, 'hover'),
        'focus' ||
        'focus-visible' => const _VariantPart(_VariantKind.focus, 'focus'),
        'active' ||
        'pressed' => const _VariantPart(_VariantKind.pressed, 'pressed'),
        'disabled' => const _VariantPart(_VariantKind.disabled, 'disabled'),
        'enabled' => const _VariantPart(_VariantKind.enabled, 'enabled'),
        'dark' ||
        'theme-midnight' => const _VariantPart(_VariantKind.dark, 'dark'),
        'light' => const _VariantPart(_VariantKind.light, 'light'),
        _ => null,
      };
    }
    if (variant is TailwindCompoundVariant && variant.root == 'not') {
      final child = variant.variant;
      if (child is TailwindStaticVariant && child.root == 'hover') {
        return const _VariantPart(_VariantKind.notHover, 'not-hover');
      }
    }
    return null;
  }

  bool _applyWidgetLayerToken(String token, TwTarget target) {
    final base = baseTokenOutsideBrackets(token);
    if (_transitionTriggerTokens.contains(base) ||
        base == 'transition-none' ||
        _easeTokens.containsKey(base) ||
        base.startsWith('duration-') ||
        base.startsWith('delay-')) {
      return true;
    }
    if (base.startsWith('flex-') ||
        base.startsWith('basis-') ||
        base.startsWith('self-') ||
        base.startsWith('shrink') ||
        base.startsWith('grow')) {
      return true;
    }
    if (base.startsWith('gap-x-') || base.startsWith('gap-y-')) return true;
    if (base.startsWith('w-') || base.startsWith('h-')) {
      final key = base.substring(2);
      return key == 'full' ||
          key == 'screen' ||
          key == 'auto' ||
          key.contains('/');
    }
    return target == TwTarget.flexBox && base == 'block';
  }

  String _utilityRoot(TailwindUtility utility) {
    return switch (utility) {
      TailwindStaticUtility(:final root) => root,
      TailwindFunctionalUtility(:final root) => root,
      TailwindUnresolvedUtility(:final segments) =>
        segments.isEmpty ? utility.raw : segments.first,
      TailwindArbitraryProperty(:final property) => property,
    };
  }

  TailwindValue? _utilityValue(TailwindUtility utility) {
    return switch (utility) {
      TailwindFunctionalUtility(:final value) => value,
      _ => null,
    };
  }

  TailwindModifier? _utilityModifier(TailwindUtility utility) {
    return switch (utility) {
      TailwindFunctionalUtility(:final modifier) => modifier,
      TailwindUnresolvedUtility(:final modifier) => modifier,
      TailwindArbitraryProperty(:final modifier) => modifier,
      _ => null,
    };
  }

  bool _utilityNegative(TailwindUtility utility) {
    return switch (utility) {
      TailwindFunctionalUtility(:final negative) => negative,
      TailwindUnresolvedUtility(:final negative) => negative,
      _ => false,
    };
  }

  String? _valueKey(TailwindValue? value) {
    return value is TailwindNamedValue ? value.raw : null;
  }

  double? _spaceLength(TailwindValue? value, {required bool negative}) {
    final key = _valueKey(value);
    final resolved = key == null ? null : config.space[key];
    if (resolved == null) return _arbitraryLength(value);
    return negative ? -resolved : resolved;
  }

  double? _arbitraryLength(TailwindValue? value) {
    if (value is! TailwindArbitraryValue) return null;
    final raw = value.value;
    final match = RegExp(r'^(-?\d+\.?\d*)(px|rem|em)?$').firstMatch(raw);
    if (match == null) return null;
    var number = double.parse(match.group(1)!);
    final unit = match.group(2) ?? 'px';
    if (unit == 'rem' || unit == 'em') number *= 16;
    return number;
  }

  Color? _color(TailwindValue? value, TailwindModifier? modifier) {
    if (value is TailwindArbitraryValue) {
      final parsed = _hexColor(value.value);
      return _applyOpacity(parsed, modifier);
    }
    if (value is TailwindCssVariableValue) return null;
    final key = _valueKey(value);
    if (key == null || key.isEmpty) return null;
    return _applyOpacity(config.colorOf(key), modifier);
  }

  Color? _applyOpacity(Color? color, TailwindModifier? modifier) {
    if (color == null || modifier == null) return color;
    final raw = switch (modifier) {
      TailwindNamedModifier(:final raw) => raw,
      TailwindArbitraryModifier(:final value) => value.replaceAll('%', ''),
      TailwindCssVariableModifier() => null,
    };
    if (raw == null) return null;
    final opacity = double.tryParse(raw);
    if (opacity == null || opacity < 0 || opacity > 100) return null;
    return color.withAlpha((opacity * 255 / 100).round());
  }

  Color? _hexColor(String value) {
    if (!value.startsWith('#')) return null;
    final hex = value.substring(1);
    if (hex.length != 3 &&
        hex.length != 4 &&
        hex.length != 6 &&
        hex.length != 8) {
      return null;
    }
    if (int.tryParse(hex, radix: 16) == null) return null;

    String expand(int index) => '${hex[index]}${hex[index]}';
    final r = hex.length <= 4 ? expand(0) : hex.substring(0, 2);
    final g = hex.length <= 4 ? expand(1) : hex.substring(2, 4);
    final b = hex.length <= 4 ? expand(2) : hex.substring(4, 6);
    final a = switch (hex.length) {
      4 => expand(3),
      8 => hex.substring(6, 8),
      _ => 'ff',
    };
    final argb = int.parse('$a$r$g$b', radix: 16);
    return Color(argb);
  }

  double? _opacity(TailwindValue? value) {
    final key = _valueKey(value);
    if (key == null) return null;
    final numeric = double.tryParse(key);
    if (numeric == null) return null;
    return numeric / 100;
  }

  double? _blur(TailwindValue? value) {
    final key = _valueKey(value) ?? '';
    return config.blurOf(key);
  }

  List<JsonMap>? _boxShadowPayload(String raw, TailwindValue? value) {
    final key = raw == 'shadow' ? 'shadow' : 'shadow-${_valueKey(value)}';
    final shadows = raw == 'shadow-none'
        ? const <BoxShadowMix>[]
        : kTailwindBoxShadowPresets[key];
    if (shadows == null) return null;
    final encoded = _schema.encode(BoxStyler().boxShadows(shadows));
    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure() => null,
    };
    final decoration = payload?['decoration'] as JsonMap?;
    return (decoration?['boxShadow'] as List?)?.cast<JsonMap>() ??
        const <JsonMap>[];
  }

  bool _applyFontWeight(JsonMap style, String raw) {
    final weight = switch (raw) {
      'font-thin' => 'w100',
      'font-extralight' => 'w200',
      'font-light' => 'w300',
      'font-normal' => 'w400',
      'font-medium' => 'w500',
      'font-semibold' => 'w600',
      'font-bold' => 'w700',
      'font-extrabold' => 'w800',
      'font-black' => 'w900',
      _ => null,
    };
    if (weight == null) return false;
    style['fontWeight'] = weight;
    return true;
  }

  bool _applyLineHeight(JsonMap style, String raw) {
    final height = switch (raw) {
      'leading-none' => 1.0,
      'leading-tight' => 1.25,
      'leading-snug' => 1.375,
      'leading-normal' => 1.5,
      'leading-relaxed' => 1.625,
      'leading-loose' => 2.0,
      _ => null,
    };
    if (height == null) return false;
    style['height'] = height;
    return true;
  }

  bool _applyTracking(JsonMap style, String raw) {
    final tracking = switch (raw) {
      'tracking-tighter' => -0.8,
      'tracking-tight' => -0.4,
      'tracking-normal' => 0.0,
      'tracking-wide' => 0.4,
      'tracking-wider' => 0.8,
      'tracking-widest' => 1.6,
      _ => null,
    };
    if (tracking == null) return false;
    style['letterSpacing'] = tracking;
    return true;
  }

  bool _applyTextShadow(JsonMap style, String raw) {
    final preset = switch (raw) {
      'text-shadow-none' => null,
      'text-shadow-2xs' => TextShadowPreset.twoXs,
      'text-shadow-xs' => TextShadowPreset.xs,
      'text-shadow-sm' => TextShadowPreset.sm,
      'text-shadow-md' => TextShadowPreset.md,
      'text-shadow-lg' => TextShadowPreset.lg,
      _ => _missingTextShadowPreset,
    };
    if (identical(preset, _missingTextShadowPreset)) return false;
    final shadows = preset == null
        ? const <ShadowMix>[]
        : kTextShadowPresets[preset]!
              .map(
                (shadow) => ShadowMix(
                  color: shadow.color,
                  offset: shadow.offset,
                  blurRadius: shadow.blurRadius,
                ),
              )
              .toList();
    final encoded = _schema.encode(TextStyler().shadows(shadows));
    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure() => null,
    };
    final encodedStyle = payload?['style'] as JsonMap?;
    style['shadows'] =
        (encodedStyle?['shadows'] as List?)?.cast<JsonMap>() ??
        const <JsonMap>[];
    return true;
  }

  bool _isWidgetLayerSize(TailwindValue? value) {
    final key = _valueKey(value);
    return key == 'full' ||
        key == 'screen' ||
        key == 'auto' ||
        key?.contains('/') == true;
  }

  void _setEdge(
    JsonMap payload,
    String field,
    double value, {
    required String sides,
  }) {
    final data = _objectField(payload, field);
    switch (sides) {
      case 'all':
        data
          ..['left'] = value
          ..['top'] = value
          ..['right'] = value
          ..['bottom'] = value;
      case 'x':
        data
          ..['left'] = value
          ..['right'] = value;
      case 'y':
        data
          ..['top'] = value
          ..['bottom'] = value;
      default:
        data[sides] = value;
    }
  }

  String _axisOrSide(String root) {
    if (root.length == 1) return 'all';
    return switch (root.substring(root.length - 1)) {
      'x' => 'x',
      'y' => 'y',
      't' => 'top',
      'r' => 'right',
      'b' => 'bottom',
      'l' => 'left',
      _ => 'all',
    };
  }

  JsonMap _decoration(JsonMap payload) => _objectField(payload, 'decoration');
  JsonMap _textStyle(JsonMap payload) => _objectField(payload, 'style');

  JsonMap _defaultTextStyle(JsonMap payload) {
    final modifiers = _modifiers(payload);
    for (final modifier in modifiers) {
      if (modifier['type'] == 'default_text_style') {
        return _objectField(modifier, 'style');
      }
    }
    final modifier = <String, Object?>{
      'type': 'default_text_style',
      'style': <String, Object?>{},
    };
    modifiers.add(modifier);
    return modifier['style']! as JsonMap;
  }

  List<JsonMap> _modifiers(JsonMap payload) {
    return (payload['modifiers'] ??= <JsonMap>[]) as List<JsonMap>;
  }

  List<String> _textDirectives(JsonMap payload) {
    return (payload['textDirectives'] ??= <String>[]) as List<String>;
  }

  JsonMap _objectField(JsonMap payload, String field) {
    return (payload[field] ??= <String, Object?>{}) as JsonMap;
  }
}

const _transitionTriggerTokens = {
  'transition',
  'transition-all',
  'transition-colors',
  'transition-opacity',
  'transition-shadow',
  'transition-transform',
};

const _sizingRoots = {'w', 'h', 'min-w', 'min-h', 'max-w', 'max-h'};

const _easeTokens = {
  'ease-linear': Curves.linear,
  'ease-in': Curves.easeIn,
  'ease-out': Curves.easeOut,
  'ease-in-out': Curves.easeInOut,
};

const Object _missingTextShadowPreset = Object();

final class _GroupContext {
  _GroupContext(this.target, {JsonMap Function()? seedPayload})
    : payload = seedPayload?.call() ?? _payloadForTarget(target);

  final TwTarget target;
  final JsonMap payload;
  final transform = TransformAccum();
  final border = BorderAccum();
  final gradient = GradientAccum();
  bool hasBaseFlex = false;

  static JsonMap _payloadForTarget(TwTarget target) {
    return {
      'type': switch (target) {
        TwTarget.box => SchemaStyler.box.wireValue,
        TwTarget.flexBox => SchemaStyler.flexBox.wireValue,
        TwTarget.text => SchemaStyler.text.wireValue,
      },
    };
  }
}

enum _VariantKind {
  hover,
  focus,
  pressed,
  disabled,
  enabled,
  dark,
  light,
  breakpoint,
  notHover,
}

final class _VariantPart {
  const _VariantPart(this.kind, this.key, {this.breakpoint});
  const _VariantPart.breakpoint(String key, double breakpoint)
    : this(_VariantKind.breakpoint, key, breakpoint: breakpoint);

  final _VariantKind kind;
  final String key;
  final double? breakpoint;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _VariantPart &&
          kind == other.kind &&
          key == other.key &&
          breakpoint == other.breakpoint;

  @override
  int get hashCode => Object.hash(kind, key, breakpoint);
}

final class _VariantPath {
  const _VariantPath(this.parts);

  static const base = _VariantPath([]);

  final List<_VariantPart> parts;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _VariantPath &&
          parts.length == other.parts.length &&
          _partsEqual(parts, other.parts);

  @override
  int get hashCode => Object.hashAll(parts);
}

bool _partsEqual(List<_VariantPart> a, List<_VariantPart> b) {
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
