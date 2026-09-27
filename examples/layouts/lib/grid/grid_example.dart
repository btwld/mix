import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

final gridExampleTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6558D3)),
  scaffoldBackgroundColor: const Color(0xFFF4F5FA),
  useMaterial3: true,
);

/// Runnable gallery for Mix's public GridBox API.
class GridBoxExampleApp extends StatelessWidget {
  const GridBoxExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mix GridBox',
      theme: gridExampleTheme,
      home: const GridBoxExampleScreen(),
    );
  }
}

enum GridExampleKind {
  dashboard('Dashboard', 'Metrics and asymmetric reporting panels'),
  catalog('Card catalog', 'A responsive product-card collection'),
  gallery('Media gallery', 'Dense visual tiles with repeated rows'),
  animation('Animation', 'State-driven track, row, and gap interpolation');

  const GridExampleKind(this.label, this.description);

  final String label;
  final String description;
}

enum GridExampleWidth {
  compact(390, 'Compact'),
  medium(760, 'Medium'),
  wide(1120, 'Wide');

  const GridExampleWidth(this.pixels, this.label);

  final double pixels;
  final String label;
}

/// Interactive selector for the real-world Grid examples.
class GridBoxExampleScreen extends StatefulWidget {
  const GridBoxExampleScreen({super.key});

  @override
  State<GridBoxExampleScreen> createState() => _GridBoxExampleScreenState();
}

class _GridBoxExampleScreenState extends State<GridBoxExampleScreen> {
  GridExampleKind _kind = GridExampleKind.dashboard;
  GridExampleWidth _width = GridExampleWidth.wide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mix GridBox gallery')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Local, responsive Grid layouts',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Change the offered width to exercise local constraints, or open '
            'Animation and press Animate to 2:1 to inspect compatible track '
            'interpolation.',
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SegmentedButton<GridExampleKind>(
                key: const Key('grid-example-kind'),
                segments: [
                  for (final value in GridExampleKind.values)
                    ButtonSegment(value: value, label: Text(value.label)),
                ],
                selected: {_kind},
                onSelectionChanged: (values) {
                  setState(() => _kind = values.single);
                },
              ),
              SegmentedButton<GridExampleWidth>(
                key: const Key('grid-example-width'),
                segments: [
                  for (final value in GridExampleWidth.values)
                    ButtonSegment(value: value, label: Text(value.label)),
                ],
                selected: {_width},
                onSelectionChanged: (values) {
                  setState(() => _width = values.single);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: GridShowcase(kind: _kind, width: _width.pixels),
          ),
        ],
      ),
    );
  }
}

/// Deterministic surface shared by the runnable gallery and golden tests.
class GridShowcase extends StatelessWidget {
  const GridShowcase({
    required this.kind,
    required this.width,
    this.boundaryKey,
    super.key,
  });

