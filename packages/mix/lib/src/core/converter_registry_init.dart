import 'package:flutter/material.dart';

import '../properties/layout/constraints_mix.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/border_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../properties/painting/decoration_mix.dart';
import '../properties/painting/gradient_mix.dart';
import '../properties/painting/shadow_mix.dart';
import '../properties/typography/strut_style_mix.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';
import 'converter_registry.dart';
import 'mix_element.dart';

// Typography converters

/// Converts [TextStyle] to [TextStyleMix].
class TextStyleConverter implements MixConverter<TextStyle> {
  const TextStyleConverter();

  @override
  Mix<TextStyle> toMix(TextStyle textStyle, ConversionContext context) {
    return TextStyleMix.value(textStyle);
  }
}

// Painting converters

/// Converts [Shadow] to [ShadowMix].
class ShadowConverter implements MixConverter<Shadow> {
  const ShadowConverter();

  @override
  Mix<Shadow> toMix(Shadow value, ConversionContext context) {
    return ShadowMix.value(value);
  }
}

/// Converts [BoxShadow] to [BoxShadowMix].
class BoxShadowConverter implements MixConverter<BoxShadow> {
  const BoxShadowConverter();

  @override
  Mix<BoxShadow> toMix(BoxShadow value, ConversionContext context) {
    return BoxShadowMix.value(value);
  }
}

// Layout converters

/// Converts [EdgeInsets] to [EdgeInsetsMix].
class EdgeInsetsConverter implements MixConverter<EdgeInsets> {
  const EdgeInsetsConverter();

  @override
  Mix<EdgeInsets> toMix(EdgeInsets value, ConversionContext context) {
    return EdgeInsetsMix.value(value);
  }
}

/// Converts [StrutStyle] to [StrutStyleMix].
class StrutStyleConverter implements MixConverter<StrutStyle> {
  const StrutStyleConverter();

  @override
  Mix<StrutStyle> toMix(StrutStyle value, ConversionContext context) {
    return StrutStyleMix.value(value);
  }
}

/// Converts [TextHeightBehavior] to [TextHeightBehaviorMix].
class TextHeightBehaviorConverter implements MixConverter<TextHeightBehavior> {
  const TextHeightBehaviorConverter();

  @override
  Mix<TextHeightBehavior> toMix(
    TextHeightBehavior value,
    ConversionContext context,
  ) {
    return TextHeightBehaviorMix.value(value);
  }
}

/// Converts [BoxDecoration] to [BoxDecorationMix].
class BoxDecorationConverter implements MixConverter<BoxDecoration> {
  const BoxDecorationConverter();

  @override
  Mix<BoxDecoration> toMix(BoxDecoration value, ConversionContext context) {
    return BoxDecorationMix.value(value);
  }
}

/// Converts [Decoration] to its corresponding Mix type.
///
/// Currently supports [BoxDecoration]. Other decoration types
/// will throw [UnimplementedError].
class DecorationConverter implements MixConverter<Decoration> {
  const DecorationConverter();

  @override
  Mix<Decoration> toMix(Decoration value, ConversionContext context) {
    if (value is BoxDecoration) {
      final result = context.tryConvert<BoxDecoration>(value);
      if (result == null) {
        throw StateError('BoxDecoration converter not registered');
      }

      return result;
    }
    throw UnimplementedError(
      'Converter for ${value.runtimeType} not implemented',
    );
  }
}

/// Converts [BorderSide] to [BorderSideMix].
class BorderSideConverter implements MixConverter<BorderSide> {
  const BorderSideConverter();

  @override
  Mix<BorderSide> toMix(BorderSide value, ConversionContext context) {
    // Use the existing .value() constructor
    return BorderSideMix.value(value);
  }
}

/// Converts [Border] to [BorderMix].
class BorderConverter implements MixConverter<Border> {
  const BorderConverter();

