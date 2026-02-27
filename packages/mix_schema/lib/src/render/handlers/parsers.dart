import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Value parsers — convert dynamic/string wire values to Flutter types.
// ---------------------------------------------------------------------------

Color? parseColor(dynamic resolved) {
  if (resolved is Color) return resolved;
  if (resolved is String) {
    final hex = resolved.replaceFirst('#', '');
    final intVal = int.tryParse(hex, radix: 16);
    if (intVal != null) {
      if (hex.length == 6) return Color(0xFF000000 | intVal);
      if (hex.length == 8) return Color(intVal);
    }
  }
  return null;
}

double toDouble(dynamic v) {
  if (v is double) return v;
  if (v is num) return v.toDouble();
  return 0.0;
}

int toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return 0;
}

FontWeight parseFontWeight(dynamic value) => switch (value) {
      FontWeight w => w,
      'thin' || 'w100' || '100' => FontWeight.w100,
      'extraLight' || 'w200' || '200' => FontWeight.w200,
      'light' || 'w300' || '300' => FontWeight.w300,
      'normal' || 'regular' || 'w400' || '400' => FontWeight.w400,
      'medium' || 'w500' || '500' => FontWeight.w500,
      'semiBold' || 'w600' || '600' => FontWeight.w600,
      'bold' || 'w700' || '700' => FontWeight.w700,
      'extraBold' || 'w800' || '800' => FontWeight.w800,
      'black' || 'w900' || '900' => FontWeight.w900,
      _ => FontWeight.w400,
    };

TextOverflow parseTextOverflow(String value) => switch (value) {
      'ellipsis' => TextOverflow.ellipsis,
      'clip' => TextOverflow.clip,
      'fade' => TextOverflow.fade,
      'visible' => TextOverflow.visible,
      _ => TextOverflow.clip,
    };

Clip parseClip(String value) => switch (value) {
      'none' => Clip.none,
      'hardEdge' => Clip.hardEdge,
      'antiAlias' => Clip.antiAlias,
      'antiAliasWithSaveLayer' => Clip.antiAliasWithSaveLayer,
      _ => Clip.none,
    };

CrossAxisAlignment parseCrossAxis(String value) => switch (value) {
      'start' => CrossAxisAlignment.start,
      'end' => CrossAxisAlignment.end,
      'center' => CrossAxisAlignment.center,
      'stretch' => CrossAxisAlignment.stretch,
      'baseline' => CrossAxisAlignment.baseline,
      _ => CrossAxisAlignment.start,
    };

MainAxisAlignment parseMainAxis(String value) => switch (value) {
      'start' => MainAxisAlignment.start,
      'end' => MainAxisAlignment.end,
      'center' => MainAxisAlignment.center,
      'spaceBetween' => MainAxisAlignment.spaceBetween,
      'spaceAround' => MainAxisAlignment.spaceAround,
      'spaceEvenly' => MainAxisAlignment.spaceEvenly,
      _ => MainAxisAlignment.start,
    };

AlignmentGeometry parseAlignment(String value) => switch (value) {
      'topLeft' => Alignment.topLeft,
      'topCenter' => Alignment.topCenter,
      'topRight' => Alignment.topRight,
      'centerLeft' => Alignment.centerLeft,
      'center' => Alignment.center,
      'centerRight' => Alignment.centerRight,
      'bottomLeft' => Alignment.bottomLeft,
      'bottomCenter' => Alignment.bottomCenter,
      'bottomRight' => Alignment.bottomRight,
      _ => Alignment.center,
    };

Curve parseCurve(String? name) => switch (name) {
      'linear' => Curves.linear,
      'easeIn' => Curves.easeIn,
      'easeOut' => Curves.easeOut,
      'easeInOut' => Curves.easeInOut,
      'bounceIn' => Curves.bounceIn,
      'bounceOut' => Curves.bounceOut,
      'elasticIn' => Curves.elasticIn,
      'elasticOut' => Curves.elasticOut,
      _ => Curves.easeOut,
    };

BoxFit parseBoxFit(String value) => switch (value) {
      'contain' => BoxFit.contain,
      'cover' => BoxFit.cover,
      'fill' => BoxFit.fill,
      'fitWidth' => BoxFit.fitWidth,
      'fitHeight' => BoxFit.fitHeight,
      'none' => BoxFit.none,
      'scaleDown' => BoxFit.scaleDown,
      _ => BoxFit.contain,
    };

/// Resolve a Material Icons icon name to IconData.
IconData resolveIconData(dynamic value) {
  if (value is IconData) return value;
  if (value is int) return IconData(value, fontFamily: 'MaterialIcons');
  if (value is String) return _iconLookup[value] ?? Icons.help_outline;
  return Icons.help_outline;
}

const _iconLookup = <String, IconData>{
  'add': Icons.add,
  'arrow_back': Icons.arrow_back,
  'arrow_forward': Icons.arrow_forward,
  'check': Icons.check,
  'check_circle': Icons.check_circle,
  'close': Icons.close,
  'delete': Icons.delete,
  'edit': Icons.edit,
  'error': Icons.error,
  'favorite': Icons.favorite,
  'home': Icons.home,
  'info': Icons.info,
  'menu': Icons.menu,
  'more_vert': Icons.more_vert,
  'person': Icons.person,
  'search': Icons.search,
  'settings': Icons.settings,
  'share': Icons.share,
  'star': Icons.star,
  'visibility': Icons.visibility,
  'visibility_off': Icons.visibility_off,
  'warning': Icons.warning,
};
