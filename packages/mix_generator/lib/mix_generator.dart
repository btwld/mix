/// Mix Generator - Auto-generates Spec, Styler, Mix, and Widget class bodies.
///
/// This package generates:
/// - Spec mixin `_$XSpec`: self-contained — implements `Spec<X>` and
///   `Diagnosticable`; inlines `==`, `hashCode`, `toString`, `getDiff`,
///   `toDiagnosticsNode`, `debugFillProperties`, plus `copyWith`, `lerp`,
///   `props`, and `type`.
/// - Styler mixin `_$XStylerMixin`: setters, base methods (`animate`,
///   `variants`, `wrap`), `merge`, `resolve`, `debugFillProperties`, `props`.
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
import 'src/styler_generator.dart';

// Export core components for testing
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
export 'src/styler_generator.dart';

/// Entry point for the mix_generator builder.
///
/// Triggers on `@MixableSpec` annotations and generates the `_$XSpec` mixin
/// (Spec method overrides: `type`, `copyWith`, `lerp`, `props`,
/// `debugFillProperties`).
Builder mixGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [SpecGenerator()],
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

/// Entry point for the mixable_generator builder.
///
/// Triggers on @Mixable annotations and generates:
/// - _$XMixin (Mix method implementations: merge, resolve, props)
Builder mixableGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [MixableGenerator()],
    'mixable_generator',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}

/// Entry point for the mix_widget_generator builder.
///
/// Triggers on @MixWidget annotations applied to top-level variables or
/// functions and generates a `class <Name> extends StatelessWidget` whose
/// constructor mirrors the factory + styler `call()` parameters.
Builder mixWidgetGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [MixWidgetGenerator()],
    'mix_widget_generator',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}
