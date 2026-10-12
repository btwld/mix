import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/widget_modifier.dart';

part 'blur_modifier.g.dart';

/// Modifier that applies a Gaussian blur filter to its child.
///
/// Wraps the child in an [ImageFiltered] widget using [ui.ImageFilter.blur].
@MixableModifier()
final class BlurModifier with _$BlurModifier {
  /// Blur sigma for X and Y axis.
  @override
  final double sigma;

  /// How the blur treats pixels outside the child's bounds.
  ///
  /// Defaults to [ui.TileMode.clamp], which extends edge pixels. Use
  /// [ui.TileMode.decal] for soft glows and blooms, where the blurred shape
  /// should fade to transparent instead of smearing its edges.
  @override
  final ui.TileMode tileMode;

  const BlurModifier([double? sigma, ui.TileMode? tileMode])
    : sigma = sigma ?? 0.0,
      tileMode = tileMode ?? ui.TileMode.clamp;

  @override
  Widget build(Widget child) {
    if (sigma == 0.0) return child;

    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(
        sigmaX: sigma,
        sigmaY: sigma,
        tileMode: tileMode,
      ),
      child: child,
    );
  }
}