  @override
  Mix<Border> toMix(Border value, ConversionContext context) {
    // Use the existing .value() constructor
    return BorderMix.value(value);
  }
}

/// Converts [BorderRadius] to [BorderRadiusMix].
class BorderRadiusConverter implements MixConverter<BorderRadius> {
  const BorderRadiusConverter();

  @override
  Mix<BorderRadius> toMix(BorderRadius value, ConversionContext context) {
    // Use the existing .value() constructor
    return BorderRadiusMix.value(value);
  }
}

/// Converts [BorderRadiusGeometry] to [BorderRadiusMix].
///
/// Currently supports [BorderRadius]. Other BorderRadiusGeometry types
/// will throw [UnimplementedError].
class BorderRadiusGeometryConverter
    implements MixConverter<BorderRadiusGeometry> {
  const BorderRadiusGeometryConverter();

  @override
  Mix<BorderRadiusGeometry> toMix(
    BorderRadiusGeometry value,
    ConversionContext context,
  ) {
    if (value is BorderRadius) {
      final result = context.tryConvert<BorderRadius>(value);
      if (result == null) {
        throw StateError('BorderRadius converter not registered');
      }

      return result;
    }
    // For BorderRadiusDirectional, we'd need to handle it specifically
    // For now, throw an error
    throw UnimplementedError(
      'Converter for ${value.runtimeType} not implemented',
    );
  }
}

/// Converts [ShapeBorder] to its corresponding Mix type.
///
/// Currently throws [UnimplementedError] for all types as
/// ShapeBorder has many subtypes that need specific handling.
class ShapeBorderConverter implements MixConverter<ShapeBorder> {
  const ShapeBorderConverter();

  @override
  Mix<ShapeBorder> toMix(ShapeBorder value, ConversionContext context) {
    // ShapeBorder is complex with many subtypes (RoundedRectangleBorder, CircleBorder, etc.)
    // For now, we'll need to handle specific types or throw
    throw UnimplementedError(
      'ShapeBorder converter needs implementation for ${value.runtimeType}',
    );
  }
}

/// Converts [Gradient] to its corresponding Mix type.
///
/// Supports [LinearGradient], [RadialGradient], and [SweepGradient].
/// Other gradient types will throw [UnimplementedError].
class GradientConverter implements MixConverter<Gradient> {
  const GradientConverter();

  @override
  Mix<Gradient> toMix(Gradient value, ConversionContext context) {
    if (value is LinearGradient) {
      final result = context.tryConvert<LinearGradient>(value);
      if (result == null) {
        throw StateError('LinearGradient converter not registered');
      }

      return result;
    } else if (value is RadialGradient) {
      final result = context.tryConvert<RadialGradient>(value);
      if (result == null) {
        throw StateError('RadialGradient converter not registered');
      }

      return result;
    } else if (value is SweepGradient) {
      final result = context.tryConvert<SweepGradient>(value);
      if (result == null) {
        throw StateError('SweepGradient converter not registered');
      }

      return result;
    }
    throw UnimplementedError('Unknown gradient type: ${value.runtimeType}');
  }
}

/// Converts [LinearGradient] to [LinearGradientMix].
class LinearGradientConverter implements MixConverter<LinearGradient> {
  const LinearGradientConverter();

  @override
  Mix<LinearGradient> toMix(LinearGradient value, ConversionContext context) {
    // Use the existing .value() constructor
    return LinearGradientMix.value(value);
  }
}

/// Converts [RadialGradient] to [RadialGradientMix].
class RadialGradientConverter implements MixConverter<RadialGradient> {
  const RadialGradientConverter();

  @override
  Mix<RadialGradient> toMix(RadialGradient value, ConversionContext context) {
    // Use the existing .value() constructor
    return RadialGradientMix.value(value);
  }
}

/// Converts [SweepGradient] to [SweepGradientMix].
class SweepGradientConverter implements MixConverter<SweepGradient> {
  const SweepGradientConverter();

