import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../checkers.dart';
import '../errors.dart';
import '../helpers/library_scope.dart';

/// Common analyzer-derived field facts used by all field model factories.
class FieldExtraction {
  final DartType type;
  final String declaredName;
  final String name;
  final String typeName;

  const FieldExtraction({
    required this.type,
    required this.declaredName,
    required this.name,
    required this.typeName,
  });
}

/// Extracts common field metadata.
FieldExtraction extractField(FieldElement element, {bool stripDollar = false}) {
  final type = element.type;
  final declaredName = element.name!;
  final name = stripDollar && declaredName.startsWith(r'$')
      ? declaredName.substring(1)
      : declaredName;

  return FieldExtraction(
    type: type,
    declaredName: declaredName,
    name: name,
    typeName: getBaseTypeName(type),
  );
}

/// Returns the display string of [type] with any trailing `?` stripped.
String getBaseTypeName(DartType type) {
  final displayString = type.getDisplayString();

  if (displayString.endsWith('?')) {
    return displayString.substring(0, displayString.length - 1);
  }

  return displayString;
}

/// Whether [type] is exactly `Prop<T>` from `package:mix`.
///
/// Uses a URL-based `TypeChecker` so unrelated local classes named `Prop`
/// are not mistaken for Mix's `Prop`.
bool isWrappedInProp(DartType type) {
  if (type is! InterfaceType) return false;

  return propChecker.isExactlyType(type);
}

/// Returns the public value type inside `Prop<T>`, or [type] when unwrapped.
DartType getInnerType(DartType type, {required bool isWrapped}) {
  if (!isWrapped) {
    return type;
  }

  if (type is! InterfaceType) return type;

  if (type.typeArguments.isNotEmpty) {
    return type.typeArguments.first;
  }

  return type;
}

/// Returns Dart code for a field-related [type] from [visibleFrom].
String visibleTypeCodeForField(
  FieldElement element, {
  required LibraryElement visibleFrom,
  DartType? type,
  String usage = 'type',
}) {
  final resolvedType = type ?? element.type;
  final hiddenType = firstInvisibleTypeName(resolvedType, visibleFrom);
  if (hiddenType != null) {
    final fieldName = element.name ?? '<unknown>';
    final libraryName = visibleFrom.uri.pathSegments.isEmpty
        ? visibleFrom.uri.toString()
        : visibleFrom.uri.pathSegments.last;
    fail(
      element,
      'Field `$fieldName` uses $usage `$hiddenType`, but that type is '
      'not visible from `$libraryName` (where generation runs). Import or '
      're-export `$hiddenType` from that library.',
    );
  }

  return typeCode(resolvedType, visibleFrom: visibleFrom);
}
