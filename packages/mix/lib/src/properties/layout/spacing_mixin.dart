import '../../core/mix_element.dart';
import 'edge_insets_geometry_mix.dart';

/// Mixin that provides convenient spacing methods for styles
mixin SpacingMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T padding(EdgeInsetsGeometryMix value);

  /// Must be implemented by the class using this mixin
  T margin(EdgeInsetsGeometryMix value);
}
