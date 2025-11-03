import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'tw_config.dart';

typedef Warn = void Function(String token);

/// Parses Tailwind-like class strings into Mix stylers.
class TwParserV2 {
  TwParserV2({TwConfig? config, this.onUnsupported})
    : config = config ?? TwConfig.standard();

  final TwConfig config;
  final Warn? onUnsupported;

  List<String> listTokens(String classNames) {
    final trimmed = classNames.trim();
    if (trimmed.isEmpty) {
      return const [];
    }
    return trimmed.split(RegExp(r'\s+'));
  }

  Set<String> setTokens(String classNames) => listTokens(classNames).toSet();

  bool wantsFlex(Set<String> tokens) {
    return tokens.contains('flex') ||
        tokens.contains('flex-row') ||
        tokens.contains('flex-col');
  }

  FlexBoxStyler parseFlex(String classNames) {
    var styler = FlexBoxStyler();
    for (final token in listTokens(classNames)) {
      styler = _applyFlexToken(styler, token);
    }
    return styler;
  }

  BoxStyler parseBox(String classNames) {
    var styler = BoxStyler();
    for (final token in listTokens(classNames)) {
      styler = _applyBoxToken(styler, token);
    }
    return styler;
  }

  TextStyler parseText(String classNames) {
    var styler = TextStyler();
    for (final token in listTokens(classNames)) {
      styler = _applyTextToken(styler, token);
    }
    return styler;
  }

  FlexBoxStyler _applyFlexToken(FlexBoxStyler base, String token) {
    final prefixIndex = token.indexOf(':');
    if (prefixIndex > 0) {
      final head = token.substring(0, prefixIndex);
      final tail = token.substring(prefixIndex + 1);
      if (_isBreakpoint(head)) {
        final min = config.breakpointOf(head);
        return base.onBreakpoint(
          Breakpoint(minWidth: min),
          _applyFlexToken(FlexBoxStyler(), tail),
        );
      }
      switch (head) {
        case 'hover':
          return base.onHovered(_applyFlexToken(FlexBoxStyler(), tail));
        case 'focus':
          return base.onFocused(_applyFlexToken(FlexBoxStyler(), tail));
        case 'active':
        case 'pressed':
          return base.onPressed(_applyFlexToken(FlexBoxStyler(), tail));
        case 'disabled':
          return base.onDisabled(_applyFlexToken(FlexBoxStyler(), tail));
        case 'enabled':
          return base.onEnabled(_applyFlexToken(FlexBoxStyler(), tail));
        case 'dark':
          return base.onDark(_applyFlexToken(FlexBoxStyler(), tail));
        case 'light':
          return base.onLight(_applyFlexToken(FlexBoxStyler(), tail));
        default:
          return base;
      }
    }
    return _applyFlexAtomic(base, token);
  }

  BoxStyler _applyBoxToken(BoxStyler base, String token) {
    final prefixIndex = token.indexOf(':');
    if (prefixIndex > 0) {
      final head = token.substring(0, prefixIndex);
      final tail = token.substring(prefixIndex + 1);
      if (_isBreakpoint(head)) {
        final min = config.breakpointOf(head);
        return base.onBreakpoint(
          Breakpoint(minWidth: min),
          _applyBoxToken(BoxStyler(), tail),
        );
      }
      switch (head) {
        case 'hover':
          return base.onHovered(_applyBoxToken(BoxStyler(), tail));
        case 'focus':
          return base.onFocused(_applyBoxToken(BoxStyler(), tail));
        case 'active':
        case 'pressed':
          return base.onPressed(_applyBoxToken(BoxStyler(), tail));
        case 'disabled':
          return base.onDisabled(_applyBoxToken(BoxStyler(), tail));
        case 'enabled':
          return base.onEnabled(_applyBoxToken(BoxStyler(), tail));
        case 'dark':
          return base.onDark(_applyBoxToken(BoxStyler(), tail));
        case 'light':
          return base.onLight(_applyBoxToken(BoxStyler(), tail));
        default:
          return base;
      }
    }
    return _applyBoxAtomic(base, token);
  }

