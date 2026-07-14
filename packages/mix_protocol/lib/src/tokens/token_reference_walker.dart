import 'dart:collection';

import 'package:flutter/painting.dart';
import 'package:mix/mix.dart';

/// A token reference used by a decoded Mix protocol style document.
///
/// [kind] matches the theme document group name (`colors`, `spaces`, etc.).
/// [name] is the token name within that group.
final class MixProtocolTokenReference {
  const MixProtocolTokenReference(this.kind, this.name);

  factory MixProtocolTokenReference.fromToken(MixToken<dynamic> token) {
    return MixProtocolTokenReference(_kindForToken(token), token.name);
  }

  final String kind;
  final String name;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MixProtocolTokenReference &&
            other.kind == kind &&
            other.name == name;
  }

  @override
  int get hashCode => Object.hash(kind, name);

  @override
  String toString() => 'MixProtocolTokenReference($kind, $name)';
}

/// Returns the unique theme token references used by a decoded Mix style.
Set<MixProtocolTokenReference> tokenReferencesOf(Object? style) {
  final walker = _TokenReferenceWalker()..visit(style);

  return Set.unmodifiable(walker.references);
}

String _kindForToken(MixToken<dynamic> token) {
  if (token.runtimeType == ColorToken) return 'colors';
  if (token.runtimeType == SpaceToken) return 'spaces';
  if (token.runtimeType == DoubleToken) return 'doubles';
  if (token.runtimeType == RadiusToken) return 'radii';
  if (token.runtimeType == TextStyleToken) return 'textStyles';
  if (token.runtimeType == ShadowToken) return 'shadows';
  if (token.runtimeType == BoxShadowToken) return 'boxShadows';
  if (token.runtimeType == BorderSideToken) return 'borders';
  if (token.runtimeType == FontWeightToken) return 'fontWeights';
  if (token.runtimeType == BreakpointToken) return 'breakpoints';
  if (token.runtimeType == DurationToken) return 'durations';

  return 'custom:${token.runtimeType}';
}

final class _TokenReferenceWalker {
  final Set<MixProtocolTokenReference> references = {};
  final HashSet<Object> _seen = HashSet.identity();

  void visit(Object? value) {
    if (value == null) return;

    final token = tokenFromReferenceValue<dynamic>(value);
    if (token != null) {
      _addToken(token);

      return;
    }

    if (value is MixToken<dynamic>) {
      _addToken(value);

      return;
    }

    if (value is Prop<dynamic>) {
      _visitProp(value);

      return;
    }

    if (value is BreakpointRef) {
      _addToken(value.token);

      return;
    }

    if (value is Iterable<Object?>) {
      for (final item in value) {
        visit(item);
      }

      return;
    }

    if (value is Map<Object?, Object?>) {
      for (final entry in value.entries) {
        visit(entry.key);
        visit(entry.value);
      }

      return;
    }

    if (!_seen.add(value)) return;

    if (value is Style<dynamic>) {
      _visitStyle(value);

      return;
    }

    if (value is VariantStyle<dynamic>) {
      _visitVariantStyle(value);

      return;
    }

    if (value is Variant) {
      _visitVariant(value);

      return;
    }

    if (value is WidgetModifierConfig) {
      visit(value.$modifiers);

      return;
    }

    if (value is ModifierMix<dynamic>) {
      _visitModifier(value);

      return;
    }

    if (value is CurveAnimationConfig) {
      visit(value.duration);
      visit(value.delay);

      return;
    }

    if (value is TextStyle) {
      _visitTextStyle(value);

      return;
    }

    if (value is BoxShadow) {
      _visitBoxShadow(value);

      return;
    }

    if (value is Shadow) {
      _visitShadow(value);

      return;
    }

    if (value is BorderSide) {
      _visitBorderSide(value);

      return;
    }

    _visitMixValue(value);
  }

  void _addToken(MixToken<dynamic> token) {
    references.add(MixProtocolTokenReference.fromToken(token));
  }

