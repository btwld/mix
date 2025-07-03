import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/internal/build_context_ext.dart';

// extension BuildContextExt on BuildContext {
//   MixData? get mix => Mix.maybeOf(this);

//   /// MEDIA QUERY EXTENSION METHODS

//   /// Directionality of context.
//   TextDirection get directionality => Directionality.of(this);

//   /// Orientation of the device.
//   Orientation get orientation => MediaQuery.orientationOf(this);

//   /// Screen size.
//   Size get screenSize => MediaQuery.sizeOf(this);

//   // Theme Context Extensions.
//   Brightness get brightness => Theme.of(this).brightness;

//   /// Theme context helpers.
//   ThemeData get theme => Theme.of(this);

//   /// Theme color scheme.
//   ColorScheme get colorScheme => theme.colorScheme;

//   /// Theme text theme.
//   TextTheme get textTheme => theme.textTheme;

//   /// Mix Theme Data.
//   MixScopeData get mixScope => MixScope.of(this);

//   /// Check if brightness is Brightness.dark.
//   bool get isDarkMode => brightness == Brightness.dark;

//   /// Is device in landscape mode.
//   bool get isLandscape => orientation == Orientation.landscape;

//   /// Is device in portrait mode.
//   bool get isPortrait => orientation == Orientation.portrait;
// }
// ;

void main() {
  testWidgets('Mock BuildContext extension methods', (tester) async {
    tester.view.physicalSize = const Size(400.0, 600.0);
    final theme = ThemeData.light(useMaterial3: true);
    await tester.pumpWidget(
      MaterialApp(
        home: MixScope(
          data: const MixScopeData.empty(),
          child: Builder(
            builder: (context) {
              return Container();
            },
          ),
        ),
        theme: theme,
      ),
    );

    final context = tester.element(find.byType(Container));

    final mix = context.mix;
    expect(mix, isNull);
    expect(context.directionality, Directionality.of(context));
    expect(context.orientation, MediaQuery.of(context).orientation);
    // expect(context.screenSize, const Size(400.0, 600.0));
    expect(context.brightness, Theme.of(context).brightness);
    expect(context.theme, Theme.of(context));
    expect(context.colorScheme, Theme.of(context).colorScheme);
    expect(context.textTheme, Theme.of(context).textTheme);
    expect(context.mixScope, const MixScopeData.empty());
    expect(context.isDarkMode, Theme.of(context).brightness == Brightness.dark);
    expect(
      context.isLandscape,
      MediaQuery.of(context).orientation == Orientation.landscape,
    );
    expect(
      context.isPortrait,
      MediaQuery.of(context).orientation == Orientation.portrait,
    );

    // addTearDown(tester.view.resetPhysicalSize);
  });
}
