import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

typedef ThemeMultiBrightness = ({RemixThemeData light, RemixThemeData dark});

final Map<String, ThemeMultiBrightness> themes = {
  'fortaleza': (
    light: RemixThemeData.baseLight(),
    dark: RemixThemeData.baseDark(),
  ),
  'base': (
    light: RemixThemeData.baseLight(),
    dark: RemixThemeData.baseDark(),
  ),
};

class ComponentTheme {
  static const fortaleza = 'fortaleza';
  static const base = 'base';
}

class ComponentThemeAddon extends WidgetbookAddon<String> {
  final String initialBrightness;

  ComponentThemeAddon({
    this.initialBrightness = ComponentTheme.fortaleza,
  }) : super(name: 'component theme');

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    String setting,
  ) {
    final theme = themes[setting];
    return RemixApp(
      debugShowCheckedModeBanner: false,
      darkTheme: theme!.dark,
      theme: theme.light,
      home: child,
    );
  }

  @override
  List<Field<String>> get fields {
    return [
      ListField<String>(
        name: 'brightness',
        initialValue: initialBrightness,
        values: [
          ComponentTheme.fortaleza,
          ComponentTheme.base,
        ],
      )
    ];
  }

  @override
  String valueFromQueryGroup(Map<String, String> group) {
    return valueOf<String>('brightness', group)!;
  }
}

class ComponentThemeAddonConfig extends AddonConfig {
  const ComponentThemeAddonConfig(String value)
      : super('component theme', 'component theme:$value');
}
