// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

extension DartTypeExtension on DartType {
  bool isAssignableTo(DartType other) {
    final self = this;

    if (self is InterfaceType) {
      final library = self.element.library;
      return library.typeSystem.isAssignableTo(this, other);
    }
    return true;
  }

  bool get isEnum {
    final self = this;
    return self is InterfaceType && self.element is EnumElement;
  }

  bool get isNullableType =>
      this is DynamicType || nullabilitySuffix == NullabilitySuffix.question;

  /// Returns `true` if `this` is `dynamic` or `Object?`.
  bool get isLikeDynamic =>
      (isDartCoreObject && isNullableType) || this is DynamicType;

  /// Returns all of the [DartType] types that `this` implements, mixes-in, and
  /// extends, starting with `this` itself.
  Iterable<DartType> get typeImplementations sync* {
    yield this;

    final myType = this;

    if (myType is InterfaceType) {
      yield* myType.interfaces.expand((e) => e.typeImplementations);
      yield* myType.mixins.expand((e) => e.typeImplementations);

      if (myType.superclass != null) {
        yield* myType.superclass!.typeImplementations;
      }
    }
  }

  /// If `this` is the [Type] or implements the [Type] represented by [checker],
  /// returns the generic arguments to the [checker] [Type] if there are any.
  ///
  /// If the [checker] [Type] doesn't have generic arguments, `null` is
  /// returned.
  List<DartType>? typeArgumentsOf(TypeChecker checker) {
    final implementation = _getImplementationType(checker) as InterfaceType?;

    return implementation?.typeArguments;
  }

  DartType? _getImplementationType(TypeChecker checker) =>
      typeImplementations.firstWhereOrNull(checker.isExactlyType);
}

extension ElementX on Element {
  Iterable<LibraryImportElement> get nonCoreImports =>
      library?.libraryImports.where((element) {
        final lib = element.importedLibrary;
        if (lib == null) {
          return false;
        }
        return !lib.isDartAsync && //
            !lib.isDartCore &&
            !lib.isInSdk;
      }) ??
      [];
}

// Check if identifier starts with 'package:flutter/' or 'dart:
// Also check if there is a depednency on pubspec, that matches 'package:NAME/'

extension LibraryElementX on LibraryElement {
  bool get isFlutterLibrary =>
      source.uri.toString().startsWith('package:flutter/');

  bool get isDartLibrary => source.uri.toString().startsWith('dart:');

  bool get isFlutterOrDart {
    return isFlutterLibrary || isDartLibrary;
  }
}

extension ConstructorElementX on ConstructorElement {
  bool get isUnamedConstructor => name == '' && !isFactory;
  bool get isPrivateConstructor => name.startsWith('_') && !isFactory;
}

extension ConstantReaderX on ConstantReader {
  String? get typeAsString {
    final peakedType = peek('type');

    String? name;

    if (peakedType?.isString == true) {
      return peakedType!.stringValue;
    } else if (peakedType?.isType == true) {
      return peakedType!.typeValue.element!.name!;
    }

    return name;
  }
}
