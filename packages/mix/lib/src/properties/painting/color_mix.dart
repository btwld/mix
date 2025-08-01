import 'package:flutter/widgets.dart';

import '../../core/directive.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../theme/tokens/mix_token.dart';

/// A Mix-compatible wrapper for Color values that provides a fluent API
/// for color transformations and token resolution.
///
/// ColorMix allows you to work with colors in the Mix framework while
/// maintaining support for tokens, directives, and merging operations.
class ColorMix extends Mix<Color> {
  final Prop<Color> $value;

  static final red = ColorMix(ColorValues.red);
  static final pink = ColorMix(ColorValues.pink);
  static final purple = ColorMix(ColorValues.purple);
  static final deepPurple = ColorMix(ColorValues.deepPurple);
  static final indigo = ColorMix(ColorValues.indigo);
  static final blue = ColorMix(ColorValues.blue);
  static final lightBlue = ColorMix(ColorValues.lightBlue);
  static final cyan = ColorMix(ColorValues.cyan);
  static final teal = ColorMix(ColorValues.teal);
  static final green = ColorMix(ColorValues.green);
  static final lightGreen = ColorMix(ColorValues.lightGreen);
  static final lime = ColorMix(ColorValues.lime);
  static final yellow = ColorMix(ColorValues.yellow);
  static final amber = ColorMix(ColorValues.amber);
  static final orange = ColorMix(ColorValues.orange);
  static final deepOrange = ColorMix(ColorValues.deepOrange);
  static final brown = ColorMix(ColorValues.brown);
  static final grey = ColorMix(ColorValues.grey);
  static final blueGrey = ColorMix(ColorValues.blueGrey);
  static final redAccent = ColorMix(ColorValues.redAccent);
  static final pinkAccent = ColorMix(ColorValues.pinkAccent);
  static final purpleAccent = ColorMix(ColorValues.purpleAccent);
  static final deepPurpleAccent = ColorMix(ColorValues.deepPurpleAccent);
  static final indigoAccent = ColorMix(ColorValues.indigoAccent);
  static final blueAccent = ColorMix(ColorValues.blueAccent);
  static final lightBlueAccent = ColorMix(ColorValues.lightBlueAccent);
  static final cyanAccent = ColorMix(ColorValues.cyanAccent);
  static final tealAccent = ColorMix(ColorValues.tealAccent);
  static final greenAccent = ColorMix(ColorValues.greenAccent);
  static final lightGreenAccent = ColorMix(ColorValues.lightGreenAccent);
  static final limeAccent = ColorMix(ColorValues.limeAccent);
  static final yellowAccent = ColorMix(ColorValues.yellowAccent);
  static final amberAccent = ColorMix(ColorValues.amberAccent);
  static final orangeAccent = ColorMix(ColorValues.orangeAccent);
  static final deepOrangeAccent = ColorMix(ColorValues.deepOrangeAccent);
  static final transparent = ColorMix(ColorValues.transparent);
  static final black = ColorMix(ColorValues.black);
  static final white = ColorMix(ColorValues.white);
  static final black87 = ColorMix(ColorValues.black87);
  static final black54 = ColorMix(ColorValues.black54);
  static final black45 = ColorMix(ColorValues.black45);
  static final black38 = ColorMix(ColorValues.black38);
  static final black26 = ColorMix(ColorValues.black26);
  static final black12 = ColorMix(ColorValues.black12);
  static final white70 = ColorMix(ColorValues.white70);
  static final white60 = ColorMix(ColorValues.white60);
  static final white54 = ColorMix(ColorValues.white54);
  static final white38 = ColorMix(ColorValues.white38);
  static final white30 = ColorMix(ColorValues.white30);
  static final white24 = ColorMix(ColorValues.white24);
  static final white12 = ColorMix(ColorValues.white12);
  static final white10 = ColorMix(ColorValues.white10);

  ColorMix(Color value) : this.raw(Prop(value));