  final GridExampleKind kind;
  final double width;
  final Key? boundaryKey;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: boundaryKey,
      child: SizedBox(
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8FC),
            border: Border.all(color: const Color(0xFFE3E4ED)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ShowcaseHeading(kind: kind),
                const SizedBox(height: 20),
                switch (kind) {
                  GridExampleKind.dashboard => const DashboardGridPreview(),
                  GridExampleKind.catalog => const CatalogGridPreview(),
                  GridExampleKind.gallery => const GalleryGridPreview(),
                  GridExampleKind.animation => const AnimatedGridPreview(),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShowcaseHeading extends StatelessWidget {
  const _ShowcaseHeading({required this.kind});

  final GridExampleKind kind;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFE9E6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(_iconFor(kind), color: const Color(0xFF5748BE)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kind.label,
                style: const TextStyle(
                  color: Color(0xFF20212D),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                kind.description,
                style: const TextStyle(color: Color(0xFF707284), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _iconFor(GridExampleKind value) => switch (value) {
    GridExampleKind.dashboard => Icons.dashboard_rounded,
    GridExampleKind.catalog => Icons.shopping_bag_rounded,
    GridExampleKind.gallery => Icons.photo_library_rounded,
    GridExampleKind.animation => Icons.animation_rounded,
  };
}

/// Dashboard composition: a 4→2→1 metric grid and a 2→1 panel grid.
class DashboardGridPreview extends StatelessWidget {
  const DashboardGridPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final GridBoxStyler metrics = .equalColumns(4)
        .gap(14)
        .autoRows(.fixed(116))
        .onConstraints(.maxWidth(900), .equalColumns(2).gap(12))
        .onConstraints(
          .maxWidth(520),
          .equalColumns(1).gap(10).autoRows(.fixed(104)),
        );
    final GridBoxStyler panels = .columns([.fr(2), .fr(1)])
        .gap(14)
        .autoRows(.fixed(230))
        .onConstraints(
          .maxWidth(720),
          .columns([.fr(1)]).autoRows(.fixed(210)),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridBox(
          key: const Key('dashboard-metrics-grid'),
          style: metrics,
          children: const [
            _MetricCard(
              label: 'Revenue',
              value: r'$84.2k',
              change: '+12.8%',
              color: Color(0xFF6558D3),
            ),
            _MetricCard(
              label: 'Orders',
              value: '1,429',
              change: '+8.1%',
              color: Color(0xFF198A72),
            ),
            _MetricCard(
              label: 'Conversion',
              value: '4.86%',
              change: '+0.7%',
              color: Color(0xFFE07835),
            ),
            _MetricCard(
              label: 'Active users',
              value: '8,702',
              change: '+16.4%',
              color: Color(0xFF3E79C5),
            ),
          ],
        ),
        const SizedBox(height: 18),
        GridBox(
          key: const Key('dashboard-panels-grid'),
          style: panels,
          children: const [_RevenuePanel(), _TrafficPanel()],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.change,
    required this.color,
  });

  final String label;
  final String value;
  final String change;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Color(0xFF77798A))),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF20212D),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '$change this month',
            style: const TextStyle(
              color: Color(0xFF198A72),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenuePanel extends StatelessWidget {
  const _RevenuePanel();

  static const heights = [42.0, 66.0, 55.0, 94.0, 72.0, 110.0, 86.0];

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue trend',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          const Text(
            'Last seven periods',
            style: TextStyle(color: Color(0xFF77798A), fontSize: 12),
          ),
          const Spacer(),
          SizedBox(
            height: 118,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final height in heights)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        height: height,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6558D3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrafficPanel extends StatelessWidget {
  const _TrafficPanel();

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Traffic sources',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          const _TrafficRow('Organic', 0.72, Color(0xFF6558D3)),
          const SizedBox(height: 14),
          const _TrafficRow('Social', 0.48, Color(0xFF3E79C5)),
          const SizedBox(height: 14),
          const _TrafficRow('Referral', 0.31, Color(0xFFE07835)),
        ],
      ),
    );
  }
}

class _TrafficRow extends StatelessWidget {
  const _TrafficRow(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text('${(value * 100).round()}%')],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            color: color,
            backgroundColor: const Color(0xFFE9EAF1),
          ),
        ),
      ],
    );
  }
}

/// Product-card collection: 3→2→1 columns under local constraints.
class CatalogGridPreview extends StatelessWidget {
  const CatalogGridPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final GridBoxStyler style = .equalColumns(3)
        .gap(16)
        .onConstraints(.maxWidth(760), .equalColumns(2).gap(12))
        .onConstraints(.maxWidth(520), .equalColumns(1).gap(10));

    return GridBox(
      key: const Key('catalog-grid'),
      style: style,
      children: const [
        _ProductCard(
          key: Key('catalog-card-0'),
          'Canvas tote',
          r'$48',
          'A roomy everyday bag.',
          Icons.shopping_bag_rounded,
          Color(0xFFE9E6FF),
        ),
        _ProductCard(
          key: Key('catalog-card-1'),
          'Desk lamp',
          r'$72',
          'Adjustable arm and a warm-dim LED. Built for late editing sessions when the rest of the room has gone dark.',
          Icons.light_rounded,
          Color(0xFFFFE9D8),
        ),
        _ProductCard(
          key: Key('catalog-card-2'),
          'Travel mug',
          r'$32',
          'Keeps coffee hot through a standup.',
          Icons.coffee_rounded,
          Color(0xFFDDF4EE),
        ),
        _ProductCard(
          key: Key('catalog-card-3'),
          'Studio clock',
          r'$64',
          'Quiet sweep, high-contrast face.',
          Icons.schedule_rounded,
          Color(0xFFDDEBFA),
        ),
        _ProductCard(
          key: Key('catalog-card-4'),
          'Wool throw',
          r'$96',
          'Heavyweight merino for the couch.',
          Icons.bed_rounded,
          Color(0xFFF6E2EB),
        ),
        _ProductCard(
          key: Key('catalog-card-5'),
          'Plant stand',
          r'$58',
          'Three-tier oak riser.',
          Icons.eco_rounded,
          Color(0xFFE4F2D8),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard(
    this.name,
    this.price,
    this.blurb,
    this.icon,
    this.tint, {
    super.key,
  });

  final String name;
  final String price;
  final String blurb;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF3C3D4A)),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            blurb,
            style: const TextStyle(color: Color(0xFF77798A), fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF252633),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Visual library: 4→3→2 columns with repeated fixed rows.
class GalleryGridPreview extends StatelessWidget {
  const GalleryGridPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final GridBoxStyler style = .equalColumns(4)
        .gap(12)
        .autoRows(.fixed(160))
        .clipBehavior(.hardEdge)
        .onConstraints(.maxWidth(920), .equalColumns(3))
        .onConstraints(.maxWidth(620), .equalColumns(2).autoRows(.fixed(142)));

    return GridBox(
      key: const Key('gallery-grid'),
      style: style,
      children: const [
        _GalleryTile(
          'Coastline',
          Icons.waves_rounded,
          Color(0xFF476C9B),
          Color(0xFF8FC6D8),
        ),
        _GalleryTile(
          'Desert',
          Icons.wb_sunny_rounded,
          Color(0xFFD27A3D),
          Color(0xFFF5C36B),
        ),
        _GalleryTile(
          'Forest',
          Icons.forest_rounded,
          Color(0xFF2E6B57),
          Color(0xFF83B98A),
        ),
        _GalleryTile(
          'Night',
          Icons.nightlight_round,
          Color(0xFF373763),
          Color(0xFF7D6BA8),
        ),
        _GalleryTile(
          'Studio',
          Icons.camera_alt_rounded,
          Color(0xFF8C4C66),
          Color(0xFFD99AB1),
        ),
        _GalleryTile(
          'Transit',
          Icons.train_rounded,
          Color(0xFF485A72),
          Color(0xFF91A7BD),
        ),
        _GalleryTile(
          'Market',
          Icons.storefront_rounded,
          Color(0xFF9B6537),
          Color(0xFFE3B270),
        ),
        _GalleryTile(
          'Garden',
          Icons.local_florist_rounded,
          Color(0xFF55773A),
          Color(0xFFA9C979),
        ),
      ],
    );
  }
}

/// Interactive implicit animation with stable two-column track topology.
class AnimatedGridPreview extends StatefulWidget {
  const AnimatedGridPreview({super.key});

