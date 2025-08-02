import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A design token that can be resolved to a value within a Mix theme.
///
/// Tokens provide a way to reference theme values indirectly, allowing for
/// dynamic theming and consistent design system implementation.
@immutable
class MixToken<T> {
  final String name;
  const MixToken(this.name);

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    if (runtimeType != other.runtimeType) return false;

    return other is MixToken && other.name == name;
  }

  @override
  String toString() => 'MixToken<$T>($name)';

  @override
  int get hashCode => Object.hash(name, T);
}

typedef BuildContextResolver<T> = T Function(BuildContext context);
