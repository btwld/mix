import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../specs/flex/flex_style.dart';

/// Provides convenient flex layout styling methods for spec attributes.
mixin FlexStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T flex(FlexStyler value);
  
  /// Sets flex direction
  T direction(Axis value) {
    return flex(FlexStyler(direction: value));
  }
  
  /// Sets main axis alignment
  T mainAxisAlignment(MainAxisAlignment value) {
    return flex(FlexStyler(mainAxisAlignment: value));
  }
  
  /// Sets cross axis alignment
  T crossAxisAlignment(CrossAxisAlignment value) {
    return flex(FlexStyler(crossAxisAlignment: value));
  }
  
  /// Sets main axis size
  T mainAxisSize(MainAxisSize value) {
    return flex(FlexStyler(mainAxisSize: value));
  }
  
  /// Sets vertical direction
  T verticalDirection(VerticalDirection value) {
    return flex(FlexStyler(verticalDirection: value));
  }
  
  /// Sets text direction
  T textDirection(TextDirection value) {
    return flex(FlexStyler(textDirection: value));
  }
  
  /// Sets text baseline
  T textBaseline(TextBaseline value) {
    return flex(FlexStyler(textBaseline: value));
  }
  
  /// Sets spacing
  T spacing(double value) {
    return flex(FlexStyler(spacing: value));
  }
  
  /// Convenience method for setting direction to horizontal (row)
  T row() => direction(Axis.horizontal);

  /// Convenience method for setting direction to vertical (column)
  T column() => direction(Axis.vertical);
}