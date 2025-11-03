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
    for (final token in tokens) {
      final base = token.substring(token.lastIndexOf(':') + 1);
      if (base == 'flex' || base == 'flex-row' || base == 'flex-col') {
        return true;
      }
    }
    return false;
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
    var result = styler;
    var handled = true;

    if (token == 'flex' || token == 'flex-row') {
      result = styler.row();
    } else if (token == 'flex-col') {
      result = styler.column();
    } else if (token == 'items-start') {
      result = styler.crossAxisAlignment(CrossAxisAlignment.start);
    } else if (token == 'items-center') {
      result = styler.crossAxisAlignment(CrossAxisAlignment.center);
    } else if (token == 'items-end') {
      result = styler.crossAxisAlignment(CrossAxisAlignment.end);
    } else if (token == 'justify-start') {
      result = styler.mainAxisAlignment(MainAxisAlignment.start);
    } else if (token == 'justify-center') {
      result = styler.mainAxisAlignment(MainAxisAlignment.center);
    } else if (token == 'justify-end') {
      result = styler.mainAxisAlignment(MainAxisAlignment.end);
    } else if (token == 'justify-between') {
      result = styler.mainAxisAlignment(MainAxisAlignment.spaceBetween);
    } else if (token == 'justify-around') {
      result = styler.mainAxisAlignment(MainAxisAlignment.spaceAround);
    } else if (token == 'justify-evenly') {
      result = styler.mainAxisAlignment(MainAxisAlignment.spaceEvenly);
    } else if (token.startsWith('gap-')) {
      result = styler.spacing(config.spaceOf(token.substring(4)));
    } else if (token.startsWith('w-')) {
      result = styler.width(_sizeFrom(token.substring(2)));
    } else if (token.startsWith('h-')) {
      result = styler.height(_sizeFrom(token.substring(2)));
    } else if (token.startsWith('p-')) {
      result = styler.paddingAll(config.spaceOf(token.substring(2)));
    } else if (token.startsWith('px-')) {
      result = styler.paddingX(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('py-')) {
      result = styler.paddingY(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pt-')) {
      result = styler.paddingTop(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pr-')) {
      result = styler.paddingRight(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pb-')) {
      result = styler.paddingBottom(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pl-')) {
      result = styler.paddingLeft(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('m-')) {
      result = styler.marginAll(config.spaceOf(token.substring(2)));
    } else if (token.startsWith('mx-')) {
      result = styler.marginX(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('my-')) {
      result = styler.marginY(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mt-')) {
      result = styler.marginTop(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mr-')) {
      result = styler.marginRight(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mb-')) {
      result = styler.marginBottom(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('ml-')) {
      result = styler.marginLeft(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('bg-')) {
      final color = config.colorOf(token.substring(3));
      if (color != null) {
        result = styler.color(color);
      } else {
        handled = false;
      }
    } else if (token == 'border') {
      result = styler.borderAll(
        color: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
        width: 1,
      );
    } else if (token.startsWith('border-')) {
      final key = token.substring(7);
      final width = config.borderWidthOf(key, fallback: -1);
      if (width > 0) {
        result = styler.borderAll(
          color: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
          width: width,
        );
      } else {
        final color = config.colorOf(key);
        if (color != null) {
          result = styler.borderAll(color: color, width: 1);
        } else {
          handled = false;
        }
      }
    } else if (token == 'rounded' || token.startsWith('rounded-')) {
      final suffix = token == 'rounded' ? '' : token.substring(8);
      result = styler.borderRounded(config.radiusOf(suffix));
    } else if (token == 'shadow') {
      result = styler.elevation(ElevationShadow.two);
    } else if (token == 'shadow-md') {
      result = styler.elevation(ElevationShadow.four);
    } else if (token == 'shadow-lg') {
      result = styler.elevation(ElevationShadow.eight);
    } else if (token.startsWith('flex-')) {
      onUnsupported?.call(token);
    } else {
      handled = false;
    }

    if (!handled) {
      onUnsupported?.call(token);
    }

    return result;
  }

  BoxStyler _applyBoxAtomic(BoxStyler styler, String token) {
    var result = styler;
    var handled = true;

    if (token.startsWith('w-')) {
      result = styler.width(_sizeFrom(token.substring(2)));
    } else if (token.startsWith('h-')) {
      result = styler.height(_sizeFrom(token.substring(2)));
    } else if (token.startsWith('p-')) {
      result = styler.paddingAll(config.spaceOf(token.substring(2)));
    } else if (token.startsWith('px-')) {
      result = styler.paddingX(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('py-')) {
      result = styler.paddingY(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pt-')) {
      result = styler.paddingTop(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pr-')) {
      result = styler.paddingRight(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pb-')) {
      result = styler.paddingBottom(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('pl-')) {
      result = styler.paddingLeft(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('m-')) {
      result = styler.marginAll(config.spaceOf(token.substring(2)));
    } else if (token.startsWith('mx-')) {
      result = styler.marginX(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('my-')) {
      result = styler.marginY(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mt-')) {
      result = styler.marginTop(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mr-')) {
      result = styler.marginRight(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('mb-')) {
      result = styler.marginBottom(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('ml-')) {
      result = styler.marginLeft(config.spaceOf(token.substring(3)));
    } else if (token.startsWith('bg-')) {
      final color = config.colorOf(token.substring(3));
      if (color != null) {
        result = styler.color(color);
      } else {
        handled = false;
      }
    } else if (token == 'border') {
      result = styler.borderAll(
        color: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
        width: 1,
      );
    } else if (token.startsWith('border-')) {
      final key = token.substring(7);
      final width = config.borderWidthOf(key, fallback: -1);
      if (width > 0) {
        result = styler.borderAll(
          color: config.colorOf('gray-200') ?? const Color(0xFFE5E7EB),
          width: width,
        );
      } else {
        final color = config.colorOf(key);
        if (color != null) {
          result = styler.borderAll(color: color, width: 1);
        } else {
          handled = false;
        }
      }
    } else if (token == 'rounded' || token.startsWith('rounded-')) {
      final suffix = token == 'rounded' ? '' : token.substring(8);
      result = styler.borderRounded(config.radiusOf(suffix));
    } else if (token == 'shadow') {
      result = styler.elevation(ElevationShadow.two);
    } else if (token == 'shadow-md') {
      result = styler.elevation(ElevationShadow.four);
    } else if (token == 'shadow-lg') {
      result = styler.elevation(ElevationShadow.eight);
    } else if (token.startsWith('text-')) {
      final color = config.colorOf(token.substring(5));
      if (color != null) {
        result = styler.wrapDefaultTextStyle(TextStyleMix().color(color));
      } else {
        final size = config.fontSizeOf(token.substring(5), fallback: -1);
        if (size > 0) {
          result = styler.wrapDefaultTextStyle(TextStyleMix().fontSize(size));
        } else {
          handled = false;
        }
      }
    } else if (token == 'font-bold') {
      result = styler.wrapDefaultTextStyle(
        TextStyleMix().fontWeight(FontWeight.w700),
      );
    } else if (token == 'font-semibold') {
      result = styler.wrapDefaultTextStyle(
        TextStyleMix().fontWeight(FontWeight.w600),
      );
    } else if (token == 'font-medium') {
      result = styler.wrapDefaultTextStyle(
        TextStyleMix().fontWeight(FontWeight.w500),
      );
    } else {
      handled = false;
    }

    if (!handled) {
      onUnsupported?.call(token);
    }

    return result;
  }

  TextStyler _applyTextAtomic(TextStyler styler, String token) {
    var result = styler;
    var handled = true;

    if (token.startsWith('text-')) {
      final color = config.colorOf(token.substring(5));
      if (color != null) {
        result = styler.color(color);
      } else {
        final size = config.fontSizeOf(token.substring(5), fallback: -1);
        if (size > 0) {
          result = styler.fontSize(size);
        } else {
          handled = false;
        }
      }
    } else if (token == 'uppercase') {
      result = styler.uppercase();
    } else if (token == 'lowercase') {
      result = styler.lowercase();
    } else if (token == 'capitalize') {
      result = styler.capitalize();
    } else if (token == 'font-bold') {
      result = styler.fontWeight(FontWeight.w700);
    } else if (token == 'font-semibold') {
      result = styler.fontWeight(FontWeight.w600);
    } else if (token == 'font-medium') {
      result = styler.fontWeight(FontWeight.w500);
    } else if (token == 'font-light') {
      result = styler.fontWeight(FontWeight.w300);
    } else {
      handled = false;
    }

    if (!handled) {
      onUnsupported?.call(token);
    }

    return result;
  }

  double _sizeFrom(String key) {
    if (key == 'full' || key == 'screen') {
      return double.infinity;
    }
    return config.spaceOf(key, fallback: 0);
  }
}
