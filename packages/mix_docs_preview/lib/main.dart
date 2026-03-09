import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'components/chip_button.dart';
import 'components/custom_scaffold.dart';
import 'preview_registry.dart';
import 'multi_view_app.dart';

// Conditional import for web-specific APIs
import 'multi_view_stub.dart'
    if (dart.library.js_interop) 'multi_view_web.dart'
    as multi_view;

void main() {
  // On web with multi-view mode, use runWidget for multiple views
  // Otherwise use standard runApp for single view (including gallery mode)
  if (kIsWeb && multi_view.isMultiViewEnabled) {
    runWidget(const MultiViewApp());
  } else {
    runApp(const MixExampleApp());
  }
}

class MixExampleApp extends StatelessWidget {
  const MixExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
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

  Widget _buildExampleCard(PreviewEntry preview, BuildContext context) {
    return Padding(
      padding: const .all(12),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            preview.previewId,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: .ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          Expanded(child: Center(child: preview.builder(context))),
        ],
      ),
    );
  }

  // Use centralized registry as single source of truth
  List<PreviewEntry> get _previews => PreviewRegistry.all;

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ..._previews.map((e) => e.category).toSet()];
    final filteredPreviews = _selectedCategory == 'All'
        ? _previews
        : _previews.where((e) => e.category == _selectedCategory).toList();

    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Mix Examples'),
      body: Column(
        children: [
          // Category filter buttons
          Container(
            padding: const .all(16),
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
              padding: const .all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final preview = filteredPreviews[index];

                return _buildExampleCard(preview, context);
              },
              itemCount: filteredPreviews.length,
            ),
          ),
        ],
      ),
    );
  }
}
