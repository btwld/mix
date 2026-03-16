import '../../core/spec.dart';
import '../../core/style.dart';
import '../../theme/tokens/mix_token.dart';
import 'variant_style_mixin.dart';

mixin TokenStyleMixin<T extends Style<S>, S extends Spec<S>>
    on VariantStyleMixin<T, S> {
  /// Applies styling based on a resolved [MixToken] value.
  ///
  /// The [token] is resolved against the current [BuildContext] at runtime,
  /// and the given [builder] function is used to produce a style based on the value.
  ///
  /// Example:
  /// ```dart
  /// BoxStyler()
  ///   .useToken($primary, BoxStyler().color);
  /// ```
  ///
  /// ```dart
  /// BoxStyler()
  ///   .useToken($primary, (color) => BoxStyler().color(color));
  /// ```
  ///
  /// This enables context-aware design tokens (such as colors or spacing)
  /// to drive dynamic styling, including theming and design system integration.
  T useToken<U>(MixToken<U> token, T Function(U value) builder) {
    return onBuilder((context) {
      return builder(token.resolve(context));
    });
  }
}
