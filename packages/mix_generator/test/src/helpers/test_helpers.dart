import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';

/// Mock classes for the mix_annotations package
/// These match the real package structure but are defined here for testing

const String _mixAnnotationsDefinitions = '''
// @dart=3.0
library mix_annotations;

class MixableSpec {
  final bool withCopyWith;
  final bool withEquality;
  final bool withLerp;
  final bool skipUtility;
  final String prefix;
  
  const MixableSpec({
    this.withCopyWith = true,
    this.withEquality = true,
    this.withLerp = true,
    this.skipUtility = false,
    this.prefix = '',
  });
}

class Mixable {
  final int generators;
  const Mixable({
    this.generators = _allHelpers,
  });
}

class MixableConstructor {
  const MixableConstructor();
}

class MixableUtility {
  final int generators;
  const MixableUtility({this.generators = _allHelpers});
}

typedef MixableUtilityProps = ({String path, String alias});

class MixableDto {
  final bool mergeLists;
  final bool generateValueExtension;
  final bool generateUtility;
  
  const MixableDto({
    this.mergeLists = true,
    this.generateValueExtension = true,
    this.generateUtility = true,
  });
}

class MixableField {
  final MixableFieldDto? dto;
  final List<MixableFieldUtility>? utilities;
  final bool isLerpable;
  
  const MixableField({this.dto, this.utilities, this.isLerpable = true});
}

class MixableFieldDto {
  final Object? type;
  
  const MixableFieldDto({this.type});
  
  String? get typeAsString {
    return type is String ? type as String : type?.toString();
  }
}

class MixableFieldUtility {
  final String? alias;
  final Object? type;
  final List<MixableUtilityProps> properties;
  
  const MixableFieldUtility({
    this.alias,
    this.type,
    this.properties = const [],
  });
  
  String? get typeAsString {
    return type is String ? type as String : type?.toString();
  }
}

class MixableClassUtility {
  final Type? type;
  final bool generateCallMethod;
  
  const MixableClassUtility({this.type, this.generateCallMethod = true});
}

class MixableEnumUtility {
  final bool generateCallMethod;
  
  const MixableEnumUtility({this.generateCallMethod = true});
}

class MixableToken {
  final Object type;
  final String? namespace;
  final bool utilityExtension;
  final bool contextExtension;
  
  const MixableToken(
    this.type, {
    this.namespace,
    this.utilityExtension = true,
    this.contextExtension = true,
  });
}

class MixableSwatchColorToken {
  final int scale;
  final int defaultValue;
  
  const MixableSwatchColorToken({this.scale = 3, this.defaultValue = 1});
}

const _allHelpers = 0;

class GenerateSpecHelpers {
  const GenerateSpecHelpers._();
  static const all = copyWithMethod | equalsMethod | lerpMethod;
  static const copyWithMethod = 1;
  static const equalsMethod = 2;
  static const lerpMethod = 3;
  static const utilityClass = 4;
  static const attributeClass = 5;
}

class GenerateDtoHelpers {
  const GenerateDtoHelpers._();
  static const all = utilityClass | toDtoExtension;
  static const utilityClass = 1;
  static const toDtoExtension = 2;
}

class GenerateUtilityHelpers {
  const GenerateUtilityHelpers._();
  static const all = callMethod;
  static const callMethod = 1;
}
''';

const String _mixDefinitions = '''
// @dart=3.0
library mix;

import 'package:flutter/widgets.dart';

/// Base class for all widget modifier specifications
abstract class WidgetModifierSpec<Self extends WidgetModifierSpec<Self>> extends Spec {
  final dynamic animated;
  
  const WidgetModifierSpec({this.animated});
  
  Self copyWith();
  
  Self lerp(covariant Self? other, double t);
  
  Widget build(Widget child);
}

/// Base class for widget modifier specification attributes
abstract class WidgetModifierSpecAttribute<Value extends WidgetModifierSpec<Value>> extends SpecAttribute {
  const WidgetModifierSpecAttribute();
}

/// Utility class for DTOs
class DtoUtility {
  const DtoUtility();
}

class Dto<V> {
  const Dto();
}

class Spec<T extends Spec<T>> {
  const Spec();
}

mixin Diagnosticable {
  void debugFillProperties(dynamic properties);
}

/// Utility class for Specs
class SpecUtility {
  const SpecUtility();
}

/// Mix data container
class MixContext {
  const MixContext();
}

/// Base class for all style elements
abstract class StyleElement {
  const StyleElement();
  
  StyleElement merge(covariant StyleElement other);
  
  List<Object?> get props;
}

/// Base class for styled attributes
abstract class StyledAttribute extends StyleElement {
  const StyledAttribute();
}

/// Base utility class for creating style elements
abstract class MixUtility<T extends StyleElement, V> {
  final T Function(V) builder;
  final bool mutable;
  
  const MixUtility(this.builder, {this.mutable = false});
}
''';

/// Helper function to resolve code in tests with improved error handling
/// and mix package imports
Future<LibraryElement> resolveMixTestLibrary(String code) async {
  try {
    // Create a map of assets for the resolver
    final sources = {
      'mix_annotations|lib/mix_annotations.dart': _mixAnnotationsDefinitions,
      'mix|lib/mix.dart': _mixDefinitions,
      'test_package|lib/main.dart': '''
        // @dart=3.0
        // Enable generic-metadata language feature
        library test_lib;
        
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        
        $code
      ''',
    };

    final resolvedLib = await resolveSources(
      sources,
      (resolver) async {
        // First ensure the mix_annotations package is resolved
        await resolver
            .libraryFor(AssetId('mix_annotations', 'lib/mix_annotations.dart'));

        // Then ensure the mix package is resolved
        await resolver.libraryFor(AssetId('mix', 'lib/mix.dart'));

        // Finally resolve our test library that imports both
        final library =
            await resolver.libraryFor(AssetId('test_package', 'lib/main.dart'));
        return library;
      },
    );

    return resolvedLib;
  } catch (e) {
    fail('Exception during library resolution: $e');
  }
}

/// Helper function to resolve code in tests without mock packages
/// Use this for tests that don't need the Mix framework
Future<LibraryElement> resolveSimpleTestLibrary(String code) async {
  try {
    final resolvedLib = await resolveSource(
      '''
      // @dart=3.0
      library test_lib;
      
      $code
      ''',
      (resolver) async {
        final library = await resolver.findLibraryByName('test_lib');
        if (library == null) {
          fail('Could not find library "test_lib"');
        }
        return library;
      },
    );
    return resolvedLib;
  } catch (e) {
    fail('Exception during library resolution: $e');
  }
}
