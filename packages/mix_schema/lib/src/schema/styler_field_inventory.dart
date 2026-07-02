import 'package:mix/mix.dart' show Equatable;

const boxStylerInventory = {
  'alignment',
  'animation',
  'clipBehavior',
  'constraints',
  'decoration',
  'foregroundDecoration',
  'margin',
  'modifier',
  'padding',
  'transform',
  'transformAlignment',
  'variants',
};

const flexStylerInventory = {
  'animation',
  'clipBehavior',
  'crossAxisAlignment',
  'direction',
  'mainAxisAlignment',
  'mainAxisSize',
  'modifier',
  'spacing',
  'textBaseline',
  'textDirection',
  'variants',
  'verticalDirection',
};

const stackStylerInventory = {
  'alignment',
  'animation',
  'clipBehavior',
  'fit',
  'modifier',
  'textDirection',
  'variants',
};

const textStylerInventory = {
  'animation',
  'locale',
  'maxLines',
  'modifier',
  'overflow',
  'selectionColor',
  'semanticsLabel',
  'softWrap',
  'strutStyle',
  'style',
  'textAlign',
  'textDirection',
  'textDirectives',
  'textHeightBehavior',
  'textScaler',
  'textWidthBasis',
  'variants',
};

const iconStylerInventory = {
  'animation',
  'applyTextScaling',
  'blendMode',
  'color',
  'fill',
  'grade',
  'icon',
  'modifier',
  'opacity',
  'opticalSize',
  'semanticsLabel',
  'shadows',
  'size',
  'textDirection',
  'variants',
  'weight',
};

const imageStylerInventory = {
  'alignment',
  'animation',
  'centerSlice',
  'color',
  'colorBlendMode',
  'excludeFromSemantics',
  'filterQuality',
  'fit',
  'gaplessPlayback',
  'height',
  'image',
  'isAntiAlias',
  'matchTextDirection',
  'modifier',
  'repeat',
  'semanticLabel',
  'variants',
  'width',
};

const flexBoxStylerInventory = {
  'animation',
  'box',
  'flex',
  'modifier',
  'variants',
};

const stackBoxStylerInventory = {
  'animation',
  'box',
  'modifier',
  'stack',
  'variants',
};

int stylerFieldCount(Equatable value) => value.props.length;
