import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// Keeps the desktop viewer in its full navigation layout at its minimum size.
const atlasMinimumWindowSize = Size(1040, 700);

/// Provides a comfortable initial canvas while remaining laptop-friendly.
const atlasInitialWindowSize = Size(1280, 800);

const atlasWindowOptions = WindowOptions(
  size: atlasInitialWindowSize,
  center: true,
  minimumSize: atlasMinimumWindowSize,
  title: 'Mix Atlas',
);
