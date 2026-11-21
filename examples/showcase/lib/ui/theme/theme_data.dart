import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'tokens.dart';

/// Appearance selection for an application-owned theme.
enum UiThemeMode { system, light, dark }

/// The concrete values behind [UiTokens] for one brightness.
///
/// This is application-owned data: change a hex value, add a field, or drop
/// one, and only this layer moves. `UiThemeScope` turns an instance into the
/// `MixScope` token map that every recipe resolves against.
@immutable
class UiThemeData {
  /// Creates a theme with an explicit value for every token.
  const UiThemeData({
    this.brightness = Brightness.light,
    required this.background,
    required this.foreground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.focusRing,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.radius,
  });

  /// The neutral light theme.
  const UiThemeData.light()
    : brightness = Brightness.light,
      background = const Color(0xFFFFFFFF),
      foreground = const Color(0xFF0C1733),
      primary = const Color(0xFF3468F5),
      primaryForeground = const Color(0xFFFFFFFF),
      secondary = const Color(0xFFE8EEFF),
      secondaryForeground = const Color(0xFF2454D7),
      muted = const Color(0xFFF3F6FA),
      mutedForeground = const Color(0xFF62708E),
      accent = const Color(0xFFDCE6FF),
      accentForeground = const Color(0xFF0C1733),
      destructive = const Color(0xFFB91C1C),
      destructiveForeground = const Color(0xFFFFFFFF),
      border = const Color(0xFFDCE4F0),
      focusRing = const Color(0xFF737373),
      chart1 = const Color(0xFF2563EB),
      chart2 = const Color(0xFFC2410C),
      chart3 = const Color(0xFF047857),
      chart4 = const Color(0xFF7E22CE),
      chart5 = const Color(0xFFBE123C),
      radius = const Radius.circular(8);

  /// The neutral dark theme.
  const UiThemeData.dark()
    : brightness = Brightness.dark,
      background = const Color(0xFF0A0A0A),
      foreground = const Color(0xFFFAFAFA),
      primary = const Color(0xFFFAFAFA),
      primaryForeground = const Color(0xFF171717),
      secondary = const Color(0xFF262626),
      secondaryForeground = const Color(0xFFFAFAFA),
      muted = const Color(0xFF262626),
      mutedForeground = const Color(0xFFA3A3A3),
      accent = const Color(0xFF404040),
      accentForeground = const Color(0xFFFAFAFA),
      destructive = const Color(0xFFDC2626),
      destructiveForeground = const Color(0xFFFFFFFF),
      border = const Color(0xFF404040),
      focusRing = const Color(0xFFA3A3A3),
      chart1 = const Color(0xFF60A5FA),
      chart2 = const Color(0xFFFB923C),
      chart3 = const Color(0xFF34D399),
      chart4 = const Color(0xFFC084FC),
      chart5 = const Color(0xFFFB7185),
      radius = const Radius.circular(8);

  /// Brightness of these concrete values, independent of the selection mode.
  final Brightness brightness;

  /// Value for [UiTokens.background].
  final Color background;

  /// Value for [UiTokens.foreground].
  final Color foreground;

  /// Value for [UiTokens.primary].
  final Color primary;

  /// Value for [UiTokens.primaryForeground].
  final Color primaryForeground;

  /// Value for [UiTokens.secondary].
  final Color secondary;

  /// Value for [UiTokens.secondaryForeground].
  final Color secondaryForeground;

  /// Value for [UiTokens.muted].
  final Color muted;

  /// Value for [UiTokens.mutedForeground].
  final Color mutedForeground;

  /// Value for [UiTokens.accent].
  final Color accent;

  /// Value for [UiTokens.accentForeground].
  final Color accentForeground;

  /// Value for [UiTokens.destructive].
  final Color destructive;

  /// Value for [UiTokens.destructiveForeground].
  final Color destructiveForeground;

  /// Value for [UiTokens.border].
  final Color border;

  /// Value for [UiTokens.focusRing].
  final Color focusRing;

  /// Value for [UiTokens.chart1].
  final Color chart1;

  /// Value for [UiTokens.chart2].
  final Color chart2;

  /// Value for [UiTokens.chart3].
  final Color chart3;

  /// Value for [UiTokens.chart4].
  final Color chart4;

  /// Value for [UiTokens.chart5].
  final Color chart5;

  /// Value for [UiTokens.radius].
  final Radius radius;

  /// This theme's values keyed by the token that resolves them.
  ///
  /// Returned unmodifiable so a caller cannot mutate a theme that widgets
  /// already read from; use [copyWith] to derive a changed theme instead.
  Map<MixToken<Object?>, Object> get tokens =>
      Map<MixToken<Object?>, Object>.unmodifiable(<MixToken<Object?>, Object>{
        UiTokens.background: background,
        UiTokens.foreground: foreground,
        UiTokens.primary: primary,
        UiTokens.primaryForeground: primaryForeground,
        UiTokens.secondary: secondary,
        UiTokens.secondaryForeground: secondaryForeground,
        UiTokens.muted: muted,
        UiTokens.mutedForeground: mutedForeground,
        UiTokens.accent: accent,
        UiTokens.accentForeground: accentForeground,
        UiTokens.destructive: destructive,
        UiTokens.destructiveForeground: destructiveForeground,
        UiTokens.border: border,
        UiTokens.focusRing: focusRing,
        UiTokens.chart1: chart1,
        UiTokens.chart2: chart2,
        UiTokens.chart3: chart3,
        UiTokens.chart4: chart4,
        UiTokens.chart5: chart5,
        UiTokens.radius: radius,
      });

  /// Returns a copy of this theme with the given values replaced.
  UiThemeData copyWith({
    Brightness? brightness,
    Color? background,
    Color? foreground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? focusRing,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Radius? radius,
  }) => UiThemeData(
    brightness: brightness ?? this.brightness,
    background: background ?? this.background,
    foreground: foreground ?? this.foreground,
    primary: primary ?? this.primary,
    primaryForeground: primaryForeground ?? this.primaryForeground,
    secondary: secondary ?? this.secondary,
    secondaryForeground: secondaryForeground ?? this.secondaryForeground,
    muted: muted ?? this.muted,
    mutedForeground: mutedForeground ?? this.mutedForeground,
    accent: accent ?? this.accent,
    accentForeground: accentForeground ?? this.accentForeground,
    destructive: destructive ?? this.destructive,
    destructiveForeground: destructiveForeground ?? this.destructiveForeground,
    border: border ?? this.border,
    focusRing: focusRing ?? this.focusRing,
    chart1: chart1 ?? this.chart1,
    chart2: chart2 ?? this.chart2,
    chart3: chart3 ?? this.chart3,
    chart4: chart4 ?? this.chart4,
    chart5: chart5 ?? this.chart5,
    radius: radius ?? this.radius,
  );

  List<Object?> get _fields => [
    brightness,
    background,
    foreground,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    muted,
    mutedForeground,
    accent,
    accentForeground,
    destructive,
    destructiveForeground,
    border,
    focusRing,
    chart1,
    chart2,
    chart3,
    chart4,
    chart5,
    radius,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UiThemeData && listEquals(other._fields, _fields);

  @override
  int get hashCode => Object.hashAll(_fields);

  @override
  String toString() => 'UiThemeData(background: $background, radius: $radius)';
}
