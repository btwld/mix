import 'package:demo/helpers/string.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum Theme {
  dark,
  light,
  system;
}

@widgetbook.UseCase(
  name: 'Radio Component',
  type: RxRadio,
)
Widget buildRadioUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: ListenableBuilder(
        listenable: _state,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: Theme.values
                .map(
                  (theme) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: RxRadio<Theme>(
                      value: theme,
                      enabled: context.knobs.boolean(
                        label: 'Enabled',
                        initialValue: true,
                      ),
                      label: theme.name.capitalize(),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    ),
  );
}

class _ThemeState extends ValueNotifier<Theme> {
  _ThemeState(super.value);

  void update(Theme value) {
    this.value = value;
    notifyListeners();
  }
}

_ThemeState _state = _ThemeState(Theme.dark);
