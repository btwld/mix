import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mix_winds/mix_winds.dart';

import 'advanced_parity_preview.dart';
import 'card_alert_preview.dart';
import 'complex_parity_preview.dart';
import 'flowbite_card_preview.dart';
import 'gradient_debug_preview.dart';
import 'showcase/showcase_embedded_example.dart';
import 'showcase/showcase_multi_view_app.dart';

const _screenshotParityFontFamily = 'TwParityRoboto';

void _noop() {}

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  // Ensure debug paint overlays are disabled for parity screenshots.
  debugPaintBaselinesEnabled = false;
  debugPaintSizeEnabled = false;
  debugPaintPointersEnabled = false;
  debugRepaintRainbowEnabled = false;

  // Embedded Flutter web runs without an implicit view. The JavaScript host
  // attaches one or more views after the engine starts and selects the example
  // for each view through initialData.
  if (kIsWeb && binding.platformDispatcher.implicitView == null) {
    runWidget(
      const ShowcaseMultiViewApp(viewBuilder: _buildShowcaseEmbeddedExample),
    );
    return;
  }

  runApp(const TailwindParityApp());
}

Widget _buildShowcaseEmbeddedExample(BuildContext context) {
  return const ShowcaseEmbeddedExample();
}

/// Parses URL query parameters for screenshot mode (web only).
/// Usage: ?screenshot=true&width=480&example=card-alert&gradient=css-angle-rect
class ScreenshotConfig {
  static bool get isScreenshotMode {
    if (!kIsWeb) return false;
    final params = Uri.base.queryParameters;
    return params['screenshot'] == 'true';
  }

  static double get width {
    if (!kIsWeb) return 480;
    final params = Uri.base.queryParameters;
    return double.tryParse(params['width'] ?? '') ?? 480;
  }

  /// Returns the example to display.
  ///
  /// Supported values:
  /// - `dashboard` (default)
  /// - `card-alert`
  /// - `complex-parity`
  /// - `flowbite-card`
  /// - `gradient-debug`
  /// - `advanced-parity`
  static String get example {
    if (!kIsWeb) return 'dashboard';
    final params = Uri.base.queryParameters;
    return params['example'] ?? 'dashboard';
  }

  /// Returns the isolated complex visual-parity case (`01` through `10`).
  static String get complexCase {
    if (!kIsWeb) return '01';
    return Uri.base.queryParameters['case'] ?? '01';
  }

  /// Returns the isolated advanced visual-parity example (`01` through `05`).
  static String get advancedExample {
    if (!kIsWeb) return '01';
    return Uri.base.queryParameters['sample'] ?? '01';
  }

  /// Returns gradient strategy for screenshot experiments.
  ///
  /// Accepted values:
  /// - css-angle-rect (default)
  /// - alignment
  /// - angle
  static TwGradientStrategy get gradientStrategy {
    if (!kIsWeb) return TwGradientStrategy.cssAngleRect;
    final params = Uri.base.queryParameters;
    final raw = params['gradient'];
    if (raw == 'angle') return TwGradientStrategy.angle;
    if (raw == 'css-angle-rect' || raw == 'cssAngleRect' || raw == 'adaptive') {
      return TwGradientStrategy.cssAngleRect;
    }
    if (raw == 'alignment') return TwGradientStrategy.alignment;
    return TwGradientStrategy.cssAngleRect;
  }
}

class TailwindParityApp extends StatelessWidget {
  const TailwindParityApp({super.key});

