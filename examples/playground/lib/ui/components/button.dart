import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'button.g.dart';

/// The visual weights this application offers for a button.
enum UiButtonVariant {
  /// Highest emphasis: a solid `primary` fill.
  primary,

  /// Medium emphasis: a solid `secondary` fill.
  secondary,

  /// Low emphasis with a hairline `border`.
  outline,

  /// Low emphasis with no fill and no border.
  ghost,

  /// Highest emphasis for irreversible actions.
  destructive,
}

/// The control densities this application offers for a button.
///
/// The 32/36/40px heights are compact, web-oriented defaults. A touch-first
/// application should raise them to meet platform hit-target guidance.
enum UiButtonSize {
  /// 32px minimum height.
  small,

  /// 36px minimum height. The default.
  medium,

  /// 40px minimum height.
  large,
}

/// The application's Button recipe.
///
/// Everything visual about a button lives in this function: geometry,
/// typography, the five variants, and the hover/pressed/focus/disabled
/// fragments. Remix keeps ownership of rendering, pointer and keyboard
/// behavior, accessibility semantics, and the loading/disabled interaction
/// rules — this recipe never reimplements any of that.
///
/// `@MixWidget(target: RemixButton.new)` generates `UiButton` into
/// `button.g.dart`: an adapter whose constructor is this function's
/// parameters plus every safe `RemixButton` parameter, and whose `build`
/// calls `RemixButton(style: uiButtonStyle(...), ...)`. Because
/// [variant] is a non-nullable enum, the generator also emits one named
/// constructor per enum value.
///
/// The widget's name comes from this function's name — the generator drops a
/// trailing `Style` and capitalises what is left — so renaming the recipe
/// renames the widget. There is nothing to keep in sync.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// UiButton.primary(
///   label: 'Publish',
///   style: ButtonStyler().color(const Color(0xFF7C3AED)),
///   onPressed: publish,
/// )
/// ```
///
/// State fragments merge by state, not by depth: an override that must beat
/// the recipe's hover fill has to be declared as a hover fragment too
/// (`ButtonStyler().onHovered(...)`).
@MixWidget(target: RemixButton.new)
ButtonStyler uiButtonStyle({
  UiButtonVariant variant = .primary,
  UiButtonSize size = .medium,
  ButtonStyler style = const ButtonStyler.create(),
}) {
  return _base(_metricsFor(size))
      .merge(_variantStyle(variant))
      .onFocusVisible(_focusVisibleStyle())
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// Alpha applied to a variant's own fill while hovered.
const _hoverAlpha = 0.9;

/// Alpha applied to the active fill while pressed.
const _pressedAlpha = 0.8;

/// A fill derived from [source] at [alpha], resolved from the active scope.
///
/// The obvious spelling would be `UiTokens.primary().withValues(alpha: 0.9)`,
/// but that records a Mix *directive*, and directives accumulate through every
/// later merge. A caller who replaced the hover fill would still get this
/// recipe's alpha applied on top of their own color. A `ContextToken` does the
/// arithmetic during resolution instead, so each state fragment holds one
/// plain color that a caller can replace outright.
///
/// Declared as top-level finals because `ContextToken` equality is resolver
/// identity: rebuilding one per call would make two identical recipes compare
/// unequal.
ContextToken<Color> _dimmed(ColorToken source, double alpha) =>
    ContextToken<Color>(
      (context) => source.resolve(context).withValues(alpha: alpha),
    );

final _primaryHoverFill = _dimmed(UiTokens.primary, _hoverAlpha);
final _primaryPressedFill = _dimmed(UiTokens.primary, _pressedAlpha);
final _secondaryHoverFill = _dimmed(UiTokens.secondary, _hoverAlpha);
final _secondaryPressedFill = _dimmed(UiTokens.secondary, _pressedAlpha);
final _destructiveHoverFill = _dimmed(UiTokens.destructive, _hoverAlpha);
final _destructivePressedFill = _dimmed(UiTokens.destructive, _pressedAlpha);
final _accentPressedFill = _dimmed(UiTokens.accent, _pressedAlpha);

/// Opacity of the loading spinner, so it reads as secondary to the label.
const _spinnerOpacity = 0.65;

/// One full spinner revolution.
const _spinnerDuration = Duration(milliseconds: 800);

/// Width of the keyboard focus ring.
const _focusRingWidth = 2.0;

/// Distance between the control edge and its focus ring.
const _focusRingOffset = 2.0;

/// Opacity applied to the whole control while disabled.
const _disabledOpacity = 0.5;

/// A fill that paints nothing, used by `outline` and `ghost`.
const _noFill = Color(0x00000000);

/// Geometry and type scale for one [UiButtonSize].
typedef _UiButtonMetrics = ({
  double minHeight,
  double paddingX,
  double gap,
  double labelSize,
  double iconSize,
});

_UiButtonMetrics _metricsFor(UiButtonSize size) => switch (size) {
  .small => (
    minHeight: 32.0,
    paddingX: 12.0,
    gap: 6.0,
    labelSize: 14.0,
    iconSize: 16.0,
  ),
  .medium => (
    minHeight: 36.0,
    paddingX: 16.0,
    gap: 8.0,
    labelSize: 14.0,
    iconSize: 16.0,
  ),
  .large => (
    minHeight: 40.0,
    paddingX: 20.0,
    gap: 8.0,
    labelSize: 16.0,
    iconSize: 18.0,
  ),
};

/// Layout, typography, and spinner defaults shared by every variant.
ButtonStyler _base(_UiButtonMetrics metrics) => ButtonStyler()
    .direction(.horizontal)
    .mainAxisSize(.min)
    .mainAxisAlignment(.center)
    .crossAxisAlignment(.center)
    .minHeight(metrics.minHeight)
    .padding(.horizontal(metrics.paddingX))
    .spacing(metrics.gap)
    .borderRadius(.all(UiTokens.radius()))
    .label(.fontSize(metrics.labelSize).fontWeight(FontWeight.w500))
    .icon(.size(metrics.iconSize))
    .spinner(
      .size(
        metrics.iconSize,
      ).opacity(_spinnerOpacity).duration(_spinnerDuration),
    );

ButtonStyler _variantStyle(UiButtonVariant variant) => switch (variant) {
  .primary => _filled(
    fill: UiTokens.primary(),
    foreground: UiTokens.primaryForeground(),
    hoverFill: _primaryHoverFill(),
    pressedFill: _primaryPressedFill(),
  ),
  .secondary => _filled(
    fill: UiTokens.secondary(),
    foreground: UiTokens.secondaryForeground(),
    hoverFill: _secondaryHoverFill(),
    pressedFill: _secondaryPressedFill(),
  ),
  .destructive => _filled(
    fill: UiTokens.destructive(),
    foreground: UiTokens.destructiveForeground(),
    hoverFill: _destructiveHoverFill(),
    pressedFill: _destructivePressedFill(),
  ),
  .outline => _quiet(bordered: true),
  .ghost => _quiet(bordered: false),
};

/// A solid variant: its own fill, dimmed on hover and further on press.
ButtonStyler _filled({
  required Color fill,
  required Color foreground,
  required Color hoverFill,
  required Color pressedFill,
}) => _content(
  .color(fill),
  foreground,
).onHovered(.color(hoverFill)).onPressed(.color(pressedFill));

/// A transparent variant: `accent` is what makes interaction visible.
ButtonStyler _quiet({required bool bordered}) {
  var style = _content(.color(_noFill), UiTokens.foreground());
  if (bordered) {
    style = style.border(.color(UiTokens.border()).width(1));
  }

  return style
      .onHovered(
        _content(.color(UiTokens.accent()), UiTokens.accentForeground()),
      )
      // Content color is re-applied on press, not only on hover: a touch
      // device never reports hover, so a press that changed the fill alone
      // would paint the accent surface under the default foreground.
      .onPressed(
        _content(.color(_accentPressedFill()), UiTokens.accentForeground()),
      );
}

/// Applies one content color to the label, the icons, and the spinner.
ButtonStyler _content(ButtonStyler style, Color foreground) => style
    .label(.color(foreground))
    .icon(.color(foreground))
    .spinner(.color(foreground));

/// The keyboard focus ring.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// box without taking layout space, so focusing a button never reflows the
/// row it sits in.
ButtonStyler _focusVisibleStyle() => ButtonStyler().containerEffects(
  .outline(
    .color(
      UiTokens.focusRing(),
    ).width(_focusRingWidth).strokeAlign(BorderSide.strokeAlignInside),
  ).outlineOffset(_focusRingOffset),
);

/// Declared last so it wins over every other state fragment.
///
/// A disabled control keeps whatever fill its variant gives it and simply
/// fades; the focus ring is cleared because a disabled button that still
/// draws a focus ring reads as actionable.
ButtonStyler _disabledStyle() => ButtonStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(_disabledOpacity));
