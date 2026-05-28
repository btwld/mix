/// Curated public API surface metadata for generated stylers.
library;

/// A generated named factory constructor descriptor.
class StylerFactoryDescriptor {
  /// Factory name, without the styler class prefix.
  final String name;

  /// Factory signature after the named constructor prefix.
  final String signature;

  /// Instance invocation used by the factory body.
  final String invocation;

  /// Fields that must be present before this factory can be emitted.
  final Set<String> requiredFieldNames;

  const StylerFactoryDescriptor({
    required this.name,
    required this.signature,
    required this.invocation,
    this.requiredFieldNames = const {},
  });

  /// Whether all required fields are available.
  bool isAvailableFor(Set<String> fieldNames) {
    return fieldNames.containsAll(requiredFieldNames);
  }

  /// Emits the complete factory constructor for [stylerName].
  String codeFor(String stylerName) {
    return 'factory $stylerName.$signature => $stylerName().$invocation;';
  }
}

/// A generated instance method descriptor.
class StylerMethodDescriptor {
  /// Method name.
  final String name;

  /// Method signature without the styler return type.
  final String signature;

  /// Unindented body lines.
  final List<String> bodyLines;

  /// Whether this method overrides an owner mixin or superclass member.
  final bool isOverride;

  /// Fields that must be present before this method can be emitted.
  final Set<String> requiredFieldNames;

  const StylerMethodDescriptor({
    required this.name,
    required this.signature,
    required this.bodyLines,
    this.isOverride = false,
    this.requiredFieldNames = const {},
  });

  /// Whether all required fields are available.
  bool isAvailableFor(Set<String> fieldNames) {
    return fieldNames.containsAll(requiredFieldNames);
  }

  /// Emits the complete method for [stylerName].
  String codeFor(String stylerName) {
    final buffer = StringBuffer();
    if (isOverride) {
      buffer.writeln('@override');
    }
    buffer.writeln('$stylerName $signature {');
    for (final line in bodyLines) {
      buffer.writeln('  ${line.replaceAll('%STYLER%', stylerName)}');
    }
    buffer.writeln('}');

    return buffer.toString();
  }
}

/// A named parameter forwarded into a nested styler constructor.
class StylerConstructorParamDescriptor {
  /// Parameter type without nullability.
  final String type;

  /// Parameter name.
  final String name;

  const StylerConstructorParamDescriptor({
    required this.type,
    required this.name,
  });

  /// Emits the nullable named parameter declaration.
  String get code => '$type? $name,';
}

/// Describes one nested styler section inside a compound styler.
class CompoundStylerPartDescriptor {
  /// Field name on the compound spec.
  final String fieldName;

  /// Nested spec name.
  final String specName;

  /// Nested styler name.
  final String stylerName;

  /// Owner mixins required by this nested surface.
  final List<String> ownerMixinNames;

  /// Flattened constructor params accepted by the compound styler.
  final List<StylerConstructorParamDescriptor> constructorParams;

  /// Named arguments passed to the nested styler constructor.
  final List<String> constructorArguments;

  const CompoundStylerPartDescriptor({
    required this.fieldName,
    required this.specName,
    required this.stylerName,
    required this.ownerMixinNames,
    required this.constructorParams,
    required this.constructorArguments,
  });
}

/// Curated compound styler surface.
class CompoundStylerSurface {
  /// Compound styler name.
  final String stylerName;

  /// Nested styler parts.
  final List<CompoundStylerPartDescriptor> parts;

  /// Direct factories that mirror handwritten compound stylers.
  final List<StylerFactoryDescriptor> factoryDescriptors;

  /// Direct methods that mirror handwritten compound stylers.
  final List<StylerMethodDescriptor> methodDescriptors;

  const CompoundStylerSurface({
    required this.stylerName,
    required this.parts,
    required this.factoryDescriptors,
    required this.methodDescriptors,
  });

  /// Flattened owner mixin names.
  List<String> get ownerMixinNames {
    return parts.expand((part) => part.ownerMixinNames).toSet().toList();
  }

  /// Flattened constructor parameter names.
  List<String> get constructorParamNames {
    return parts
        .expand((part) => part.constructorParams)
        .map((param) => param.name)
        .toList();
  }

