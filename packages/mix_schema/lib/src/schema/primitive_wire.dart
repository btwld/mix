import 'package:flutter/widgets.dart';

String encodeColorWire(Color value) {
  final argb = value.toARGB32();
  final alpha = (argb >> 24) & 0xFF;
  final red = (argb >> 16) & 0xFF;
  final green = (argb >> 8) & 0xFF;
  final blue = argb & 0xFF;

  if (alpha == 0xFF) {
    return '#${_hex(red)}${_hex(green)}${_hex(blue)}';
  }

  return '#${_hex(alpha)}${_hex(red)}${_hex(green)}${_hex(blue)}';
}

Object encodeAlignmentWire(Alignment value) {
  for (final entry in namedAlignments.entries) {
    if (entry.value == value) return entry.key;
  }

  return {'x': value.x, 'y': value.y};
}

Object encodeEdgeInsetsWire({
  required double? left,
  required double? top,
  required double? right,
  required double? bottom,
}) {
  if (left != null && left == top && top == right && right == bottom) {
    return left;
  }

  final payload = <String, double>{};
  if (left != null) payload['left'] = left;
  if (top != null) payload['top'] = top;
  if (right != null) payload['right'] = right;
  if (bottom != null) payload['bottom'] = bottom;
  return payload;
}

const namedAlignments = <String, Alignment>{
  'topLeft': Alignment.topLeft,
  'topCenter': Alignment.topCenter,
  'topRight': Alignment.topRight,
  'centerLeft': Alignment.centerLeft,
  'center': Alignment.center,
  'centerRight': Alignment.centerRight,
  'bottomLeft': Alignment.bottomLeft,
  'bottomCenter': Alignment.bottomCenter,
  'bottomRight': Alignment.bottomRight,
};

String _hex(int value) => value.toRadixString(16).padLeft(2, '0').toUpperCase();

/// Canonical wire vocabulary for [WidgetState]. Single owner consumed by both
/// the variant codec (decode + encode) and the producer payload API, so the
/// wire spelling never drifts between the two paths.
const Map<String, WidgetState> widgetStateWireValues = {
  'hovered': WidgetState.hovered,
  'focused': WidgetState.focused,
  'pressed': WidgetState.pressed,
  'dragged': WidgetState.dragged,
  'selected': WidgetState.selected,
  'scrolled_under': WidgetState.scrolledUnder,
  'disabled': WidgetState.disabled,
  'error': WidgetState.error,
};

/// Canonical wire vocabulary for the schema's supported [FontWeight] values.
const Map<String, FontWeight> fontWeightWireValues = {
  'w100': FontWeight.w100,
  'w200': FontWeight.w200,
  'w300': FontWeight.w300,
  'w400': FontWeight.w400,
  'w500': FontWeight.w500,
  'w600': FontWeight.w600,
  'w700': FontWeight.w700,
  'w800': FontWeight.w800,
  'w900': FontWeight.w900,
};

/// Canonical wire vocabulary for schema-supported [TextDecoration] values.
const Map<String, TextDecoration> textDecorationWireValues = {
  'none': TextDecoration.none,
  'underline': TextDecoration.underline,
  'overline': TextDecoration.overline,
  'line_through': TextDecoration.lineThrough,
};

/// Reverse lookup for the producer payload API: the wire spelling for [value].
String encodeWidgetStateWire(WidgetState value) =>
    _wireValueFor(widgetStateWireValues, value, 'WidgetState');

/// Reverse lookup for the producer payload API: the wire spelling for [value].
String encodeFontWeightWire(FontWeight value) =>
    _wireValueFor(fontWeightWireValues, value, 'FontWeight');

/// Reverse lookup for the producer payload API: the wire spelling for [value].
String encodeTextDecorationWire(TextDecoration value) =>
    _wireValueFor(textDecorationWireValues, value, 'TextDecoration');

/// The wire key in [byWire] whose value equals [value], or null if none match.
///
/// Single reverse-lookup used by both the producer payload helpers (below) and
/// the codec encode path (`enumCodec`), so the two resolve a wire spelling the
/// same way. Callers supply their own error for the no-match case.
String? reverseWireLookup<T extends Object>(Map<String, T> byWire, T value) {
  for (final entry in byWire.entries) {
    if (entry.value == value) return entry.key;
  }

  return null;
}

String _wireValueFor<T extends Object>(
  Map<String, T> byWire,
  T value,
  String debugName,
) {
  final wire = reverseWireLookup(byWire, value);
  if (wire == null) {
    throw ArgumentError.value(
      value,
      'value',
      'No $debugName wire value is registered.',
    );
  }

  return wire;
}
