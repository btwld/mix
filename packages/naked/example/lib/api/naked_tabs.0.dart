import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: TabsExample(),
        ),
      ),
    );
  }
}

class TabsExample extends StatefulWidget {
  const TabsExample({super.key});

  @override
  State<TabsExample> createState() => _TabsExampleState();
}

class _TabsExampleState extends State<TabsExample> {
  String _selectedTabId = 'light';

  @override
  Widget build(BuildContext context) {
    return NakedTabGroup(
      selectedTabId: _selectedTabId,
      onSelectedTabIdChanged: (tabId) => setState(() => _selectedTabId = tabId),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: NakedTabList(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  Expanded(
                    child: TabItem(
                      tabId: 'light',
                      label: 'Light',
                      isSelected: _selectedTabId == 'light',
                    ),
                  ),
                  Expanded(
                    child: TabItem(
                      tabId: 'dark',
                      label: 'Dark',
                      isSelected: _selectedTabId == 'dark',
                    ),
                  ),
                  Expanded(
                    child: TabItem(
                      tabId: 'system',
                      label: 'System',
                      isSelected: _selectedTabId == 'system',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          NakedTabPanel(
            tabId: 'light',
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: const Text('Content for Tab 1'),
            ),
          ),
          NakedTabPanel(
            tabId: 'dark',
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade50,
              child: const Text('Content for Tab 2'),
            ),
          ),
          NakedTabPanel(
            tabId: 'system',
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade50,
              child: const Text('Content for Tab 3'),
            ),
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatefulWidget {
  const TabItem({
    super.key,
    required this.tabId,
    required this.label,
    required this.isSelected,
  });

  final String tabId;
  final String label;
  final bool isSelected;

  @override
  State<TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  bool _isHovered = false;

  Color get _backgroundColor {
    if (widget.isSelected) return Colors.white;
    if (_isHovered) return Colors.grey.shade200;
    return Colors.grey.shade100;
  }

  Color get _textColor {
    if (widget.isSelected) return Colors.black87;
    return Colors.black38;
  }

  @override
  Widget build(BuildContext context) {
    return NakedTab(
      tabId: widget.tabId,
      onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
          ),
          child: Text(
            widget.label,
          ),
        ),
      ),
    );
  }
}
