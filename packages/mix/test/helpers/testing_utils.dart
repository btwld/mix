// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/widget_state/internal/mix_widget_state_builder.dart';

export 'package:mix/src/internal/values_ext.dart';

class MockBuildContext extends BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>(
      {Object? aspect}) {
    return null;
  }

  @override
  InheritedElement?
      getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    return null;
  }
}

MixData MockMixData(Style style) {
  return MixData.create(MockBuildContext(), style);
}

final EmptyMixData = MixData.create(MockBuildContext(), const Style.empty());

MediaQuery createMediaQuery({
  Size? size,
  Brightness? brightness,
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: size ?? const Size.square(500),
      platformBrightness: brightness ?? Brightness.light,
    ),
    child: MixTheme(
      data: MixThemeData(),
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return Container();
            },
          ),
        ),
      ),
    ),
  );
}

Widget createDirectionality(TextDirection direction) {
  return MixTheme(
    data: MixThemeData(),
    child: MaterialApp(
      home: Directionality(
        textDirection: direction,
        child: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return Container();
            },
          ),
        ),
      ),
    ),
  );
}

Widget createWithMixTheme(MixThemeData theme, {Widget? child}) {
  return MixTheme(
    data: theme,
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return child ?? Container();
          },
        ),
      ),
    ),
  );
}

extension WidgetTesterExt on WidgetTester {
  Future<void> pumpWithMix(
    Widget widget, {
    Style style = const Style.empty(),
  }) async {
    await pumpWithMixTheme(
      Builder(
        builder: (BuildContext context) {
          // Populate MixData into the widget tree if needed
          return Mix.build(
            context,
            style: style,
            builder: (_) => widget,
          );
        },
      ),
    );
  }

  Future<void> pumpWithMixTheme(
    Widget widget, {
    MixThemeData? theme,
  }) async {
    await pumpWidget(
      MaterialApp(home: MixTheme(data: theme ?? MixThemeData(), child: widget)),
    );
  }

  Future<void> pumpWithPressable(
    Widget widget, {
    bool disabled = false,
    bool focused = false,
    bool pressed = false,
    bool hovered = false,
  }) async {
    final controller = WidgetStatesController();

    controller.disabled = disabled;
    controller.focused = focused;
    controller.hovered = hovered;
    controller.pressed = pressed;

    await pumpWidget(
      MaterialApp(
        home: MixWidgetStateBuilder(
          controller: controller,
          builder: (_) {
            return widget;
          },
        ),
      ),
    );
  }

  Future<void> pumpMaterialApp(Widget widget) async {
    await pumpWidget(MaterialApp(home: widget));
  }

  Future<BuildContext> pumpAndGetContext(Widget widget, [Type? type]) async {
    await pumpWidget(widget);
    return element(find.byType(type ?? widget.runtimeType)) as BuildContext;
  }

  Future<void> pumpStyledWidget(
    StyledWidget widget, {
    MixThemeData theme = const MixThemeData.empty(),
  }) async {
    await pumpWidget(
      MaterialApp(home: MixTheme(data: theme, child: widget)),
    );
  }
}

// ignore: constant_identifier_names
const FillWidget = SizedBox(width: 25, height: 25);

class WrapMixThemeWidget extends StatelessWidget {
  const WrapMixThemeWidget({required this.child, this.theme, super.key});

  final Widget child;
  final MixThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return MixTheme(
      data: theme ?? MixThemeData(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );
  }
}

final class MockDoubleScalarAttribute
    extends TestScalarAttribute<MockDoubleScalarAttribute, double> {
  const MockDoubleScalarAttribute(super.value);

  @override
  double resolve(MixData mix) => value;
}

class MockContextVariantCondition extends ContextVariant {
  final bool condition;
  @override
  final VariantPriority priority;
  const MockContextVariantCondition(this.condition,
      {this.priority = VariantPriority.normal});

  @override
  List<Object?> get props => [condition];

  @override
  Object get mergeKey => '$runtimeType.${priority.name}';

  @override
  bool when(BuildContext context) => condition;
}

final class MockIntScalarAttribute
    extends TestScalarAttribute<MockIntScalarAttribute, int> {
  const MockIntScalarAttribute(super.value);

  @override
  int resolve(MixData mix) => value;
}

class MockContextVariant extends ContextVariant {
  @override
  final VariantPriority priority;
  const MockContextVariant([this.priority = VariantPriority.normal]);

  @override
  bool when(BuildContext context) => true;
}

final class MockBooleanScalarAttribute
    extends TestScalarAttribute<MockBooleanScalarAttribute, bool> {
  const MockBooleanScalarAttribute(super.value);

  @override
  bool resolve(MixData mix) => value;
}

abstract class _MockSpecAttribute<T> extends SpecAttribute<T> {
  final T _value;
  const _MockSpecAttribute(this._value);

  @override
  T resolve(MixData mix) => _value;

  @override
  _MockSpecAttribute<T> merge(_MockSpecAttribute<T>? other);

  @override
  get props => [_value];
}

final class MockSpecBooleanAttribute extends _MockSpecAttribute<bool> {
  const MockSpecBooleanAttribute(super.value);

