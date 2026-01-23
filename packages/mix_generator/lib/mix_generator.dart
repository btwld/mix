/// Mix Generator - Auto-generates Spec class bodies.
///
/// This package generates:
/// - Spec mixin (_$XSpecMethods): copyWith(), lerp(), debugFillProperties(), props
///
/// See PLAN.md for the implementation plan.
library;

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import 'src/mix_generator.dart';

// Export core components for testing
export 'src/core/builders/index.dart';
export 'src/core/curated/index.dart';
export 'src/core/models/field_model.dart';
export 'src/core/registry/mix_type_registry.dart';
export 'src/core/resolvers/index.dart';
export 'src/mix_generator.dart';

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
