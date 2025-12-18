import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

import 'card_alert_preview.dart';

void main() {
  runApp(const TailwindParityApp());
}

/// Parses URL query parameters for screenshot mode (web only).
/// Usage: ?screenshot=true&width=480&example=card-alert
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

  /// Returns the example to display: 'dashboard' (default) or 'card-alert'.
  static String get example {
    if (!kIsWeb) return 'dashboard';
    final params = Uri.base.queryParameters;
    return params['example'] ?? 'dashboard';
  }

}

class TailwindParityApp extends StatelessWidget {
  const TailwindParityApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Screenshot mode: render clean preview without UI chrome
    if (ScreenshotConfig.isScreenshotMode) {
      final width = ScreenshotConfig.width;
      final example = ScreenshotConfig.example;

      // Card alert example - use slate-900 background to match gradient edge
      if (example == 'card-alert') {
        const slate900 = Color(0xFF0F172A);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: slate900,
            canvasColor: slate900,
          ),
          home: Material(
            color: slate900,
            child: SizedBox(
              width: width,
              child: const CardAlertPreview(),
            ),
          ),
        );
      }

      // Default dashboard example
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          body: SingleChildScrollView(
            child: TailwindParityPreview(width: width, scrollable: false),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'mix_tailwinds vs Tailwind CSS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const TailwindParityScreen(),
    );
  }
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview width: ${_previewWidth.toStringAsFixed(0)} px',
                    style: Theme.of(context).textTheme.titleMedium,
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
              child: Center(child: TailwindParityPreview(width: _previewWidth)),
            ),
          ],
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
            'mix_tailwinds parity samples',
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
    return Div(
      classNames: 'flex flex-col gap-6 w-full',
      children: const [_CampaignOverviewCard(), _TeamActivityCard()],
    );
  }
}

class _CampaignOverviewCard extends StatelessWidget {
  const _CampaignOverviewCard();

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames:
          'flex flex-col gap-5 rounded-2xl border border-gray-200 bg-white p-6 shadow-lg',
      children: [
        const P(
          text: 'Campaign Health',
          classNames: 'text-sm font-semibold uppercase text-blue-700',
        ),
        const H1(
          text: 'November brand push',
          classNames: 'text-3xl font-semibold text-gray-700',
        ),
        const P(
          text:
              'Live performance snapshot for paid, lifecycle, and organic channels.',
          classNames: 'text-base text-gray-500',
        ),
        Div(
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
          classNames: 'flex flex-col gap-3 md:flex-row',
          children: [
            Div(
              classNames:
                  'flex flex-1 items-center justify-center rounded-full bg-blue-600 px-4 py-3 text-base font-semibold text-white hover:bg-blue-700',
              child: const Span(text: 'View live dashboard'),
            ),
            Div(
              classNames:
                  'flex flex-1 items-center justify-center rounded-full border border-blue-600 px-4 py-3 text-base font-semibold text-blue-600 hover:bg-blue-50',
              child: const Span(text: 'Download CSV'),
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
      classNames: 'flex flex-1 flex-col gap-2 rounded-xl bg-blue-50 p-4',
      children: [
        P(
          text: label,
          classNames: 'text-sm font-semibold uppercase text-blue-700',
        ),
        P(text: value, classNames: 'text-2xl font-semibold text-gray-700'),
        P(text: change, classNames: 'text-sm text-blue-700'),
      ],
    );
  }
}

class _TeamActivityCard extends StatelessWidget {
  const _TeamActivityCard();

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames:
          'flex flex-col gap-5 rounded-2xl border border-gray-200 bg-white p-6 shadow-lg',
      children: [
        const P(
          text: 'Team activity',
          classNames: 'text-sm font-semibold uppercase text-blue-700',
        ),
        const H2(
          text: 'Channel owners',
          classNames: 'text-2xl font-semibold text-gray-700',
        ),
        const P(
          text: 'Latest updates from lifecycle, paid, and organic squads.',
          classNames: 'text-base text-gray-500',
        ),
        Div(
          classNames: 'flex flex-col',
          children: const [
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
          ],
        ),
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
      classNames: 'flex items-center justify-between gap-4 py-4 $borderClass',
      children: [
        Div(
          classNames: 'flex flex-1 items-center gap-4',
          children: [
            Div(
              classNames:
                  'flex h-12 w-12 items-center justify-center rounded-full bg-gray-100',
              child: Span(
                text: avatarLetter,
                classNames: 'text-lg font-semibold text-gray-700',
              ),
            ),
            Div(
              classNames: 'flex flex-1 flex-col gap-1',
              children: [
                P(
                  text: name,
                  classNames: 'text-base font-semibold text-gray-700',
                ),
                P(text: role, classNames: 'text-sm text-gray-500'),
                Div(
                  classNames: 'flex items-center gap-2',
                  children: [
                    Div(classNames: 'h-1 w-1 rounded-full $badgeColor'),
                    P(text: update, classNames: 'text-sm text-gray-500'),
                  ],
                ),
              ],
            ),
          ],
        ),
        P(text: timeago, classNames: 'text-sm text-gray-500'),
      ],
    );
  }
}
