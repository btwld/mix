import 'package:flutter/widgets.dart';

import '../../specs/icon/icon_spec.dart';
import '../../specs/text/text_spec.dart';
import '../spec.dart';
import '../style.dart';

/// Provides unresolved styles to descendant widgets for inheritance.
///
/// Deprecated: Use [Style.of] or [Style.maybeOf] instead.
@Deprecated(
  'Use Style.of() or Style.maybeOf() instead. '
  'This will be removed in a future release.',
)
class StyleProvider<S extends Spec<S>> extends InheritedWidget {
  const StyleProvider({super.key, required this.style, required super.child});

  /// Gets the closest [Style] from the widget tree, or null if not found.
  ///
  /// Deprecated: Use [Style.maybeOf] instead.
  @Deprecated(
    'Use Style.maybeOf() instead. '
    'This will be removed in a future release.',
  )
  static Style<S>? maybeOf<S extends Spec<S>>(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<StyleProvider<S>>();

    return provider?.style;
  }

  /// The style provided to descendant widgets.
  final Style<S> style;

  @override
  bool updateShouldNotify(StyleProvider<S> oldWidget) {
    return style != oldWidget.style;
  }
}

/// Provides [TextStyler] to descendant [StyledText].
///
/// This is a convenience typedef for [StyleProvider<TextSpec>] that makes it
/// easier to provide [TextStyler] (font, color, size, etc.) to descendant
/// [StyledText] widgets through the widget tree.
typedef DefaultStyledText = StyleProvider<TextSpec>;

/// Provides [IconStyler] to descendant [StyledIcon] widgets.
///
/// This is a convenience typedef for [StyleProvider<IconSpec>] that makes it
/// easier to provide [IconStyler] (size, color, theme, etc.) to descendant
/// [StyledIcon] widgets through the widget tree.
typedef DefaultStyledIcon = StyleProvider<IconSpec>;
