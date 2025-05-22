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
          child: MenuExample(),
        ),
      ),
    );
  }
}

class MenuExample extends StatefulWidget {
  const MenuExample({super.key});

  @override
  State<MenuExample> createState() => _MenuExampleState();
}

class _MenuExampleState extends State<MenuExample> {
  final _controller = OverlayPortalController();

  void _onItemPressed(String item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item $item selected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NakedMenu(
      builder: (context) => NakedButton(
        onPressed: () => _controller.show(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(Icons.settings, size: 18),
        ),
      ),
      overlayBuilder: (context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        constraints: const BoxConstraints(
          maxWidth: 200,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ItemContent(
              title: 'Menu Item 1',
              onPressed: () => _onItemPressed('1'),
            ),
            ItemContent(
              title: 'Menu Item 2',
              onPressed: () => _onItemPressed('2'),
            ),
            ItemContent(
              title: 'Menu Item 3',
              onPressed: () => _onItemPressed('3'),
            ),
          ],
        ),
      ),
      controller: _controller,
      onClose: () => _controller.hide(),
    );
  }
}

class ItemContent extends StatefulWidget {
  const ItemContent({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  State<ItemContent> createState() => _ItemContentState();
}

class _ItemContentState extends State<ItemContent> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return NakedMenuItem(
      onPressed: widget.onPressed,
      onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(widget.title),
          AnimatedOpacity(
            opacity: _isHovered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.grey,
            ),
          ),
        ]),
      ),
    );
  }
}