  /// Factory names.
  List<String> get factoryNames {
    return factoryDescriptors.map((factory) => factory.name).toList();
  }

  /// Method names.
  List<String> get methodNames {
    return methodDescriptors.map((method) => method.name).toList();
  }
}

/// Curated styler public surface.
class StylerSurface {
  /// Styler name.
  final String stylerName;

  /// Additional owner mixins required by this surface.
  final List<String> ownerMixinNames;

  /// Curated named factory constructors.
  final List<StylerFactoryDescriptor> factoryDescriptors;

  /// Curated instance methods.
  final List<StylerMethodDescriptor> methodDescriptors;

  /// Whether to emit the static `animate` convenience factory.
  final bool generatesAnimateFactory;

  /// Direct field factories intentionally suppressed for parity.
  final Set<String> suppressedFieldFactoryNames;

  /// Fields that must be present before surface-level owner mixins are emitted.
  final Set<String> requiredFieldNames;

  const StylerSurface({
    required this.stylerName,
    this.ownerMixinNames = const [],
    this.factoryDescriptors = const [],
    this.methodDescriptors = const [],
    this.generatesAnimateFactory = false,
    this.suppressedFieldFactoryNames = const {},
    this.requiredFieldNames = const {},
  });

  /// Factory names.
  List<String> get factoryNames {
    return factoryDescriptors.map((factory) => factory.name).toList();
  }

  /// Method names.
  List<String> get methodNames {
    return methodDescriptors.map((method) => method.name).toList();
  }

  /// Whether all required fields are available.
  bool isAvailableFor(Set<String> fieldNames) {
    return fieldNames.containsAll(requiredFieldNames);
  }
}

const _boxOwnerMixinNames = [
  'SpacingStyleMixin',
  'ConstraintStyleMixin',
  'DecorationStyleMixin',
  'BorderStyleMixin',
  'BorderRadiusStyleMixin',
  'ShadowStyleMixin',
  'TransformStyleMixin',
];

