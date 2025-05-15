import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naked Menu Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Naked Menu Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _lastAction = 'None';
  final controller = OverlayPortalController();

  void _handleAction(String action) {
    setState(() {
      _lastAction = action;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $action')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Last selected: $_lastAction'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => controller.show(),
              child: const Text('Show Menu'),
            ),
            TextButton(
              onPressed: () => controller.show(),
              child: const Text('Show Menu'),
            ),
            TextButton(
              onPressed: () => controller.show(),
              child: const Text('Show Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  const MenuItem({super.key, required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool isFocused = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return NakedMenuItem(
      onPressed: widget.onPressed,
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: isFocused ? Colors.red : Colors.black,
                fontWeight: isFocused ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isHovered) const Icon(Icons.chevron_right),
          ],
        ),
      ),
      onHoverState: (isHovered) => setState(() => this.isHovered = isHovered),
      onFocusState: (isFocused) => setState(() => this.isFocused = isFocused),
    );
  }
}
