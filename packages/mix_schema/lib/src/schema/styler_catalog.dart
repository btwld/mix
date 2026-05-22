import '../contract/mix_schema_limits.dart';
import '../registry/registry_catalog.dart';
import 'builtins/styler_metadata.dart';
import 'metadata/metadata_schemas.dart';
import 'painting/painting_schemas.dart';
import 'shared/shared_schemas.dart';

final class StylerCatalog {
  final RegistryCatalog registries;
  final MixSchemaLimits limits;

  late final imageProviderCodec = buildImageProviderCodec(registries);
  late final iconDataCodec = buildIconDataCodec(registries);
  late final decorationCodec = buildDecorationCodec(registries);
  late final metadata = StylerMetadataContext(
    registries: registries,
    limits: limits,
    animationCodec: buildAnimationCodec(registries),
    modifierCodec: buildModifierSchema(),
  );

  StylerCatalog({
    required this.registries,
    this.limits = const MixSchemaLimits(),
  });
}