  TextStyler _applyTextToken(TextStyler base, String token) {
    final prefixIndex = token.indexOf(':');
    if (prefixIndex > 0) {
      final head = token.substring(0, prefixIndex);
      final tail = token.substring(prefixIndex + 1);
      if (_isBreakpoint(head)) {
        final min = config.breakpointOf(head);
        return base.onBreakpoint(
          Breakpoint(minWidth: min),
          _applyTextToken(TextStyler(), tail),
        );
      }
      switch (head) {
        case 'hover':
          return base.onHovered(_applyTextToken(TextStyler(), tail));
        case 'focus':
          return base.onFocused(_applyTextToken(TextStyler(), tail));
        case 'active':
        case 'pressed':
          return base.onPressed(_applyTextToken(TextStyler(), tail));
        case 'disabled':
          return base.onDisabled(_applyTextToken(TextStyler(), tail));
        case 'enabled':
          return base.onEnabled(_applyTextToken(TextStyler(), tail));
        case 'dark':
          return base.onDark(_applyTextToken(TextStyler(), tail));
        case 'light':
          return base.onLight(_applyTextToken(TextStyler(), tail));
        default:
          return base;
      }
    }
    return _applyTextAtomic(base, token);
  }

  bool _isBreakpoint(String prefix) {
    return prefix == 'sm' ||
        prefix == 'md' ||
        prefix == 'lg' ||
        prefix == 'xl';
  }

