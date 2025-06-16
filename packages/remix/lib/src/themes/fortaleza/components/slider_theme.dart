import 'package:flutter/animation.dart';
import 'package:mix/mix.dart';

import '../../../components/form/slider/slider.dart';
import '../tokens.dart';

class FortalezaSliderStyle extends SliderStyle {
  const FortalezaSliderStyle();

  @override
  Style makeStyle(SpecConfiguration<SliderSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);
    final divisions = $.division.color.$neutralAlpha(8);

    final thumb = $.thumb
      ..color.$neutral(1)
      ..shape.circle.side.color.$accent(9);

    final track = $.track
      ..color.resetDirectives()
      ..color.$accent(4)
      ..height(6)
      ..borderRadius.all(10);

    final activeTrack = $.activeTrack
      ..color.resetDirectives()
      ..color.$accent(9)
      ..height(6)
      ..borderRadius.all(10);

    final disabled = spec.on.disabled(
      $.activeTrack.color.$accent(7),
      $.thumb.shape.circle.side.color.$accent(7),
    );

    final animation = (spec.on.press | spec.on.hover)(
      $.thumb.shadow.spreadRadius(8),
      $.thumb.shadow.color.$accentAlpha(4),
    );

    return Style.create([
      baseStyle,
      divisions,
      thumb,
      track,
      activeTrack,
      disabled,
      animation,
    ]).animate(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }
}
