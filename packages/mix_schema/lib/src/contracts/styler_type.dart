enum StylerType { box, text, flex, icon, image, stack, flexBox, stackBox }

const Map<StylerType, String> _stylerTypeToWire = {
  StylerType.box: 'box',
  StylerType.text: 'text',
  StylerType.flex: 'flex',
  StylerType.icon: 'icon',
  StylerType.image: 'image',
  StylerType.stack: 'stack',
  StylerType.flexBox: 'flexBox',
  StylerType.stackBox: 'stackBox',
};

final Map<String, StylerType> _wireToStylerType = {
  for (final entry in _stylerTypeToWire.entries) entry.value: entry.key,
};

extension StylerTypeWire on StylerType {
  String get wire => _stylerTypeToWire[this]!;
}

StylerType? stylerTypeFromWire(String value) {
  return _wireToStylerType[value];
}
