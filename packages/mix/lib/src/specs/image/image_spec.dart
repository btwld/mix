import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/color/color_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../core/attribute.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/resolved_style_provider.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';

final class ImageSpec extends Spec<ImageSpec> with Diagnosticable {
  final double? width, height;
  final Color? color;
  final ImageRepeat? repeat;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Rect? centerSlice;
  final FilterQuality? filterQuality;

  final BlendMode? colorBlendMode;

  const ImageSpec({
    this.width,
    this.height,
    this.color,
    this.repeat,
    this.fit,
    this.alignment,
    this.centerSlice,
    this.filterQuality,
    this.colorBlendMode,
  });

  static ImageSpec from(BuildContext context) {
    return maybeOf(context) ?? const ImageSpec();
  }

  /// Retrieves the [ImageSpec] from the nearest [ResolvedStyleProvider] ancestor.
  ///
  /// Returns null if no ancestor [ResolvedStyleProvider] is found.
  static ImageSpec? maybeOf(BuildContext context) {
    return ResolvedStyleProvider.of<ImageSpec>(context)?.spec;
  }

  /// Retrieves the [ImageSpec] from the nearest [ResolvedStyleProvider] ancestor in the widget tree.
  ///
  /// If no ancestor [ResolvedStyleProvider] is found, this method returns an empty [ImageSpec].
  static ImageSpec of(BuildContext context) {
    return maybeOf(context) ?? const ImageSpec();
  }

  @override
  ImageSpec copyWith({
    double? width,
    double? height,
    Color? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
  }) {
    return ImageSpec(
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
      repeat: repeat ?? this.repeat,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment,
      centerSlice: centerSlice ?? this.centerSlice,
      filterQuality: filterQuality ?? this.filterQuality,
      colorBlendMode: colorBlendMode ?? this.colorBlendMode,
    );
  }

