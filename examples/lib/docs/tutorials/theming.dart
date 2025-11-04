/// Theming Tutorial
///
/// This example demonstrates Mix's robust theming system using design tokens.
/// It shows how to create multiple themes and apply them consistently across
/// your application.
///
/// Key concepts:
/// - Creating design tokens (ColorToken, TextStyleToken, SpaceToken, RadiusToken)
/// - Using MixScope to provide token values
/// - Building themed components with BoxStyler and TextStyler
/// - Switching between themes dynamically
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(const ThemingTutorialApp());
}

enum CustomColorTokens {
  primary('primary'),
  onPrimary('on-primary'),
  surface('surface'),
  onSurface('on-surface'),
  onSurfaceVariant('on-surface-variant');

  final String name;

  const CustomColorTokens(this.name);

  ColorToken get token => ColorToken(name);
}

enum CustomTextStyleTokens {
  headline1('headline1'),
  headline2('headline2'),
  button('headline3'),
  body('body'),
  callout('callout');

  final String name;
  const CustomTextStyleTokens(this.name);

  TextStyleToken get token => TextStyleToken(name);
}

enum MyThemeRadiusToken {
  large('large'),
  medium('medium');

  final String name;
  const MyThemeRadiusToken(this.name);

  RadiusToken get token => RadiusToken(name);
}

enum MyThemeSpaceToken {
  medium('medium'),
  large('large');

  final String name;
  const MyThemeSpaceToken(this.name);

  SpaceToken get token => SpaceToken(name);
}

// Light Blue Theme
class LightBlueTheme {
  static Map<ColorToken, Color> get colors => {
    CustomColorTokens.primary.token: const Color(0xFF0093B9),
    CustomColorTokens.onPrimary.token: const Color(0xFFFAFAFA),
    CustomColorTokens.surface.token: const Color(0xFFFAFAFA),
    CustomColorTokens.onSurface.token: const Color(0xFF141C24),
    CustomColorTokens.onSurfaceVariant.token: const Color(0xFF405473),
  };

  static Map<TextStyleToken, TextStyle> get textStyles => {
    CustomTextStyleTokens.headline1.token: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
    CustomTextStyleTokens.headline2.token: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
    CustomTextStyleTokens.button.token: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
    CustomTextStyleTokens.body.token: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto',
    ),
    CustomTextStyleTokens.callout.token: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto',
    ),
  };

  static Map<RadiusToken, Radius> get radii => {
    MyThemeRadiusToken.large.token: const Radius.circular(100),
    MyThemeRadiusToken.medium.token: const Radius.circular(12),
  };

  static Map<SpaceToken, double> get spaces => {
    MyThemeSpaceToken.medium.token: 16,
    MyThemeSpaceToken.large.token: 24,
  };
}

// Dark Purple Theme
class DarkPurpleTheme {
  static Map<ColorToken, Color> get colors => {
    CustomColorTokens.primary.token: const Color(0xFF617AFA),
    CustomColorTokens.onPrimary.token: const Color(0xFFFAFAFA),
    CustomColorTokens.surface.token: const Color(0xFF1C1C21),
    CustomColorTokens.onSurface.token: const Color(0xFFFAFAFA),
    CustomColorTokens.onSurfaceVariant.token: const Color(0xFFD6D6DE),
  };

  static Map<TextStyleToken, TextStyle> get textStyles => {
    CustomTextStyleTokens.headline1.token: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: 'Courier',
    ),
    CustomTextStyleTokens.headline2.token: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Courier',
    ),
    CustomTextStyleTokens.button.token: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'Courier',
    ),
    CustomTextStyleTokens.body.token: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontFamily: 'Courier',
    ),
    CustomTextStyleTokens.callout.token: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: 'Courier',
    ),
  };

  static Map<RadiusToken, Radius> get radii => {
    MyThemeRadiusToken.large.token: const Radius.circular(12),
    MyThemeRadiusToken.medium.token: const Radius.circular(8),
  };

  static Map<SpaceToken, double> get spaces => {
    MyThemeSpaceToken.medium.token: 16,
    MyThemeSpaceToken.large.token: 24,
  };
}

// ProfileButton Component
class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final box = BoxStyler()
        .height(50)
        .width(double.infinity)
        .color(CustomColorTokens.primary.token())
        .alignment(Alignment.center)
        .borderRadiusAll(MyThemeRadiusToken.large.token());

    final text = TextStyler()
        .style(CustomTextStyleTokens.button.token.mix())
        .color(CustomColorTokens.onPrimary.token());

    return box(child: text(label));
  }
}

// ProfilePage Widget
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarTitle = TextStyler()
        .style(CustomTextStyleTokens.headline2.token.mix())
        .color(CustomColorTokens.onSurface.token());

    final flexBox = FlexBoxStyler()
        .crossAxisAlignment(.start)
        .marginAll(MyThemeSpaceToken.medium.token())
        .spacing(MyThemeSpaceToken.medium.token());

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Profile'),
        backgroundColor: CustomColorTokens.surface.token.resolve(context),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ColumnBox(
          style: flexBox,
          children: [
            // Image
            ImagePlaceholder(),
            // Title
            StyledText(
              'Hollywood Academy',
              style: TextStyler()
                  .style(CustomTextStyleTokens.headline1.token.mix())
                  .color(CustomColorTokens.onSurface.token()),
            ),
            // Subtitle
            StyledText(
              'Education · Los Angeles, California',
              style: TextStyler()
                  .style(CustomTextStyleTokens.callout.token.mix())
                  .color(CustomColorTokens.onSurfaceVariant.token()),
            ),
            // Description
            StyledText(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
              style: TextStyler()
                  .style(CustomTextStyleTokens.body.token.mix())
                  .color(CustomColorTokens.onSurfaceVariant.token()),
            ),
            const Spacer(),
            // Button
            const ProfileButton(label: 'Add to your contacts'),
          ],
        ),
      ),
      backgroundColor: CustomColorTokens.surface.token.resolve(context),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final imageContainer = BoxStyler()
        .height(200)
        .width(double.infinity)
        .color(CustomColorTokens.primary.token())
        .borderRadiusAll(MyThemeRadiusToken.medium.token());

    final icon = IconStyler()
        .size(80)
        .color(CustomColorTokens.onPrimary.token());

    return imageContainer(child: icon(icon: Icons.image));
  }
}

// Main App with Theme Switching
class ThemingTutorialApp extends StatefulWidget {
  const ThemingTutorialApp({super.key});

  @override
  State<ThemingTutorialApp> createState() => _ThemingTutorialAppState();
}

class _ThemingTutorialAppState extends State<ThemingTutorialApp> {
  final bool _isDarkPurpleTheme = true;

  @override
  Widget build(BuildContext context) {
    // Select theme based on state
    final colors = _isDarkPurpleTheme
        ? DarkPurpleTheme.colors
        : LightBlueTheme.colors;
    final textStyles = _isDarkPurpleTheme
        ? DarkPurpleTheme.textStyles
        : LightBlueTheme.textStyles;
    final radii = _isDarkPurpleTheme
        ? DarkPurpleTheme.radii
        : LightBlueTheme.radii;
    final spaces = _isDarkPurpleTheme
        ? DarkPurpleTheme.spaces
        : LightBlueTheme.spaces;

    return MixScope(
      colors: colors,
      textStyles: textStyles,
      spaces: spaces,
      radii: radii,
      child: const ProfilePage(),
    );
  }
}