  @override
  State<AnimatedGridPreview> createState() => _AnimatedGridPreviewState();
}

class _AnimatedGridPreviewState extends State<AnimatedGridPreview> {
  // Deliberately slower than a typical product transition so each changing
  // Grid dimension is easy to inspect in this runnable API example.
  static const _duration = Duration(milliseconds: 1200);

  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final GridBoxStyler style = .columns([.fr(_focused ? 2 : 1), .fr(1)])
        .autoRows(.fixed(_focused ? 148 : 112))
        .columnGap(_focused ? 20 : 12)
        .rowGap(_focused ? 20 : 12)
        .animate(.easeInOut(_duration));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _focused ? 'Focused allocation' : 'Balanced allocation',
                    key: const Key('animation-state-label'),
                    style: const TextStyle(
                      color: Color(0xFF20212D),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _focused
                        ? 'The leading track receives two shares.'
                        : 'Both tracks receive one share.',
                    style: const TextStyle(
                      color: Color(0xFF707284),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.tonalIcon(
              key: const Key('animation-toggle'),
              onPressed: () => setState(() => _focused = !_focused),
              icon: Icon(
                _focused
                    ? Icons.balance_rounded
                    : Icons.center_focus_strong_rounded,
              ),
              label: Text(_focused ? 'Animate to 1:1' : 'Animate to 2:1'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridBox(
          key: const Key('animated-grid'),
          style: style,
          children: const [
            _AnimatedMetricCard(
              key: Key('animation-card-reach'),
              label: 'Reach',
              value: '42k',
              icon: Icons.campaign_rounded,
              tint: Color(0xFFE9E6FF),
              color: Color(0xFF6558D3),
            ),
            _AnimatedMetricCard(
              key: Key('animation-card-spend'),
              label: 'Spend',
              value: r'$18k',
              icon: Icons.payments_rounded,
              tint: Color(0xFFFFE9D8),
              color: Color(0xFFE07835),
            ),
            _AnimatedMetricCard(
              key: Key('animation-card-leads'),
              label: 'Leads',
              value: '1.2k',
              icon: Icons.group_add_rounded,
              tint: Color(0xFFDDF4EE),
              color: Color(0xFF198A72),
            ),
            _AnimatedMetricCard(
              key: Key('animation-card-roi'),
              label: 'ROI',
              value: '3.8x',
              icon: Icons.trending_up_rounded,
              tint: Color(0xFFDDEBFA),
              color: Color(0xFF3E79C5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'This deliberately visible 1.2-second demo keeps the track count '
          'and kinds unchanged, so Mix interpolates the fraction weights, '
          'repeated row height, and gaps without an AnimationController.',
          style: TextStyle(color: Color(0xFF707284), fontSize: 12),
        ),
      ],
    );
  }
}

class _AnimatedMetricCard extends StatelessWidget {
  const _AnimatedMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
    required this.color,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E6EE)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(icon, color: color, size: 18),
              ),
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF20212D),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF77798A), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile(this.label, this.icon, this.start, this.end);

  final String label;
  final IconData icon;
  final Color start;
  final Color end;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [start, end],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              'Editorial collection',
              style: TextStyle(color: Color(0xD9FFFFFF), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E6EE)),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F252633),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
