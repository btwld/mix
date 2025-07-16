import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

// Define theme color tokens
const _surface = MixToken<Color>('surface');
const _onSurface = MixToken<Color>('onSurface');

// Light theme
final _lightTheme = MixScopeData.static(
  tokens: {
    _surface: const Color(0xFF000000),
    _onSurface: const Color(0xFFFFFFFF),
  },
);

// Dark theme
final _darkTheme = MixScopeData.static(
  tokens: {
    _surface: const Color(0xFFFFFFFF),
    _onSurface: const Color(0xFF000000),
  },
);

// Widget wrapper that allows toggling between themes
class _ThemeToggleWrapper extends StatefulWidget {
  const _ThemeToggleWrapper({required this.child});

  final Widget child;

  @override
  State<_ThemeToggleWrapper> createState() => _ThemeToggleWrapperState();
}

class _ThemeToggleWrapperState extends State<_ThemeToggleWrapper> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MixScope(
      data: isDark ? _darkTheme : _lightTheme,
      child: widget.child,
    );
  }
}

// Sample widget that uses theme colors
class _ThemedBox extends StatelessWidget {
  const _ThemedBox();

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style($box.color.token(_surface)),
      child: StyledText('test', style: Style($text.color.token(_onSurface))),
    );
  }
}

void main() {
  testWidgets('should update colors when theme changes', (tester) async {
    await tester.pumpMaterialApp(
      const _ThemeToggleWrapper(child: _ThemedBox()),
    );

    final themeToggle = tester.state<_ThemeToggleWrapperState>(
      find.byType(_ThemeToggleWrapper),
    );

    Text text = tester.widget<Text>(find.byType(Text));
    expect(themeToggle.isDark, isFalse);
    expect(text.style?.color, const Color(0xFFFFFFFF));

    themeToggle.toggleTheme();
    await tester.pump();

    text = tester.widget<Text>(find.byType(Text));
    expect(themeToggle.isDark, isTrue);
    expect(text.style?.color, const Color(0xFF000000));
  });
}