const _boxConvenienceFactories = [
  StylerFactoryDescriptor(
    name: 'color',
    signature: 'color(Color value)',
    invocation: 'color(value)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'gradient',
    signature: 'gradient(GradientMix value)',
    invocation: 'gradient(value)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'border',
    signature: 'border(BoxBorderMix value)',
    invocation: 'border(value)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'borderRadius',
    signature: 'borderRadius(BorderRadiusGeometryMix value)',
    invocation: 'borderRadius(value)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'elevation',
    signature: 'elevation(ElevationShadow value)',
    invocation: 'elevation(value)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'shadow',
    signature: 'shadow(BoxShadowMix value)',
    invocation: 'shadow(value)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'shadows',
    signature: 'shadows(List<BoxShadowMix> value)',
    invocation: 'shadows(value)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'width',
    signature: 'width(double value)',
    invocation: 'width(value)',
    requiredFieldNames: {'constraints'},
  ),
  StylerFactoryDescriptor(
    name: 'height',
    signature: 'height(double value)',
    invocation: 'height(value)',
    requiredFieldNames: {'constraints'},
  ),
  StylerFactoryDescriptor(
    name: 'size',
    signature: 'size(double width, double height)',
    invocation: 'size(width, height)',
    requiredFieldNames: {'constraints'},
  ),
  StylerFactoryDescriptor(
    name: 'minWidth',
    signature: 'minWidth(double value)',
    invocation: 'minWidth(value)',
    requiredFieldNames: {'constraints'},
  ),
  StylerFactoryDescriptor(
    name: 'maxWidth',
    signature: 'maxWidth(double value)',
    invocation: 'maxWidth(value)',
    requiredFieldNames: {'constraints'},
  ),
  StylerFactoryDescriptor(
    name: 'minHeight',
    signature: 'minHeight(double value)',
    invocation: 'minHeight(value)',
    requiredFieldNames: {'constraints'},
  ),
  StylerFactoryDescriptor(
    name: 'maxHeight',
    signature: 'maxHeight(double value)',
    invocation: 'maxHeight(value)',
    requiredFieldNames: {'constraints'},
  ),
  StylerFactoryDescriptor(
    name: 'scale',
    signature: 'scale(double scale, {Alignment alignment = .center})',
    invocation: 'scale(scale, alignment: alignment)',
    requiredFieldNames: {'transform', 'transformAlignment'},
  ),
  StylerFactoryDescriptor(
    name: 'rotate',
    signature: 'rotate(double radians, {Alignment alignment = .center})',
    invocation: 'rotate(radians, alignment: alignment)',
    requiredFieldNames: {'transform', 'transformAlignment'},
  ),
  StylerFactoryDescriptor(
    name: 'translate',
    signature: 'translate(double x, double y, [double z = 0.0])',
    invocation: 'translate(x, y, z)',
    requiredFieldNames: {'transform', 'transformAlignment'},
  ),
  StylerFactoryDescriptor(
    name: 'skew',
    signature: 'skew(double skewX, double skewY)',
    invocation: 'skew(skewX, skewY)',
    requiredFieldNames: {'transform', 'transformAlignment'},
  ),
  StylerFactoryDescriptor(
    name: 'textStyle',
    signature: 'textStyle(TextStyler value)',
    invocation: 'textStyle(value)',
  ),
  StylerFactoryDescriptor(
    name: 'image',
    signature: 'image(DecorationImageMix value)',
    invocation: 'image(value)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'shape',
    signature: 'shape(ShapeBorderMix value)',
    invocation: 'shape(value)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'backgroundImage',
    signature:
        'backgroundImage(ImageProvider image, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat = .noRepeat})',
    invocation:
        'backgroundImage(image, fit: fit, alignment: alignment, repeat: repeat)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'backgroundImageUrl',
    signature:
        'backgroundImageUrl(String url, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat = .noRepeat})',
    invocation:
        'backgroundImageUrl(url, fit: fit, alignment: alignment, repeat: repeat)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'backgroundImageAsset',
    signature:
        'backgroundImageAsset(String path, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat = .noRepeat})',
    invocation:
        'backgroundImageAsset(path, fit: fit, alignment: alignment, repeat: repeat)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'linearGradient',
    signature:
        'linearGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? begin, AlignmentGeometry? end, TileMode? tileMode})',
    invocation:
        'linearGradient(colors: colors, stops: stops, begin: begin, end: end, tileMode: tileMode)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'radialGradient',
    signature:
        'radialGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? radius, AlignmentGeometry? focal, double? focalRadius, TileMode? tileMode})',
    invocation:
        'radialGradient(colors: colors, stops: stops, center: center, radius: radius, focal: focal, focalRadius: focalRadius, tileMode: tileMode)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'sweepGradient',
    signature:
        'sweepGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? startAngle, double? endAngle, TileMode? tileMode})',
    invocation:
        'sweepGradient(colors: colors, stops: stops, center: center, startAngle: startAngle, endAngle: endAngle, tileMode: tileMode)',
    requiredFieldNames: {'decoration'},
  ),
  StylerFactoryDescriptor(
    name: 'foregroundLinearGradient',
    signature:
        'foregroundLinearGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? begin, AlignmentGeometry? end, TileMode? tileMode})',
    invocation:
        'foregroundLinearGradient(colors: colors, stops: stops, begin: begin, end: end, tileMode: tileMode)',
    requiredFieldNames: {'foregroundDecoration'},
  ),
  StylerFactoryDescriptor(
    name: 'foregroundRadialGradient',
    signature:
        'foregroundRadialGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? radius, AlignmentGeometry? focal, double? focalRadius, TileMode? tileMode})',
    invocation:
        'foregroundRadialGradient(colors: colors, stops: stops, center: center, radius: radius, focal: focal, focalRadius: focalRadius, tileMode: tileMode)',
    requiredFieldNames: {'foregroundDecoration'},
  ),
  StylerFactoryDescriptor(
    name: 'foregroundSweepGradient',
    signature:
        'foregroundSweepGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? startAngle, double? endAngle, TileMode? tileMode})',
    invocation:
        'foregroundSweepGradient(colors: colors, stops: stops, center: center, startAngle: startAngle, endAngle: endAngle, tileMode: tileMode)',
    requiredFieldNames: {'foregroundDecoration'},
  ),
];

