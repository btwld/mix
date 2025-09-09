import 'package:flutter/material.dart';
import 'package:mix/src/theme/tokens/color_token.dart';
import 'package:mix/src/theme/tokens/space_token.dart';
import 'package:mix/src/theme/tokens/radius_token.dart';

// Basic color tokens
final $primary = ColorToken('primary');
final $surface = ColorToken('surface');
final $surfaceVariant = ColorToken('surface.variant');
final $onPrimary = ColorToken('on.primary');
final $onSurface = ColorToken('on.surface');
final $onSurfaceVariant = ColorToken('on.surface.variant');

// Basic spacing tokens
final $space = SpaceToken('space');
final $spaceSmall = SpaceToken('space.small');
final $spaceLarge = SpaceToken('space.large');

// Basic radius token
final $radius = RadiusToken('radius');

// Token maps for use with MixScope
final exampleColorTokens = <ColorToken, Color>{
  $primary: Colors.blue,
  $surface: Colors.grey.shade200,
  $surfaceVariant: Colors.grey.shade300,
  $onPrimary: Colors.white,
  $onSurface: Colors.grey.shade800,
  $onSurfaceVariant: Colors.grey.shade600,
};

final exampleSpaceTokens = <SpaceToken, double>{
  $spaceSmall: 8.0,
  $space: 16.0,
  $spaceLarge: 24.0,
};

final exampleRadiusTokens = <RadiusToken, Radius>{
  $radius: const Radius.circular(20),
};
