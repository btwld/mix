import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// Basic color tokens
final $primary = MixToken<Color>('primary');
final $surface = MixToken<Color>('surface');
final $surfaceVariant = MixToken<Color>('surface.variant');
final $onPrimary = MixToken<Color>('on.primary');
final $onSurface = MixToken<Color>('on.surface');
final $onSurfaceVariant = MixToken<Color>('on.surface.variant');

// Basic spacing tokens
final $space = MixToken<double>('space');
final $spaceSmall = MixToken<double>('space.small');
final $spaceLarge = MixToken<double>('space.large');

// Basic radius token
final $radius = MixToken<Radius>('radius');

// Simple default theme
final exampleTheme = {
  // Colors
  $primary.defineValue(Colors.blue),
  $surface.defineValue(Colors.grey.shade200),
  $surfaceVariant.defineValue(Colors.grey.shade300),
  $onPrimary.defineValue(Colors.white),
  $onSurface.defineValue(Colors.grey.shade800),
  $onSurfaceVariant.defineValue(Colors.grey.shade600),
  
  // Spacing
  $spaceSmall.defineValue(8.0),
  $space.defineValue(16.0),
  $spaceLarge.defineValue(24.0),
  
  // Radius
  $radius.defineValue(const Radius.circular(20)),
};