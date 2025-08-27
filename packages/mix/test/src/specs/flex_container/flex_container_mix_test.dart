import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexBoxMix', () {
    test('should create instance with container and flex', () {
      final mix = FlexBoxMix(
        box: BoxMix(
          decoration: DecorationMix.color(Colors.red),
          padding: EdgeInsetsGeometryMix.all(10),
        ),
        flex: FlexMix(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.0,
        ),
      );

      expect(mix, isA<FlexBoxMix>());
      expect(mix.box, isNotNull);
      expect(mix.flex, isNotNull);
    });

    test('should create empty instance with null properties', () {
      final mix = FlexBoxMix();

      expect(mix, isA<FlexBoxMix>());
      expect(mix.box, isNull);
      expect(mix.flex, isNull);
    });

    test('should merge two instances correctly', () {
      final mix1 = FlexBoxMix(
        box: BoxMix(decoration: DecorationMix.color(Colors.red)),
      );
      final mix2 = FlexBoxMix(flex: FlexMix(direction: Axis.horizontal));

      final merged = mix1.merge(mix2);

      expect(merged.box, isNotNull);
      expect(merged.flex, isNotNull);
    });

    test('should resolve to FlexBoxSpec correctly', () {
      final mix = FlexBoxMix(
        box: BoxMix(
          decoration: DecorationMix.color(Colors.red),
          padding: EdgeInsetsGeometryMix.all(10),
        ),
        flex: FlexMix(direction: Axis.horizontal, spacing: 8.0),
      );

      final context = MockBuildContext();
      final spec = mix.resolve(context);

      expect(spec, isA<FlexBoxSpec>());
    });

    test('equality should work correctly', () {
      final mix1 = FlexBoxMix(
        box: BoxMix(decoration: DecorationMix.color(Colors.red)),
        flex: FlexMix(direction: Axis.horizontal),
      );
      final mix2 = FlexBoxMix(
        box: BoxMix(decoration: DecorationMix.color(Colors.red)),
        flex: FlexMix(direction: Axis.horizontal),
      );

      expect(mix1, equals(mix2));
    });

    test('hashCode should be consistent', () {
      final mix = FlexBoxMix(
        box: BoxMix(decoration: DecorationMix.color(Colors.red)),
        flex: FlexMix(direction: Axis.horizontal),
      );

      expect(mix.hashCode, mix.hashCode);
    });

    group('merge behavior', () {
      test('should merge container properties', () {
        final mix1 = FlexBoxMix(
          box: BoxMix(decoration: DecorationMix.color(Colors.red)),
        );
        final mix2 = FlexBoxMix(
          box: BoxMix(padding: EdgeInsetsGeometryMix.all(10)),
        );

        final merged = mix1.merge(mix2);

        expect(merged.box, isNotNull);
      });

      test('should merge flex properties', () {
        final mix1 = FlexBoxMix(flex: FlexMix(direction: Axis.horizontal));
        final mix2 = FlexBoxMix(flex: FlexMix(spacing: 10.0));

        final merged = mix1.merge(mix2);

        expect(merged.flex, isNotNull);
      });

      test('should override properties when merging', () {
        final mix1 = FlexBoxMix(flex: FlexMix(direction: Axis.horizontal));
        final mix2 = FlexBoxMix(flex: FlexMix(direction: Axis.vertical));

        final merged = mix1.merge(mix2);

        expect(merged.flex, isNotNull);
      });
    });

    group('props', () {
      test('should include container and flex in props', () {
        final mix = FlexBoxMix(
          box: BoxMix(decoration: DecorationMix.color(Colors.red)),
          flex: FlexMix(direction: Axis.horizontal),
        );

        expect(mix.props.length, equals(2));
        expect(mix.props, contains(mix.box));
        expect(mix.props, contains(mix.flex));
      });
    });

    group('debugFillProperties', () {
      test('should add container and flex to diagnostics', () {
        final mix = FlexBoxMix(
          box: BoxMix(decoration: DecorationMix.color(Colors.red)),
          flex: FlexMix(direction: Axis.horizontal),
        );

        final builder = DiagnosticPropertiesBuilder();
        mix.debugFillProperties(builder);

        expect(builder.properties.length, equals(2));
      });
    });
  });
}

class MockBuildContext implements BuildContext {
  @override
  bool get debugDoingBuild => false;

  @override
  InheritedWidget dependOnInheritedElement(
    InheritedElement ancestor, {
    Object? aspect,
  }) {
    throw UnimplementedError();
  }

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) {
    return null;
  }

  @override
  DiagnosticsNode describeElement(
    String name, {
    DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty,
  }) {
    throw UnimplementedError();
  }

  @override
  List<DiagnosticsNode> describeMissingAncestor({
    required Type expectedAncestorType,
  }) {
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeOwnershipChain(String name) {
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeWidget(
    String name, {
    DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty,
  }) {
    throw UnimplementedError();
  }

  @override
  void dispatchNotification(Notification notification) {}

  @override
  T? findAncestorRenderObjectOfType<T extends RenderObject>() {
    return null;
  }

  @override
  T? findAncestorStateOfType<T extends State<StatefulWidget>>() {
    return null;
  }

  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() {
    return null;
  }

  @override
  RenderObject? findRenderObject() {
    return null;
  }

  @override
  T? findRootAncestorStateOfType<T extends State<StatefulWidget>>() {
    return null;
  }

  @override
  InheritedElement?
  getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    return null;
  }

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    return null;
  }

  @override
  BuildOwner? get owner => null;

  @override
  Size? get size => null;

  @override
  void visitAncestorElements(bool Function(Element element) visitor) {}

  @override
  void visitChildElements(ElementVisitor visitor) {}

  @override
  Widget get widget => throw UnimplementedError();

  @override
  bool get mounted => true;

  bool get debugIsActive => true;
}
