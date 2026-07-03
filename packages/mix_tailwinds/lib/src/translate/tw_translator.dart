/// Tailwind candidate to Mix styler translator.
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

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

  List<String> listTokens(String classNames) {
    final trimmed = classNames.trim();
    if (trimmed.isEmpty) return const [];
    return trimmed.split(RegExp(r'\s+'));
  }

  BoxStyler translateBox(String classNames) {
    return _translate<BoxStyler>(
      classNames,
      target: TwTarget.box,
      build: (context) => context.toBoxStyler(config),
      merge: (base, other) => base.merge(other),
      wrapVariant: _wrapBoxVariant,
    );
  }

  FlexBoxStyler translateFlex(String classNames) {
    return _translate<FlexBoxStyler>(
      classNames,
      target: TwTarget.flexBox,
      build: (context) => context.toFlexBoxStyler(config),
      merge: (base, other) => base.merge(other),
      wrapVariant: _wrapFlexVariant,
      afterBase: (context) {
        if (!context.hasBaseFlex) {
          context.direction = Axis.vertical;
        }
      },
    );
  }

  TextStyler translateText(String classNames) {
    return _translate<TextStyler>(
      classNames,
      target: TwTarget.text,
      build: (context) => context.toTextStyler(config),
      merge: (base, other) => base.merge(other),
      wrapVariant: _wrapTextVariant,
    );
  }

  IconStyler translateIcon(String classNames) {
    double? width;
    double? height;
    Color? color;
    double? opacity;

    for (final token in listTokens(classNames)) {
      final parsed = _parser.parseCandidate(token);
      if (parsed is! TailwindParseSuccess) continue;
      final candidate = parsed.candidate;
      if (candidate.variants.isNotEmpty) continue;

      final route = routeCandidate(candidate, breakpoints: config.breakpoints);
      if (route.kind != TwRouteKind.schemaValue) continue;

      final utility = candidate.utility;
      if (_utilityNegative(utility)) continue;
      final root = _utilityRoot(utility);
      final value = _utilityValue(utility);

      switch (root) {
        case 'w':
          width = _sizingLength('w', value) ?? width;
        case 'h':
          height = _sizingLength('h', value) ?? height;
        case 'text':
          color = _color(value, _utilityModifier(utility)) ?? color;
        case 'opacity':
          opacity = _opacity(value) ?? opacity;
      }
    }

    final size = (width != null && height != null)
        ? (width < height ? width : height)
        : (width ?? height);

    return IconStyler(size: size, color: color, opacity: opacity);
  }

  CurveAnimationConfig? parseAnimationFromTokens(List<String> tokens) {
    var hasTransition = false;
    var hasTransitionNone = false;
    var duration = const Duration(milliseconds: 150);
    Curve curve = Curves.easeOut;
    var delay = Duration.zero;

    for (final token in tokens) {
      final parsed = _parser.parseCandidate(token);
      if (parsed is TailwindParseFailure) {
        onUnsupported?.call(token);
        continue;
      }

      final candidate = (parsed as TailwindParseSuccess).candidate;
      final route = routeCandidate(candidate, breakpoints: config.breakpoints);
      if (route.kind == TwRouteKind.ignored) {
        if (route.reason == 'important modifier') onUnsupported?.call(token);
        continue;
      }
      if (route.kind == TwRouteKind.unsupported) {
        onUnsupported?.call(token);
        continue;
      }

      final base = candidate.utility.raw;
      if (transitionTriggerTokens.contains(base)) {
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

  S _translate<S>(
    String classNames, {
    required TwTarget target,
    required S Function(_GroupContext context) build,
    required S Function(S base, S other) merge,
    required S Function(List<_VariantPart> path, S style) wrapVariant,
    void Function(_GroupContext context)? afterBase,
  }) {
    final groups = _buildGroups(classNames, target);
    final baseContext = groups[_VariantPath.base] ?? _GroupContext(target);
    afterBase?.call(baseContext);

    final hasVariantTransform = groups.entries.any(
      (entry) =>
          entry.key != _VariantPath.base &&
          entry.value.transform.hasAnyTransform,
    );
    if (hasVariantTransform && !baseContext.transform.hasAnyTransform) {
      baseContext.transform.needsIdentity = true;
    }

    var result = build(baseContext);

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
      final child = build(context);
      result = merge(result, wrapVariant(entry.key.parts, child));
    }

    return result;
  }

  Map<_VariantPath, _GroupContext> _buildGroups(
    String classNames,
    TwTarget target,
  ) {
    final groups = <_VariantPath, _GroupContext>{};
    _GroupContext groupFor(_VariantPath path) {
      return groups.putIfAbsent(path, () => _GroupContext(target));
    }

    for (final token in listTokens(classNames)) {
      final parsed = _parser.parseCandidate(token);
      if (parsed is TailwindParseFailure) {
        onUnsupported?.call(token);
        continue;
      }

      final candidate = (parsed as TailwindParseSuccess).candidate;
      final route = routeCandidate(candidate, breakpoints: config.breakpoints);
      if (route.kind == TwRouteKind.ignored) {
        if (route.reason == 'important modifier') onUnsupported?.call(token);
        continue;
      }
      if (route.kind == TwRouteKind.unsupported) {
        onUnsupported?.call(token);
        continue;
      }
      if (route.kind == TwRouteKind.widgetLayer) {
        if (!_isSupportedWidgetLayerUtility(candidate.utility)) {
          onUnsupported?.call(token);
        }
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
      if (!handled) onUnsupported?.call(token);
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
      return _applyTextUtility(group, raw, root, value, modifier);
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
    switch (raw) {
      case 'inline-flex':
        group.direction = Axis.horizontal;
        group.mainAxisSize = MainAxisSize.min;
        group.hasBaseFlex = true;
        return true;
      case 'flex':
      case 'flex-row':
        group.direction = Axis.horizontal;
        group.hasBaseFlex = true;
        return true;
      case 'flex-col':
        group.direction = Axis.vertical;
        group.hasBaseFlex = true;
        return true;
      case 'items-start':
        group.crossAxisAlignment = CrossAxisAlignment.start;
        return true;
      case 'items-center':
        group.crossAxisAlignment = CrossAxisAlignment.center;
        return true;
      case 'items-end':
        group.crossAxisAlignment = CrossAxisAlignment.end;
        return true;
      case 'items-stretch':
        group.crossAxisAlignment = CrossAxisAlignment.stretch;
        return true;
      case 'items-baseline':
        group.crossAxisAlignment = CrossAxisAlignment.baseline;
        group.textBaseline = TextBaseline.alphabetic;
        return true;
      case 'justify-start':
        group.mainAxisAlignment = MainAxisAlignment.start;
        return true;
      case 'justify-center':
        group.mainAxisAlignment = MainAxisAlignment.center;
        return true;
      case 'justify-end':
        group.mainAxisAlignment = MainAxisAlignment.end;
        return true;
      case 'justify-between':
        group.mainAxisAlignment = MainAxisAlignment.spaceBetween;
        return true;
      case 'justify-around':
        group.mainAxisAlignment = MainAxisAlignment.spaceAround;
        return true;
      case 'justify-evenly':
        group.mainAxisAlignment = MainAxisAlignment.spaceEvenly;
        return true;
    }

    if (root == 'gap') {
      final length = _spaceLength(value, negative: negative);
      if (length == null) return false;
      group.spacing = length;
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
    if (_applySpacing(group, root, value, negative: negative)) return true;
    if (_applySizing(group, root, value, negative: negative)) return true;
    if (_applyBorder(group, raw, root, value, modifier)) return true;
    if (_applyRadius(group, root, value)) return true;
    if (_applyTransform(group.transform, root, value, negative)) return true;

    switch (root) {
      case 'bg':
        final color = _color(value, modifier);
        if (color == null) return false;
        group.decoration.color = color;
        return true;
      case 'opacity':
        final opacity = _opacity(value);
        if (opacity == null) return false;
        group.modifiers.add(OpacityModifierMix(opacity: opacity));
        return true;
      case 'blur':
        final sigma = _blur(value);
        if (sigma == null) return false;
        group.modifiers.add(BlurModifierMix(sigma: sigma));
        return true;
      case 'shadow':
        final shadows = _boxShadowMixes(raw, value);
        if (shadows == null) return false;
        group.decoration.boxShadow = shadows;
        return true;
      case 'text':
      case 'size':
        return _applyDefaultTextUtility(group, root, value, modifier);
    }

    if (raw == 'overflow-hidden' || raw == 'overflow-clip') {
      group.decoration.ensurePresent = true;
      group.clipBehavior = Clip.hardEdge;
      return true;
    }
    if (raw == 'overflow-visible') {
      group.clipBehavior = Clip.none;
      return true;
    }
    if (_applyDefaultTextStatic(group, raw)) return true;

    return false;
  }

  bool _applyTextUtility(
    _GroupContext group,
    String raw,
    String root,
    TailwindValue? value,
    TailwindModifier? modifier,
  ) {
    if (root == 'text' || root == 'size') {
      if (_applyTextStyleUtility(() => group.textStyle, value, modifier)) {
        return true;
      }
    }

    switch (raw) {
      case 'text-left':
        group.textAlign = TextAlign.left;
        return true;
      case 'text-center':
        group.textAlign = TextAlign.center;
        return true;
      case 'text-right':
        group.textAlign = TextAlign.right;
        return true;
      case 'text-justify':
        group.textAlign = TextAlign.justify;
        return true;
      case 'text-start':
        group.textAlign = TextAlign.start;
        return true;
      case 'text-end':
        group.textAlign = TextAlign.end;
        return true;
      case 'uppercase':
        group.textDirectives.add(const UppercaseStringDirective());
        return true;
      case 'lowercase':
        group.textDirectives.add(const LowercaseStringDirective());
        return true;
      case 'capitalize':
        group.textDirectives.add(const CapitalizeStringDirective());
        return true;
      case 'truncate':
        group.overflow = TextOverflow.ellipsis;
        group.maxLines = 1;
        group.softWrap = false;
        return true;
      case 'leading-even':
        group.textHeightBehavior.leadingDistribution =
            TextLeadingDistribution.even;
        return true;
      case 'leading-trim':
        group.textHeightBehavior
          ..leadingDistribution = TextLeadingDistribution.even
          ..applyHeightToFirstAscent = false
          ..applyHeightToLastDescent = false;
        return true;
    }

    if (_applyFontWeight(group.textStyle, raw)) return true;
    if (_applyLineHeight(group.textStyle, raw)) return true;
    if (_applyTracking(group.textStyle, raw)) return true;
    if (_applyTextShadow(group.textStyle, raw)) return true;

    return false;
  }

  bool _applyDefaultTextUtility(
    _GroupContext group,
    String root,
    TailwindValue? value,
    TailwindModifier? modifier,
  ) {
    if (root == 'text' || root == 'size') {
      return _applyTextStyleUtility(
        () => group.ensureDefaultTextStyle(),
        value,
        modifier,
      );
    }

    return false;
  }

  bool _applyTextStyleUtility(
    _TextStyleAccum Function() style,
    TailwindValue? value,
    TailwindModifier? modifier,
  ) {
    final key = _valueKey(value);
    final size = key == null ? null : config.fontSizes[key];
    if (size != null) {
      final lineHeight = twDefaultLineHeights[key];
      style()
        ..fontSize = size
        ..height = lineHeight;
      return true;
    }

    final arbitraryLength = _arbitraryLength(value);
    if (arbitraryLength != null) {
      style().fontSize = arbitraryLength;
      return true;
    }

    final color = _color(value, modifier);
    if (color != null) {
      style().color = color;
      return true;
    }

    return false;
  }

  bool _applyDefaultTextStatic(_GroupContext group, String raw) {
    final style = group.ensureDefaultTextStyle();
    if (_applyFontWeight(style, raw)) return true;
    if (_applyTextShadow(style, raw)) return true;
    return false;
  }

  bool _applySpacing(
    _GroupContext group,
    String root,
    TailwindValue? value, {
    required bool negative,
  }) {
    final edges = switch (root) {
      'p' || 'px' || 'py' || 'pt' || 'pr' || 'pb' || 'pl' => group.padding,
      'm' || 'mx' || 'my' || 'mt' || 'mr' || 'mb' || 'ml' => group.margin,
      _ => null,
    };
    if (edges == null) return false;
    final length = _spaceLength(value, negative: negative);
    if (length == null) return false;
    if (identical(edges, group.margin) && length < 0) return true;
    edges.set(length, sides: _axisOrSide(root));
    return true;
  }

  bool _applySizing(
    _GroupContext group,
    String root,
    TailwindValue? value, {
    required bool negative,
  }) {
    if (!sizingRoots.contains(root)) return false;
    if (negative) return false;
    final length = _sizingLength(root, value);
    if (length == null) return _isWidgetLayerSize(value);

    switch (root) {
      case 'w':
        group.constraints
          ..minWidth = length
          ..maxWidth = length;
      case 'h':
        group.constraints
          ..minHeight = length
          ..maxHeight = length;
      case 'min-w':
        group.constraints.minWidth = length;
      case 'min-h':
        group.constraints.minHeight = length;
      case 'max-w':
        group.constraints.maxWidth = length;
      case 'max-h':
        group.constraints.maxHeight = length;
      default:
        return false;
    }

    return true;
  }

  bool _applyRadius(_GroupContext group, String root, TailwindValue? value) {
    if (!root.startsWith('rounded')) return false;
    final key = _valueKey(value) ?? '';
    final radius = config.radii[key];
    if (radius == null) return false;
    final corner = Radius.circular(radius);
    switch (root) {
      case 'rounded':
        group.decoration.borderRadius
          ..topLeft = corner
          ..topRight = corner
          ..bottomLeft = corner
          ..bottomRight = corner;
      case 'rounded-t':
        group.decoration.borderRadius
          ..topLeft = corner
          ..topRight = corner;
      case 'rounded-b':
        group.decoration.borderRadius
          ..bottomLeft = corner
          ..bottomRight = corner;
      case 'rounded-l':
        group.decoration.borderRadius
          ..topLeft = corner
          ..bottomLeft = corner;
      case 'rounded-r':
        group.decoration.borderRadius
          ..topRight = corner
          ..bottomRight = corner;
      case 'rounded-tl':
        group.decoration.borderRadius.topLeft = corner;
      case 'rounded-tr':
        group.decoration.borderRadius.topRight = corner;
      case 'rounded-bl':
        group.decoration.borderRadius.bottomLeft = corner;
      case 'rounded-br':
        group.decoration.borderRadius.bottomRight = corner;
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
    final runtime = runtimeVariantFor(variant, breakpoints: config.breakpoints);
    if (runtime == null) return null;

    return switch (runtime.kind) {
      TwRuntimeVariantKind.hover => _VariantPart(
        _VariantKind.hover,
        runtime.key,
      ),
      TwRuntimeVariantKind.focus => _VariantPart(
        _VariantKind.focus,
        runtime.key,
      ),
      TwRuntimeVariantKind.pressed => _VariantPart(
        _VariantKind.pressed,
        runtime.key,
      ),
      TwRuntimeVariantKind.disabled => _VariantPart(
        _VariantKind.disabled,
        runtime.key,
      ),
      TwRuntimeVariantKind.enabled => _VariantPart(
        _VariantKind.enabled,
        runtime.key,
      ),
      TwRuntimeVariantKind.dark => _VariantPart(_VariantKind.dark, runtime.key),
      TwRuntimeVariantKind.light => _VariantPart(
        _VariantKind.light,
        runtime.key,
      ),
      TwRuntimeVariantKind.breakpoint => _VariantPart.breakpoint(
        runtime.key,
        runtime.breakpoint!,
      ),
      TwRuntimeVariantKind.notHover => _VariantPart(
        _VariantKind.notHover,
        runtime.key,
      ),
    };
  }

  String _utilityRoot(TailwindUtility utility) {
    return tailwindUtilityRoot(utility);
  }

  TailwindValue? _utilityValue(TailwindUtility utility) {
    return tailwindUtilityValue(utility);
  }

  TailwindModifier? _utilityModifier(TailwindUtility utility) {
    return tailwindUtilityModifier(utility);
  }

  bool _utilityNegative(TailwindUtility utility) {
    return tailwindUtilityNegative(utility);
  }

  String? _valueKey(TailwindValue? value) {
    return tailwindValueKey(value);
  }

  bool _isSupportedWidgetLayerUtility(TailwindUtility utility) {
    if (_isBasisUtility(utility)) {
      return _isSupportedBasisUtility(utility);
    }

    return true;
  }

  bool _isBasisUtility(TailwindUtility utility) {
    final raw = utility.raw;
    return raw.startsWith('basis-') || _utilityRoot(utility) == 'basis';
  }

  bool _isSupportedBasisUtility(TailwindUtility utility) {
    if (_utilityNegative(utility)) return false;

    final key = _basisKey(utility);
    if (key == null || key.isEmpty) return false;
    if (key == 'auto') return true;

    return config.hasSpace(key);
  }

  String? _basisKey(TailwindUtility utility) {
    final raw = utility.raw;
    if (raw.startsWith('basis-')) {
      return raw.substring(6);
    }

    if (_utilityRoot(utility) == 'basis') {
      return _valueKey(_utilityValue(utility));
    }

    return null;
  }

  double? _spaceLength(TailwindValue? value, {required bool negative}) {
    final key = _valueKey(value);
    final resolved = key == null ? null : config.space[key];
    final length = resolved ?? _arbitraryLength(value);
    if (length == null) return null;
    return negative ? -length : length;
  }

  double? _sizingLength(String root, TailwindValue? value) {
    final key = _valueKey(value);
    if (root == 'max-w' && key != null) {
      final maxWidth = kTailwindMaxWidthPresets[key];
      if (maxWidth != null) return maxWidth;
    }

    return _spaceLength(value, negative: false);
  }

  double? _arbitraryLength(TailwindValue? value) {
    return value is TailwindArbitraryValue ? parseCssLength(value.value) : null;
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
    final percent = switch (modifier) {
      TailwindNamedModifier(:final raw) => double.tryParse(raw),
      TailwindArbitraryModifier(:final value) => _arbitraryOpacityPercent(
        value,
      ),
      TailwindCssVariableModifier() => null,
    };
    if (percent == null || percent < 0 || percent > 100) return null;
    return color.withAlpha((percent * 255 / 100).round());
  }

  /// Tailwind arbitrary opacity modifiers: `[50%]` is a 0–100 percentage,
  /// while `[0.5]` is a 0–1 alpha fraction. Both normalize to the 0–100 scale.
  double? _arbitraryOpacityPercent(String value) {
    if (value.contains('%')) return double.tryParse(value.replaceAll('%', ''));
    final fraction = double.tryParse(value);
    return fraction == null ? null : fraction * 100;
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

  List<BoxShadowMix>? _boxShadowMixes(String raw, TailwindValue? value) {
    final key = raw == 'shadow' ? 'shadow' : 'shadow-${_valueKey(value)}';
    final shadows = raw == 'shadow-none'
        ? const <BoxShadow>[]
        : kTailwindBoxShadowPresets[key];
    if (shadows == null) return null;
    return shadows.map(BoxShadowMix.value).toList(growable: false);
  }

  bool _applyFontWeight(_TextStyleAccum style, String raw) {
    final weight = switch (raw) {
      'font-thin' => FontWeight.w100,
      'font-extralight' => FontWeight.w200,
      'font-light' => FontWeight.w300,
      'font-normal' => FontWeight.w400,
      'font-medium' => FontWeight.w500,
      'font-semibold' => FontWeight.w600,
      'font-bold' => FontWeight.w700,
      'font-extrabold' => FontWeight.w800,
      'font-black' => FontWeight.w900,
      _ => null,
    };
    if (weight == null) return false;
    style.fontWeight = weight;
    return true;
  }

  bool _applyLineHeight(_TextStyleAccum style, String raw) {
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
    style.height = height;
    return true;
  }

  bool _applyTracking(_TextStyleAccum style, String raw) {
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
    style.letterSpacing = tracking;
    return true;
  }

  bool _applyTextShadow(_TextStyleAccum style, String raw) {
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
        ? const <Shadow>[]
        : kTextShadowPresets[preset]!;
    style.shadows = shadows.map(ShadowMix.value).toList(growable: false);
    return true;
  }

  bool _isWidgetLayerSize(TailwindValue? value) {
    final key = _valueKey(value);
    return key == 'full' ||
        key == 'screen' ||
        key == 'auto' ||
        key?.contains('/') == true;
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
}

const _easeTokens = {
  'ease-linear': Curves.linear,
  'ease-in': Curves.easeIn,
  'ease-out': Curves.easeOut,
  'ease-in-out': Curves.easeInOut,
};

const Object _missingTextShadowPreset = Object();

final class _GroupContext {
  _GroupContext(this.target);

  final TwTarget target;
  final padding = _EdgeAccum();
  final margin = _EdgeAccum();
  final constraints = _ConstraintsAccum();
  final decoration = _DecorationAccum();
  final modifiers = <ModifierMix>[];
  final textStyle = _TextStyleAccum();
  final defaultTextStyle = _TextStyleAccum();
  final textHeightBehavior = _TextHeightBehaviorAccum();
  final textDirectives = <Directive<String>>[];
  final transform = TransformAccum();
  final border = BorderAccum();
  final gradient = GradientAccum();
  int? _defaultTextStyleInsertIndex;

  Clip? clipBehavior;
  Axis? direction;
  MainAxisAlignment? mainAxisAlignment;
  CrossAxisAlignment? crossAxisAlignment;
  MainAxisSize? mainAxisSize;
  TextBaseline? textBaseline;
  double? spacing;
  TextAlign? textAlign;
  TextOverflow? overflow;
  int? maxLines;
  bool? softWrap;
  bool hasBaseFlex = false;

  _TextStyleAccum ensureDefaultTextStyle() {
    _defaultTextStyleInsertIndex ??= modifiers.length;
    return defaultTextStyle;
  }

  BoxStyler toBoxStyler(TwConfig config) {
    return BoxStyler(
      padding: padding.toMix(),
      margin: margin.toMix(),
      constraints: constraints.toMix(),
      decoration: _decorationMix(config),
      transform: transform.hasAnyTransform ? transform.toMatrix4() : null,
      clipBehavior: clipBehavior,
      modifier: _modifierConfig(),
    );
  }

  FlexBoxStyler toFlexBoxStyler(TwConfig config) {
    return FlexBoxStyler(
      padding: padding.toMix(),
      margin: margin.toMix(),
      constraints: constraints.toMix(),
      decoration: _decorationMix(config),
      transform: transform.hasAnyTransform ? transform.toMatrix4() : null,
      clipBehavior: clipBehavior,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      spacing: spacing,
      modifier: _modifierConfig(),
    );
  }

  TextStyler toTextStyler(TwConfig config) {
    return TextStyler(
      style: textStyle.toMix(defaultHeight: config.textDefaults.lineHeight),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textHeightBehavior: textHeightBehavior.toMix(),
      textDirectives: textDirectives.isEmpty
          ? null
          : List.unmodifiable(textDirectives),
      modifier: _modifierConfig(),
    );
  }

  BoxDecorationMix? _decorationMix(TwConfig config) {
    final gradientMix = gradient.toGradientMix(config.gradientStrategy);
    final borderMix = border.hasStructure
        ? border.toMix(
            defaultColor: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
          )
        : null;

    return decoration.toMix(border: borderMix, gradient: gradientMix);
  }

  WidgetModifierConfig? _modifierConfig() {
    if (modifiers.isEmpty && _defaultTextStyleInsertIndex == null) return null;

    final output = List<ModifierMix>.of(modifiers);
    if (_defaultTextStyleInsertIndex case final index?) {
      output.insert(
        index,
        DefaultTextStyleModifierMix(style: defaultTextStyle.toMix()),
      );
    }

    return WidgetModifierConfig.modifiers(output);
  }
}

final class _EdgeAccum {
  double? left;
  double? top;
  double? right;
  double? bottom;

  bool get hasAny =>
      left != null || top != null || right != null || bottom != null;

  void set(double value, {required String sides}) {
    switch (sides) {
      case 'all':
        left = top = right = bottom = value;
      case 'x':
        left = right = value;
      case 'y':
        top = bottom = value;
      case 'top':
        top = value;
      case 'right':
        right = value;
      case 'bottom':
        bottom = value;
      case 'left':
        left = value;
    }
  }

  EdgeInsetsMix? toMix() {
    if (!hasAny) return null;
    return EdgeInsetsMix(left: left, top: top, right: right, bottom: bottom);
  }
}

final class _ConstraintsAccum {
  double? minWidth;
  double? maxWidth;
  double? minHeight;
  double? maxHeight;

  bool get hasAny =>
      minWidth != null ||
      maxWidth != null ||
      minHeight != null ||
      maxHeight != null;

  BoxConstraintsMix? toMix() {
    if (!hasAny) return null;
    return BoxConstraintsMix(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }
}

final class _DecorationAccum {
  Color? color;
  List<BoxShadowMix>? boxShadow;
  bool ensurePresent = false;
  final borderRadius = _BorderRadiusAccum();

  bool get hasAny =>
      ensurePresent ||
      color != null ||
      boxShadow != null ||
      borderRadius.hasAny;

  BoxDecorationMix? toMix({BoxBorderMix? border, GradientMix? gradient}) {
    if (!hasAny && border == null && gradient == null) return null;
    return BoxDecorationMix(
      color: color,
      border: border,
      borderRadius: borderRadius.toMix(),
      boxShadow: boxShadow,
      gradient: gradient,
    );
  }
}

final class _BorderRadiusAccum {
  Radius? topLeft;
  Radius? topRight;
  Radius? bottomLeft;
  Radius? bottomRight;

  bool get hasAny =>
      topLeft != null ||
      topRight != null ||
      bottomLeft != null ||
      bottomRight != null;

  BorderRadiusMix? toMix() {
    if (!hasAny) return null;
    return BorderRadiusMix(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }
}

final class _TextStyleAccum {
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  TextDecoration? decoration;
  double? height;
  double? letterSpacing;
  List<ShadowMix>? shadows;

  bool get hasAny =>
      color != null ||
      fontSize != null ||
      fontWeight != null ||
      decoration != null ||
      height != null ||
      letterSpacing != null ||
      shadows != null;

  TextStyleMix? toMix({double? defaultHeight}) {
    final resolvedHeight = height ?? defaultHeight;
    if (!hasAny && resolvedHeight == null) return null;
    return TextStyleMix(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
      height: resolvedHeight,
      letterSpacing: letterSpacing,
      shadows: shadows,
    );
  }
}

final class _TextHeightBehaviorAccum {
  bool? applyHeightToFirstAscent;
  bool? applyHeightToLastDescent;
  TextLeadingDistribution? leadingDistribution;

  bool get hasAny =>
      applyHeightToFirstAscent != null ||
      applyHeightToLastDescent != null ||
      leadingDistribution != null;

  TextHeightBehaviorMix? toMix() {
    if (!hasAny) return null;
    return TextHeightBehaviorMix(
      applyHeightToFirstAscent: applyHeightToFirstAscent,
      applyHeightToLastDescent: applyHeightToLastDescent,
      leadingDistribution: leadingDistribution,
    );
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