  @override
  ImageSpec lerp(ImageSpec? other, double t) {
    if (other == null) return this;

    return ImageSpec(
      width: MixHelpers.lerpDouble(width, other.width, t),
      height: MixHelpers.lerpDouble(height, other.height, t),
      color: Color.lerp(color, other.color, t),
      repeat: t < 0.5 ? repeat : other.repeat,
      fit: t < 0.5 ? fit : other.fit,
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      centerSlice: Rect.lerp(centerSlice, other.centerSlice, t),
      filterQuality: t < 0.5 ? filterQuality : other.filterQuality,
      colorBlendMode: t < 0.5 ? colorBlendMode : other.colorBlendMode,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty('repeat', repeat, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('centerSlice', centerSlice, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('filterQuality', filterQuality, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('colorBlendMode', colorBlendMode, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [
    width,
    height,
    color,
    repeat,
    fit,
    alignment,
    centerSlice,
    filterQuality,
    colorBlendMode,
  ];
}

class ImageSpecAttribute extends SpecAttribute<ImageSpec> with Diagnosticable {
  final Prop<double>? width;
  final Prop<double>? height;
  final Prop<Color>? color;
  final Prop<ImageRepeat>? repeat;
  final Prop<BoxFit>? fit;
  final Prop<AlignmentGeometry>? alignment;
  final Prop<Rect>? centerSlice;
  final Prop<FilterQuality>? filterQuality;
  final Prop<BlendMode>? colorBlendMode;

  /// Constructor that accepts Prop values directly
  const ImageSpecAttribute.props({
    this.width,
    this.height,
    this.color,
    this.repeat,
    this.fit,
    this.alignment,
    this.centerSlice,
    this.filterQuality,
    this.colorBlendMode,
  });

  // Factory constructor accepts raw values
  factory ImageSpecAttribute({
    double? width,
    double? height,
    Color? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
  }) {
    return ImageSpecAttribute.props(
      width: Prop.maybe(width),
      height: Prop.maybe(height),
      color: Prop.maybe(color),
      repeat: Prop.maybe(repeat),
      fit: Prop.maybe(fit),
      alignment: Prop.maybe(alignment),
      centerSlice: Prop.maybe(centerSlice),
      filterQuality: Prop.maybe(filterQuality),
      colorBlendMode: Prop.maybe(colorBlendMode),
    );
  }

  /// Constructor that accepts an [ImageSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ImageSpec] instances to [ImageSpecAttribute].
  ///
  /// ```dart
  /// const spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageSpecAttribute.value(spec);
  /// ```
  static ImageSpecAttribute value(ImageSpec spec) {
    return ImageSpecAttribute.props(
      width: Prop.maybe(spec.width),
      height: Prop.maybe(spec.height),
      color: Prop.maybe(spec.color),
      repeat: Prop.maybe(spec.repeat),
      fit: Prop.maybe(spec.fit),
      alignment: Prop.maybe(spec.alignment),
      centerSlice: Prop.maybe(spec.centerSlice),
      filterQuality: Prop.maybe(spec.filterQuality),
      colorBlendMode: Prop.maybe(spec.colorBlendMode),
    );
  }

  /// Constructor that accepts a nullable [ImageSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [ImageSpecAttribute.value].
  ///
  /// ```dart
  /// const ImageSpec? spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageSpecAttribute.maybeValue(spec); // Returns ImageSpecAttribute or null
  /// ```
  static ImageSpecAttribute? maybeValue(ImageSpec? spec) {
    return spec != null ? ImageSpecAttribute.value(spec) : null;
  }

  @override
  ImageSpec resolve(BuildContext context) {
    return ImageSpec(
      width: MixHelpers.resolve(context, width),
      height: MixHelpers.resolve(context, height),
      color: MixHelpers.resolve(context, color),
      repeat: MixHelpers.resolve(context, repeat),
      fit: MixHelpers.resolve(context, fit),
      alignment: MixHelpers.resolve(context, alignment),
      centerSlice: MixHelpers.resolve(context, centerSlice),
      filterQuality: MixHelpers.resolve(context, filterQuality),
      colorBlendMode: MixHelpers.resolve(context, colorBlendMode),
    );
  }

  @override
  ImageSpecAttribute merge(ImageSpecAttribute? other) {
    if (other == null) return this;

    return ImageSpecAttribute.props(
      width: MixHelpers.merge(width, other.width),
      height: MixHelpers.merge(height, other.height),
      color: MixHelpers.merge(color, other.color),
      repeat: MixHelpers.merge(repeat, other.repeat),
      fit: MixHelpers.merge(fit, other.fit),
      alignment: MixHelpers.merge(alignment, other.alignment),
      centerSlice: MixHelpers.merge(centerSlice, other.centerSlice),
      filterQuality: MixHelpers.merge(filterQuality, other.filterQuality),
      colorBlendMode: MixHelpers.merge(colorBlendMode, other.colorBlendMode),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty('repeat', repeat, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('centerSlice', centerSlice, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('filterQuality', filterQuality, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('colorBlendMode', colorBlendMode, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [
    width,
    height,
    color,
    repeat,
    fit,
    alignment,
    centerSlice,
    filterQuality,
    colorBlendMode,
  ];
}

class ImageSpecUtility<T extends Attribute>
    extends SpecUtility<T, ImageSpecAttribute> {
  late final width = DoubleUtility(
    (prop) => builder(ImageSpecAttribute.props(width: prop)),
  );
  late final height = DoubleUtility(
    (prop) => builder(ImageSpecAttribute.props(height: prop)),
  );
  late final color = ColorUtility(
    (prop) => builder(ImageSpecAttribute.props(color: prop)),
  );
  late final repeat = ImageRepeatUtility((v) => only(repeat: v));
  late final fit = BoxFitUtility((v) => only(fit: v));
  late final alignment = AlignmentGeometryUtility((v) => only(alignment: v));
  late final centerSlice = RectUtility((v) => only(centerSlice: v));
  late final filterQuality = FilterQualityUtility(
    (v) => only(filterQuality: v),
  );
  late final colorBlendMode = BlendModeUtility((v) => only(colorBlendMode: v));

  ImageSpecUtility(super.builder);

  static ImageSpecUtility<ImageSpecAttribute> get self =>
      ImageSpecUtility((v) => v);

  @override
  T only({
    double? width,
    double? height,
    Color? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
  }) {
    return builder(
      ImageSpecAttribute(
        width: width,
        height: height,
        color: color,
        repeat: repeat,
        fit: fit,
        alignment: alignment,
        centerSlice: centerSlice,
        filterQuality: filterQuality,
        colorBlendMode: colorBlendMode,
      ),
    );
  }
}

