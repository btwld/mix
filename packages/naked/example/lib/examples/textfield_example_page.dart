import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class TextFieldExamplePage extends StatefulWidget {
  const TextFieldExamplePage({super.key});

  @override
  State<TextFieldExamplePage> createState() => _TextFieldExamplePageState();
}

class _TextFieldExamplePageState extends State<TextFieldExamplePage> {
  // Text controllers for the 3 examples
  final _searchController = TextEditingController();
  final _gradientController = TextEditingController();
  final _currencyController = TextEditingController();

  // Focus nodes for the 3 examples
  final _gradientFocus = FocusNode();
  final _currencyFocus = FocusNode();

  // State tracking
  bool _searchHovered = false;
  bool _searchFocused = false;

  bool _gradientHovered = false;
  bool _gradientFocused = false;

  bool _currencyHovered = false;
  bool _currencyFocused = false;

  @override
  void initState() {
    super.initState();
    // Listen for focus changes

    _gradientFocus.addListener(_updateGradientFocus);
    _currencyFocus.addListener(_updateCurrencyFocus);
  }

  void _updateGradientFocus() {
    setState(() {
      _gradientFocused = _gradientFocus.hasFocus;
    });
  }

  void _updateCurrencyFocus() {
    setState(() {
      _currencyFocused = _currencyFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    // Dispose controllers
    _searchController.dispose();
    _gradientController.dispose();
    _currencyController.dispose();

    // Dispose focus nodes

    _gradientFocus.removeListener(_updateGradientFocus);
    _currencyFocus.removeListener(_updateCurrencyFocus);

    _gradientFocus.dispose();
    _currencyFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NakedTextField Examples',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          // Example 1: Search Field
          const Text(
            '1. Search Field with Prefix Icon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Search field using builder
          NakedTextField(
            controller: _searchController,
            onChanged: (value) => setState(() {}),
            onFocusState: (value) => setState(() => _searchFocused = value),
            onHoverState: (value) => setState(() => _searchHovered = value),
            // onPressed: () => print('onTap'),
            // onPressOutside: (_) => print('onTapOutside'),
            // onPressUpOutside: (_) => print('onTapUpOutside'),
            builder: (context, child) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: _searchFocused
                        ? Colors.blue
                        : _searchHovered
                            ? Colors.blueGrey
                            : Colors.grey.shade300,
                    width: _searchFocused || _searchHovered ? 2 : 1,
                  ),
                  boxShadow: _searchFocused
                      ? [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Prefix icon
                    Icon(
                      Icons.search,
                      color: _searchFocused
                          ? Colors.blue
                          : _searchHovered
                              ? Colors.blueGrey
                              : Colors.grey,
                    ),
                    const SizedBox(width: 8),

                    // TextField
                    Expanded(child: child),

                    // Clear button
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () =>
                            setState(() => _searchController.clear()),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),

          // Example 2: Gradient Background
          const Text('2. Gradient Background Field',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Gradient field using builder
          NakedTextField(
            controller: _gradientController,
            focusNode: _gradientFocus,
            cursorColor: Colors.white,
            onHoverState: (value) => setState(() => _gradientHovered = value),
            builder: (context, child) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _gradientFocused || _gradientHovered
                        ? [Colors.purple, Colors.blue]
                        : [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _gradientFocused
                      ? [
                          BoxShadow(
                            color: Colors.purple.withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Star icon
                    const Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),

                    // TextField
                    Expanded(child: child),

                    // Arrow icon
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),

          // Example 3: Currency Field with Custom Prefix
          const Text('3. Currency Field with Custom Prefix',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Currency field using builder
          NakedTextField(
            controller: _currencyController,
            focusNode: _currencyFocus,
            keyboardType: TextInputType.number,
            onHoverState: (value) => setState(() => _currencyHovered = value),
            builder: (context, child) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _currencyFocused
                        ? Colors.green
                        : _currencyHovered
                            ? Colors.green.withValues(alpha: 0.5)
                            : Colors.grey.shade300,
                    width: _currencyFocused || _currencyHovered ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Currency badge
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Colors.green.shade800,
                          ),
                          Text(
                            'USD',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // TextField
                    Expanded(child: child),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NakedTextField Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      home: const TextFieldExamplePage(),
    );
  }
}
