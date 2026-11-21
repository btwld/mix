/// Tailwind preset values that are not represented in the generated theme maps.
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

enum TextShadowPreset { twoXs, xs, sm, md, lg }

const kTextShadowPresets = {
  TextShadowPreset.twoXs: [
    Shadow(color: Color(0x26000000), offset: Offset(0, 1), blurRadius: 0),
  ],
  TextShadowPreset.xs: [
    Shadow(color: Color(0x33000000), offset: Offset(0, 1), blurRadius: 1),
  ],
  TextShadowPreset.sm: [
    Shadow(color: Color(0x13000000), offset: Offset(0, 1), blurRadius: 0),
    Shadow(color: Color(0x13000000), offset: Offset(0, 1), blurRadius: 1),
    Shadow(color: Color(0x13000000), offset: Offset(0, 2), blurRadius: 2),
  ],
  TextShadowPreset.md: [
    Shadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 1),
    Shadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 2),
    Shadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
  ],
  TextShadowPreset.lg: [
    Shadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 2),
    Shadow(color: Color(0x1A000000), offset: Offset(0, 3), blurRadius: 2),
    Shadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 8),
  ],
};

final kTailwindBoxShadowPresets = {
  'shadow-xs': [
    BoxShadowMix(
      color: const Color(0x0D000000),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ],
  'shadow-sm': [
    BoxShadowMix(
      color: const Color(0x0D000000),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ],
  'shadow': [
    BoxShadowMix(
      color: const Color(0x1A000000),
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadowMix(
      color: const Color(0x0F000000),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ],
  'shadow-md': [
    BoxShadowMix(
      color: const Color(0x1A000000),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadowMix(
      color: const Color(0x1A000000),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ],
  'shadow-lg': [
    BoxShadowMix(
      color: const Color(0x1A000000),
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadowMix(
      color: const Color(0x1A000000),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
    ),
  ],
  'shadow-xl': [
    BoxShadowMix(
      color: const Color(0x1A000000),
      offset: const Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadowMix(
      color: const Color(0x1A000000),
      offset: const Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
    ),
  ],
  'shadow-2xl': [
    BoxShadowMix(
      color: const Color(0x40000000),
      offset: const Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
    ),
  ],
};

const kTailwindMaxWidthPresets = {
  'xs': 320.0,
  'sm': 384.0,
  'md': 448.0,
  'lg': 512.0,
  'xl': 576.0,
  '2xl': 672.0,
  '3xl': 768.0,
  '4xl': 896.0,
  '5xl': 1024.0,
  '6xl': 1152.0,
  '7xl': 1280.0,
};
