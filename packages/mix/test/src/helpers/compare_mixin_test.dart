import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  test('mapPropsToString', () {
    final firstStyle = Style(
      $box.alignment.center(),
      $box.borderRadius.all(Radius.circular(10)),
      $box.color.red(),
    );
    final secondStyle = Style(
      $box.alignment.center(),
      $box.borderRadius.all(Radius.circular(10)),
      $box.color.red(),
    );

    expect(firstStyle.toString(), secondStyle.toString());
  });

  test('getDiff', () {
    final firstStyle = Style($box.color.blue());
    final secondStyle = Style($box.color.red());

    final diff = firstStyle.getDiff(secondStyle);

    expect(diff.length, 1);
  });
}

// A dummy custom object class for testing purposes
class CustomObject {
  final int id;
  final String value;

  const CustomObject({required this.id, required this.value});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomObject && other.id == id && other.value == value;
  }

  @override
  int get hashCode => Object.hash(id, value);
}

class AnotherCustomObject {
  final int id;
  final String name;
  final List<AnotherCustomObject> children;

  const AnotherCustomObject({
    required this.id,
    required this.name,
    this.children = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnotherCustomObject &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          listEquals(children, other.children);

  @override
  int get hashCode => Object.hash(id, name, Object.hashAll(children));
}
