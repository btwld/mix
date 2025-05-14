import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class NakedButtonExample extends StatefulWidget {
  const NakedButtonExample({super.key});

  @override
  State<NakedButtonExample> createState() => _NakedButtonExampleState();
}

class _NakedButtonExampleState extends State<NakedButtonExample> {
  // Global state tracking
  String _lastAction = 'None';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'Beautiful Button Examples',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                child: Text(
                  'Last Action: $_lastAction',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            // Basic Buttons Section
            _buildSectionTitle('Basic Buttons'),
            _buildGridLayout(
              columnCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              child: BasicButtons(
                onButtonPressed: (action) =>
                    setState(() => _lastAction = action),
              ),
            ),
            const SizedBox(height: 40),

            // Button States Section
            _buildSectionTitle('Button States'),
            ButtonStates(
              onButtonPressed: (action) => setState(() => _lastAction = action),
            ),
            const SizedBox(height: 40),

            // Toggle Buttons Section
            _buildSectionTitle('Toggle Buttons'),
            _buildGridLayout(
              columnCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
              child: ToggleButtons(
                onButtonPressed: (action) =>
                    setState(() => _lastAction = action),
              ),
            ),
            const SizedBox(height: 40),

            // Loading Buttons Section
            _buildSectionTitle('Loading Buttons'),
            _buildGridLayout(
              columnCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
              child: LoadingButtons(
                onButtonPressed: (action) =>
                    setState(() => _lastAction = action),
              ),
            ),
            const SizedBox(height: 40),

            // Styled Buttons Section
            _buildSectionTitle('Styled Buttons'),
            _buildGridLayout(
              columnCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
              child: StyledButtons(
                onButtonPressed: (action) =>
                    setState(() => _lastAction = action),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151), // text-gray-700
        ),
      ),
    );
  }

  Widget _buildGridLayout({
    required int columnCount,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

// Basic Buttons Component
class BasicButtons extends StatefulWidget {
  final Function(String) onButtonPressed;

  const BasicButtons({super.key, required this.onButtonPressed});

  @override
  State<BasicButtons> createState() => _BasicButtonsState();
}

class _BasicButtonsState extends State<BasicButtons> {
  // State variables for each button
  Map<String, bool> hoverStates = {};
  Map<String, bool> pressedStates = {};
  Map<String, bool> focusStates = {};

  // Button definitions
  final List<Map<String, dynamic>> buttons = [
    {
      'label': 'Primary',
      'color': Colors.blue,
      'hoverColor': Colors.blue[600],
      'textColor': Colors.white,
    },
    {
      'label': 'Secondary',
      'color': Colors.grey[200],
      'hoverColor': Colors.grey[300],
      'textColor': Colors.grey[800],
    },
    {
      'label': 'Success',
      'color': Colors.green,
      'hoverColor': Colors.green[600],
      'textColor': Colors.white,
    },
    {
      'label': 'Danger',
      'color': Colors.red,
      'hoverColor': Colors.red[600],
      'textColor': Colors.white,
    },
    {
      'label': 'Warning',
      'color': Colors.yellow[500],
      'hoverColor': Colors.yellow[600],
      'textColor': Colors.white,
    },
    {
      'label': 'Info',
      'color': Colors.purple,
      'hoverColor': Colors.purple[600],
      'textColor': Colors.white,
    },
    {
      'label': 'Dark',
      'color': Colors.grey[800],
      'hoverColor': Colors.black,
      'textColor': Colors.white,
    },
    {
      'label': 'Light',
      'color': Colors.white,
      'hoverColor': Colors.grey[100],
      'textColor': Colors.grey[800],
      'hasBorder': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize state maps
    for (var button in buttons) {
      String label = button['label'];
      hoverStates[label] = false;
      pressedStates[label] = false;
      focusStates[label] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: buttons.map((button) {
        String label = button['label'];
        Color color = button['color'];
        Color hoverColor = button['hoverColor'] ?? color;
        Color textColor = button['textColor'];
        bool hasBorder = button['hasBorder'] ?? false;

        return NakedButton(
          // Web Reference (React + Tailwind):
          // <button className="bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded">
          //   Primary
          // </button>
          onPressed: () => widget.onButtonPressed('$label Button Pressed'),
          onHoverState: (value) => setState(() => hoverStates[label] = value),
          onPressedState: (value) =>
              setState(() => pressedStates[label] = value),
          onFocusState: (value) => setState(() => focusStates[label] = value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: pressedStates[label]!
                  ? _darken(hoverColor)
                  : hoverStates[label]!
                      ? hoverColor
                      : color,
              borderRadius: BorderRadius.circular(4),
              border: hasBorder
                  ? Border.all(color: Colors.grey[300]!)
                  : focusStates[label]!
                      ? Border.all(
                          color: Colors.black.withValues(alpha: 0.5), width: 2)
                      : null,
              boxShadow: hoverStates[label]! && !pressedStates[label]!
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper method to darken a color (for pressed states)
  Color _darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

// Button States Component
class ButtonStates extends StatefulWidget {
  final Function(String) onButtonPressed;

  const ButtonStates({super.key, required this.onButtonPressed});

  @override
  State<ButtonStates> createState() => _ButtonStatesState();
}

class _ButtonStatesState extends State<ButtonStates> {
  // State for hover effects
  bool _isHoverSlideHovered = false;

  bool _isHoverSlideFocused = false;

  bool _isColorChangeHovered = false;

  bool _isColorChangeFocused = false;

  bool _isElevationHovered = false;
  bool _isElevationPressed = false;
  bool _isElevationFocused = false;

  // State for active effects

  bool _isScalePressed = false;
  bool _isScaleFocused = false;

  bool _isShadowPressed = false;
  bool _isShadowFocused = false;

  bool _isPushDownPressed = false;
  bool _isPushDownFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hover States
        _buildSubsectionTitle('Hover States'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Hover Slide Effect
            // Web Reference:
            // <button className="group relative bg-blue-500 text-white font-medium py-2 px-4 rounded overflow-hidden">
            //   <span className="relative z-10">Hover Me</span>
            //   <span className="absolute inset-0 bg-blue-600 transform scale-x-0 group-hover:scale-x-100 transition-transform origin-left"></span>
            // </button>
            NakedButton(
              onPressed: () =>
                  widget.onButtonPressed('Hover Slide Effect Pressed'),
              onHoverState: (value) =>
                  setState(() => _isHoverSlideHovered = value),
              onFocusState: (value) =>
                  setState(() => _isHoverSlideFocused = value),
              child: Stack(
                children: [
                  // Base Container
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                      border: _isHoverSlideFocused
                          ? Border.all(
                              color: Colors.black.withValues(alpha: 0.5),
                              width: 2)
                          : null,
                    ),
                    child: const Text(
                      'Hover Me',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Slide-in overlay (only visible on hover)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.identity()
                          ..scale(
                            _isHoverSlideHovered ? 1.0 : 0.0,
                            1.0,
                          ),
                        transformAlignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Text on top
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      alignment: Alignment.center,
                      child: const Text(
                        'Hover Me',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Color Change
            // Web Reference:
            // <button className="bg-white text-purple-600 border-2 border-purple-600 font-medium py-2 px-4 rounded hover:bg-purple-600 hover:text-white transition-colors duration-300">
            //   Color Change
            // </button>
            NakedButton(
              onPressed: () =>
                  widget.onButtonPressed('Color Change Button Pressed'),
              onHoverState: (value) =>
                  setState(() => _isColorChangeHovered = value),
              onFocusState: (value) =>
                  setState(() => _isColorChangeFocused = value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      _isColorChangeHovered ? Colors.purple[600] : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _isColorChangeFocused
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.purple[600]!,
                    width: _isColorChangeFocused ? 2 : 1,
                  ),
                ),
                child: Text(
                  'Color Change',
                  style: TextStyle(
                    color: _isColorChangeHovered
                        ? Colors.white
                        : Colors.purple[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Elevation
            // Web Reference:
            // <button className="bg-gray-800 text-white font-medium py-2 px-4 rounded hover:shadow-lg hover:-translate-y-1 transform transition-all duration-300">
            //   Elevation
            // </button>
            NakedButton(
              onPressed: () =>
                  widget.onButtonPressed('Elevation Button Pressed'),
              onHoverState: (value) =>
                  setState(() => _isElevationHovered = value),
              onPressedState: (value) =>
                  setState(() => _isElevationPressed = value),
              onFocusState: (value) =>
                  setState(() => _isElevationFocused = value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                transform: Matrix4.identity()
                  ..translate(
                    0.0,
                    _isElevationHovered && !_isElevationPressed ? -4.0 : 0.0,
                  ),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                  border: _isElevationFocused
                      ? Border.all(
                          color: Colors.black.withValues(alpha: 0.5), width: 2)
                      : null,
                  boxShadow: _isElevationHovered && !_isElevationPressed
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: const Text(
                  'Elevation',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Active (Pressed) States
        _buildSubsectionTitle('Active (Pressed) States'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Scale Button
            // Web Reference:
            // <button className="bg-blue-500 text-white font-medium py-2 px-4 rounded active:bg-blue-700 active:scale-95 transform transition-all duration-100">
            //   Press Me
            // </button>
            NakedButton(
              onPressed: () => widget.onButtonPressed('Scale Button Pressed'),
              onPressedState: (value) =>
                  setState(() => _isScalePressed = value),
              onFocusState: (value) => setState(() => _isScaleFocused = value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                transform: Matrix4.identity()
                  ..scale(_isScalePressed ? 0.95 : 1.0),
                decoration: BoxDecoration(
                  color: _isScalePressed ? Colors.blue[700] : Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                  border: _isScaleFocused
                      ? Border.all(
                          color: Colors.black.withValues(alpha: 0.5), width: 2)
                      : null,
                ),
                child: const Text(
                  'Press Me',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Inner Shadow
            // Web Reference:
            // <button className="bg-green-500 text-white font-medium py-2 px-4 rounded active:bg-green-700 active:shadow-inner transition-all duration-100">
            //   Inner Shadow
            // </button>
            NakedButton(
              onPressed: () =>
                  widget.onButtonPressed('Inner Shadow Button Pressed'),
              onPressedState: (value) =>
                  setState(() => _isShadowPressed = value),
              onFocusState: (value) => setState(() => _isShadowFocused = value),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isShadowPressed ? Colors.green[700] : Colors.green,
                  borderRadius: BorderRadius.circular(4),
                  border: _isShadowFocused
                      ? Border.all(
                          color: Colors.black.withValues(alpha: 0.5), width: 2)
                      : null,
                  boxShadow: _isShadowPressed
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                            spreadRadius: -2,
                          )
                        ]
                      : [],
                ),
                child: const Text(
                  'Inner Shadow',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Push Down
            // Web Reference:
            // <button className="bg-red-500 text-white font-medium py-2 px-4 rounded active:bg-red-700 active:translate-y-1 transform transition-all duration-100">
            //   Push Down
            // </button>
            NakedButton(
              onPressed: () =>
                  widget.onButtonPressed('Push Down Button Pressed'),
              onPressedState: (value) =>
                  setState(() => _isPushDownPressed = value),
              onFocusState: (value) =>
                  setState(() => _isPushDownFocused = value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                transform: Matrix4.identity()
                  ..translate(0.0, _isPushDownPressed ? 4.0 : 0.0),
                decoration: BoxDecoration(
                  color: _isPushDownPressed ? Colors.red[700] : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                  border: _isPushDownFocused
                      ? Border.all(
                          color: Colors.black.withValues(alpha: 0.5), width: 2)
                      : null,
                ),
                child: const Text(
                  'Push Down',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Disabled States
        _buildSubsectionTitle('Disabled States'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Disabled Primary
            // Web Reference:
            // <button disabled className="bg-blue-300 text-white font-medium py-2 px-4 rounded cursor-not-allowed opacity-60">
            //   Disabled Primary
            // </button>
            NakedButton(
              enabled: false,
              onPressed: null,
              child: Opacity(
                opacity: 0.6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Disabled Primary',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Disabled Secondary
            // Web Reference:
            // <button disabled className="bg-gray-200 text-gray-500 font-medium py-2 px-4 rounded cursor-not-allowed">
            //   Disabled Secondary
            // </button>
            NakedButton(
              enabled: false,
              onPressed: null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Disabled Secondary',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Disabled Outline
            // Web Reference:
            // <button disabled className="bg-white border border-gray-300 text-gray-400 font-medium py-2 px-4 rounded cursor-not-allowed">
            //   Disabled Outline
            // </button>
            NakedButton(
              enabled: false,
              onPressed: null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  'Disabled Outline',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}

// Toggle Buttons Component
class ToggleButtons extends StatefulWidget {
  final Function(String) onButtonPressed;

  const ToggleButtons({super.key, required this.onButtonPressed});

  @override
  State<ToggleButtons> createState() => _ToggleButtonsState();
}

class _ToggleButtonsState extends State<ToggleButtons> {
  // Toggle states
  bool _simpleToggleState = false;
  bool _simpleToggleFocused = false;
  bool _iconToggleState = false;
  bool _iconToggleFocused = false;
  bool _themeToggleState = false;
  bool _themeToggleFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCardContainer(
          title: 'Simple Toggle',
          child: NakedButton(
            // Web Reference:
            // <button
            //   className={`w-full py-2 px-4 rounded font-medium transition-colors ${
            //     toggleState1
            //       ? 'bg-blue-500 text-white'
            //       : 'bg-gray-200 text-gray-800'
            //   }`}
            //   onClick={() => setToggleState1(!toggleState1)}
            // >
            //   {toggleState1 ? 'ON' : 'OFF'}
            // </button>
            onPressed: () {
              setState(() => _simpleToggleState = !_simpleToggleState);
              widget.onButtonPressed(
                  'Simple Toggle: ${_simpleToggleState ? "ON" : "OFF"}');
            },
            onFocusState: (value) =>
                setState(() => _simpleToggleFocused = value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: _simpleToggleState ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
                border: _simpleToggleFocused
                    ? Border.all(
                        color: Colors.black.withValues(alpha: 0.5), width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  _simpleToggleState ? 'ON' : 'OFF',
                  style: TextStyle(
                    color: _simpleToggleState ? Colors.white : Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCardContainer(
          title: 'Icon Toggle',
          child: NakedButton(
            // Web Reference:
            // <button
            //   className={`w-full py-2 px-4 rounded font-medium flex items-center justify-center gap-2 transition-colors ${
            //     toggleState2
            //       ? 'bg-green-500 text-white'
            //       : 'bg-red-500 text-white'
            //   }`}
            //   onClick={() => setToggleState2(!toggleState2)}
            // >
            //   {toggleState2 ? <Check className="w-4 h-4" /> : <X className="w-4 h-4" />}
            //   <span>{toggleState2 ? 'Enabled' : 'Disabled'}</span>
            // </button>
            onPressed: () {
              setState(() => _iconToggleState = !_iconToggleState);
              widget.onButtonPressed(
                  'Icon Toggle: ${_iconToggleState ? "Enabled" : "Disabled"}');
            },
            onFocusState: (value) => setState(() => _iconToggleFocused = value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: _iconToggleState ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(4),
                border: _iconToggleFocused
                    ? Border.all(
                        color: Colors.black.withValues(alpha: 0.5), width: 2)
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _iconToggleState ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _iconToggleState ? 'Enabled' : 'Disabled',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCardContainer(
          title: 'Theme Toggle',
          child: NakedButton(
            // Web Reference:
            // <button
            //   className={`w-full p-3 rounded-full flex items-center justify-center transition-colors ${
            //     toggleState3
            //       ? 'bg-gray-800 text-yellow-400'
            //       : 'bg-blue-100 text-blue-800'
            //   }`}
            //   onClick={() => setToggleState3(!toggleState3)}
            // >
            //   {toggleState3 ? <Moon className="w-5 h-5" /> : <Sun className="w-5 h-5" />}
            // </button>
            onPressed: () {
              setState(() => _themeToggleState = !_themeToggleState);
              widget.onButtonPressed(
                  'Theme Toggle: ${_themeToggleState ? "Dark" : "Light"}');
            },
            onFocusState: (value) =>
                setState(() => _themeToggleFocused = value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _themeToggleState ? Colors.grey[800] : Colors.blue[100],
                borderRadius: BorderRadius.circular(50),
                border: _themeToggleFocused
                    ? Border.all(
                        color: Colors.black.withValues(alpha: 0.5), width: 2)
                    : null,
              ),
              child: Icon(
                _themeToggleState ? Icons.dark_mode : Icons.light_mode,
                color:
                    _themeToggleState ? Colors.yellow[400] : Colors.blue[800],
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// Loading Buttons Component
class LoadingButtons extends StatefulWidget {
  final Function(String) onButtonPressed;

  const LoadingButtons({super.key, required this.onButtonPressed});

  @override
  State<LoadingButtons> createState() => _LoadingButtonsState();
}

class _LoadingButtonsState extends State<LoadingButtons> {
  // Loading states
  bool _isSpinnerLoading = false;
  bool _isSpinnerHovered = false;
  bool _isSpinnerPressed = false;
  bool _isSpinnerFocused = false;

  bool _isProgressLoading = false;
  bool _isProgressHovered = false;
  bool _isProgressPressed = false;
  bool _isProgressFocused = false;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    // Animation controller will be initialized in the handleProgressClick method
  }

  Future<void> handleSpinnerClick() async {
    if (_isSpinnerLoading) return;
    setState(() => _isSpinnerLoading = true);
    widget.onButtonPressed('Loading Spinner Started');

    // Simulate loading
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSpinnerLoading = false);
      widget.onButtonPressed('Loading Spinner Completed');
    }
  }

  Future<void> handleProgressClick() async {
    if (_isProgressLoading) return;
    setState(() {
      _isProgressLoading = true;
      _progressValue = 0.0;
    });
    widget.onButtonPressed('Progress Loading Started');

    // Reset progress
    setState(() => _progressValue = 0.0);

    // Simulate progressive loading
    for (int i = 1; i <= 10; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _progressValue = i / 10);
    }

    // Complete loading
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() => _isProgressLoading = false);
      widget.onButtonPressed('Progress Loading Completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCardContainer(
          title: 'Loading Spinner',
          child: NakedButton(
            // Web Reference:
            // <button
            //   className="w-full bg-blue-500 hover:bg-blue-600 disabled:bg-blue-400 text-white font-medium py-2 px-4 rounded flex items-center justify-center transition-colors"
            //   onClick={handleClick1}
            //   disabled={isLoading1}
            // >
            //   {isLoading1 ? (
            //     <>
            //       <Loader className="w-4 h-4 mr-2 animate-spin" />
            //       <span>Loading...</span>
            //     </>
            //   ) : (
            //     <span>Click to Load</span>
            //   )}
            // </button>
            loading: _isSpinnerLoading,
            onPressed: _isSpinnerLoading ? null : handleSpinnerClick,
            onHoverState: (value) => setState(() => _isSpinnerHovered = value),
            onPressedState: (value) =>
                setState(() => _isSpinnerPressed = value),
            onFocusState: (value) => setState(() => _isSpinnerFocused = value),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: _isSpinnerLoading
                    ? Colors.blue[400]
                    : _isSpinnerPressed
                        ? Colors.blue[600]
                        : _isSpinnerHovered
                            ? Colors.blue[600]
                            : Colors.blue,
                borderRadius: BorderRadius.circular(4),
                border: _isSpinnerFocused && !_isSpinnerLoading
                    ? Border.all(
                        color: Colors.black.withValues(alpha: 0.5), width: 2)
                    : null,
              ),
              child: Center(
                child: _isSpinnerLoading
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Click to Load',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCardContainer(
          title: 'Progress Button',
          child: NakedButton(
            // Web Reference:
            // <button
            //   className="w-full relative bg-purple-500 hover:bg-purple-600 disabled:bg-purple-400 text-white font-medium py-2 px-4 rounded overflow-hidden transition-colors"
            //   onClick={handleClick2}
            //   disabled={isLoading2}
            // >
            //   {isLoading2 && (
            //     <div className="absolute inset-0 bg-purple-700 animate-progress origin-left" style={{
            //       animation: "progress 2s linear forwards",
            //       animationPlayState: isLoading2 ? "running" : "paused"
            //     }}></div>
            //   )}
            //   <span className="relative z-10">{isLoading2 ? 'Processing...' : 'Submit'}</span>
            // </button>
            loading: _isProgressLoading,
            onPressed: _isProgressLoading ? null : handleProgressClick,
            onHoverState: (value) => setState(() => _isProgressHovered = value),
            onPressedState: (value) =>
                setState(() => _isProgressPressed = value),
            onFocusState: (value) => setState(() => _isProgressFocused = value),
            child: Stack(
              children: [
                // Button container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _isProgressLoading
                        ? Colors.purple[400]
                        : _isProgressPressed
                            ? Colors.purple[600]
                            : _isProgressHovered
                                ? Colors.purple[600]
                                : Colors.purple,
                    borderRadius: BorderRadius.circular(4),
                    border: _isProgressFocused && !_isProgressLoading
                        ? Border.all(
                            color: Colors.black.withValues(alpha: 0.5),
                            width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      _isProgressLoading ? 'Processing...' : 'Submit',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Progress overlay
                if (_isProgressLoading)
                  Positioned.fill(
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progressValue,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                // Ensure text stays on top
                if (_isProgressLoading)
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      child: const Text(
                        'Processing...',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// Styled Buttons Component
class StyledButtons extends StatefulWidget {
  final Function(String) onButtonPressed;

  const StyledButtons({super.key, required this.onButtonPressed});

  @override
  State<StyledButtons> createState() => _StyledButtonsState();
}

class _StyledButtonsState extends State<StyledButtons> {
  // State variables
  bool _isGradientHovered = false;
  bool _isGradientPressed = false;
  bool _isGradientFocused = false;

  bool _isGlassHovered = false;
  bool _isGlassFocused = false;

  bool _isArrowHovered = false;
  bool _isArrowPressed = false;
  bool _isArrowFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCardContainer(
          title: 'Gradient Button',
          child: NakedButton(
            // Web Reference:
            // <button className="w-full bg-gradient-to-r from-purple-500 to-blue-500 hover:from-purple-600 hover:to-blue-600 text-white font-medium py-3 px-4 rounded-lg shadow-md hover:shadow-lg transition-all duration-300">
            //   Gradient Button
            // </button>
            onPressed: () => widget.onButtonPressed('Gradient Button Pressed'),
            onHoverState: (value) => setState(() => _isGradientHovered = value),
            onPressedState: (value) =>
                setState(() => _isGradientPressed = value),
            onFocusState: (value) => setState(() => _isGradientFocused = value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isGradientHovered || _isGradientPressed
                      ? [Colors.purple[600]!, Colors.blue[600]!]
                      : [Colors.purple, Colors.blue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: _isGradientFocused
                    ? Border.all(
                        color: Colors.black.withValues(alpha: 0.5), width: 2)
                    : null,
                boxShadow: _isGradientHovered && !_isGradientPressed
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
              ),
              child: const Center(
                child: Text(
                  'Gradient Button',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Glass Button wrapped in a gradient container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[400]!, Colors.purple[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Glass Button',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              // Web Reference:
              // <button className="w-full backdrop-blur-md bg-white/30 hover:bg-white/40 text-white font-medium py-3 px-4 rounded-lg border border-white/50 shadow-md hover:shadow-lg transition-all duration-300">
              //   Glass Button
              // </button>
              NakedButton(
                onPressed: () => widget.onButtonPressed('Glass Button Pressed'),
                onHoverState: (value) =>
                    setState(() => _isGlassHovered = value),
                onFocusState: (value) =>
                    setState(() => _isGlassFocused = value),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _isGlassHovered
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isGlassFocused
                              ? Colors.black.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.5),
                          width: _isGlassFocused ? 2 : 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Glass Button',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildCardContainer(
          title: 'Arrow Button',
          child: NakedButton(
            // Web Reference:
            // <button className="w-full group bg-blue-500 hover:bg-blue-600 text-white font-medium py-3 px-4 rounded-lg flex items-center justify-center gap-2 transition-all duration-300">
            //   <span>Next Step</span>
            //   <ChevronRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
            // </button>
            onPressed: () => widget.onButtonPressed('Arrow Button Pressed'),
            onHoverState: (value) => setState(() => _isArrowHovered = value),
            onPressedState: (value) => setState(() => _isArrowPressed = value),
            onFocusState: (value) => setState(() => _isArrowFocused = value),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _isArrowPressed
                    ? Colors.blue[700]
                    : _isArrowHovered
                        ? Colors.blue[600]
                        : Colors.blue,
                borderRadius: BorderRadius.circular(8),
                border: _isArrowFocused
                    ? Border.all(
                        color: Colors.black.withValues(alpha: 0.5), width: 2)
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Next Step',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.identity()
                      ..translate(_isArrowHovered ? 4.0 : 0.0, 0.0),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