const _textStyleFactories = [
  StylerFactoryDescriptor(
    name: 'color',
    signature: 'color(Color value)',
    invocation: 'color(value)',
  ),
  StylerFactoryDescriptor(
    name: 'fontSize',
    signature: 'fontSize(double value)',
    invocation: 'fontSize(value)',
  ),
  StylerFactoryDescriptor(
    name: 'fontWeight',
    signature: 'fontWeight(FontWeight value)',
    invocation: 'fontWeight(value)',
  ),
  StylerFactoryDescriptor(
    name: 'fontStyle',
    signature: 'fontStyle(FontStyle value)',
    invocation: 'fontStyle(value)',
  ),
  StylerFactoryDescriptor(
    name: 'letterSpacing',
    signature: 'letterSpacing(double value)',
    invocation: 'letterSpacing(value)',
  ),
  StylerFactoryDescriptor(
    name: 'wordSpacing',
    signature: 'wordSpacing(double value)',
    invocation: 'wordSpacing(value)',
  ),
  StylerFactoryDescriptor(
    name: 'height',
    signature: 'height(double value)',
    invocation: 'height(value)',
  ),
  StylerFactoryDescriptor(
    name: 'fontFamily',
    signature: 'fontFamily(String value)',
    invocation: 'fontFamily(value)',
  ),
  StylerFactoryDescriptor(
    name: 'decoration',
    signature: 'decoration(TextDecoration value)',
    invocation: 'decoration(value)',
  ),
  StylerFactoryDescriptor(
    name: 'backgroundColor',
    signature: 'backgroundColor(Color value)',
    invocation: 'backgroundColor(value)',
  ),
  StylerFactoryDescriptor(
    name: 'textBaseline',
    signature: 'textBaseline(TextBaseline value)',
    invocation: 'textBaseline(value)',
  ),
  StylerFactoryDescriptor(
    name: 'decorationColor',
    signature: 'decorationColor(Color value)',
    invocation: 'decorationColor(value)',
  ),
  StylerFactoryDescriptor(
    name: 'decorationStyle',
    signature: 'decorationStyle(TextDecorationStyle value)',
    invocation: 'decorationStyle(value)',
  ),
  StylerFactoryDescriptor(
    name: 'decorationThickness',
    signature: 'decorationThickness(double value)',
    invocation: 'decorationThickness(value)',
  ),
  StylerFactoryDescriptor(
    name: 'fontFamilyFallback',
    signature: 'fontFamilyFallback(List<String> value)',
    invocation: 'fontFamilyFallback(value)',
  ),
  StylerFactoryDescriptor(
    name: 'shadow',
    signature: 'shadow(ShadowMix value)',
    invocation: 'shadow(value)',
  ),
  StylerFactoryDescriptor(
    name: 'shadows',
    signature: 'shadows(List<ShadowMix> value)',
    invocation: 'shadows(value)',
  ),
  StylerFactoryDescriptor(
    name: 'fontFeatures',
    signature: 'fontFeatures(List<FontFeature> value)',
    invocation: 'fontFeatures(value)',
  ),
  StylerFactoryDescriptor(
    name: 'fontVariations',
    signature: 'fontVariations(List<FontVariation> value)',
    invocation: 'fontVariations(value)',
  ),
  StylerFactoryDescriptor(
    name: 'foreground',
    signature: 'foreground(Paint value)',
    invocation: 'foreground(value)',
  ),
  StylerFactoryDescriptor(
    name: 'background',
    signature: 'background(Paint value)',
    invocation: 'background(value)',
  ),
];

const _flexFactories = [
  StylerFactoryDescriptor(name: 'row', signature: 'row()', invocation: 'row()'),
  StylerFactoryDescriptor(
    name: 'column',
    signature: 'column()',
    invocation: 'column()',
  ),
];

const _textStyleMethod = StylerMethodDescriptor(
  name: 'textStyle',
  signature: 'textStyle(TextStyler value)',
  bodyLines: ['return wrap(WidgetModifierConfig.defaultTextStyler(value));'],
);

const _flexAnchorMethod = StylerMethodDescriptor(
  name: 'flex',
  signature: 'flex(FlexStyler value)',
  bodyLines: ['return merge(value);'],
);

