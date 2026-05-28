/// Plans and validates generated styler public API members.
library;

import '../curated/styler_surface_metadata.dart';

/// Concrete generated API member code keyed by public member name.
class StylerApiMember {
  /// Public member name.
  final String name;

  /// Generated Dart code.
  final String code;

  const StylerApiMember({required this.name, required this.code});
}

/// Validated styler API plan.
class StylerApiPlan {
  /// Styler name.
  final String stylerName;

  /// Field-backed factory members.
  final List<StylerApiMember> fieldFactories;

  /// Curated factory members.
  final List<StylerApiMember> curatedFactories;

  /// Curated method members.
  final List<StylerApiMember> curatedMethods;

  const StylerApiPlan({
    required this.stylerName,
    this.fieldFactories = const [],
    this.curatedFactories = const [],
    this.curatedMethods = const [],
  });

  /// Factory code in emission order.
  List<String> get factoryCodes {
    return [
      ...fieldFactories.map((factory) => factory.code),
      ...curatedFactories.map((factory) => factory.code),
    ];
  }

  /// Method code in emission order.
  List<String> get methodCodes {
    return curatedMethods.map((method) => method.code).toList();
  }
}

/// Converts curated descriptors and generated field members into a validated
/// styler API plan.
class StylerApiPlanner {
  /// Styler name.
  final String stylerName;

  static const _reservedBaseMethodNames = {
    'animate',
    'variants',
    'wrap',
    'modifier',
  };

  const StylerApiPlanner({required this.stylerName});

  void _validateUniqueFactories(List<StylerApiMember> factories) {
    final seen = <String>{};
    for (final factory in factories) {
      if (seen.add(factory.name)) continue;

      throw StateError(
        'Duplicate generated factory `$stylerName.${factory.name}`.',
      );
    }
  }

  void _validateUniqueMethods(
    Set<String> generatedSetterNames,
    List<StylerApiMember> methods,
  ) {
    for (final setterName in generatedSetterNames) {
      if (!_reservedBaseMethodNames.contains(setterName)) continue;

      throw StateError('Duplicate generated method `$stylerName.$setterName`.');
    }

    final seen = <String>{..._reservedBaseMethodNames, ...generatedSetterNames};
    for (final method in methods) {
      if (seen.add(method.name)) continue;

      throw StateError(
        'Duplicate generated method `$stylerName.${method.name}`.',
      );
    }
  }

  /// Builds a validated plan.
  StylerApiPlan build({
    List<StylerApiMember> fieldFactories = const [],
    List<StylerFactoryDescriptor> curatedFactories = const [],
    List<StylerMethodDescriptor> curatedMethods = const [],
    Set<String> generatedSetterNames = const {},
  }) {
    final curatedFactoryMembers = [
      for (final descriptor in curatedFactories)
        StylerApiMember(
          name: descriptor.name,
          code: descriptor.codeFor(stylerName),
        ),
    ];
    final curatedMethodMembers = [
      for (final descriptor in curatedMethods)
        StylerApiMember(
          name: descriptor.name,
          code: descriptor.codeFor(stylerName),
        ),
    ];

    _validateUniqueFactories([...fieldFactories, ...curatedFactoryMembers]);
    _validateUniqueMethods(generatedSetterNames, curatedMethodMembers);

    return StylerApiPlan(
      stylerName: stylerName,
      fieldFactories: fieldFactories,
      curatedFactories: curatedFactoryMembers,
      curatedMethods: curatedMethodMembers,
    );
  }
}
