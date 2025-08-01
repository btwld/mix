import 'package:flutter/material.dart';

import 'components/custom_scaffold.dart';
import 'components/chip_button.dart';
import 'api/animation/animation.curved.0.dart' as animCurved0;
import 'api/animation/animation.curved.1.dart' as animCurved1;
import 'api/animation/animation.phase.0.dart' as animPhase0;
import 'api/animation/animation.phase.1.dart' as animPhase1;
import 'api/animation/animation.spring.dart' as animSpring;
import 'api/context_variants/disabled.dart' as disabled;
import 'api/context_variants/focused.dart' as focused;
import 'api/context_variants/hovered.dart' as hovered;
import 'api/context_variants/on_dark_light.dart' as darkLight;
import 'api/context_variants/pressed.dart' as pressed;
import 'api/context_variants/selected.dart' as selected;
// Animation examples have different class names, will be added separately
import 'api/design_tokens/design_token.dart' as designToken;
// Import all example widgets
import 'api/widgets/box/box.0.dart' as box0;
import 'api/widgets/box/box.1.dart' as box1;
import 'api/widgets/hbox/hbox.0.dart' as hbox0;
import 'api/widgets/icon/icon.0.dart' as icon0;
import 'api/widgets/text/text.0.dart' as text0;
import 'api/widgets/vbox/vbox.0.dart' as vbox0;
import 'api/widgets/zbox/stack.0.dart' as zbox0;

void main() {
  runApp(const MixExampleApp());
}

class MixExampleApp extends StatelessWidget {
  const MixExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Mix Examples',
      color: const Color(0xFF2196F3),
      home: const ExampleNavigator(),
      pageRouteBuilder:
          <T extends Object?>(RouteSettings settings, WidgetBuilder builder) =>
              PageRouteBuilder<T>(
                settings: settings,
                pageBuilder: (context, animation, _) => builder(context),
              ),
    );
  }
}

class ExampleNavigator extends StatefulWidget {
  const ExampleNavigator({super.key});

  @override
  State<ExampleNavigator> createState() => _ExampleNavigatorState();
}

class _ExampleNavigatorState extends State<ExampleNavigator> {
  String _selectedCategory = 'All';

  final List<ExampleItem> _examples = [
    // Widget Examples
    ExampleItem(
      title: 'Box - Basic',
      description: 'Simple red box with rounded corners',
      category: 'Widgets',
      widget: const box0.Example(),
    ),
    ExampleItem(
      title: 'Box - Gradient',
      description: 'Box with gradient and shadow',
      category: 'Widgets',
      widget: const box1.Example(),
    ),
    ExampleItem(
      title: 'HBox - Horizontal Layout',
      description: 'Horizontal flex container with icon and text',
      category: 'Widgets',
      widget: const hbox0.Example(),
    ),
    ExampleItem(
      title: 'VBox - Vertical Layout',
      description: 'Vertical flex container with styled elements',
      category: 'Widgets',
      widget: const vbox0.Example(),
    ),
    ExampleItem(
      title: 'ZBox - Stack Layout',
      description: 'Stacked boxes with different alignments',
      category: 'Widgets',
      widget: const zbox0.Example(),
    ),
    ExampleItem(
      title: 'Icon - Styled',
      description: 'Styled icon with custom size and color',
      category: 'Widgets',
      widget: const icon0.Example(),
    ),
    ExampleItem(
      title: 'Text - Styled',
      description: 'Styled text with custom typography',
      category: 'Widgets',
      widget: const text0.Example(),
    ),

    // Context Variants
    ExampleItem(
      title: 'Hover State',
      description: 'Box that changes color on hover',
      category: 'Context Variants',
      widget: const hovered.Example(),
    ),
    ExampleItem(
      title: 'Press State',
      description: 'Box that changes color when pressed',
      category: 'Context Variants',
      widget: const pressed.Example(),
    ),
    ExampleItem(
      title: 'Focus State',
      description: 'Boxes that change color when focused',
      category: 'Context Variants',
      widget: const focused.Example(),
    ),
    ExampleItem(
      title: 'Selected State',
      description: 'Box that toggles selected state',
      category: 'Context Variants',
      widget: const selected.Example(),
    ),
    ExampleItem(
      title: 'Disabled State',
      description: 'Disabled box with grey color',
      category: 'Context Variants',
      widget: const disabled.Example(),
    ),
    ExampleItem(
      title: 'Dark/Light Theme',
      description: 'Boxes that adapt to theme changes',
      category: 'Context Variants',
      widget: const darkLight.Example(),
    ),

    // Design Tokens
    ExampleItem(
      title: 'Design Tokens',
      description: 'Using design tokens for consistent styling',
      category: 'Design System',
      widget: const designToken.Example(),
    ),
    // Animations
    ExampleItem(
      title: 'Animation - Curved 0',
      description: 'Box that animates on hover',
      category: 'Animations',
      widget: const animCurved0.Example(),
    ),
    ExampleItem(
      title: 'Animation - Curved 1',
      description: 'Box that animates on appear',
      category: 'Animations',
      widget: const animCurved1.Example(),
    ),
    ExampleItem(
      title: 'Animation - Phase 0',
      description: 'Box that animates on hover',
      category: 'Animations',
      widget: const animPhase0.BlockAnimation(),
    ),
    ExampleItem(
      title: 'Animation - Phase 1',
      description: 'Box that animates on appear',
      category: 'Animations',
      widget: const animPhase1.SwitchAnimation(),
    ),
    ExampleItem(
      title: 'Animation - Spring',
      description: 'Box that animates on appear',
      category: 'Animations',
      widget: const animSpring.Example(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ..._examples.map((e) => e.category).toSet()];
    final filteredExamples = _selectedCategory == 'All'
        ? _examples
        : _examples.where((e) => e.category == _selectedCategory).toList();

    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Mix Examples'),
      body: Column(
        children: [
          // Category filter buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: categories.map((category) {
                final isSelected = _selectedCategory == category;
                return FilterChipButton(
                  label: category,
                  selected: isSelected,
                  onPressed: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          // Examples grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: filteredExamples.length,
              itemBuilder: (context, index) {
                final example = filteredExamples[index];
                return _buildExampleCard(example);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(ExampleItem example) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            example.description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Expanded(child: Center(child: example.widget)),
        ],
      ),
    );
  }
}

class ExampleItem {
  final String title;
  final String description;
  final String category;
  final Widget widget;

  const ExampleItem({
    required this.title,
    required this.description,
    required this.category,
    required this.widget,
  });
}