const _surfaces = {
  'BoxStyler': StylerSurface(
    stylerName: 'BoxStyler',
    factoryDescriptors: _boxConvenienceFactories,
    methodDescriptors: [_textStyleMethod],
    generatesAnimateFactory: true,
  ),
  'FlexStyler': StylerSurface(
    stylerName: 'FlexStyler',
    ownerMixinNames: ['FlexStyleMixin'],
    factoryDescriptors: _flexFactories,
    methodDescriptors: [_flexAnchorMethod],
    requiredFieldNames: {'direction'},
  ),
  'IconStyler': StylerSurface(
    stylerName: 'IconStyler',
    suppressedFieldFactoryNames: {'semanticsLabel'},
  ),
  'ImageStyler': StylerSurface(
    stylerName: 'ImageStyler',
    suppressedFieldFactoryNames: {'semanticLabel', 'excludeFromSemantics'},
  ),
  'StackStyler': StylerSurface(stylerName: 'StackStyler'),
  'TextStyler': StylerSurface(
    stylerName: 'TextStyler',
    ownerMixinNames: ['TextStyleMixin'],
    factoryDescriptors: _textStyleFactories,
    suppressedFieldFactoryNames: {'semanticsLabel'},
    requiredFieldNames: {'style'},
  ),
  'FlexBoxStyler': StylerSurface(
    stylerName: 'FlexBoxStyler',
    factoryDescriptors: [..._boxConvenienceFactories, ..._flexFactories],
    methodDescriptors: [_textStyleMethod],
    generatesAnimateFactory: true,
  ),
  'StackBoxStyler': StylerSurface(
    stylerName: 'StackBoxStyler',
    factoryDescriptors: _boxConvenienceFactories,
    methodDescriptors: [_textStyleMethod],
    generatesAnimateFactory: true,
  ),
};

const _boxConstructorParams = [
  StylerConstructorParamDescriptor(type: 'DecorationMix', name: 'decoration'),
  StylerConstructorParamDescriptor(
    type: 'DecorationMix',
    name: 'foregroundDecoration',
  ),
  StylerConstructorParamDescriptor(
    type: 'EdgeInsetsGeometryMix',
    name: 'padding',
  ),
  StylerConstructorParamDescriptor(
    type: 'EdgeInsetsGeometryMix',
    name: 'margin',
  ),
  StylerConstructorParamDescriptor(
    type: 'AlignmentGeometry',
    name: 'alignment',
  ),
  StylerConstructorParamDescriptor(
    type: 'BoxConstraintsMix',
    name: 'constraints',
  ),
  StylerConstructorParamDescriptor(type: 'Matrix4', name: 'transform'),
  StylerConstructorParamDescriptor(
    type: 'AlignmentGeometry',
    name: 'transformAlignment',
  ),
  StylerConstructorParamDescriptor(type: 'Clip', name: 'clipBehavior'),
];

const _boxConstructorArguments = [
  'alignment: alignment,',
  'padding: padding,',
  'margin: margin,',
  'constraints: constraints,',
  'decoration: decoration,',
  'foregroundDecoration: foregroundDecoration,',
  'transform: transform,',
  'transformAlignment: transformAlignment,',
  'clipBehavior: clipBehavior,',
];

const _flexConstructorParams = [
  StylerConstructorParamDescriptor(type: 'Axis', name: 'direction'),
  StylerConstructorParamDescriptor(
    type: 'MainAxisAlignment',
    name: 'mainAxisAlignment',
  ),
  StylerConstructorParamDescriptor(
    type: 'CrossAxisAlignment',
    name: 'crossAxisAlignment',
  ),
  StylerConstructorParamDescriptor(type: 'MainAxisSize', name: 'mainAxisSize'),
  StylerConstructorParamDescriptor(
    type: 'VerticalDirection',
    name: 'verticalDirection',
  ),
  StylerConstructorParamDescriptor(
    type: 'TextDirection',
    name: 'textDirection',
  ),
  StylerConstructorParamDescriptor(type: 'TextBaseline', name: 'textBaseline'),
  StylerConstructorParamDescriptor(type: 'Clip', name: 'flexClipBehavior'),
  StylerConstructorParamDescriptor(type: 'double', name: 'spacing'),
];

