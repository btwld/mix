// import 'package:example/examples/naked_tooltip_example.dart';
import 'package:example/examples/naked_tooltip_example.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import examples
import 'examples/naked_accordion_example.dart';
import 'examples/naked_avatar_example.dart';
import 'examples/naked_button_example.dart';
import 'examples/naked_checkbox_example.dart';
import 'examples/naked_dialog_example.dart';
import 'examples/naked_menu_example.dart';
import 'examples/naked_radio_example.dart';
import 'examples/naked_select_example.dart';
import 'examples/naked_slider_example.dart';
import 'examples/naked_tabs_example.dart';
import 'examples/naked_toast_example.dart';
import 'examples/textfield_example_page.dart';
import 'url_strategy.dart';

void main() {
  // Initialize URL strategy before running the app
  UrlStrategy.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naked Components',
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Use Inter font from Google Fonts
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        // Modern color scheme inspired by Vercel/shadcn
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0070F3), // Vercel blue
          brightness: Brightness.light,
          surface: Colors.white,
          onSurface: const Color(0xFF171717), // Near black
          primary: const Color(0xFF0070F3), // Primary blue
          secondary: const Color(0xFF6B7280), // Gray
        ),
        scaffoldBackgroundColor: Colors.white,
        // App bar styling
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF171717),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF6B7280),
          ),
        ),
        // Card styling
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(
              color: Color(0xFFE5E7EB), // Light gray border
              width: 1,
            ),
          ),
        ),
        // Button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF0070F3),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Parse route name from URL path
        final path = settings.name ?? '/';
        if (path == '/') {
          return MaterialPageRoute(
            builder: (context) => const ShowcaseApp(initialIndex: 0),
          );
        }

        // Extract the component name from the URL path
        final componentName = path.substring(1);
        // Find the matching index in the destination list
        final index = _getDestinationIndex(componentName);
        return MaterialPageRoute(
          builder: (context) => ShowcaseApp(initialIndex: index),
        );
      },
    );
  }

  // Helper method to find the index based on the URL path segment
  static int _getDestinationIndex(String componentName) {
    final normalizedName = componentName.toLowerCase().replaceAll('-', '');

    for (int i = 0; i < destinations().length; i++) {
      final destName =
          destinations()[i].label.toLowerCase().replaceAll(' ', '');
      if (destName == normalizedName) {
        return i;
      }
    }

    // Default to 0 if component not found
    return 0;
  }
}

// Define destinations at the app level for route generation
List<NavDestination> destinations() => [
      NavDestination(
        label: 'Toast',
        widget: const NakedToastExample(),
      ),
      NavDestination(
        label: 'TextField',
        widget: const TextFieldExamplePage(),
      ),
      NavDestination(
        label: 'Menu',
        widget: const NakedMenuExample(),
      ),
      NavDestination(
        label: 'Tooltips',
        widget: const NakedTooltipExample(),
      ),
      NavDestination(
        label: 'Accordion',
        widget: const NakedAccordionExample(),
      ),
      NavDestination(
        label: 'Avatar',
        widget: const NakedAvatarExample(),
      ),
      NavDestination(
        label: 'Button',
        widget: const NakedButtonExample(),
      ),
      NavDestination(
        label: 'Checkbox',
        widget: const NakedCheckboxExample(),
      ),
      NavDestination(
        label: 'Dialog',
        widget: const NakedDialogExample(),
      ),
      NavDestination(
        label: 'Radio',
        widget: const NakedRadioExample(),
      ),
      NavDestination(
        label: 'Select',
        widget: const NakedSelectExample(),
      ),
      NavDestination(
        label: 'Slider',
        widget: const NakedSliderExample(),
      ),
      NavDestination(
        label: 'Tabs',
        widget: const NakedTabsExample(),
      ),
    ];

class ShowcaseApp extends StatefulWidget {
  final int initialIndex;

  const ShowcaseApp({super.key, this.initialIndex = 0});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

// Helper class to define navigation destinations
class NavDestination {
  final String label;
  final Widget widget;

  NavDestination({required this.label, required this.widget});
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  late int _selectedIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // Method to update URL path when tab changes
  void _updateUrlForDestination(int index) {
    final destination = destinations()[index];
    final path = '/${destination.label.toLowerCase().replaceAll(' ', '-')}';

    // Update browser URL without adding to history stack
    updateUrl(path);
  }

  @override
  Widget build(BuildContext context) {
    // Get the selected destination
    final NavDestination selectedDestination = destinations()[_selectedIndex];
    // Use the destination widget directly
    final Widget selectedWidget = selectedDestination.widget;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          selectedDestination.label,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Container(
        width: 260,
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'COMPONENTS',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: destinations().asMap().entries.map((entry) {
                    final int index = entry.key;
                    final NavDestination destination = entry.value;
                    final bool isSelected = index == _selectedIndex;

                    return ListTile(
                      title: Text(
                        destination.label,
                        style: GoogleFonts.inter(
                          color: isSelected
                              ? const Color(0xFF0070F3)
                              : const Color(0xFF6B7280),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      tileColor: isSelected
                          ? const Color(0xFFEFF6FF)
                          : Colors.transparent,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                          _updateUrlForDestination(index);
                          _scaffoldKey.currentState?.closeDrawer();
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Naked Components',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Component description
          Container(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Text(
              'Headless component with complete styling freedom and built-in accessibility',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          // Component example content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card to contain the example
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: selectedWidget,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
