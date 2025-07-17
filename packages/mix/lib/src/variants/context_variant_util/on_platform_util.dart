import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/variant.dart';

base class OnPlatformVariant extends ContextVariant {
  final TargetPlatform platform;

  const OnPlatformVariant(this.platform);

  @override
  bool when(BuildContext context) {
    return !MixHelpers.isWeb && MixHelpers.targetPlatform == platform;
  }

  @override
  List<Object?> get props => [platform];
}

base class OnWebVariant extends ContextVariant {
  const OnWebVariant();

  @override
  bool when(BuildContext context) => MixHelpers.isWeb;

  @override
  List<Object?> get props => [];
}
