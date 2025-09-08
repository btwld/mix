import 'package:flutter/material.dart';

import 'components/custom_scaffold.dart';
import 'components/chip_button.dart';
import 'api/animation/implicit.curved.hover.dart' as hover_scale;
import 'api/animation/implicit.curved.scale.dart' as auto_scale;
import 'api/animation/phase.compress.dart' as tap_phase;
import 'api/animation/keyframe.switch.dart' as animated_switch;
import 'api/animation/implicit.spring.translate.dart' as spring_anim;
import 'api/context_variants/disabled.dart' as disabled;
import 'api/context_variants/focused.dart' as focused;
import 'api/context_variants/hovered.dart' as hovered;
import 'api/context_variants/on_dark_light.dart' as dark_light;
import 'api/context_variants/pressed.dart' as pressed;
import 'api/context_variants/selected.dart' as selected;
import 'api/context_variants/selected_toggle.dart' as selected_toggle;
import 'api/context_variants/responsive_size.dart' as responsive_size;
// Animation examples have different class names, will be added separately
import 'api/design_tokens/theme_tokens.dart' as theme_tokens;
// Import all example widgets
import 'api/widgets/box/simple_box.dart' as simple_box;
import 'api/widgets/box/gradient_box.dart' as gradient_box;
import 'api/widgets/hbox/icon_label_chip.dart' as icon_label_chip;
import 'api/widgets/icon/styled_icon.dart' as styled_icon;
import 'api/widgets/text/styled_text.dart' as styled_text;
import 'api/widgets/vbox/card_layout.dart' as card_layout;
import 'api/widgets/zbox/layered_boxes.dart' as layered_boxes;
// Text examples
import 'api/text/text_directives.dart' as text_directives;
// Gradient examples
import 'api/gradients/gradient_linear.dart' as gradient_linear;
import 'api/gradients/gradient_radial.dart' as gradient_radial;
import 'api/gradients/gradient_sweep.dart' as gradient_sweep;

void main() {
  runApp(const MixExampleApp());
}

class MixExampleApp extends StatelessWidget {
  const MixExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      pageRouteBuilder:
          <T extends Object?>(RouteSettings settings, WidgetBuilder builder) =>
              PageRouteBuilder<T>(
                settings: settings,
                pageBuilder: (context, animation, _) => builder(context),
              ),
      home: const ExampleNavigator(),
      title: 'Mix Examples',
      color: const Color(0xFF2196F3),
      debugShowCheckedModeBanner: false,
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
      widget: const simple_box.Example(),
    ),
    ExampleItem(
      title: 'Box - Gradient',
      description: 'Box with gradient and shadow',
      category: 'Widgets',
      widget: const gradient_box.Example(),
    ),
    ExampleItem(
      title: 'HBox - Horizontal Layout',
      description: 'Horizontal flex container with icon and text',
      category: 'Widgets',
      widget: const icon_label_chip.Example(),
    ),
    ExampleItem(
      title: 'VBox - Vertical Layout',
      description: 'Vertical flex container with styled elements',
      category: 'Widgets',
      widget: const card_layout.Example(),
    ),
    ExampleItem(
      title: 'ZBox - Stack Layout',
      description: 'Stacked boxes with different alignments',
      category: 'Widgets',
      widget: const layered_boxes.Example(),
    ),
    ExampleItem(
      title: 'Icon - Styled',
      description: 'Styled icon with custom size and color',
      category: 'Widgets',
      widget: const styled_icon.Example(),
    ),
    ExampleItem(
      title: 'Text - Styled',
      description: 'Styled text with custom typography',
      category: 'Widgets',
      widget: const styled_text.Example(),
    ),
    ExampleItem(
      title: 'Text - Directives',
      description:
          'Text transformations: uppercase, lowercase, capitalize, etc.',
      category: 'Widgets',
      widget: const text_directives.Example(),
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
      widget: const dark_light.Example(),
    ),
    ExampleItem(
      title: 'Selected Toggle',
      description: 'Beautiful toggle button with selected state',
      category: 'Context Variants',
      widget: const selected_toggle.Example(),
    ),
    ExampleItem(
      title: 'Responsive Size',
      description: 'Dynamic sizing based on screen width',
      category: 'Context Variants',
      widget: const responsive_size.Example(),
    ),

    // Gradients
    ExampleItem(
      title: 'Linear Gradient',
      description: 'Beautiful purple-to-pink gradient with shadow',
      category: 'Gradients',
      widget: const gradient_linear.Example(),
    ),
    ExampleItem(
      title: 'Radial Gradient',
      description: 'Orange radial gradient with focal points',
      category: 'Gradients',
      widget: const gradient_radial.Example(),
    ),
    ExampleItem(
      title: 'Sweep Gradient',
      description: 'Colorful sweep gradient creating rainbow effect',
      category: 'Gradients',
      widget: const gradient_sweep.Example(),
    ),

    // Design Tokens
    ExampleItem(
      title: 'Design Tokens',
      description: 'Using design tokens for consistent styling',
      category: 'Design System',
      widget: const theme_tokens.Example(),
    ),
    // Animations
    ExampleItem(
      title: 'Hover Scale Animation',
      description: 'Box that scales up smoothly when hovered',
      category: 'Animations',
      widget: const hover_scale.Example(),
    ),
    ExampleItem(
      title: 'Auto Scale Animation',
      description: 'Box that automatically scales on load',
      category: 'Animations',
      widget: const auto_scale.Example(),
    ),
    ExampleItem(
      title: 'Tap Phase Animation',
      description: 'Multi-phase animation triggered by tap',
      category: 'Animations',
      widget: const tap_phase.BlockAnimation(),
    ),
    ExampleItem(
      title: 'Animated Switch',
      description: 'Toggle switch with phase-based animation',
      category: 'Animations',
      widget: const animated_switch.SwitchAnimation(),
    ),
    ExampleItem(
      title: 'Spring Animation',
      description: 'Bouncy spring physics animation',
      category: 'Animations',
      widget: const spring_anim.Example(),
    ),
  ];

  Widget _buildExampleCard(ExampleItem example) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Text(
            example.description,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Expanded(child: Center(child: example.widget)),
        ],
      ),
    );
  }

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
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final example = filteredExamples[index];

                return _buildExampleCard(example);
              },
              itemCount: filteredExamples.length,
            ),
          ),
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
