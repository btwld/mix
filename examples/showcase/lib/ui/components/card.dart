import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'card.g.dart';

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
@MixWidget(target: RemixCard.new)
CardStyler uiCardStyle({CardStyler style = const CardStyler.create()}) =>
    CardStyler()
        .color(UiTokens.background())
        .border(.color(UiTokens.border()).width(_borderWidth))
        .borderRadius(.all(UiTokens.radius()))
        .padding(.all(_padding))
        .merge(style);

/// Width of the card outline.
const _borderWidth = 1.0;

/// Inset between the card edge and its content.
const _padding = 24.0;
