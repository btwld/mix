import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../theme/tokens/mix_token.dart';
import 'color_directives.dart';
import 'color_directives_impl.dart';

/// A Data transfer object that represents a [Color] value.
///
/// Create instances using the factory constructors:
/// - `ColorDto.value()` for direct color values
/// - `ColorDto.token()` for theme token references
@immutable
sealed class ColorDto extends Mixable<Color> with Diagnosticable {
  /// Directives to apply to the resolved color
  final List<ColorDirective> directives;

  // Private constructor
  const ColorDto._({this.directives = const []});

  // Public factory constructors
  const factory ColorDto.value(
    Color value, {
    List<ColorDirective> directives,
  }) = _ValueColorDto;

  const factory ColorDto.token(
    MixableToken<Color> token, {
    List<ColorDirective> directives,
  }) = _TokenColorDto;

  /// Handles reset directive logic when merging directive lists
  @protected
  static List<ColorDirective> mergeDirectives(
    List<ColorDirective> current,
    List<ColorDirective> incoming,
  ) {
    final combined = [...current, ...incoming];
    final lastResetIndex =
        combined.lastIndexWhere((e) => e is ResetColorDirective);

    return lastResetIndex == -1 ? combined : combined.sublist(lastResetIndex);
  }

  /// Applies directives to a color
  @protected
  Color applyDirectives(Color color) {
    Color result = color;
    for (final directive in directives) {
      result = directive.modify(result);
    }

    return result;
  }

  @override
  ColorDto merge(ColorDto? other) {
    if (other == null) return this;

    // Merge directives from both
    final mergedDirectives = mergeDirectives(directives, other.directives);

    // Create new instance based on the other's type (other takes precedence)
    return switch (other) {
      _ValueColorDto(:final value) =>
        ColorDto.value(value, directives: mergedDirectives),
      _TokenColorDto(:final token) =>
        ColorDto.token(token, directives: mergedDirectives),
    };
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (directives.isNotEmpty) {
      properties.add(IterableProperty('directives', directives));
    }
  }
}

// Private implementation for direct color values
@immutable
class _ValueColorDto extends ColorDto {
  final Color value;

  const _ValueColorDto(this.value, {super.directives}) : super._();

  @override
  Color resolve(MixContext mix) => applyDirectives(value);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', value));
  }

  @override
  List<Object?> get props => [value, directives];
}

// Private implementation for token references
@immutable
class _TokenColorDto extends ColorDto {
  final MixableToken<Color> token;

  const _TokenColorDto(this.token, {super.directives}) : super._();

  @override
  Color resolve(MixContext mix) {
    final resolved = mix.scope.getToken(token, mix.context);

    return applyDirectives(resolved);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('token', token.name));
  }

  @override
  List<Object?> get props => [token, directives];
}

extension ColorExt on Color {
  ColorDto toDto() => ColorDto.value(this);
}
