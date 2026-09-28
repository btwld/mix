import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'badge.g.dart';

/// The visual weights this application offers for a badge.
enum UiBadgeVariant {
  /// Highest emphasis: a solid `primary` fill.
  primary,

  /// Medium emphasis: a solid `secondary` fill.
  secondary,

  /// Low emphasis with a hairline `border` and no fill.
  outline,

  /// Highest emphasis for a problem the reader must notice.
  destructive,
}

/// The application's Badge recipe.
///
/// A badge is a static label: no interaction, no states. That is why this
/// recipe has no hover, focus, or disabled fragments — there is nothing to
/// report.
///
/// It takes no size. A badge sits inline beside other content and reads at
/// one scale; a size axis would have to be threaded through every call site
/// for no gain.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. Because [variant] is a non-nullable
/// enum, the generator also emits one named constructor per enum value:
///
/// ```dart
/// UiBadge.destructive(label: 'Failing')
/// ```
@MixWidget(target: RemixBadge.new)
BadgeStyler uiBadgeStyle({
  UiBadgeVariant variant = .primary,
  BadgeStyler style = const BadgeStyler.create(),
}) => _base().merge(_variantStyle(variant)).merge(style);

/// Horizontal inset between the badge edge and its label.
const _paddingX = 8.0;

/// Vertical inset between the badge edge and its label.
const _paddingY = 2.0;

/// Label size, one step below body text so a badge reads as an annotation.
const _labelSize = 12.0;

/// Width of the outline the `outline` variant draws.
const _borderWidth = 1.0;

/// A fill that paints nothing, used by `outline`.
const _noFill = Color(0x00000000);

/// Geometry and typography shared by every variant.
BadgeStyler _base() => BadgeStyler()
    .padding(.symmetric(horizontal: _paddingX, vertical: _paddingY))
    .borderRadius(.all(UiTokens.radius()))
    .label(.fontSize(_labelSize).fontWeight(FontWeight.w500));

BadgeStyler _variantStyle(UiBadgeVariant variant) => switch (variant) {
  .primary => _filled(
    fill: UiTokens.primary(),
    foreground: UiTokens.primaryForeground(),
  ),
  .secondary => _filled(
    fill: UiTokens.secondary(),
    foreground: UiTokens.secondaryForeground(),
  ),
  .destructive => _filled(
    fill: UiTokens.destructive(),
    foreground: UiTokens.destructiveForeground(),
  ),
  .outline => _filled(
    fill: _noFill,
    foreground: UiTokens.foreground(),
  ).border(.color(UiTokens.border()).width(_borderWidth)),
};

/// One surface and one content color.
BadgeStyler _filled({required Color fill, required Color foreground}) =>
    BadgeStyler().color(fill).label(.color(foreground));