const _flexConstructorArguments = [
  'direction: direction,',
  'mainAxisAlignment: mainAxisAlignment,',
  'crossAxisAlignment: crossAxisAlignment,',
  'mainAxisSize: mainAxisSize,',
  'verticalDirection: verticalDirection,',
  'textDirection: textDirection,',
  'textBaseline: textBaseline,',
  'clipBehavior: flexClipBehavior,',
  'spacing: spacing,',
];

const _stackConstructorParams = [
  StylerConstructorParamDescriptor(
    type: 'AlignmentGeometry',
    name: 'stackAlignment',
  ),
  StylerConstructorParamDescriptor(type: 'StackFit', name: 'fit'),
  StylerConstructorParamDescriptor(
    type: 'TextDirection',
    name: 'textDirection',
  ),
  StylerConstructorParamDescriptor(type: 'Clip', name: 'stackClipBehavior'),
];

const _stackConstructorArguments = [
  'alignment: stackAlignment,',
  'fit: fit,',
  'textDirection: textDirection,',
  'clipBehavior: stackClipBehavior,',
];

List<StylerFactoryDescriptor> _directFactories(Map<String, String> signatures) {
  return [
    for (final entry in signatures.entries)
      StylerFactoryDescriptor(
        name: entry.key,
        signature: '${entry.key}(${entry.value} value)',
        invocation: '${entry.key}(value)',
      ),
  ];
}

StylerMethodDescriptor _directMergeMethod(
  String name,
  String parameterType,
  String constructorArg, {
  bool isOverride = false,
}) {
  return StylerMethodDescriptor(
    name: name,
    signature: '$name($parameterType value)',
    bodyLines: ['return merge(%STYLER%($constructorArg: value));'],
    isOverride: isOverride,
  );
}

const _boxDirectFactorySignatures = {
  'alignment': 'AlignmentGeometry',
  'padding': 'EdgeInsetsGeometryMix',
  'margin': 'EdgeInsetsGeometryMix',
  'constraints': 'BoxConstraintsMix',
  'decoration': 'DecorationMix',
  'foregroundDecoration': 'DecorationMix',
  'clipBehavior': 'Clip',
};

const _flexDirectFactorySignatures = {
  'direction': 'Axis',
  'mainAxisAlignment': 'MainAxisAlignment',
  'crossAxisAlignment': 'CrossAxisAlignment',
  'mainAxisSize': 'MainAxisSize',
  'spacing': 'double',
  'verticalDirection': 'VerticalDirection',
  'textDirection': 'TextDirection',
  'textBaseline': 'TextBaseline',
};

const _stackDirectFactorySignatures = {
  'stackAlignment': 'AlignmentGeometry',
  'fit': 'StackFit',
  'textDirection': 'TextDirection',
  'stackClipBehavior': 'Clip',
};

final _boxDirectMethods = [
  _directMergeMethod('alignment', 'AlignmentGeometry', 'alignment'),
  _directMergeMethod(
    'transformAlignment',
    'AlignmentGeometry',
    'transformAlignment',
  ),
  _directMergeMethod('clipBehavior', 'Clip', 'clipBehavior'),
  _directMergeMethod(
    'foregroundDecoration',
    'DecorationMix',
    'foregroundDecoration',
    isOverride: true,
  ),
  _directMergeMethod(
    'padding',
    'EdgeInsetsGeometryMix',
    'padding',
    isOverride: true,
  ),
  _directMergeMethod(
    'margin',
    'EdgeInsetsGeometryMix',
    'margin',
    isOverride: true,
  ),
  const StylerMethodDescriptor(
    name: 'transform',
    signature:
        'transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center})',
    bodyLines: [
      'return merge(%STYLER%(transform: value, transformAlignment: alignment));',
    ],
    isOverride: true,
  ),
  _directMergeMethod(
    'decoration',
    'DecorationMix',
    'decoration',
    isOverride: true,
  ),
  _directMergeMethod(
    'constraints',
    'BoxConstraintsMix',
    'constraints',
    isOverride: true,
  ),
];

final _flexDirectMethods = [
  const StylerMethodDescriptor(
    name: 'flex',
    signature: 'flex(FlexStyler value)',
    bodyLines: ['return merge(%STYLER%.create(flex: Prop.maybeMix(value)));'],
    isOverride: true,
  ),
];

