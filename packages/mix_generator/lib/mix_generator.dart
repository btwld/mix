/// Mix Generator - Auto-generates Spec and Styler class bodies.
///
/// This package generates:
/// - Spec mixin (_$XSpecMethods): copyWith(), lerp(), debugFillProperties(), props
/// - Styler mixin (_$XStylerMixin): setters, merge(), resolve(), debugFillProperties(), props
///
/// See PLAN.md for the implementation plan.
library;

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import 'src/mix_generator.dart';
import 'src/styler_generator.dart';

// Export core components for testing
export 'src/core/builders/index.dart';
export 'src/core/curated/index.dart';
export 'src/core/models/field_model.dart';
export 'src/core/models/styler_field_model.dart';
export 'src/core/registry/mix_type_registry.dart';
export 'src/core/resolvers/index.dart';
export 'src/mix_generator.dart';
export 'src/styler_generator.dart';

/// Entry point for the mix_generator builder.
///
/// Triggers on @MixableSpec annotations and generates:
/// - _$XSpecMethods mixin (Spec method overrides)
Builder mixGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [MixGenerator()],
    'mix_generator',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}

/// Entry point for the styler_generator builder.
///
/// Triggers on @MixableStyler annotations and generates:
/// - _$XStylerMixin (Styler method implementations)
Builder stylerGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [StylerGenerator()],
    'styler_generator',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}
