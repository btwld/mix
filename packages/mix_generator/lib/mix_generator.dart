/// Code generators for Mix specs, stylers, mix values, and widget wrappers.
///
/// This package generates the following artifacts:
/// - Spec mixin `_$XSpec`: self-contained — implements `Spec<X>` and
///   `Diagnosticable`; inlines `==`, `hashCode`, `toString`, `getDiff`,
///   `toDiagnosticsNode`, `debugFillProperties`, plus `copyWith`, `lerp`,
///   `props`, and `type`.
/// - Styler mixin `_$XStylerMixin`: setters, base methods (`animate`,
///   `variants`, `wrap`, `modifier`), `merge`, `resolve`,
///   `debugFillProperties`, `props`.
/// - Mix mixin `_$XMixin`: `merge`, `resolve`, `props`.
/// - Widget wrapper `class X extends StatelessWidget` for a `Style<S>`
///   factory annotated with `@MixWidget`.
library;

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import 'src/mix_generator.dart';
import 'src/mix_widget_generator.dart';
import 'src/mixable_generator.dart';
import 'src/spec_styler_generator.dart';

// Expose internals for generator unit tests.
export 'src/core/builders/index.dart';
export 'src/core/curated/index.dart';
export 'src/core/models/field_model.dart';
export 'src/core/models/mix_field_model.dart';
export 'src/core/models/mix_widget_model.dart';
export 'src/core/models/styler_field_model.dart';
export 'src/core/resolvers/index.dart';
export 'src/mix_generator.dart';
export 'src/mix_widget_generator.dart';
export 'src/mixable_generator.dart';
export 'src/spec_styler_generator.dart';

/// Builder factory for `mix_generator`.
///
/// Generates `_$XSpec` mixins for `@MixableSpec` classes, including `type`,
/// `copyWith`, `lerp`, `props`, and `debugFillProperties` overrides.
Builder mixGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [SpecGenerator()],
    'mix_generator',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}

/// Builder factory for `spec_styler_generator`.
///
/// Generates full Styler classes from `@MixableSpec` classes.
Builder specStylerGenerator(BuilderOptions _) {
  return LibraryBuilder(
    const SpecStylerGenerator(),
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
    generatedExtension: '.styler.g.dart',
  );
}

/// Builder factory for `mixable_generator`.
///
/// Generates `_$XMixin` implementations for `@Mixable` classes.
Builder mixableGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [MixableGenerator()],
    'mixable_generator',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}

/// Builder factory for `mix_widget_generator`.
///
/// Generates `StatelessWidget` wrappers for `@MixWidget` top-level factories.
Builder mixWidgetGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [MixWidgetGenerator()],
    'mix_widget_generator',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}
