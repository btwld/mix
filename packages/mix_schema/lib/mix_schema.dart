/// Reference Dart implementation of the Mix JSON Schema.
///
/// Public contract for describing Mix widget trees declaratively. Producers
/// (AI agents, design tools, CMS, backends) emit JSON conforming to this
/// contract; consumers parse and render it.
///
/// See `guides/mix_schema/spec.md` for the normative specification.
library;

export 'src/assets.dart' show MixSchemaAssets;
export 'src/errors.dart'
    show
        ErrorCatalog,
        ErrorCode,
        ErrorCodeDef,
        MixSchemaError,
        Severity,
        ValidationResult;
export 'src/registry.dart'
    show
        DirectiveDef,
        FieldDef,
        LiteralDef,
        ModifierDef,
        Registry,
        SpecDef,
        TokenNamespaceDef;
