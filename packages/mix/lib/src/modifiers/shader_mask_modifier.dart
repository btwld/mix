import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

/// Modifier that applies a shader mask to its child.
///
/// Wraps the child in a [ShaderMask] widget with the specified shader callback and blend mode.
final class ShaderMaskModifier extends WidgetModifier<ShaderMaskModifier>
    with Diagnosticable {
  final ShaderCallback shaderCallback;
  final BlendMode blendMode;

  const ShaderMaskModifier({
    required this.shaderCallback,
    this.blendMode = BlendMode.modulate,
  }) : super();

  @override
  ShaderMaskModifier copyWith({
    ShaderCallback? shaderCallback,
    BlendMode? blendMode,
  }) {
    return ShaderMaskModifier(
      shaderCallback: shaderCallback ?? this.shaderCallback,
      blendMode: blendMode ?? this.blendMode,
    );
  }

  @override
  ShaderMaskModifier lerp(ShaderMaskModifier? other, double t) {
    if (other == null) return this;

    // Shader functions cannot be lerped, so we just return this if t < 0.5, other if t >= 0.5
    return t < 0.5
        ? this
        : ShaderMaskModifier(
            shaderCallback: other.shaderCallback,
            blendMode: MixOps.lerp(blendMode, other.blendMode, t) ?? blendMode,
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<Shader Function(Rect)>(
          'shaderCallback',
          shaderCallback,
        ),
      )
      ..add(EnumProperty<BlendMode>('blendMode', blendMode));
  }

  @override
  List<Object?> get props => [shaderCallback, blendMode];

  @override
  Widget build(Widget child) {
    return ShaderMask(
      shaderCallback: shaderCallback,
      blendMode: blendMode,
      child: child,
    );
  }
}

/// Mix class for applying shader mask modifications.
///
/// This class allows for mixing and resolving shader mask properties.
class ShaderMaskModifierMix extends WidgetModifierMix<ShaderMaskModifier>
    with Diagnosticable {
  final Prop<Shader Function(Rect)>? shaderCallback;
  final Prop<BlendMode>? blendMode;

  const ShaderMaskModifierMix.create({this.shaderCallback, this.blendMode});

  ShaderMaskModifierMix({
    required ShaderCallback shaderCallback,
    BlendMode blendMode = BlendMode.modulate,
  }) : this.create(
         shaderCallback: Prop.value(shaderCallback),
         blendMode: Prop.value(blendMode),
       );

  @override
  ShaderMaskModifier resolve(BuildContext context) {
    return ShaderMaskModifier(
      shaderCallback: MixOps.resolve(context, shaderCallback)!,
      blendMode: MixOps.resolve(context, blendMode) ?? BlendMode.modulate,
    );
  }

  @override
  ShaderMaskModifierMix merge(ShaderMaskModifierMix? other) {
    if (other == null) return this;

    return ShaderMaskModifierMix.create(
      shaderCallback: MixOps.merge(shaderCallback, other.shaderCallback),
      blendMode: MixOps.merge(blendMode, other.blendMode),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('shaderCallback', shaderCallback))
      ..add(DiagnosticsProperty('blendMode', blendMode));
  }

  @override
  List<Object?> get props => [shaderCallback, blendMode];
}

/// Utility class for applying shader mask modifications.
///
/// Provides convenient methods for creating ShaderMaskModifierMix instances.
final class ShaderMaskModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, ShaderMaskModifierMix> {
  const ShaderMaskModifierUtility(super.utilityBuilder);

  T call({
    required ShaderCallbackBuilder shaderCallback,
    BlendMode blendMode = BlendMode.modulate,
  }) {
    return utilityBuilder(
      ShaderMaskModifierMix(
        shaderCallback: shaderCallback.callback,
        blendMode: blendMode,
      ),
    );
  }
}

/// Utility class for common [Shader Function(Rect)] callbacks.
///
/// Provides predefined shader callbacks such as linear gradients.
class ShaderCallbackBuilder {
  final ShaderCallback callback;

  const ShaderCallbackBuilder({required this.callback});

  /// Returns a [Shader] that draws a linear gradient from [begin] to [end]
  /// with the given [colors] and optional [stops] and [tileMode].
  static ShaderCallbackBuilder linearGradient({
    Alignment begin = Alignment.centerLeft,
    Alignment end = Alignment.centerRight,
    required List<Color> colors,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
  }) {
    return ShaderCallbackBuilder(
      callback: (Rect bounds) {
        return LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
        ).createShader(bounds);
      },
    );
  }

  /// Returns a [Shader] that draws a radial gradient centered at [center]
  /// with the given [radius], [colors], optional [stops], and [tileMode].
  static ShaderCallbackBuilder radialGradient({
    Alignment center = Alignment.center,
    double radius = 0.5,
    required List<Color> colors,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
  }) {
    return ShaderCallbackBuilder(
      callback: (Rect bounds) {
        return RadialGradient(
          center: center,
          radius: radius,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
        ).createShader(bounds);
      },
    );
  }

  /// Returns a [Shader] that draws a sweep gradient centered at [center]
  /// with the given [colors], optional [stops], [startAngle], [endAngle], and [tileMode].
  static ShaderCallbackBuilder sweepGradient({
    Alignment center = Alignment.center,
    required List<Color> colors,
    List<double>? stops,
    double startAngle = 0.0,
    double endAngle = 3.1415926535897932 * 2,
    TileMode tileMode = TileMode.clamp,
  }) {
    return ShaderCallbackBuilder(
      callback: (Rect bounds) {
        return SweepGradient(
          center: center,
          startAngle: startAngle,
          endAngle: endAngle,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
        ).createShader(bounds);
      },
    );
  }
}
