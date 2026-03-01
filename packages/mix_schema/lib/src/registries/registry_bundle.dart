import 'package:flutter/widgets.dart';

import 'frozen_registry.dart';
import 'registry.dart';

abstract final class RegistryScope {
  static const imageProvider = 'image_provider';
  static const animationOnEnd = 'animation_on_end';
  static const modifierShader = 'modifier_shader';
  static const modifierClipper = 'modifier_clipper';
  static const contextVariantBuilder = 'context_variant_builder';
}

final class RegistryBundleBuilder {
  final RegistryBuilder<ImageProvider<Object>> imageProvider = RegistryBuilder(
    scope: RegistryScope.imageProvider,
  );
  final RegistryBuilder<VoidCallback> animationOnEnd = RegistryBuilder(
    scope: RegistryScope.animationOnEnd,
  );
  final RegistryBuilder<ShaderCallback> modifierShader = RegistryBuilder(
    scope: RegistryScope.modifierShader,
  );
  final RegistryBuilder<Object> modifierClipper = RegistryBuilder(
    scope: RegistryScope.modifierClipper,
  );
  final RegistryBuilder<Object> contextVariantBuilder = RegistryBuilder(
    scope: RegistryScope.contextVariantBuilder,
  );

  FrozenRegistryBundle freeze() {
    return FrozenRegistryBundle(
      imageProvider: imageProvider.freeze(),
      animationOnEnd: animationOnEnd.freeze(),
      modifierShader: modifierShader.freeze(),
      modifierClipper: modifierClipper.freeze(),
      contextVariantBuilder: contextVariantBuilder.freeze(),
    );
  }
}

final class FrozenRegistryBundle {
  final FrozenRegistry<ImageProvider<Object>> imageProvider;
  final FrozenRegistry<VoidCallback> animationOnEnd;
  final FrozenRegistry<ShaderCallback> modifierShader;
  final FrozenRegistry<Object> modifierClipper;
  final FrozenRegistry<Object> contextVariantBuilder;

  const FrozenRegistryBundle({
    required this.imageProvider,
    required this.animationOnEnd,
    required this.modifierShader,
    required this.modifierClipper,
    required this.contextVariantBuilder,
  });

  factory FrozenRegistryBundle.empty() {
    return RegistryBundleBuilder().freeze();
  }
}
