/// Resolves Mix-owned symbols from the public Mix library.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import '../errors.dart';

const mixPublicImport = 'package:mix/mix.dart';

final class KnownMixSymbolResolver {
  final LibraryElement supportLibrary;

  const KnownMixSymbolResolver._(this.supportLibrary);

  static Future<KnownMixSymbolResolver> load(
    BuildStep buildStep,
    Element errorElement,
  ) async {
    final assetId = AssetId.resolve(
      Uri.parse(mixPublicImport),
      from: buildStep.inputId,
    );

    try {
      final library = await buildStep.resolver.libraryFor(assetId);

      return KnownMixSymbolResolver._(library);
    } on Object catch (error) {
      fail(
        errorElement,
        'SpecStylerGenerator could not resolve `$mixPublicImport` '
        'while deriving generated styler support metadata.',
        todo:
            'Ensure `lib/mix.dart` exports the Mix runtime surface needed by '
            'generated stylers. Original resolver error: $error',
      );
    }
  }

  InterfaceElement requireInterface(String symbolName, Element errorElement) {
    final element = supportLibrary.exportNamespace.get2(symbolName);
    if (element is InterfaceElement) return element;

    fail(
      errorElement,
      'SpecStylerGenerator could not resolve Mix support symbol '
      '`$symbolName` from `$mixPublicImport`.',
      todo:
          'Export `$symbolName` from `lib/mix.dart`, or remove it from the '
          'curated ownerMixins registry.',
    );
  }

  /// All non-static instance member names declared or inherited by [symbolName].
  Set<String> instanceMemberNames(String symbolName, Element errorElement) {
    final interface = requireInterface(symbolName, errorElement);
    final hierarchy = {
      interface,
      ...interface.allSupertypes.map((type) => type.element),
    };

    return {
      for (final element in hierarchy)
        ...element.methods
            .where((method) => !method.isStatic)
            .map((method) => method.name)
            .nonNulls,
      for (final element in hierarchy)
        ...element.getters
            .where((getter) => !getter.isStatic)
            .map((getter) => getter.name)
            .nonNulls,
      for (final element in hierarchy)
        ...element.setters
            .where((setter) => !setter.isStatic)
            .map((setter) => setter.name)
            .nonNulls,
    };
  }
}
