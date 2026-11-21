/// Plans and validates generated styler public API members.
library;

import '../curated/styler_surface_metadata.dart';

/// Concrete generated API member code keyed by public member name.
typedef ApiMember = ({String name, String code});

/// Methods emitted by every generated Styler outside the curated API plan.
const stylerGeneratedBaseMethodNames = {
  'animate',
  'variants',
  'wrap',
  'modifier',
};

void _validateUniqueFactories(String stylerName, List<ApiMember> factories) {
  final seen = <String>{};
  for (final factory in factories) {
    if (seen.add(factory.name)) continue;

    throw StateError(
      'Duplicate generated factory `$stylerName.${factory.name}`.',
    );
  }
}

void _validateUniqueMethods(
  String stylerName,
  Set<String> generatedSetterNames,
  List<ApiMember> methods,
) {
  for (final setterName in generatedSetterNames) {
    if (!stylerGeneratedBaseMethodNames.contains(setterName)) continue;

    throw StateError('Duplicate generated method `$stylerName.$setterName`.');
  }

  final seen = <String>{
    ...stylerGeneratedBaseMethodNames,
    ...generatedSetterNames,
  };
  for (final method in methods) {
    if (seen.add(method.name)) continue;

    throw StateError(
      'Duplicate generated method `$stylerName.${method.name}`.',
    );
  }
}

/// Converts curated descriptors and generated field members into validated
/// styler API code in emission order.
({List<String> factoryCodes, List<String> methodCodes}) planStylerApi({
  required String stylerName,
  List<ApiMember> fieldFactories = const [],
  List<StylerFactoryDescriptor> curatedFactories = const [],
  List<StylerMethodDescriptor> curatedMethods = const [],
  Set<String> generatedSetterNames = const {},
}) {
  final curatedFactoryMembers = [
    for (final descriptor in curatedFactories)
      (name: descriptor.name, code: descriptor.codeFor(stylerName)),
  ];
  final curatedMethodMembers = [
    for (final descriptor in curatedMethods)
      (name: descriptor.name, code: descriptor.codeFor(stylerName)),
  ];

  _validateUniqueFactories(stylerName, [
    ...fieldFactories,
    ...curatedFactoryMembers,
  ]);
  _validateUniqueMethods(
    stylerName,
    generatedSetterNames,
    curatedMethodMembers,
  );

  return (
    factoryCodes: [
      ...fieldFactories.map((factory) => factory.code),
      ...curatedFactoryMembers.map((factory) => factory.code),
    ],
    methodCodes: curatedMethodMembers.map((method) => method.code).toList(),
  );
}
