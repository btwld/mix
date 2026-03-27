import '../../core/spec.dart';
import '../../core/style.dart';
import '../../theme/tokens/mix_token.dart';
import 'variant_style_mixin.dart';

mixin TokenStyleMixin<T extends Style<S>, S extends Spec<S>>
    on VariantStyleMixin<T, S> {
  /// Applies style values produced from a resolved [MixToken].
  ///
  /// The token is resolved at build time using the current [BuildContext].
  T useToken<U>(MixToken<U> token, T Function(U value) builder) {
    return onBuilder((context) => builder(token.resolve(context)));
  }
}
