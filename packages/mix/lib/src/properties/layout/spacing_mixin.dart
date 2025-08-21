import '../../core/style.dart';
import 'edge_insets_geometry_mix.dart';

/// Mixin that provides convenient spacing methods for styles
mixin SpacingMixin<T extends Style<Object?>> {
  /// Must be implemented by the class using this mixin
  T padding(EdgeInsetsGeometryMix value);

  /// Must be implemented by the class using this mixin  
  T margin(EdgeInsetsGeometryMix value);
}