  FlexBoxStyler _applyFlexAtomic(FlexBoxStyler styler, String token) {
    if (token == 'flex' || token == 'flex-row') {
      return styler.row();
    }
    if (token == 'flex-col') {
      return styler.column();
    }

    if (token == 'items-start') {
      return styler.crossAxisAlignment(CrossAxisAlignment.start);
    }
    if (token == 'items-center') {
      return styler.crossAxisAlignment(CrossAxisAlignment.center);
    }
    if (token == 'items-end') {
      return styler.crossAxisAlignment(CrossAxisAlignment.end);
    }

    if (token == 'justify-start') {
      return styler.mainAxisAlignment(MainAxisAlignment.start);
    }
    if (token == 'justify-center') {
      return styler.mainAxisAlignment(MainAxisAlignment.center);
    }
    if (token == 'justify-end') {
      return styler.mainAxisAlignment(MainAxisAlignment.end);
    }
    if (token == 'justify-between') {
      return styler.mainAxisAlignment(MainAxisAlignment.spaceBetween);
    }
    if (token == 'justify-around') {
      return styler.mainAxisAlignment(MainAxisAlignment.spaceAround);
    }
    if (token == 'justify-evenly') {
      return styler.mainAxisAlignment(MainAxisAlignment.spaceEvenly);
    }

    if (token.startsWith('gap-')) {
      return styler.spacing(config.spaceOf(token.substring(4)));
    }

    if (token.startsWith('w-')) {
      return styler.width(_sizeFrom(token.substring(2)));
    }
    if (token.startsWith('h-')) {
      return styler.height(_sizeFrom(token.substring(2)));
    }

    if (token.startsWith('p-')) {
      return styler.paddingAll(config.spaceOf(token.substring(2)));
    }
    if (token.startsWith('px-')) {
      return styler.paddingX(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('py-')) {
      return styler.paddingY(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('pt-')) {
      return styler.paddingTop(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('pr-')) {
      return styler.paddingRight(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('pb-')) {
      return styler.paddingBottom(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('pl-')) {
      return styler.paddingLeft(config.spaceOf(token.substring(3)));
    }

    if (token.startsWith('m-')) {
      return styler.marginAll(config.spaceOf(token.substring(2)));
    }
    if (token.startsWith('mx-')) {
      return styler.marginX(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('my-')) {
      return styler.marginY(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('mt-')) {
      return styler.marginTop(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('mr-')) {
      return styler.marginRight(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('mb-')) {
      return styler.marginBottom(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('ml-')) {
      return styler.marginLeft(config.spaceOf(token.substring(3)));
    }

    if (token.startsWith('bg-')) {
      final color = config.colorOf(token.substring(3));
      if (color != null) {
        return styler.color(color);
      }
    }

    if (token == 'border') {
      return styler.borderAll(
        color: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
        width: 1,
      );
    }
    if (token.startsWith('border-')) {
      final key = token.substring(7);
      final width = config.borderWidthOf(key, fallback: -1);
      if (width > 0) {
        return styler.borderAll(
          color: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
          width: width,
        );
      }
      final color = config.colorOf(key);
      if (color != null) {
        return styler.borderAll(color: color, width: 1);
      }
    }

    if (token == 'rounded' || token.startsWith('rounded-')) {
      final suffix = token == 'rounded' ? '' : token.substring(8);
      return styler.borderRounded(config.radiusOf(suffix));
    }

    if (token == 'shadow') {
      return styler.elevation(ElevationShadow.two);
    }
    if (token == 'shadow-md') {
      return styler.elevation(ElevationShadow.four);
    }
    if (token == 'shadow-lg') {
      return styler.elevation(ElevationShadow.eight);
    }

    if (token.startsWith('flex-')) {
      onUnsupported?.call(token);
      return styler;
    }

    return styler;
  }

  BoxStyler _applyBoxAtomic(BoxStyler styler, String token) {
    if (token.startsWith('w-')) {
      return styler.width(_sizeFrom(token.substring(2)));
    }
    if (token.startsWith('h-')) {
      return styler.height(_sizeFrom(token.substring(2)));
    }

    if (token.startsWith('p-')) {
      return styler.paddingAll(config.spaceOf(token.substring(2)));
    }
    if (token.startsWith('px-')) {
      return styler.paddingX(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('py-')) {
      return styler.paddingY(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('pt-')) {
      return styler.paddingTop(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('pr-')) {
      return styler.paddingRight(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('pb-')) {
      return styler.paddingBottom(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('pl-')) {
      return styler.paddingLeft(config.spaceOf(token.substring(3)));
    }

    if (token.startsWith('m-')) {
      return styler.marginAll(config.spaceOf(token.substring(2)));
    }
    if (token.startsWith('mx-')) {
      return styler.marginX(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('my-')) {
      return styler.marginY(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('mt-')) {
      return styler.marginTop(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('mr-')) {
      return styler.marginRight(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('mb-')) {
      return styler.marginBottom(config.spaceOf(token.substring(3)));
    }
    if (token.startsWith('ml-')) {
      return styler.marginLeft(config.spaceOf(token.substring(3)));
    }

    if (token.startsWith('bg-')) {
      final color = config.colorOf(token.substring(3));
      if (color != null) {
        return styler.color(color);
      }
    }

    if (token == 'border') {
      return styler.borderAll(
        color: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
        width: 1,
      );
    }
    if (token.startsWith('border-')) {
      final key = token.substring(7);
      final width = config.borderWidthOf(key, fallback: -1);
      if (width > 0) {
        return styler.borderAll(
          color: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
          width: width,
        );
      }
      final color = config.colorOf(key);
      if (color != null) {
        return styler.borderAll(color: color, width: 1);
      }
    }

    if (token == 'rounded' || token.startsWith('rounded-')) {
      final suffix = token == 'rounded' ? '' : token.substring(8);
      return styler.borderRounded(config.radiusOf(suffix));
    }

    if (token == 'shadow') {
      return styler.elevation(ElevationShadow.two);
    }
    if (token == 'shadow-md') {
      return styler.elevation(ElevationShadow.four);
    }
    if (token == 'shadow-lg') {
      return styler.elevation(ElevationShadow.eight);
    }

    if (token.startsWith('text-')) {
      final color = config.colorOf(token.substring(5));
      if (color != null) {
        return styler.wrapDefaultTextStyle(TextStyleMix().color(color));
      }
      final size = config.fontSizeOf(token.substring(5), fallback: -1);
      if (size > 0) {
        return styler.wrapDefaultTextStyle(TextStyleMix().fontSize(size));
      }
    }
    if (token == 'font-bold') {
      return styler.wrapDefaultTextStyle(
        TextStyleMix().fontWeight(FontWeight.w700),
      );
    }
    if (token == 'font-semibold') {
      return styler.wrapDefaultTextStyle(
        TextStyleMix().fontWeight(FontWeight.w600),
      );
    }
    if (token == 'font-medium') {
      return styler.wrapDefaultTextStyle(
        TextStyleMix().fontWeight(FontWeight.w500),
      );
    }

    return styler;
  }

  TextStyler _applyTextAtomic(TextStyler styler, String token) {
    if (token.startsWith('text-')) {
      final color = config.colorOf(token.substring(5));
      if (color != null) {
        return styler.color(color);
      }
      final size = config.fontSizeOf(token.substring(5), fallback: -1);
      if (size > 0) {
        return styler.fontSize(size);
      }
    }
    if (token == 'uppercase') {
      return styler.uppercase();
    }
    if (token == 'lowercase') {
      return styler.lowercase();
    }
    if (token == 'capitalize') {
      return styler.capitalize();
    }
    if (token == 'font-bold') {
      return styler.fontWeight(FontWeight.w700);
    }
    if (token == 'font-semibold') {
      return styler.fontWeight(FontWeight.w600);
    }
    if (token == 'font-medium') {
      return styler.fontWeight(FontWeight.w500);
    }
    if (token == 'font-light') {
      return styler.fontWeight(FontWeight.w300);
    }
    return styler;
  }

  double _sizeFrom(String key) {
    if (key == 'full' || key == 'screen') {
      return double.infinity;
    }
    return config.spaceOf(key, fallback: 0);
  }
}