  void _visitProp(Prop<dynamic> prop) {
    for (final source in prop.sources) {
      switch (source) {
        case TokenSource<dynamic>():
          _addToken(source.token);
        case MixSource<dynamic>():
          visit(source.mix);
        case ValueSource<dynamic>():
          visit(source.value);
      }
    }
  }

  void _visitStyle(Style<dynamic> style) {
    visit(style.$variants);
    visit(style.$modifier);
    visit(style.$animation);

    switch (style) {
      case BoxStyler():
        visit(style.$alignment);
        visit(style.$padding);
        visit(style.$margin);
        visit(style.$constraints);
        visit(style.$decoration);
        visit(style.$foregroundDecoration);
        visit(style.$transform);
        visit(style.$transformAlignment);
        visit(style.$clipBehavior);
      case TextStyler():
        visit(style.$overflow);
        visit(style.$strutStyle);
        visit(style.$textAlign);
        visit(style.$textScaler);
        visit(style.$maxLines);
        visit(style.$style);
        visit(style.$textWidthBasis);
        visit(style.$textHeightBehavior);
        visit(style.$textDirection);
        visit(style.$softWrap);
        visit(style.$selectionColor);
        visit(style.$semanticsLabel);
        visit(style.$locale);
      case FlexStyler():
        visit(style.$direction);
        visit(style.$mainAxisAlignment);
        visit(style.$crossAxisAlignment);
        visit(style.$mainAxisSize);
        visit(style.$verticalDirection);
        visit(style.$textDirection);
        visit(style.$textBaseline);
        visit(style.$clipBehavior);
        visit(style.$spacing);
      case StackStyler():
        visit(style.$alignment);
        visit(style.$fit);
        visit(style.$textDirection);
        visit(style.$clipBehavior);
      case IconStyler():
        visit(style.$icon);
        visit(style.$color);
        visit(style.$size);
        visit(style.$weight);
        visit(style.$grade);
        visit(style.$opticalSize);
        visit(style.$shadows);
        visit(style.$textDirection);
        visit(style.$applyTextScaling);
        visit(style.$fill);
        visit(style.$semanticsLabel);
        visit(style.$opacity);
        visit(style.$blendMode);
      case ImageStyler():
        visit(style.$image);
        visit(style.$width);
        visit(style.$height);
        visit(style.$color);
        visit(style.$repeat);
        visit(style.$fit);
        visit(style.$alignment);
        visit(style.$centerSlice);
        visit(style.$filterQuality);
        visit(style.$colorBlendMode);
        visit(style.$semanticLabel);
        visit(style.$excludeFromSemantics);
        visit(style.$gaplessPlayback);
        visit(style.$isAntiAlias);
        visit(style.$matchTextDirection);
      case FlexBoxStyler():
        visit(style.$box);
        visit(style.$flex);
      case StackBoxStyler():
        visit(style.$box);
        visit(style.$stack);
      default:
        break;
    }
  }

  void _visitVariantStyle(VariantStyle<dynamic> value) {
    _visitVariant(value.variant);
    visit(value.value);
  }

  void _visitVariant(Variant variant) {
    switch (variant) {
      case BreakpointVariant():
        visit(variant.breakpoint);
      case NotVariant():
        _visitVariant(variant.inner);
      default:
        break;
    }
  }

  void _visitModifier(ModifierMix<dynamic> modifier) {
    switch (modifier) {
      case OpacityModifierMix():
        visit(modifier.opacity);
      case BlurModifierMix():
        visit(modifier.sigma);
      case FlexibleModifierMix():
        visit(modifier.flex);
        visit(modifier.fit);
      case DefaultTextStyleModifierMix():
        visit(modifier.style);
        visit(modifier.textAlign);
        visit(modifier.softWrap);
        visit(modifier.overflow);
        visit(modifier.maxLines);
        visit(modifier.textWidthBasis);
        visit(modifier.textHeightBehavior);
      case DefaultTextStylerModifierMix():
        visit(modifier.style);
      case BoxModifierMix():
        visit(modifier.spec);
      case IconThemeModifierMix():
        visit(modifier.color);
        visit(modifier.size);
        visit(modifier.fill);
        visit(modifier.weight);
        visit(modifier.grade);
        visit(modifier.opticalSize);
        visit(modifier.opacity);
        visit(modifier.shadows);
        visit(modifier.applyTextScaling);
      default:
        break;
    }
  }