final _stackDirectMethods = [
  const StylerMethodDescriptor(
    name: 'stack',
    signature: 'stack(StackStyler value)',
    bodyLines: ['return merge(%STYLER%.create(stack: Prop.maybeMix(value)));'],
  ),
  StylerMethodDescriptor(
    name: 'stackAlignment',
    signature: 'stackAlignment(AlignmentGeometry value)',
    bodyLines: ['return merge(%STYLER%(stackAlignment: value));'],
  ),
  StylerMethodDescriptor(
    name: 'fit',
    signature: 'fit(StackFit value)',
    bodyLines: ['return merge(%STYLER%(fit: value));'],
  ),
  StylerMethodDescriptor(
    name: 'textDirection',
    signature: 'textDirection(TextDirection value)',
    bodyLines: ['return merge(%STYLER%(textDirection: value));'],
  ),
  StylerMethodDescriptor(
    name: 'stackClipBehavior',
    signature: 'stackClipBehavior(Clip value)',
    bodyLines: ['return merge(%STYLER%(stackClipBehavior: value));'],
  ),
];

final _compoundSurfaces = {
  'FlexBoxStyler': CompoundStylerSurface(
    stylerName: 'FlexBoxStyler',
    parts: const [
      CompoundStylerPartDescriptor(
        fieldName: 'box',
        specName: 'BoxSpec',
        stylerName: 'BoxStyler',
        ownerMixinNames: _boxOwnerMixinNames,
        constructorParams: _boxConstructorParams,
        constructorArguments: _boxConstructorArguments,
      ),
      CompoundStylerPartDescriptor(
        fieldName: 'flex',
        specName: 'FlexSpec',
        stylerName: 'FlexStyler',
        ownerMixinNames: ['FlexStyleMixin'],
        constructorParams: _flexConstructorParams,
        constructorArguments: _flexConstructorArguments,
      ),
    ],
    factoryDescriptors: [
      ..._directFactories(_boxDirectFactorySignatures),
      ..._directFactories(_flexDirectFactorySignatures),
      transformAnchorFactoryDescriptor(),
    ],
    methodDescriptors: [..._boxDirectMethods, ..._flexDirectMethods],
  ),
  'StackBoxStyler': CompoundStylerSurface(
    stylerName: 'StackBoxStyler',
    parts: const [
      CompoundStylerPartDescriptor(
        fieldName: 'box',
        specName: 'BoxSpec',
        stylerName: 'BoxStyler',
        ownerMixinNames: _boxOwnerMixinNames,
        constructorParams: _boxConstructorParams,
        constructorArguments: _boxConstructorArguments,
      ),
      CompoundStylerPartDescriptor(
        fieldName: 'stack',
        specName: 'StackSpec',
        stylerName: 'StackStyler',
        ownerMixinNames: [],
        constructorParams: _stackConstructorParams,
        constructorArguments: _stackConstructorArguments,
      ),
    ],
    factoryDescriptors: [
      ..._directFactories(_boxDirectFactorySignatures),
      ..._directFactories(_stackDirectFactorySignatures),
      transformAnchorFactoryDescriptor(),
    ],
    methodDescriptors: [..._boxDirectMethods, ..._stackDirectMethods],
  ),
};

/// Returns curated surface metadata for [stylerName].
StylerSurface? stylerSurfaceFor(String stylerName) => _surfaces[stylerName];

/// Returns curated compound surface metadata for [stylerName].
CompoundStylerSurface? compoundStylerSurfaceFor(String stylerName) {
  return _compoundSurfaces[stylerName];
}

/// Field-backed factories intentionally suppressed for [stylerName].
Set<String> suppressedFieldFactoryNamesFor(String stylerName) {
  return stylerSurfaceFor(stylerName)?.suppressedFieldFactoryNames ?? const {};
}