  const ColorMix.raw(this.$value);

  /// Creates a ColorMix from a color token.
  factory ColorMix.token(MixToken<Color> token) {
    return ColorMix.raw(Prop.token(token));
  }

  /// Creates a ColorMix with a color directive applied.
  factory ColorMix.directive(MixDirective<Color> directive) {
    return ColorMix.raw(Prop.directives([directive]));
  }

  /// Creates a ColorMix with an opacity directive.
  factory ColorMix.withOpacity(double opacity) {
    return ColorMix.raw(Prop.directives([OpacityColorDirective(opacity)]));
  }

  /// Creates a ColorMix with an alpha directive.
  factory ColorMix.withAlpha(int alpha) {
    return ColorMix.raw(Prop.directives([AlphaColorDirective(alpha)]));
  }

  /// Creates a ColorMix with a darken directive.
  factory ColorMix.darken(int amount) {
    return ColorMix.raw(Prop.directives([DarkenColorDirective(amount)]));
  }

  /// Creates a ColorMix with a lighten directive.
  factory ColorMix.lighten(int amount) {
    return ColorMix.raw(Prop.directives([LightenColorDirective(amount)]));
  }

  /// Creates a ColorMix with a saturate directive.
  factory ColorMix.saturate(int amount) {
    return ColorMix.raw(Prop.directives([SaturateColorDirective(amount)]));
  }

  /// Creates a ColorMix with a desaturate directive.
  factory ColorMix.desaturate(int amount) {
    return ColorMix.raw(Prop.directives([DesaturateColorDirective(amount)]));
  }

  /// Creates a ColorMix with a tint directive.
  factory ColorMix.tint(int amount) {
    return ColorMix.raw(Prop.directives([TintColorDirective(amount)]));
  }

  /// Creates a ColorMix with a shade directive.
  factory ColorMix.shade(int amount) {
    return ColorMix.raw(Prop.directives([ShadeColorDirective(amount)]));
  }

  /// Creates a ColorMix with a withRed directive.
  factory ColorMix.withRed(int red) {
    return ColorMix.raw(Prop.directives([WithRedColorDirective(red)]));
  }

  /// Creates a ColorMix with a withGreen directive.
  factory ColorMix.withGreen(int green) {
    return ColorMix.raw(Prop.directives([WithGreenColorDirective(green)]));
  }

  /// Creates a ColorMix with a withBlue directive.
  factory ColorMix.withBlue(int blue) {
    return ColorMix.raw(Prop.directives([WithBlueColorDirective(blue)]));
  }

  /// Creates a ColorMix from a nullable Color value.
  /// Returns null if the color is null, otherwise returns a ColorMix.
  static ColorMix? maybeValue(Color? color) {
    if (color == null) return null;

    return ColorMix(color);
  }

  /// Merges this ColorMix with a color token.
  ColorMix token(MixToken<Color> token) {
    return merge(ColorMix.token(token));
  }

  /// Merges this ColorMix with a color directive.
  ColorMix directive(MixDirective<Color> directive) {
    return merge(ColorMix.directive(directive));
  }

  ColorMix darken(int amount) {
    return merge(ColorMix.darken(amount));
  }

  ColorMix lighten(int amount) {
    return merge(ColorMix.lighten(amount));
  }

  ColorMix saturate(int amount) {
    return merge(ColorMix.saturate(amount));
  }

  ColorMix desaturate(int amount) {
    return merge(ColorMix.desaturate(amount));
  }

  ColorMix tint(int amount) {
    return merge(ColorMix.tint(amount));
  }

  ColorMix shade(int amount) {
    return merge(ColorMix.shade(amount));
  }

  ColorMix withOpacity(double opacity) {
    return merge(ColorMix.withOpacity(opacity));
  }

  ColorMix withAlpha(int alpha) {
    return merge(ColorMix.withAlpha(alpha));
  }

