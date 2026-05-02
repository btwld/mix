/// Flutter runtime bindings for the Mix JSON Schema.
///
/// Bridges typed [MixJsonDocument] models from `package:mix_schema` to
/// the Mix runtime (`BoxStyler`, `TextStyler`, ...) and back.
///
/// Re-exports the entire `mix_schema` API so most consumers depend on
/// `mix_schema_flutter` alone.
library;

export 'package:mix_schema/mix_schema.dart';

export 'src/host_resolver.dart'
    show AllowlistHostResolver, EmptyHostResolver, HostResolver;
export 'src/parser_to_runtime.dart' show RuntimeParser;
export 'src/serializer_from_runtime.dart' show RuntimeSerializer;