  @override
  Mix<SweepGradient> toMix(SweepGradient value, ConversionContext context) {
    // Use the existing .value() constructor
    return SweepGradientMix.value(value);
  }
}

/// Converts [BoxConstraints] to [BoxConstraintsMix].
class BoxConstraintsConverter implements MixConverter<BoxConstraints> {
  const BoxConstraintsConverter();

  @override
  Mix<BoxConstraints> toMix(BoxConstraints value, ConversionContext context) {
    // Use the existing .value() constructor
    return BoxConstraintsMix.value(value);
  }
}

/// Converts [EdgeInsetsGeometry] to its corresponding Mix type.
///
/// Supports [EdgeInsets] and [EdgeInsetsDirectional]. Other EdgeInsetsGeometry
/// types will throw [ArgumentError].
class EdgeInsetsGeometryConverter implements MixConverter<EdgeInsetsGeometry> {
  const EdgeInsetsGeometryConverter();

  @override
  Mix<EdgeInsetsGeometry> toMix(
    EdgeInsetsGeometry value,
    ConversionContext context,
  ) {
    // EdgeInsets is a subtype of EdgeInsetsGeometry
    if (value is EdgeInsets) {
      return EdgeInsetsMix.value(value);
    }

    if (value is EdgeInsetsDirectional) {
      return EdgeInsetsDirectionalMix.value(value);
    }

    throw ArgumentError(
      'Unsupported EdgeInsetsGeometry type: ${value.runtimeType}',
    );
  }
}

/// Registers all built-in converters for Flutter types.
///
/// This function is automatically called on first use of the registry.
/// You can also call it explicitly during app initialization.
///
/// Registers converters for:
/// - Typography: [TextStyle], [StrutStyle], [TextHeightBehavior]
/// - Painting: [Shadow], [BoxShadow], [Border], [BoxDecoration], etc.
/// - Layout: [EdgeInsets], [EdgeInsetsGeometry], [BoxConstraints]
/// - Gradients: [LinearGradient], [RadialGradient], [SweepGradient]
void initializeMixConverters() {
  final registry = MixConverterRegistry.instance;

  // Typography converters
  registry.register<TextStyle>(const TextStyleConverter());

  // Painting converters
  registry.register<Shadow>(const ShadowConverter());
  registry.register<BoxShadow>(const BoxShadowConverter());

  // Layout converters
  registry.register<EdgeInsets>(const EdgeInsetsConverter());
  registry.register<EdgeInsetsGeometry>(const EdgeInsetsGeometryConverter());

  registry.register<BoxConstraints>(const BoxConstraintsConverter());

  // Typography
  registry.register<StrutStyle>(const StrutStyleConverter());
  registry.register<TextHeightBehavior>(const TextHeightBehaviorConverter());

  // Painting
  registry.register<BoxDecoration>(const BoxDecorationConverter());
  registry.register<Decoration>(const DecorationConverter());
  registry.register<BorderSide>(const BorderSideConverter());
  registry.register<Border>(const BorderConverter());
  registry.register<BorderRadius>(const BorderRadiusConverter());
  registry.register<BorderRadiusGeometry>(
    const BorderRadiusGeometryConverter(),
  );
  // TODO: ShapeBorder converter needs implementation for specific subtypes
  // Disabled until implemented - currently always throws UnimplementedError
  // registry.register<ShapeBorder>(const ShapeBorderConverter());
  registry.register<Gradient>(const GradientConverter());
  registry.register<LinearGradient>(const LinearGradientConverter());
  registry.register<RadialGradient>(const RadialGradientConverter());
  registry.register<SweepGradient>(const SweepGradientConverter());
}

/// Checks whether the built-in converters have been registered.
///
/// Returns `true` if converters are initialized, `false` otherwise.
/// This is useful for testing or debugging initialization issues.
bool areMixConvertersInitialized() {
  return MixConverterRegistry.instance.canConvert<TextStyle>();
}