  @override
  Color resolve(BuildContext context) {
    return $value.resolve(context);
  }

  @override
  ColorMix merge(ColorMix? other) {
    if (other == null) return this;

    return ColorMix.raw($value.merge(other.$value));
  }

  @override
  List<Object> get props => [$value];
}

class ColorValues {
  static const transparent = Color(0x00000000);
  static const black = Color(0xFF000000);

  static const white = Color(0xFFFFFFFF);

  // Black variants
  static const black87 = Color(0xDD000000);

  static const black54 = Color(0x8A000000);

  static const black45 = Color(0x73000000);

  static const black38 = Color(0x61000000);

  static const black26 = Color(0x42000000);

  static const black12 = Color(0x1F000000);

  // White variants
  static const white70 = Color(0xB3FFFFFF);

  static const white60 = Color(0x99FFFFFF);

  static const white54 = Color(0x8AFFFFFF);

  static const white38 = Color(0x62FFFFFF);

  static const white30 = Color(0x4DFFFFFF);
  static const white24 = Color(0x3DFFFFFF);
  static const white12 = Color(0x1FFFFFFF);

  static const white10 = Color(0x1AFFFFFF); // Color swatches - Primary colors
  static const redSwatch = ColorSwatch<int>(0xFFF44336, {
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(0xFFF44336),
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  });
  static const pinkSwatch = ColorSwatch<int>(0xFFE91E63, {
    50: Color(0xFFFCE4EC),
    100: Color(0xFFF8BBD0),
    200: Color(0xFFF48FB1),
    300: Color(0xFFF06292),
    400: Color(0xFFEC407A),
    500: Color(0xFFE91E63),
    600: Color(0xFFD81B60),
    700: Color(0xFFC2185B),
    800: Color(0xFFAD1457),
    900: Color(0xFF880E4F),
  });
  static const purpleSwatch = ColorSwatch<int>(0xFF9C27B0, {
    50: Color(0xFFF3E5F5),
    100: Color(0xFFE1BEE7),
    200: Color(0xFFCE93D8),
    300: Color(0xFFBA68C8),
    400: Color(0xFFAB47BC),
    500: Color(0xFF9C27B0),
    600: Color(0xFF8E24AA),
    700: Color(0xFF7B1FA2),
    800: Color(0xFF6A1B9A),
    900: Color(0xFF4A148C),
  });
  static const deepPurpleSwatch = ColorSwatch<int>(0xFF673AB7, {
    50: Color(0xFFEDE7F6),
    100: Color(0xFFD1C4E9),
    200: Color(0xFFB39DDB),
    300: Color(0xFF9575CD),
    400: Color(0xFF7E57C2),
    500: Color(0xFF673AB7),
    600: Color(0xFF5E35B1),
    700: Color(0xFF512DA8),
    800: Color(0xFF4527A0),
    900: Color(0xFF311B92),
  });
  static const indigoSwatch = ColorSwatch<int>(0xFF3F51B5, {
    50: Color(0xFFE8EAF6),
    100: Color(0xFFC5CAE9),
    200: Color(0xFF9FA8DA),
    300: Color(0xFF7986CB),
    400: Color(0xFF5C6BC0),
    500: Color(0xFF3F51B5),
    600: Color(0xFF3949AB),
    700: Color(0xFF303F9F),
    800: Color(0xFF283593),
    900: Color(0xFF1A237E),
  });