/// Curated text directive factories.
List<StylerFactoryDescriptor> textDirectiveFactoryDescriptors() {
  return const [
    StylerFactoryDescriptor(
      name: 'textDirective',
      signature: 'textDirective(Directive<String> value)',
      invocation: 'textDirective(value)',
    ),
    StylerFactoryDescriptor(
      name: 'directive',
      signature: 'directive(Directive<String> value)',
      invocation: 'directive(value)',
    ),
    StylerFactoryDescriptor(
      name: 'uppercase',
      signature: 'uppercase()',
      invocation: 'uppercase()',
    ),
    StylerFactoryDescriptor(
      name: 'lowercase',
      signature: 'lowercase()',
      invocation: 'lowercase()',
    ),
    StylerFactoryDescriptor(
      name: 'capitalize',
      signature: 'capitalize()',
      invocation: 'capitalize()',
    ),
    StylerFactoryDescriptor(
      name: 'titlecase',
      signature: 'titlecase()',
      invocation: 'titlecase()',
    ),
    StylerFactoryDescriptor(
      name: 'sentencecase',
      signature: 'sentencecase()',
      invocation: 'sentencecase()',
    ),
  ];
}

/// Curated text directive methods.
List<StylerMethodDescriptor> textDirectiveMethodDescriptors() {
  return const [
    StylerMethodDescriptor(
      name: 'textDirective',
      signature: 'textDirective(Directive<String> value)',
      bodyLines: ['return merge(%STYLER%(textDirectives: [value]));'],
    ),
    StylerMethodDescriptor(
      name: 'directive',
      signature: 'directive(Directive<String> value)',
      bodyLines: ['return merge(%STYLER%(textDirectives: [value]));'],
    ),
    StylerMethodDescriptor(
      name: 'uppercase',
      signature: 'uppercase()',
      bodyLines: [
        'return merge(%STYLER%(textDirectives: [const UppercaseStringDirective()]));',
      ],
    ),
    StylerMethodDescriptor(
      name: 'lowercase',
      signature: 'lowercase()',
      bodyLines: [
        'return merge(%STYLER%(textDirectives: [const LowercaseStringDirective()]));',
      ],
    ),
    StylerMethodDescriptor(
      name: 'capitalize',
      signature: 'capitalize()',
      bodyLines: [
        'return merge(%STYLER%(textDirectives: [const CapitalizeStringDirective()]));',
      ],
    ),
    StylerMethodDescriptor(
      name: 'titlecase',
      signature: 'titlecase()',
      bodyLines: [
        'return merge(%STYLER%(textDirectives: [const TitleCaseStringDirective()]));',
      ],
    ),
    StylerMethodDescriptor(
      name: 'sentencecase',
      signature: 'sentencecase()',
      bodyLines: [
        'return merge(%STYLER%(textDirectives: [const SentenceCaseStringDirective()]));',
      ],
    ),
  ];
}

/// Curated single-shadow factory for icon stylers.
StylerFactoryDescriptor iconShadowFactoryDescriptor() {
  return const StylerFactoryDescriptor(
    name: 'shadow',
    signature: 'shadow(ShadowMix value)',
    invocation: 'shadow(value)',
  );
}

/// Curated single-shadow method for icon stylers.
StylerMethodDescriptor iconShadowMethodDescriptor() {
  return const StylerMethodDescriptor(
    name: 'shadow',
    signature: 'shadow(ShadowMix value)',
    bodyLines: ['return merge(%STYLER%(shadows: [value]));'],
  );
}

/// Transform factory emitted when a styler has a transform anchor.
StylerFactoryDescriptor transformAnchorFactoryDescriptor() {
  return const StylerFactoryDescriptor(
    name: 'transform',
    signature: 'transform(Matrix4 value, {Alignment alignment = .center})',
    invocation: 'transform(value, alignment: alignment)',
  );
}

/// Transform anchor method emitted for non-compound transform stylers.
StylerMethodDescriptor transformAnchorMethodDescriptor() {
  return const StylerMethodDescriptor(
    name: 'transform',
    signature: 'transform(Matrix4 value, {Alignment alignment = .center})',
    bodyLines: [
      'return merge(%STYLER%(transform: value, transformAlignment: alignment));',
    ],
    isOverride: true,
  );
}

/// Static animate factory descriptor.
StylerFactoryDescriptor animateFactoryDescriptor() {
  return const StylerFactoryDescriptor(
    name: 'animate',
    signature: 'animate(AnimationConfig value)',
    invocation: 'animate(value)',
  );
}
