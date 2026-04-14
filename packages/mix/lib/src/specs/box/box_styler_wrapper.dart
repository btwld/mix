import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import 'box_style.dart';

/// A wrapper that holds a list of [BoxStyler] layers and resolves them
/// into a single [BoxStyler] with all variants applied and tokens resolved.
///
/// Unlike [BoxStyler.merge], which combines styles eagerly,
/// [BoxStylerWrapper] preserves each layer independently until
/// [resolve] is called with a [BuildContext].
///
/// The [resolve] method:
/// 1. Merges all layers into one [BoxStyler]
/// 2. Applies active variants (context, named, widget-state)
/// 3. Resolves all token references to concrete values
///
/// The result is a [BoxStyler] with no unresolved tokens or pending variants.
class BoxStylerWrapper {
  final List<BoxStyler> _styles;

  BoxStylerWrapper([BoxStyler? initial])
      : _styles = [?initial];

  BoxStylerWrapper._(this._styles);

  /// Adds a [BoxStyler] layer to the wrapper.
  BoxStylerWrapper wrap(BoxStyler styler) {
    return BoxStylerWrapper._([..._styles, styler]);
  }

  /// Resolves all layers into a single [BoxStyler] with concrete values.
  ///
  /// Merges all layers, applies active variants, and resolves all
  /// token references using the provided [context].
  BoxStyler resolve(BuildContext context) {
    // 1. Resolve variants per layer, then merge resolved layers
    BoxStyler merged = const BoxStyler.create();
    for (final style in _styles) {
      final resolved =
          style.mergeActiveVariants(context, namedVariants: {}) as BoxStyler;
      merged = merged.merge(resolved);
    }

    // 2. Resolve each Prop's tokens to concrete values
    return BoxStyler.create(
      alignment: _resolveProp(context, merged.$alignment),
      padding: _resolveProp(context, merged.$padding),
      margin: _resolveProp(context, merged.$margin),
      constraints: _resolveProp(context, merged.$constraints),
      decoration: _resolveProp(context, merged.$decoration),
      foregroundDecoration:
          _resolveProp(context, merged.$foregroundDecoration),
      transform: _resolveProp(context, merged.$transform),
      transformAlignment:
          _resolveProp(context, merged.$transformAlignment),
      clipBehavior: _resolveProp(context, merged.$clipBehavior),
      animation: merged.$animation,
      modifier: merged.$modifier,
    );
  }

  static Prop<V>? _resolveProp<V>(BuildContext context, Prop<V>? prop) {
    if (prop == null) return null;
    return Prop.value(prop.resolveProp(context));
  }
}