  static const blueSwatch = ColorSwatch<int>(0xFF2196F3, {
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF2196F3),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  });
  static const lightBlueSwatch = ColorSwatch<int>(0xFF03A9F4, {
    50: Color(0xFFE1F5FE),
    100: Color(0xFFB3E5FC),
    200: Color(0xFF81D4FA),
    300: Color(0xFF4FC3F7),
    400: Color(0xFF29B6F6),
    500: Color(0xFF03A9F4),
    600: Color(0xFF039BE5),
    700: Color(0xFF0288D1),
    800: Color(0xFF0277BD),
    900: Color(0xFF01579B),
  });
  static const cyanSwatch = ColorSwatch<int>(0xFF00BCD4, {
    50: Color(0xFFE0F7FA),
    100: Color(0xFFB2EBF2),
    200: Color(0xFF80DEEA),
    300: Color(0xFF4DD0E1),
    400: Color(0xFF26C6DA),
    500: Color(0xFF00BCD4),
    600: Color(0xFF00ACC1),
    700: Color(0xFF0097A7),
    800: Color(0xFF00838F),
    900: Color(0xFF006064),
  });
  static const tealSwatch = ColorSwatch<int>(0xFF009688, {
    50: Color(0xFFE0F2F1),
    100: Color(0xFFB2DFDB),
    200: Color(0xFF80CBC4),
    300: Color(0xFF4DB6AC),
    400: Color(0xFF26A69A),
    500: Color(0xFF009688),
    600: Color(0xFF00897B),
    700: Color(0xFF00796B),
    800: Color(0xFF00695C),
    900: Color(0xFF004D40),
  });
  static const greenSwatch = ColorSwatch<int>(0xFF4CAF50, {
    50: Color(0xFFE8F5E9),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(0xFF4CAF50),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  });
  static const lightGreenSwatch = ColorSwatch<int>(0xFF8BC34A, {
    50: Color(0xFFF1F8E9),
    100: Color(0xFFDCEDC8),
    200: Color(0xFFC5E1A5),
    300: Color(0xFFAED581),
    400: Color(0xFF9CCC65),
    500: Color(0xFF8BC34A),
    600: Color(0xFF7CB342),
    700: Color(0xFF689F38),
    800: Color(0xFF558B2F),
    900: Color(0xFF33691E),
  });
  static const limeSwatch = ColorSwatch<int>(0xFFCDDC39, {
    50: Color(0xFFF9FBE7),
    100: Color(0xFFF0F4C3),
    200: Color(0xFFE6EE9C),
    300: Color(0xFFDCE775),
    400: Color(0xFFD4E157),
    500: Color(0xFFCDDC39),
    600: Color(0xFFC0CA33),
    700: Color(0xFFAFB42B),
    800: Color(0xFF9E9D24),
    900: Color(0xFF827717),
  });
  static const yellowSwatch = ColorSwatch<int>(0xFFFFEB3B, {
    50: Color(0xFFFFFDE7),
    100: Color(0xFFFFF9C4),
    200: Color(0xFFFFF59D),
    300: Color(0xFFFFF176),
    400: Color(0xFFFFEE58),
    500: Color(0xFFFFEB3B),
    600: Color(0xFFFDD835),
    700: Color(0xFFFBC02D),
    800: Color(0xFFF9A825),
    900: Color(0xFFF57F17),
  });

  static const amberSwatch = ColorSwatch<int>(0xFFFFC107, {
    50: Color(0xFFFFF8E1),
    100: Color(0xFFFFECB3),
    200: Color(0xFFFFE082),
    300: Color(0xFFFFD54F),
    400: Color(0xFFFFCA28),
    500: Color(0xFFFFC107),
    600: Color(0xFFFFB300),
    700: Color(0xFFFFA000),
    800: Color(0xFFFF8F00),
    900: Color(0xFFFF6F00),
  });

  static const orangeSwatch = ColorSwatch<int>(0xFFFF9800, {
    50: Color(0xFFFFF3E0),
    100: Color(0xFFFFE0B2),
    200: Color(0xFFFFCC80),
    300: Color(0xFFFFB74D),
    400: Color(0xFFFFA726),
    500: Color(0xFFFF9800),
    600: Color(0xFFFB8C00),
    700: Color(0xFFF57C00),
    800: Color(0xFFEF6C00),
    900: Color(0xFFE65100),
  });

  static const deepOrangeSwatch = ColorSwatch<int>(0xFFFF5722, {
    50: Color(0xFFFBE9E7),
    100: Color(0xFFFFCCBC),
    200: Color(0xFFFFAB91),
    300: Color(0xFFFF8A65),
    400: Color(0xFFFF7043),
    500: Color(0xFFFF5722),
    600: Color(0xFFF4511E),
    700: Color(0xFFE64A19),
    800: Color(0xFFD84315),
    900: Color(0xFFBF360C),
  });

  static const brownSwatch = ColorSwatch<int>(0xFF795548, {
    50: Color(0xFFEFEBE9),
    100: Color(0xFFD7CCC8),
    200: Color(0xFFBCAAA4),
    300: Color(0xFFA1887F),
    400: Color(0xFF8D6E63),
    500: Color(0xFF795548),
    600: Color(0xFF6D4C41),
    700: Color(0xFF5D4037),
    800: Color(0xFF4E342E),
    900: Color(0xFF3E2723),
  });

  static const greySwatch = ColorSwatch<int>(0xFF9E9E9E, {
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    350: Color(0xFFD6D6D6),
    400: Color(0xFFBDBDBD),
    500: Color(0xFF9E9E9E),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    850: Color(0xFF303030),
    900: Color(0xFF212121),
  });

  static const blueGreySwatch = ColorSwatch<int>(0xFF607D8B, {
    50: Color(0xFFECEFF1),
    100: Color(0xFFCFD8DC),
    200: Color(0xFFB0BEC5),
    300: Color(0xFF90A4AE),
    400: Color(0xFF78909C),
    500: Color(0xFF607D8B),
    600: Color(0xFF546E7A),
    700: Color(0xFF455A64),
    800: Color(0xFF37474F),
    900: Color(0xFF263238),
  });

  // Accent color swatches
  static const redAccentSwatch = ColorSwatch<int>(0xFFFF5252, {
    100: Color(0xFFFF8A80),
    200: Color(0xFFFF5252),
    400: Color(0xFFFF1744),
    700: Color(0xFFD50000),
  });

  static const pinkAccentSwatch = ColorSwatch<int>(0xFFFF4081, {
    100: Color(0xFFFF80AB),
    200: Color(0xFFFF4081),
    400: Color(0xFFF50057),
    700: Color(0xFFC51162),
  });

  static const purpleAccentSwatch = ColorSwatch<int>(0xFFE040FB, {
    100: Color(0xFFEA80FC),
    200: Color(0xFFE040FB),
    400: Color(0xFFD500F9),
    700: Color(0xFFAA00FF),
  });

  static const deepPurpleAccentSwatch = ColorSwatch<int>(0xFF7C4DFF, {
    100: Color(0xFFB388FF),
    200: Color(0xFF7C4DFF),
    400: Color(0xFF651FFF),
    700: Color(0xFF6200EA),
  });

  static const indigoAccentSwatch = ColorSwatch<int>(0xFF536DFE, {
    100: Color(0xFF8C9EFF),
    200: Color(0xFF536DFE),
    400: Color(0xFF3D5AFE),
    700: Color(0xFF304FFE),
  });

  static const blueAccentSwatch = ColorSwatch<int>(0xFF448AFF, {
    100: Color(0xFF82B1FF),
    200: Color(0xFF448AFF),
    400: Color(0xFF2979FF),
    700: Color(0xFF2962FF),
  });

  static const lightBlueAccentSwatch = ColorSwatch<int>(0xFF40C4FF, {
    100: Color(0xFF80D8FF),
    200: Color(0xFF40C4FF),
    400: Color(0xFF00B0FF),
    700: Color(0xFF0091EA),
  });

  static const cyanAccentSwatch = ColorSwatch<int>(0xFF18FFFF, {
    100: Color(0xFF84FFFF),
    200: Color(0xFF18FFFF),
    400: Color(0xFF00E5FF),
    700: Color(0xFF00B8D4),
  });

  static const tealAccentSwatch = ColorSwatch<int>(0xFF64FFDA, {
    100: Color(0xFFA7FFEB),
    200: Color(0xFF64FFDA),
    400: Color(0xFF1DE9B6),
    700: Color(0xFF00BFA5),
  });

  static const greenAccentSwatch = ColorSwatch<int>(0xFF69F0AE, {
    100: Color(0xFFB9F6CA),
    200: Color(0xFF69F0AE),
    400: Color(0xFF00E676),
    700: Color(0xFF00C853),
  });

  static const lightGreenAccentSwatch = ColorSwatch<int>(0xFFB2FF59, {
    100: Color(0xFFCCFF90),
    200: Color(0xFFB2FF59),
    400: Color(0xFF76FF03),
    700: Color(0xFF64DD17),
  });

  static const limeAccentSwatch = ColorSwatch<int>(0xFFEEFF41, {
    100: Color(0xFFF4FF81),
    200: Color(0xFFEEFF41),
    400: Color(0xFFC6FF00),
    700: Color(0xFFAEEA00),
  });

  static const yellowAccentSwatch = ColorSwatch<int>(0xFFFFFF00, {
    100: Color(0xFFFFFF8D),
    200: Color(0xFFFFFF00),
    400: Color(0xFFFFEA00),
    700: Color(0xFFFFD600),
  });

  static const amberAccentSwatch = ColorSwatch<int>(0xFFFFD740, {
    100: Color(0xFFFFE57F),
    200: Color(0xFFFFD740),
    400: Color(0xFFFFC400),
    700: Color(0xFFFFAB00),
  });

  static const orangeAccentSwatch = ColorSwatch<int>(0xFFFFAB40, {
    100: Color(0xFFFFD180),
    200: Color(0xFFFFAB40),
    400: Color(0xFFFF9100),
    700: Color(0xFFFF6D00),
  });

  static const deepOrangeAccentSwatch = ColorSwatch<int>(0xFFFF6E40, {
    100: Color(0xFFFF9E80),
    200: Color(0xFFFF6E40),
    400: Color(0xFFFF3D00),
    700: Color(0xFFDD2C00),
  });

  static final red = redSwatch;

  static final pink = pinkSwatch;
  static final purple = purpleSwatch;
  static final deepPurple = deepPurpleSwatch;
  static final indigo = indigoSwatch;
  static final blue = blueSwatch;
  static final lightBlue = lightBlueSwatch;
  static final cyan = cyanSwatch;
  static final teal = tealSwatch;
  static final green = greenSwatch;
  static final lightGreen = lightGreenSwatch;
  static final lime = limeSwatch;
  static final yellow = yellowSwatch;
  static final amber = amberSwatch;
  static final orange = orangeSwatch;
  static final deepOrange = deepOrangeSwatch;
  static final brown = brownSwatch;
  static final grey = greySwatch;
  static final blueGrey = blueGreySwatch;
  static final redAccent = redAccentSwatch;

  static final pinkAccent = pinkAccentSwatch;
  static final purpleAccent = purpleAccentSwatch;
  static final deepPurpleAccent = deepPurpleAccentSwatch;
  static final indigoAccent = indigoAccentSwatch;
  static final blueAccent = blueAccentSwatch;
  static final lightBlueAccent = lightBlueAccentSwatch;
  static final cyanAccent = cyanAccentSwatch;
  static final tealAccent = tealAccentSwatch;
  static final greenAccent = greenAccentSwatch;
  static final lightGreenAccent = lightGreenAccentSwatch;
  static final limeAccent = limeAccentSwatch;
  static final yellowAccent = yellowAccentSwatch;
  static final amberAccent = amberAccentSwatch;
  static final orangeAccent = orangeAccentSwatch;
  static final deepOrangeAccent = deepOrangeAccentSwatch;
  const ColorValues._();
}

