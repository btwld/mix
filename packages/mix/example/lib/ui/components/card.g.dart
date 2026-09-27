// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Card recipe.
///
/// A card is a surface that groups related content. Everything visual about
/// it lives in this function; Remix owns nothing but the rendering, because a
/// card has no interaction and no state of its own.
///
/// It takes no variant and no size. A card is one surface, and its content
/// decides how tall it is — an axis with nothing behind it would only be one
/// more thing to keep consistent.
///
/// The fill is `background`, the same token the page uses, so a card is told
/// apart by its outline rather than by a second surface color. That is
/// deliberate: it keeps the token vocabulary at twenty names, and a theme
/// that wants a distinct card surface changes this one line.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// UiCard(
///   style: CardStyler().color(UiTokens.muted()),
///   child: summary,
/// )
/// ```
class UiCard extends StatelessWidget {
  const UiCard({super.key, this.style = const CardStyler.create(), this.child});

  final CardStyler style;

  final Widget? child;

  @override
  Widget build(BuildContext _) {
    return RemixCard(
      key: key,
      style: uiCardStyle(style: style),
      child: child,
    );
  }
}