  void _visitTextStyle(TextStyle value) {
    visit(value.color);
    visit(value.backgroundColor);
    visit(value.fontSize);
    visit(value.fontWeight);
    visit(value.letterSpacing);
    visit(value.wordSpacing);
    visit(value.height);
    visit(value.decorationColor);
    visit(value.decorationThickness);
    visit(value.shadows);
  }

  void _visitShadow(Shadow value) {
    visit(value.color);
    visit(value.blurRadius);
  }

  void _visitBoxShadow(BoxShadow value) {
    _visitShadow(value);
    visit(value.spreadRadius);
  }

  void _visitBorderSide(BorderSide value) {
    visit(value.color);
    visit(value.width);
    visit(value.strokeAlign);
  }

  void _visitMixValue(Object value) {
    switch (value) {
      case EdgeInsetsMix():
        visit(value.$top);
        visit(value.$bottom);
        visit(value.$left);
        visit(value.$right);
      case EdgeInsetsDirectionalMix():
        visit(value.$top);
        visit(value.$bottom);
        visit(value.$start);
        visit(value.$end);
      case BoxConstraintsMix():
        visit(value.$minWidth);
        visit(value.$maxWidth);
        visit(value.$minHeight);
        visit(value.$maxHeight);
      case BoxDecorationMix():
        visit(value.$color);
        visit(value.$gradient);
        visit(value.$image);
        visit(value.$boxShadow);
        visit(value.$border);
        visit(value.$borderRadius);
        visit(value.$shape);
        visit(value.$backgroundBlendMode);
      case ShapeDecorationMix():
        visit(value.$color);
        visit(value.$gradient);
        visit(value.$image);
        visit(value.$boxShadow);
        visit(value.$shape);
      case BorderMix():
        visit(value.$top);
        visit(value.$bottom);
        visit(value.$left);
        visit(value.$right);
      case BorderDirectionalMix():
        visit(value.$top);
        visit(value.$bottom);
        visit(value.$start);
        visit(value.$end);
      case BorderSideMix():
        visit(value.$color);
        visit(value.$width);
        visit(value.$style);
        visit(value.$strokeAlign);
      case BorderRadiusMix():
        visit(value.$topLeft);
        visit(value.$topRight);
        visit(value.$bottomLeft);
        visit(value.$bottomRight);
      case BorderRadiusDirectionalMix():
        visit(value.$topStart);
        visit(value.$topEnd);
        visit(value.$bottomStart);
        visit(value.$bottomEnd);
      case TextStyleMix():
        visit(value.$color);
        visit(value.$backgroundColor);
        visit(value.$fontSize);
        visit(value.$fontWeight);
        visit(value.$fontStyle);
        visit(value.$letterSpacing);
        visit(value.$debugLabel);
        visit(value.$wordSpacing);
        visit(value.$textBaseline);
        visit(value.$decoration);
        visit(value.$decorationColor);
        visit(value.$decorationStyle);
        visit(value.$height);
        visit(value.$decorationThickness);
        visit(value.$fontFamily);
        visit(value.$foreground);
        visit(value.$background);
        visit(value.$inherit);
        visit(value.$fontFamilyFallback);
        visit(value.$fontFeatures);
        visit(value.$fontVariations);
        visit(value.$shadows);
      case TextHeightBehaviorMix():
        visit(value.$applyHeightToFirstAscent);
        visit(value.$applyHeightToLastDescent);
        visit(value.$leadingDistribution);
      case ShadowMix():
        visit(value.$color);
        visit(value.$offset);
        visit(value.$blurRadius);
      case BoxShadowMix():
        visit(value.$color);
        visit(value.$offset);
        visit(value.$blurRadius);
        visit(value.$spreadRadius);
      case ShadowListMix():
        visit(value.items);
      case BoxShadowListMix():
        visit(value.items);
      default:
        break;
    }
  }
}
