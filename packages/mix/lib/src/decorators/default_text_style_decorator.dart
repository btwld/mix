import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_decorator.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';

final class DefaultTextStyleWidgetDecorator
    extends WidgetDecorator<DefaultTextStyleWidgetDecorator>
    with Diagnosticable {
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const DefaultTextStyleWidgetDecorator({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// Creates a copy of this [DefaultTextStyleWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  DefaultTextStyleWidgetDecorator copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return DefaultTextStyleWidgetDecorator(
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }

  /// Linearly interpolates between this [DefaultTextStyleWidgetDecorator] and another [DefaultTextStyleWidgetDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [DefaultTextStyleWidgetDecorator] is returned. When [t] is 1.0, the [other] [DefaultTextStyleWidgetDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [DefaultTextStyleWidgetDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [DefaultTextStyleWidgetDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [DefaultTextStyleWidgetDecorator] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [style].
  /// For [textAlign] and [softWrap] and [overflow] and [maxLines] and [textWidthBasis] and [textHeightBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DefaultTextStyleWidgetDecorator] is used. Otherwise, the value
  /// from the [other] [DefaultTextStyleWidgetDecorator] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DefaultTextStyleWidgetDecorator] configurations.
  @override
  DefaultTextStyleWidgetDecorator lerp(
    DefaultTextStyleWidgetDecorator? other,
    double t,
  ) {
    if (other == null) return this;

    return DefaultTextStyleWidgetDecorator(
      style: MixOps.lerp(style, other.style, t),
      textAlign: MixOps.lerp(textAlign, other.textAlign, t),
      softWrap: MixOps.lerp(softWrap, other.softWrap, t),
      overflow: MixOps.lerp(overflow, other.overflow, t),
      maxLines: MixOps.lerp(maxLines, other.maxLines, t),
      textWidthBasis: MixOps.lerp(textWidthBasis, other.textWidthBasis, t),
      textHeightBehavior: MixOps.lerp(
        textHeightBehavior,
        other.textHeightBehavior,
        t,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textAlign', textAlign, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('softWrap', softWrap, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('overflow', overflow, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('maxLines', maxLines, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textWidthBasis', textWidthBasis, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'textHeightBehavior',
        textHeightBehavior,
        defaultValue: null,
      ),
    );
  }

  /// The list of properties that constitute the state of this [DefaultTextStyleWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DefaultTextStyleWidgetDecorator] instances for equality.
  @override
  List<Object?> get props => [
    style,
    textAlign,
    softWrap,
    overflow,
    maxLines,
    textWidthBasis,
    textHeightBehavior,
  ];

  @override
  Widget build(Widget child) {
    return DefaultTextStyle(
      style: style ?? const TextStyle(),
      textAlign: textAlign,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.clip,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: textHeightBehavior,
      child: child,
    );
  }
}

/// Represents the attributes of a [DefaultTextStyleWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [DefaultTextStyleWidgetDecorator].
///
/// Use this class to configure the attributes of a [DefaultTextStyleWidgetDecorator] and pass it to
/// the [DefaultTextStyleWidgetDecorator] constructor.
class DefaultTextStyleWidgetDecoratorMix
    extends WidgetDecoratorMix<DefaultTextStyleWidgetDecorator> {
  final MixProp<TextStyle>? style;
  final Prop<TextAlign>? textAlign;
  final Prop<bool>? softWrap;
  final Prop<TextOverflow>? overflow;
  final Prop<int>? maxLines;
  final Prop<TextWidthBasis>? textWidthBasis;
  final MixProp<TextHeightBehavior>? textHeightBehavior;

  const DefaultTextStyleWidgetDecoratorMix.raw({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  DefaultTextStyleWidgetDecoratorMix({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) : this.raw(
         style: MixProp.maybe(style),
         textAlign: Prop.maybe(textAlign),
         softWrap: Prop.maybe(softWrap),
         overflow: Prop.maybe(overflow),
         maxLines: Prop.maybe(maxLines),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: MixProp.maybe(textHeightBehavior),
       );

  /// Resolves to [DefaultTextStyleWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final defaultTextStyleWidgetDecorator = DefaultTextStyleWidgetDecoratorMix(...).resolve(mix);
  /// ```
  @override
  DefaultTextStyleWidgetDecorator resolve(BuildContext context) {
    return DefaultTextStyleWidgetDecorator(
      style: MixOps.resolve(context, style),
      textAlign: MixOps.resolve(context, textAlign),
      softWrap: MixOps.resolve(context, softWrap),
      overflow: MixOps.resolve(context, overflow),
      maxLines: MixOps.resolve(context, maxLines),
      textWidthBasis: MixOps.resolve(context, textWidthBasis),
      textHeightBehavior: MixOps.resolve(context, textHeightBehavior),
    );
  }

  /// Merges the properties of this [DefaultTextStyleWidgetDecoratorMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DefaultTextStyleWidgetDecoratorMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DefaultTextStyleWidgetDecoratorMix merge(
    DefaultTextStyleWidgetDecoratorMix? other,
  ) {
    if (other == null) return this;

    return DefaultTextStyleWidgetDecoratorMix.raw(
      style: style.tryMerge(other.style),
      textAlign: textAlign.tryMerge(other.textAlign),
      softWrap: softWrap.tryMerge(other.softWrap),
      overflow: overflow.tryMerge(other.overflow),
      maxLines: maxLines.tryMerge(other.maxLines),
      textWidthBasis: textWidthBasis.tryMerge(other.textWidthBasis),
      textHeightBehavior: textHeightBehavior.tryMerge(other.textHeightBehavior),
    );
  }

  @override
  List<Object?> get props => [
    style,
    textAlign,
    softWrap,
    overflow,
    maxLines,
    textWidthBasis,
    textHeightBehavior,
  ];
}

final class DefaultTextStyleWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, DefaultTextStyleWidgetDecoratorMix> {
  const DefaultTextStyleWidgetDecoratorUtility(super.builder);
  T call({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return builder(
      DefaultTextStyleWidgetDecoratorMix(
        style: TextStyleMix.maybeValue(style),
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: TextHeightBehaviorMix.maybeValue(
          textHeightBehavior,
        ),
      ),
    );
  }
}
