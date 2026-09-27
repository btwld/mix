import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(const WrapBoxExampleApp());

/// Runnable gallery for Mix's public WrapBox API.
class WrapBoxExampleApp extends StatelessWidget {
  const WrapBoxExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mix WrapBox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B5BD6)),
        scaffoldBackgroundColor: const Color(0xFFF5F5FA),
        useMaterial3: true,
      ),
      home: const WrapBoxExampleScreen(),
    );
  }
}

enum CloudWidth {
  narrow(220, 'Narrow'),
  wide(420, 'Wide');

  const CloudWidth(this.pixels, this.label);

  final double pixels;
  final String label;
}

/// Interactive controls plus fixed directionality examples.
class WrapBoxExampleScreen extends StatefulWidget {
  const WrapBoxExampleScreen({super.key});

  @override
  State<WrapBoxExampleScreen> createState() => _WrapBoxExampleScreenState();
}

class _WrapBoxExampleScreenState extends State<WrapBoxExampleScreen> {
  CloudWidth _width = CloudWidth.narrow;
  Axis _axis = Axis.horizontal;
  TextDirection _textDirection = TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mix WrapBox')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Interactive tag cloud',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'The constrained width makes Flutter Wrap create multiple runs.',
          ),
          const SizedBox(height: 16),
          _Controls(
            width: _width,
            axis: _axis,
            textDirection: _textDirection,
            onWidthChanged: (value) => setState(() => _width = value),
            onAxisChanged: (value) => setState(() => _axis = value),
            onTextDirectionChanged: (value) {
              setState(() => _textDirection = value);
            },
          ),
          const SizedBox(height: 20),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: WrapCloudPreview(
              width: _width.pixels,
              axis: _axis,
              textDirection: _textDirection,
              cloudKey: const Key('tag-cloud'),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Direction matrix',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const _DirectionMatrix(),
          const SizedBox(height: 32),
          Text(
            'Advanced escape hatch',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const _AdvancedFlowExample(),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.width,
    required this.axis,
    required this.textDirection,
    required this.onWidthChanged,
    required this.onAxisChanged,
    required this.onTextDirectionChanged,
  });

  final CloudWidth width;
  final Axis axis;
  final TextDirection textDirection;
  final ValueChanged<CloudWidth> onWidthChanged;
  final ValueChanged<Axis> onAxisChanged;
  final ValueChanged<TextDirection> onTextDirectionChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SegmentedButton<CloudWidth>(
          key: const Key('width-control'),
          segments: [
            for (final value in CloudWidth.values)
              ButtonSegment(value: value, label: Text(value.label)),
          ],
          selected: {width},
          onSelectionChanged: (values) => onWidthChanged(values.single),
        ),
        SegmentedButton<Axis>(
          key: const Key('axis-control'),
          segments: const [
            ButtonSegment(value: Axis.horizontal, label: Text('Horizontal')),
            ButtonSegment(value: Axis.vertical, label: Text('Vertical')),
          ],
          selected: {axis},
          onSelectionChanged: (values) => onAxisChanged(values.single),
        ),
        SegmentedButton<TextDirection>(
          key: const Key('direction-control'),
          segments: const [
            ButtonSegment(value: TextDirection.ltr, label: Text('LTR')),
            ButtonSegment(value: TextDirection.rtl, label: Text('RTL')),
          ],
          selected: {textDirection},
          onSelectionChanged: (values) {
            onTextDirectionChanged(values.single);
          },
        ),
      ],
    );
  }
}

/// A deterministic constrained cloud built with flattened WrapBox styling.
class WrapCloudPreview extends StatelessWidget {
  const WrapCloudPreview({
    required this.width,
    this.axis = Axis.horizontal,
    this.textDirection = TextDirection.ltr,
    this.compact = false,
    this.cloudKey,
    this.boundaryKey,
    super.key,
  });

  final double width;
  final Axis axis;
  final TextDirection textDirection;
  final bool compact;
  final Key? cloudKey;
  final Key? boundaryKey;

  static const tags = [
    'Flutter',
    'Mix',
    'Tokens',
    'Variants',
    'Themes',
    'Motion',
    'Responsive',
    'Typed',
  ];

  @override
  Widget build(BuildContext context) {
    final height = axis == Axis.horizontal ? (compact ? 142.0 : 188.0) : 150.0;
    final style = WrapBoxStyler()
        .paddingAll(compact ? 10 : 16)
        .color(const Color(0xFFFFFFFF))
        .borderRounded(18)
        .clipBehavior(Clip.antiAlias)
        .direction(axis)
        .spacing(8)
        .runSpacing(10)
        .wrapAlignment(WrapAlignment.center)
        .runAlignment(WrapAlignment.center)
        .crossAxisAlignment(WrapCrossAlignment.center)
        .textDirection(textDirection);

    return RepaintBoundary(
      key: boundaryKey,
      child: SizedBox(
        width: width,
        height: height,
        child: WrapBox(
          key: cloudKey,
          style: style,
          children: [for (final tag in tags) _Tag(label: tag)],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .paddingX(10)
          .paddingY(6)
          .color(const Color(0xFFE8E8FF))
          .borderRounded(999),
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          color: Color(0xFF35358A),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DirectionMatrix extends StatelessWidget {
  const _DirectionMatrix();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: const [
        _DirectionSample(
          label: 'Horizontal · LTR',
          axis: Axis.horizontal,
          textDirection: TextDirection.ltr,
        ),
        _DirectionSample(
          label: 'Horizontal · RTL',
          axis: Axis.horizontal,
          textDirection: TextDirection.rtl,
        ),
        _DirectionSample(
          label: 'Vertical · LTR',
          axis: Axis.vertical,
          textDirection: TextDirection.ltr,
        ),
        _DirectionSample(
          label: 'Vertical · RTL',
          axis: Axis.vertical,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}

class _DirectionSample extends StatelessWidget {
  const _DirectionSample({
    required this.label,
    required this.axis,
    required this.textDirection,
  });

  final String label;
  final Axis axis;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        WrapCloudPreview(
          width: 220,
          axis: axis,
          textDirection: textDirection,
          compact: true,
        ),
      ],
    );
  }
}

class _AdvancedFlowExample extends StatelessWidget {
  const _AdvancedFlowExample();

  @override
  Widget build(BuildContext context) {
    final style = WrapBoxStyler()
        .paddingAll(12)
        .color(const Color(0xFF202033))
        .borderRounded(14)
        .flow(
          WrapStyler(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
          ),
        );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: WrapBox(
        style: style,
        children: const [
          _Tag(label: 'Nested'),
          _Tag(label: 'flow'),
          _Tag(label: 'escape hatch'),
        ],
      ),
    );
  }
}
