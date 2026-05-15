/// Shared type helpers for field models.
library;

import 'package:analyzer/dart/element/type.dart';

String getBaseTypeName(DartType type) {
  final displayString = type.getDisplayString();

  if (displayString.endsWith('?')) {
    return displayString.substring(0, displayString.length - 1);
  }

  return displayString;
}

bool isWrappedInProp(DartType type) {
  if (type is! InterfaceType) return false;

  return type.element.name == 'Prop';
}

String getInnerTypeName(DartType type, {required bool isWrapped}) {
  if (!isWrapped) {
    return getBaseTypeName(type);
  }

  if (type is! InterfaceType) return getBaseTypeName(type);

  if (type.typeArguments.isNotEmpty) {
    return getBaseTypeName(type.typeArguments.first);
  }

  return getBaseTypeName(type);
}
