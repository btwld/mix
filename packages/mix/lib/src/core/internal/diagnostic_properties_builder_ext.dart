import 'package:flutter/foundation.dart';

extension DiagnosticPropertiesBuilderExt on DiagnosticPropertiesBuilder {
  void addUsingDefault<T>(String name, T value, {expandableValue = false}) {
    add(
      DiagnosticsProperty(
        name,
        value,
        defaultValue: null,
        expandableValue: expandableValue,
      ),
    );
  }
}
