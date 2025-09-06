import 'package:flutter/material.dart';

import '../tokens/mix_token.dart';

@immutable
class MaterialTokens {
  final colorScheme = const _MaterialColorTokens();
  final textTheme = const _MaterialTextStyles();

  const MaterialTokens();
}

@immutable
class _MaterialColorTokens {
  final primary = const MixableToken<Color>('md.color.primary');

  final secondary = const MixableToken<Color>('md.color.secondary');

  final tertiary = const MixableToken<Color>('md.color.tertiary');

  final surface = const MixableToken<Color>('md.color.surface');

  final background = const MixableToken<Color>('md.color.background');

  final error = const MixableToken<Color>('md.color.error');

  final onPrimary = const MixableToken<Color>('md.color.on.primary');

  final onSecondary = const MixableToken<Color>('md.color.on.secondary');

  final onTertiary = const MixableToken<Color>('md.color.on.tertiary');

  final onSurface = const MixableToken<Color>('md.color.on.surface');

  final onBackground = const MixableToken<Color>('md.color.on.background');

  final onError = const MixableToken<Color>('md.color.on.error');

  const _MaterialColorTokens();
}

@immutable
// Material 3 TextTheme Tokens.
class _MaterialTextStyles {
  //  Material 3 text styles
  final displayLarge =
      const MixableToken<TextStyle>('md3.text.theme.display.large');
  final displayMedium = const MixableToken<TextStyle>(
    'md3.text.theme.display.medium',
  );
  final displaySmall =
      const MixableToken<TextStyle>('md3.text.theme.display.small');
  final headlineLarge = const MixableToken<TextStyle>(
    'md3.text.theme.headline.large',
  );
  final headlineMedium = const MixableToken<TextStyle>(
    'md3.text.theme.headline.medium',
  );
  final headlineSmall = const MixableToken<TextStyle>(
    'md3.text.theme.headline.small',
  );

  final titleLarge =
      const MixableToken<TextStyle>('md3.text.theme.title.large');
  final titleMedium =
      const MixableToken<TextStyle>('md3.text.theme.title.medium');
  final titleSmall =
      const MixableToken<TextStyle>('md3.text.theme.title.small');
  final bodyLarge = const MixableToken<TextStyle>('md3.text.theme.body.large');
  final bodyMedium =
      const MixableToken<TextStyle>('md3.text.theme.body.medium');
  final bodySmall = const MixableToken<TextStyle>('md3.text.theme.body.small');
  final labelLarge =
      const MixableToken<TextStyle>('md3.text.theme.label.large');
  final labelMedium =
      const MixableToken<TextStyle>('md3.text.theme.label.medium');
  final labelSmall =
      const MixableToken<TextStyle>('md3.text.theme.label.small');
  // Material 2 text styles
  final headline1 = const MixableToken<TextStyle>('md2.text.theme.headline1');
  final headline2 = const MixableToken<TextStyle>('md2.text.theme.headline2');
  final headline3 = const MixableToken<TextStyle>('md2.text.theme.headline3');
  final headline4 = const MixableToken<TextStyle>('md2.text.theme.headline4');
  final headline5 = const MixableToken<TextStyle>('md2.text.theme.headline5');
  final headline6 = const MixableToken<TextStyle>('md2.text.theme.headline6');
  final subtitle1 = const MixableToken<TextStyle>('md2.text.theme.subtitle1');
  final subtitle2 = const MixableToken<TextStyle>('md2.text.theme.subtitle2');
  final bodyText1 = const MixableToken<TextStyle>('md2.text.theme.bodyText1');
  final bodyText2 = const MixableToken<TextStyle>('md2.text.theme.bodyText2');
  final caption = const MixableToken<TextStyle>('md2.text.theme.caption');
  final button = const MixableToken<TextStyle>('md2.text.theme.button');
  final overline = const MixableToken<TextStyle>('md2.text.theme.overline');

  const _MaterialTextStyles();
}