  @override
  MockSpecBooleanAttribute merge(MockSpecBooleanAttribute? other) {
    return MockSpecBooleanAttribute(other?._value ?? _value);
  }
}

final class MockSpecIntAttribute extends _MockSpecAttribute<int> {
  const MockSpecIntAttribute(super.value);

  @override
  MockSpecIntAttribute merge(MockSpecIntAttribute? other) {
    return MockSpecIntAttribute(other?._value ?? _value);
  }
}

final class MockSpecDoubleAttribute extends _MockSpecAttribute<double> {
  const MockSpecDoubleAttribute(super.value);

  @override
  MockSpecDoubleAttribute merge(MockSpecDoubleAttribute? other) {
    return MockSpecDoubleAttribute(other?._value ?? _value);
  }
}

final class MockSpecStringAttribute extends _MockSpecAttribute<String> {
  const MockSpecStringAttribute(super.value);

  @override
  MockSpecStringAttribute merge(MockSpecStringAttribute? other) {
    return MockSpecStringAttribute(other?._value ?? _value);
  }
}

final class MockStringScalarAttribute
    extends TestScalarAttribute<MockStringScalarAttribute, String> {
  const MockStringScalarAttribute(super.value);

  @override
  String resolve(MixData mix) => value;
}

final class MockInvalidAttribute extends Attribute {
  const MockInvalidAttribute();

  @override
  MockInvalidAttribute merge(MockInvalidAttribute? other) {
    return const MockInvalidAttribute();
  }

  @override
  get props => [];
}

const mockVariant = Variant('mock-variant');

final class UtilityTestAttribute<T>
    extends TestScalarAttribute<UtilityTestAttribute<T>, T> {
  const UtilityTestAttribute(super.value);

  @override
  T resolve(MixData mix) => value;
}

final class UtilityTestDtoAttribute<T extends Mixable<V>, V>
    extends SpecAttribute<V> {
  final T value;
  const UtilityTestDtoAttribute(this.value);

  @override
  V resolve(MixData mix) {
    return value.resolve(mix);
  }

  @override
  UtilityTestDtoAttribute<T, V> merge(UtilityTestDtoAttribute<T, V>? other) {
    return UtilityTestDtoAttribute(other?.value ?? value);
  }

  @override
  get props => [value];
}

final class CustomWidgetModifierSpec
    extends WidgetModifierSpec<CustomWidgetModifierSpec> {
  final bool value;
  const CustomWidgetModifierSpec(
    this.value, {
    super.animated,
  });

  @override
  CustomWidgetModifierSpec copyWith({bool? value}) {
    return CustomWidgetModifierSpec(value ?? this.value);
  }

  @override
  CustomWidgetModifierSpec lerp(CustomWidgetModifierSpec? other, double t) {
    if (other == null) return this;

    return CustomWidgetModifierSpec(
        MixHelpers.lerpSnap(value, other.value, t) ?? value);
  }

  @override
  get props => [value];

  @override
  Widget build(Widget child) {
    return Padding(padding: const EdgeInsets.all(8.0), child: child);
  }
}

final class CustomModifierAttribute
    extends WidgetModifierSpecAttribute<CustomWidgetModifierSpec> {
  final bool? value;
  const CustomModifierAttribute([this.value = true]);

  @override
  CustomWidgetModifierSpec resolve(MixData mix) {
    return CustomWidgetModifierSpec(value ?? true);
  }

  @override
  CustomModifierAttribute merge(CustomModifierAttribute? other) {
    return CustomModifierAttribute(other?.value ?? true);
  }

  @override
  get props => [value];
}

class WidgetWithTestableBuild extends StyledWidget {
  const WidgetWithTestableBuild(
    this.onBuild, {
    super.key,
    super.orderOfModifiers = const [],
  });

  final void Function(BuildContext context) onBuild;

  @override
  Widget build(BuildContext context) {
    return withMix(context, (_) {
      onBuild(context);

      return const SizedBox();
    });
  }
}

abstract class TestScalarAttribute<
    Self extends TestScalarAttribute<Self, Value>,
    Value> extends SpecAttribute<Value> {
  final Value value;
  const TestScalarAttribute(this.value);

  @override
  get props => [value];

  @override
  Self merge(Self? other) {
    return other ?? this as Self;
  }
}

class MixTokensTest {
  final space = const SpaceTokenUtil();
  final radius = const RadiusTokenUtil();
  final color = const ColorTokenUtil();
  final breakpoint = const BreakpointTokenUtil();
  final textStyle = const TextStyleTokenUtil();

  const MixTokensTest();
}

class RadiusTokenUtil {
  final small = const RadiusToken('mix.radius.small');
  final medium = const RadiusToken('mix.radius.medium');
  final large = const RadiusToken('mix.radius.large');
  const RadiusTokenUtil();
}

class SpaceTokenUtil {
  final large = const SpaceToken('mix.space.large');
  final medium = const SpaceToken('mix.space.medium');
  final small = const SpaceToken('mix.space.small');

  const SpaceTokenUtil();
}

class ColorTokenUtil {
  const ColorTokenUtil();
}

class TextStyleTokenUtil {
  const TextStyleTokenUtil();
}
