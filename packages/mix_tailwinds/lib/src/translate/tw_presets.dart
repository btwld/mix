/// Tailwind preset values that are not represented in the generated theme maps.
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

enum TextShadowPreset { twoXs, xs, sm, md, lg }

const kTextShadowPresets = <TextShadowPreset, List<Shadow>>{
  TextShadowPreset.twoXs: [
    Shadow(offset: Offset(0, 1), blurRadius: 0, color: Color(0x26000000)),
  ],
  TextShadowPreset.xs: [
    Shadow(offset: Offset(0, 1), blurRadius: 1, color: Color(0x33000000)),
  ],
  TextShadowPreset.sm: [
    Shadow(offset: Offset(0, 1), blurRadius: 0, color: Color(0x13000000)),
    Shadow(offset: Offset(0, 1), blurRadius: 1, color: Color(0x13000000)),
    Shadow(offset: Offset(0, 2), blurRadius: 2, color: Color(0x13000000)),
  ],
  TextShadowPreset.md: [
    Shadow(offset: Offset(0, 1), blurRadius: 1, color: Color(0x1A000000)),
    Shadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x1A000000)),
    Shadow(offset: Offset(0, 2), blurRadius: 4, color: Color(0x1A000000)),
  ],
  TextShadowPreset.lg: [
    Shadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x1A000000)),
    Shadow(offset: Offset(0, 3), blurRadius: 2, color: Color(0x1A000000)),
    Shadow(offset: Offset(0, 4), blurRadius: 8, color: Color(0x1A000000)),
  ],
};

final kTailwindBoxShadowPresets = <String, List<BoxShadowMix>>{
  'shadow-sm': [
    BoxShadowMix(
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
      color: const Color(0x0D000000),
    ),
  ],
  'shadow': [
    BoxShadowMix(
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
      color: const Color(0x1A000000),
    ),
    BoxShadowMix(
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
      color: const Color(0x0F000000),
    ),
  ],
  'shadow-md': [
    BoxShadowMix(
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
      color: const Color(0x1A000000),
    ),
    BoxShadowMix(
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
      color: const Color(0x1A000000),
    ),
  ],
  'shadow-lg': [
    BoxShadowMix(
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
      color: const Color(0x1A000000),
    ),
    BoxShadowMix(
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
      color: const Color(0x1A000000),
    ),
  ],
  'shadow-xl': [
    BoxShadowMix(
      offset: const Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
      color: const Color(0x1A000000),
    ),
    BoxShadowMix(
      offset: const Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
      color: const Color(0x1A000000),
    ),
  ],
  'shadow-2xl': [
    BoxShadowMix(
      offset: const Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
      color: const Color(0x40000000),
    ),
  ],
  'shadow-card': [
    BoxShadowMix(
      offset: const Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
      color: const Color(0x1F000000),
    ),
  ],
};
