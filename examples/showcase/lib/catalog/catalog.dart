import 'package:flutter/widgets.dart';

import '../snacks/catalog.dart';
import '../examples/charts/bar.dart';
import '../examples/charts/line.dart';
import '../examples/charts/pie.dart';
import '../examples/core/box.dart';
import '../examples/core/image.dart';
import '../examples/core/pressable.dart';
import '../examples/core/text.dart';
import '../examples/layouts/flex.dart';
import '../examples/layouts/grid.dart';
import '../examples/layouts/wrap.dart';

enum ExampleCategory {
  core('Core widgets', 'The building blocks for expressive interfaces.'),
  layouts('Layouts', 'Responsive arrangements built with Mix.'),
  snacks('Snacks', 'Try an interaction, then read the Mix code beside it.'),
  charts('Charts', 'Visualize data with mix_chart.');

  const ExampleCategory(this.title, this.description);
  final String title;
  final String description;
}

class CatalogExample {
  const CatalogExample({
    required this.title,
    required this.description,
    required this.category,
    required this.source,
    required this.preview,
    this.previewImage,
    this.snack,
  });

  final String title;
  final String description;
  final ExampleCategory category;
  final String source;
  final WidgetBuilder preview;
  final String? previewImage;
  final SnackDemo? snack;

  /// Curated static preview for the landing page.
  String get previewAsset =>
      previewImage ??
      'assets/previews/${category.name}_${title.toLowerCase().replaceAll(' ', '_')}.png';
}

final examples = <CatalogExample>[
  CatalogExample(
    title: 'Box',
    description: 'A flexible container for layout and styling.',
    category: .core,
    source: 'lib/examples/core/box.dart',
    preview: (_) => const BoxExample(),
  ),
  CatalogExample(
    title: 'Text',
    description: 'Display and style text with ease.',
    category: .core,
    source: 'lib/examples/core/text.dart',
    preview: (_) => const TextExample(),
  ),
  CatalogExample(
    title: 'Image',
    description: 'Display images with flexible sizing.',
    category: .core,
    source: 'lib/examples/core/image.dart',
    previewImage: 'assets/previews/core_image.jpg',
    preview: (_) => const ImageExample(),
  ),
  CatalogExample(
    title: 'Pressable',
    description: 'Respond to taps, clicks, and gestures.',
    category: .core,
    source: 'lib/examples/core/pressable.dart',
    preview: (_) => const PressableExample(),
  ),
  CatalogExample(
    title: 'FlexBox',
    description: 'Arrange children in a single direction.',
    category: .layouts,
    source: 'lib/examples/layouts/flex.dart',
    preview: (_) => const FlexExample(),
  ),
  CatalogExample(
    title: 'WrapBox',
    description: 'Automatically wrap children to new lines.',
    category: .layouts,
    source: 'lib/examples/layouts/wrap.dart',
    preview: (_) => const WrapExample(),
  ),
  CatalogExample(
    title: 'GridBox',
    description: 'Two-dimensional responsive layouts.',
    category: .layouts,
    source: 'lib/examples/layouts/grid.dart',
    preview: (_) => const GridExample(),
  ),
  for (final demo in snackDemos)
    CatalogExample(
      title: demo.title,
      description: demo.caption,
      category: .snacks,
      source: demo.sourceAsset,
      preview: demo.builder,
      snack: demo,
    ),
  CatalogExample(
    title: 'Line',
    description: 'Simple, beautiful line charts.',
    category: .charts,
    source: 'lib/examples/charts/line.dart',
    preview: (_) => const LineExample(),
  ),
  CatalogExample(
    title: 'Bar',
    description: 'Clean and flexible bar charts.',
    category: .charts,
    source: 'lib/examples/charts/bar.dart',
    preview: (_) => const BarExample(),
  ),
  CatalogExample(
    title: 'Pie',
    description: 'Visualize proportions with pie charts.',
    category: .charts,
    source: 'lib/examples/charts/pie.dart',
    preview: (_) => const PieExample(),
  ),
];

List<CatalogExample> examplesFor(ExampleCategory category) => [
  for (final example in examples)
    if (example.category == category) example,
];
