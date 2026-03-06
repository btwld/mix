/// Built-in registry scope identifiers recognized by `mix_schema`.
enum MixSchemaScope {
  animationOnEnd('animation_on_end'),
  imageProvider('image_provider'),
  modifierShader('modifier_shader'),
  modifierClipper('modifier_clipper'),
  contextVariantBuilder('context_variant_builder');

  const MixSchemaScope(this.wireValue);

  /// Stable wire value used by runtime registries and payload transforms.
  final String wireValue;

  @override
  String toString() => wireValue;
}