  @override
  Widget build(BuildContext context) {
    final twConfig = _twConfigForCurrentMode();

    // Screenshot mode: render clean preview without UI chrome
    if (ScreenshotConfig.isScreenshotMode) {
      final width = ScreenshotConfig.width;
      final example = ScreenshotConfig.example;

      if (example == 'complex-parity') {
        return _ScreenshotWidgetsApp(
          backgroundColor: const Color(0xFFF3F4F6),
          child: TwScope(
            config: twConfig,
            child: ComplexParityPreview(
              caseId: ScreenshotConfig.complexCase,
              width: width,
            ),
          ),
        );
      }

      if (example == 'gradient-debug') {
        return _ScreenshotWidgetsApp(
          backgroundColor: const Color(0xFFE2E8F0),
          child: TwScope(
            config: twConfig,
            child: SingleChildScrollView(
              child: GradientDebugPreview(width: width),
            ),
          ),
        );
      }

      if (example == 'advanced-parity') {
        const slate100 = Color(0xFFF1F5F9);
        return _ScreenshotWidgetsApp(
          backgroundColor: slate100,
          child: TwScope(
            config: twConfig,
            child: SingleChildScrollView(
              child: AdvancedParityPreview(
                exampleId: ScreenshotConfig.advancedExample,
              ),
            ),
          ),
        );
      }

      // Card alert example - use slate-900 background to match gradient edge
      if (example == 'card-alert') {
        const slate900 = Color(0xFF0F172A);
        return _ScreenshotWidgetsApp(
          backgroundColor: slate900,
          child: TwScope(config: twConfig, child: const CardAlertPreview()),
        );
      }

      if (example == 'flowbite-card') {
        const gray50 = Color(0xFFF9FAFB);
        return _ScreenshotWidgetsApp(
          backgroundColor: gray50,
          child: TwScope(
            config: flowbiteCardTwConfig(twConfig),
            child: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FlowbiteCardPreview(),
                ),
              ),
            ),
          ),
        );
      }

      // Default dashboard example
      return _ScreenshotWidgetsApp(
        backgroundColor: const Color(0xFFF3F4F6),
        child: TwScope(
          config: twConfig,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: TailwindParityPreview(width: width, scrollable: false),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'mix_winds vs Tailwind CSS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: TwScope(config: twConfig, child: const TailwindParityScreen()),
    );
  }
}

class _ScreenshotWidgetsApp extends StatelessWidget {
  const _ScreenshotWidgetsApp({
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: backgroundColor,
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
        );
      },
      home: ColoredBox(
        color: backgroundColor,
        child: SizedBox.expand(child: child),
      ),
    );
  }
}

TwConfig _twConfigForCurrentMode() {
  final baseConfig = TwConfig.standard().copyWith(
    gradientStrategy: ScreenshotConfig.gradientStrategy,
  );

  if (!ScreenshotConfig.isScreenshotMode) return baseConfig;

  return baseConfig.copyWith(
    textDefaults: baseConfig.textDefaults.copyWith(
      fontFamily: _screenshotParityFontFamily,
      fontFamilyFallback: const [],
    ),
  );
}

class TailwindParityScreen extends StatefulWidget {
  const TailwindParityScreen({super.key, this.initialWidth = 420});

  final double initialWidth;

  @override
  State<TailwindParityScreen> createState() => _TailwindParityScreenState();
}

class _TailwindParityScreenState extends State<TailwindParityScreen> {
  late double _previewWidth;

  @override
  void initState() {
    super.initState();
    _previewWidth = widget.initialWidth;
  }

  void _updateWidth(double value) {
    setState(() {
      _previewWidth = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final twConfig = TwConfigProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: TwScope(
        config: twConfig,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    p(
                      'text-base font-semibold text-gray-700',
                      'Preview width: ${_previewWidth.toStringAsFixed(0)} px',
                    ),
                    Slider(
                      min: 320,
                      max: 1040,
                      divisions: 9,
                      label: _previewWidth.toStringAsFixed(0),
                      value: _previewWidth,
                      onChanged: _updateWidth,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: TailwindParityPreview(width: _previewWidth),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'mix_winds parity samples',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
            'Use the slider to exercise the same responsive Tailwind tokens the web sample uses.',
          ),
        ],
      ),
    );
  }
}

class _ComparisonStack extends StatelessWidget {
  const _ComparisonStack();

  @override
  Widget build(BuildContext context) {
    return div('flex w-full flex-col gap-6', const [
      _CampaignOverviewCard(),
      _TeamActivityCard(),
    ]);
  }
}

class _CampaignOverviewCard extends StatelessWidget {
  const _CampaignOverviewCard();

