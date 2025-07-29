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
  final Prop<Color> value; // Basic colors
  static const Color transparent = Color(0x00000000);

  static const Color black = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);

  // Black variants
  static const Color black87 = Color(0xDD000000);

  static const Color black54 = Color(0x8A000000);

  static const Color black45 = Color(0x73000000);

  static const Color black38 = Color(0x61000000);

  static const Color black26 = Color(0x42000000);

  static const Color black12 = Color(0x1F000000);

  // White variants
  static const Color white70 = Color(0xB3FFFFFF);

  static const Color white60 = Color(0x99FFFFFF);

  static const Color white54 = Color(0x8AFFFFFF);

  static const Color white38 = Color(0x62FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);

  static const Color white12 = Color(0x1FFFFFFF);
  static const Color white10 = Color(
    0x1AFFFFFF,
  ); // Color swatches - Primary colors
  static const ColorSwatch<int> redSwatch = ColorSwatch<int>(0xFFF44336, {
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
  static const ColorSwatch<int> pinkSwatch = ColorSwatch<int>(0xFFE91E63, {
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
  static const ColorSwatch<int> purpleSwatch = ColorSwatch<int>(0xFF9C27B0, {
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
  static const ColorSwatch<int> deepPurpleSwatch =
      ColorSwatch<int>(0xFF673AB7, {
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

  static const ColorSwatch<int> indigoSwatch = ColorSwatch<int>(0xFF3F51B5, {
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
  static const ColorSwatch<int> blueSwatch = ColorSwatch<int>(0xFF2196F3, {
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
  static const ColorSwatch<int> lightBlueSwatch = ColorSwatch<int>(0xFF03A9F4, {
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
  static const ColorSwatch<int> cyanSwatch = ColorSwatch<int>(0xFF00BCD4, {
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
  static const ColorSwatch<int> tealSwatch = ColorSwatch<int>(0xFF009688, {
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
  static const ColorSwatch<int> greenSwatch = ColorSwatch<int>(0xFF4CAF50, {
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
  static const ColorSwatch<int> lightGreenSwatch =
      ColorSwatch<int>(0xFF8BC34A, {
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
  static const ColorSwatch<int> limeSwatch = ColorSwatch<int>(0xFFCDDC39, {
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

  static const ColorSwatch<int> yellowSwatch = ColorSwatch<int>(0xFFFFEB3B, {
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

  static const ColorSwatch<int> amberSwatch = ColorSwatch<int>(0xFFFFC107, {
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

  static const ColorSwatch<int> orangeSwatch = ColorSwatch<int>(0xFFFF9800, {
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

  static const ColorSwatch<int> deepOrangeSwatch =
      ColorSwatch<int>(0xFFFF5722, {
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

  static const ColorSwatch<int> brownSwatch = ColorSwatch<int>(0xFF795548, {
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

  static const ColorSwatch<int> greySwatch = ColorSwatch<int>(0xFF9E9E9E, {
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

  static const ColorSwatch<int> blueGreySwatch = ColorSwatch<int>(0xFF607D8B, {
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
  static const ColorSwatch<int> redAccentSwatch = ColorSwatch<int>(0xFFFF5252, {
    100: Color(0xFFFF8A80),
    200: Color(0xFFFF5252),
    400: Color(0xFFFF1744),
    700: Color(0xFFD50000),
  });

  static const ColorSwatch<int> pinkAccentSwatch =
      ColorSwatch<int>(0xFFFF4081, {
        100: Color(0xFFFF80AB),
        200: Color(0xFFFF4081),
        400: Color(0xFFF50057),
        700: Color(0xFFC51162),
      });

  static const ColorSwatch<int> purpleAccentSwatch =
      ColorSwatch<int>(0xFFE040FB, {
        100: Color(0xFFEA80FC),
        200: Color(0xFFE040FB),
        400: Color(0xFFD500F9),
        700: Color(0xFFAA00FF),
      });

  static const ColorSwatch<int> deepPurpleAccentSwatch =
      ColorSwatch<int>(0xFF7C4DFF, {
        100: Color(0xFFB388FF),
        200: Color(0xFF7C4DFF),
        400: Color(0xFF651FFF),
        700: Color(0xFF6200EA),
      });

  static const ColorSwatch<int> indigoAccentSwatch =
      ColorSwatch<int>(0xFF536DFE, {
        100: Color(0xFF8C9EFF),
        200: Color(0xFF536DFE),
        400: Color(0xFF3D5AFE),
        700: Color(0xFF304FFE),
      });

  static const ColorSwatch<int> blueAccentSwatch =
      ColorSwatch<int>(0xFF448AFF, {
        100: Color(0xFF82B1FF),
        200: Color(0xFF448AFF),
        400: Color(0xFF2979FF),
        700: Color(0xFF2962FF),
      });

  static const ColorSwatch<int> lightBlueAccentSwatch =
      ColorSwatch<int>(0xFF40C4FF, {
        100: Color(0xFF80D8FF),
        200: Color(0xFF40C4FF),
        400: Color(0xFF00B0FF),
        700: Color(0xFF0091EA),
      });

  static const ColorSwatch<int> cyanAccentSwatch =
      ColorSwatch<int>(0xFF18FFFF, {
        100: Color(0xFF84FFFF),
        200: Color(0xFF18FFFF),
        400: Color(0xFF00E5FF),
        700: Color(0xFF00B8D4),
      });

  static const ColorSwatch<int> tealAccentSwatch =
      ColorSwatch<int>(0xFF64FFDA, {
        100: Color(0xFFA7FFEB),
        200: Color(0xFF64FFDA),
        400: Color(0xFF1DE9B6),
        700: Color(0xFF00BFA5),
      });

  static const ColorSwatch<int> greenAccentSwatch =
      ColorSwatch<int>(0xFF69F0AE, {
        100: Color(0xFFB9F6CA),
        200: Color(0xFF69F0AE),
        400: Color(0xFF00E676),
        700: Color(0xFF00C853),
      });

  static const ColorSwatch<int> lightGreenAccentSwatch =
      ColorSwatch<int>(0xFFB2FF59, {
        100: Color(0xFFCCFF90),
        200: Color(0xFFB2FF59),
        400: Color(0xFF76FF03),
        700: Color(0xFF64DD17),
      });

  static const ColorSwatch<int> limeAccentSwatch =
      ColorSwatch<int>(0xFFEEFF41, {
        100: Color(0xFFF4FF81),
        200: Color(0xFFEEFF41),
        400: Color(0xFFC6FF00),
        700: Color(0xFFAEEA00),
      });

  static const ColorSwatch<int> yellowAccentSwatch =
      ColorSwatch<int>(0xFFFFFF00, {
        100: Color(0xFFFFFF8D),
        200: Color(0xFFFFFF00),
        400: Color(0xFFFFEA00),
        700: Color(0xFFFFD600),
      });

  static const ColorSwatch<int> amberAccentSwatch =
      ColorSwatch<int>(0xFFFFD740, {
        100: Color(0xFFFFE57F),
        200: Color(0xFFFFD740),
        400: Color(0xFFFFC400),
        700: Color(0xFFFFAB00),
      });

  static const ColorSwatch<int> orangeAccentSwatch =
      ColorSwatch<int>(0xFFFFAB40, {
        100: Color(0xFFFFD180),
        200: Color(0xFFFFAB40),
        400: Color(0xFFFF9100),
        700: Color(0xFFFF6D00),
      });

  static const ColorSwatch<int> deepOrangeAccentSwatch =
      ColorSwatch<int>(0xFFFF6E40, {
        100: Color(0xFFFF9E80),
        200: Color(0xFFFF6E40),
        400: Color(0xFFFF3D00),
        700: Color(0xFFDD2C00),
      });

  ColorMix(Color value) : this.raw(Prop(value));

  const ColorMix.raw(this.value);

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

  factory ColorMix.saturate(int amount) {
    return ColorMix.raw(Prop.directives([SaturateColorDirective(amount)]));
  }

  factory ColorMix.desaturate(int amount) {
    return ColorMix.raw(Prop.directives([DesaturateColorDirective(amount)]));
  }

  factory ColorMix.tint(int amount) {
    return ColorMix.raw(Prop.directives([TintColorDirective(amount)]));
  }

  factory ColorMix.shade(int amount) {
    return ColorMix.raw(Prop.directives([ShadeColorDirective(amount)]));
  }

  // ColorMix getters - Primary colors (main shades)
  static ColorMix get red => ColorMix(redSwatch);
  static ColorMix get pink => ColorMix(pinkSwatch);
  static ColorMix get purple => ColorMix(purpleSwatch);
  static ColorMix get deepPurple => ColorMix(deepPurpleSwatch);
  static ColorMix get indigo => ColorMix(indigoSwatch);
  static ColorMix get blue => ColorMix(blueSwatch);
  static ColorMix get lightBlue => ColorMix(lightBlueSwatch);
  static ColorMix get cyan => ColorMix(cyanSwatch);
  static ColorMix get teal => ColorMix(tealSwatch);
  static ColorMix get green => ColorMix(greenSwatch);
  static ColorMix get lightGreen => ColorMix(lightGreenSwatch);
  static ColorMix get lime => ColorMix(limeSwatch);
  static ColorMix get yellow => ColorMix(yellowSwatch);
  static ColorMix get amber => ColorMix(amberSwatch);
  static ColorMix get orange => ColorMix(orangeSwatch);
  static ColorMix get deepOrange => ColorMix(deepOrangeSwatch);
  static ColorMix get brown => ColorMix(brownSwatch);
  static ColorMix get grey => ColorMix(greySwatch);
  static ColorMix get blueGrey => ColorMix(blueGreySwatch);

  // ColorMix getters - Accent colors
  static ColorMix get redAccent => ColorMix(redAccentSwatch);
  static ColorMix get pinkAccent => ColorMix(pinkAccentSwatch);
  static ColorMix get purpleAccent => ColorMix(purpleAccentSwatch);
  static ColorMix get deepPurpleAccent => ColorMix(deepPurpleAccentSwatch);
  static ColorMix get indigoAccent => ColorMix(indigoAccentSwatch);
  static ColorMix get blueAccent => ColorMix(blueAccentSwatch);
  static ColorMix get lightBlueAccent => ColorMix(lightBlueAccentSwatch);
  static ColorMix get cyanAccent => ColorMix(cyanAccentSwatch);
  static ColorMix get tealAccent => ColorMix(tealAccentSwatch);
  static ColorMix get greenAccent => ColorMix(greenAccentSwatch);
  static ColorMix get lightGreenAccent => ColorMix(lightGreenAccentSwatch);
  static ColorMix get limeAccent => ColorMix(limeAccentSwatch);
  static ColorMix get yellowAccent => ColorMix(yellowAccentSwatch);
  static ColorMix get amberAccent => ColorMix(amberAccentSwatch);
  static ColorMix get orangeAccent => ColorMix(orangeAccentSwatch);
  static ColorMix get deepOrangeAccent => ColorMix(deepOrangeAccentSwatch);

  /// Merges this ColorMix with a color token.
  ColorMix token(MixToken<Color> token) {
    return merge(ColorMix.token(token));
  }

  /// Merges this ColorMix with a color directive.
  ColorMix directive(MixDirective<Color> directive) {
    return merge(ColorMix.directive(directive));
  }

  ColorMix withOpacity(double opacity) {
    return merge(ColorMix.withOpacity(opacity));
  }

  ColorMix withAlpha(int alpha) {
    return merge(ColorMix.withAlpha(alpha));
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

  @override
  Color resolve(BuildContext context) {
    return value.resolve(context);
  }

  @override
  ColorMix merge(ColorMix? other) {
    if (other == null) return this;

    return ColorMix.raw(value.merge(other.value));
  }

  @override
  List<Object> get props => [value];
}
