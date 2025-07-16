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
  final primary = const MixToken<Color>('md.color.primary');

  final secondary = const MixToken<Color>('md.color.secondary');

  final tertiary = const MixToken<Color>('md.color.tertiary');

  final surface = const MixToken<Color>('md.color.surface');

  final background = const MixToken<Color>('md.color.background');

  final error = const MixToken<Color>('md.color.error');

  final onPrimary = const MixToken<Color>('md.color.on.primary');

  final onSecondary = const MixToken<Color>('md.color.on.secondary');

  final onTertiary = const MixToken<Color>('md.color.on.tertiary');

  final onSurface = const MixToken<Color>('md.color.on.surface');

  final onBackground = const MixToken<Color>('md.color.on.background');

  final onError = const MixToken<Color>('md.color.on.error');

  const _MaterialColorTokens();
}

@immutable
// Material 3 TextTheme Tokens.
class _MaterialTextStyles {
  //  Material 3 text styles
  final displayLarge = const MixToken<TextStyle>(
    'md3.text.theme.display.large',
  );
  final displayMedium = const MixToken<TextStyle>(
    'md3.text.theme.display.medium',
  );
  final displaySmall = const MixToken<TextStyle>(
    'md3.text.theme.display.small',
  );
  final headlineLarge = const MixToken<TextStyle>(
    'md3.text.theme.headline.large',
  );
  final headlineMedium = const MixToken<TextStyle>(
    'md3.text.theme.headline.medium',
  );
  final headlineSmall = const MixToken<TextStyle>(
    'md3.text.theme.headline.small',
  );

  final titleLarge = const MixToken<TextStyle>('md3.text.theme.title.large');
  final titleMedium = const MixToken<TextStyle>('md3.text.theme.title.medium');
  final titleSmall = const MixToken<TextStyle>('md3.text.theme.title.small');
  final bodyLarge = const MixToken<TextStyle>('md3.text.theme.body.large');
  final bodyMedium = const MixToken<TextStyle>('md3.text.theme.body.medium');
  final bodySmall = const MixToken<TextStyle>('md3.text.theme.body.small');
  final labelLarge = const MixToken<TextStyle>('md3.text.theme.label.large');
  final labelMedium = const MixToken<TextStyle>('md3.text.theme.label.medium');
  final labelSmall = const MixToken<TextStyle>('md3.text.theme.label.small');
  // Material 2 text styles
  final headline1 = const MixToken<TextStyle>('md2.text.theme.headline1');
  final headline2 = const MixToken<TextStyle>('md2.text.theme.headline2');
  final headline3 = const MixToken<TextStyle>('md2.text.theme.headline3');
  final headline4 = const MixToken<TextStyle>('md2.text.theme.headline4');
  final headline5 = const MixToken<TextStyle>('md2.text.theme.headline5');
  final headline6 = const MixToken<TextStyle>('md2.text.theme.headline6');
  final subtitle1 = const MixToken<TextStyle>('md2.text.theme.subtitle1');
  final subtitle2 = const MixToken<TextStyle>('md2.text.theme.subtitle2');
  final bodyText1 = const MixToken<TextStyle>('md2.text.theme.bodyText1');
  final bodyText2 = const MixToken<TextStyle>('md2.text.theme.bodyText2');
  final caption = const MixToken<TextStyle>('md2.text.theme.caption');
  final button = const MixToken<TextStyle>('md2.text.theme.button');
  final overline = const MixToken<TextStyle>('md2.text.theme.overline');

  const _MaterialTextStyles();
}