  @override
  Widget build(BuildContext context) {
    return div(
      'flex flex-col gap-5 rounded-2xl border border-gray-200 bg-white p-6 shadow-lg',
      [
        p('text-sm font-semibold uppercase text-blue-700', 'Campaign Health'),
        h1('text-3xl font-semibold text-gray-700', 'November brand push'),
        p(
          'text-base text-gray-500',
          'Live performance snapshot for paid, lifecycle, and organic channels.',
        ),
        Div(
          key: const ValueKey('dashboard-metric-row'),
          classNames:
              'flex flex-col gap-4 border-t border-gray-200 pt-4 md:flex-row',
          children: const [
            _MetricTile(
              label: 'Spend',
              value: r'$241.18M',
              change: '+8.6% vs last week',
            ),
            _MetricTile(label: 'Return', value: '4.8x', change: '+0.4 uplift'),
            _MetricTile(
              label: 'CPA',
              value: r'$248.30',
              change: '-12% efficiency gain',
            ),
          ],
        ),
        Div(
          key: const ValueKey('dashboard-button-row'),
          classNames: 'flex flex-col gap-3 md:flex-row',
          children: [
            Button(
              key: const ValueKey('dashboard-view-button'),
              classNames:
                  'flex flex-1 items-center justify-center rounded-full bg-blue-600 px-4 py-3 text-base font-semibold text-white hover:bg-blue-700',
              onPressed: _noop,
              child: span('', 'View live dashboard'),
            ),
            Button(
              key: const ValueKey('dashboard-download-button'),
              classNames:
                  'flex flex-1 items-center justify-center rounded-full border border-blue-600 px-4 py-3 text-base font-semibold text-blue-600 hover:bg-blue-50',
              onPressed: _noop,
              child: span('', 'Download CSV'),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.change,
  });

  final String label;
  final String value;
  final String change;

  @override
  Widget build(BuildContext context) {
    return Div(
      key: ValueKey('dashboard-metric-$label'),
      classNames: 'flex flex-1 flex-col gap-2 rounded-xl bg-blue-50 p-4',
      children: [
        p('text-sm font-semibold uppercase text-blue-700', label),
        p('text-2xl font-semibold text-gray-700', value),
        p('text-sm text-blue-700', change),
      ],
    );
  }
}

class _TeamActivityCard extends StatelessWidget {
  const _TeamActivityCard();

  @override
  Widget build(BuildContext context) {
    return div(
      'flex flex-col gap-5 rounded-2xl border border-gray-200 bg-white p-6 shadow-lg',
      [
        p('text-sm font-semibold uppercase text-blue-700', 'Team activity'),
        h2('text-2xl font-semibold text-gray-700', 'Channel owners'),
        p(
          'text-base text-gray-500',
          'Latest updates from lifecycle, paid, and organic squads.',
        ),
        div('flex flex-col', const [
          _ActivityRow(
            name: 'Rita Carr',
            role: 'Lifecycle · Email',
            update: 'Shipped reactivation flow revamp',
            timeago: '12m ago',
            accentIndex: 0,
            showBorder: false,
          ),
          _ActivityRow(
            name: 'Jalen Ruiz',
            role: 'Paid · Social',
            update: 'Cut CPA by 14% on TikTok lookalikes',
            timeago: '1h ago',
            accentIndex: 1,
          ),
          _ActivityRow(
            name: 'Mara Singh',
            role: 'Organic · Web',
            update: 'Published performance teardown for Q4',
            timeago: '3h ago',
            accentIndex: 2,
          ),
        ]),
      ],
    );
  }
}

class TailwindParityPreview extends StatelessWidget {
  const TailwindParityPreview({
    super.key,
    required this.width,
    this.scrollable = true,
  });

  final double width;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(width: width, child: const _ComparisonStack());

    if (!scrollable) {
      return Align(
        alignment: Alignment.topCenter,
        heightFactor: 1,
        widthFactor: 1,
        child: content,
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: content,
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.name,
    required this.role,
    required this.update,
    required this.timeago,
    required this.accentIndex,
    this.showBorder = true,
  });

  final String name;
  final String role;
  final String update;
  final String timeago;
  final int accentIndex;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final borderClass = showBorder ? 'border-t border-gray-100' : '';
    final avatarLetter = name.isNotEmpty ? name[0] : '?';
    final badgeColor = switch (accentIndex % 3) {
      0 => 'bg-blue-100',
      1 => 'bg-blue-50',
      _ => 'bg-gray-200',
    };

    return Div(
      key: ValueKey('dashboard-activity-$name'),
      classNames: 'flex items-center justify-between gap-4 $borderClass py-4',
      children: [
        div('flex flex-1 items-center gap-4', [
          Div(
            classNames:
                'flex h-12 w-12 items-center justify-center rounded-full bg-gray-100',
            child: span('text-lg font-semibold text-gray-700', avatarLetter),
          ),
          div('flex flex-1 flex-col gap-1', [
            p('text-base font-semibold text-gray-700', name),
            p('text-sm text-gray-500', role),
            div('flex items-center gap-2', [
              div('h-1 w-1 rounded-full $badgeColor'),
              p('text-sm text-gray-500', update),
            ]),
          ]),
        ]),
        p('text-sm text-gray-500', timeago),
      ],
    );
  }
}
