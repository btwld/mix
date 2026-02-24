// =============================================================================
// Mix 2.0 YouTube Episode - Demo Code Snippets
// =============================================================================
// These snippets are organized by presentation segment for easy reference
// during recording. Each can be run as a standalone example.
//
// To run any example from the examples/ directory:
//   cd examples && flutter run -t lib/api/widgets/box/gradient_box.dart
// =============================================================================

// ignore_for_file: unused_element, unused_local_variable

import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// =============================================================================
// DEMO 1: Simple Styled Box
// Shows: Basic fluent API chaining
// File: examples/lib/api/widgets/box/gradient_box.dart
// =============================================================================

class Demo1_SimpleBox extends StatelessWidget {
  const Demo1_SimpleBox({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .height(50)
        .width(100)
        .borderRounded(10)
        .linearGradient(
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade200],
          begin: .topLeft,
          end: .bottomRight,
        )
        .shadowOnly(
          color: Colors.deepPurple.shade700,
          offset: Offset(0, 4),
          blurRadius: 10,
        );

    return Box(style: style);
  }
}

// =============================================================================
// DEMO 2: Rainbow Gradient Circle
// Shows: Sweep gradients, shadows, the "wow" factor
// File: examples/lib/api/gradients/gradient_sweep.dart
// =============================================================================

class Demo2_GradientCircle extends StatelessWidget {
  const Demo2_GradientCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .height(120)
        .width(120)
        .borderRounded(60)
        .shadowOnly(
          color: Colors.purple.shade300,
          blurRadius: 25,
          spreadRadius: 2,
        )
        .sweepGradient(
          colors: [
            Colors.blue.shade400,
            Colors.purple.shade400,
            Colors.pink.shade400,
            Colors.orange.shade400,
            Colors.blue.shade400,
          ],
          center: .center,
          startAngle: 0,
          endAngle: pi * 2,
        );

    return Box(style: style);
  }
}

// =============================================================================
// DEMO 3: Style Composition & Reuse
// Shows: Extending styles, merging, creating variants from a base
// =============================================================================

class Demo3_StyleComposition extends StatelessWidget {
  const Demo3_StyleComposition({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a reusable base style
    final baseCard = BoxStyler()
        .height(100)
        .width(200)
        .borderRounded(12)
        .paddingAll(16)
        .shadowOnly(color: Colors.black12, blurRadius: 10);

    // Create variants by chaining onto the base
    final primaryCard = baseCard.color(Colors.blue);
    final successCard = baseCard.color(Colors.green);
    final errorCard = baseCard.color(Colors.red);

    return Row(
      mainAxisAlignment: .spaceEvenly,
      children: [
        Box(style: primaryCard, child: Text('Primary')),
        Box(style: successCard, child: Text('Success')),
        Box(style: errorCard, child: Text('Error')),
      ],
    );
  }
}

// =============================================================================
// DEMO 4: Dark/Light Mode Toggle
// Shows: Context variants, .onDark(), animated transitions
// File: examples/lib/api/context_variants/on_dark_light.dart
// =============================================================================

class Demo4_DarkModeToggle extends StatefulWidget {
  const Demo4_DarkModeToggle({super.key});

  @override
  State<Demo4_DarkModeToggle> createState() => _Demo4State();
}

class _Demo4State extends State<Demo4_DarkModeToggle> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    // Style adapts automatically based on brightness
    final buttonStyle = BoxStyler()
        .height(60)
        .width(60)
        .borderRounded(30)
        .color(Colors.grey.shade200)
        .animate(.easeInOut(600.ms))
        .onDark(BoxStyler().color(Colors.grey.shade800))
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.1),
          offset: Offset(0, 4),
          blurRadius: 10,
        );

    // Icon also adapts - even swaps the icon itself!
    final iconStyle = IconStyler()
        .color(Colors.grey.shade800)
        .size(28)
        .icon(Icons.dark_mode)
        .animate(.easeInOut(200.ms))
        .onDark(IconStyler().icon(Icons.light_mode).color(Colors.yellow));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        platformBrightness: isDark ? .dark : .light,
      ),
      child: PressableBox(
        style: buttonStyle,
        onPress: () => setState(() => isDark = !isDark),
        child: StyledIcon(style: iconStyle),
      ),
    );
  }
}

// =============================================================================
// DEMO 5: Responsive Breakpoints
// Shows: .onBreakpoint(), responsive color changes
// File: examples/lib/api/context_variants/responsive_size.dart
// =============================================================================

class Demo5_Responsive extends StatelessWidget {
  const Demo5_Responsive({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .width(100)
        .height(100)
        .color(Colors.blue.shade400)
        .onBreakpoint(
          Breakpoint.maxWidth(575),
          BoxStyler().color(Colors.green),
        )
        .borderRounded(16)
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
        )
        .animate(.spring(300.ms));

    return Center(
      child: Box(
        style: style,
        child: Center(child: Text('Resize window!')),
      ),
    );
  }
}

// =============================================================================
// DEMO 6: Spring Animation
// Shows: Implicit animation with spring physics - ONE LINE
// File: examples/lib/api/animation/implicit.spring.translate.dart
// =============================================================================

class Demo6_SpringAnimation extends StatefulWidget {
  const Demo6_SpringAnimation({super.key});

  @override
  State<Demo6_SpringAnimation> createState() => _Demo6State();
}

class _Demo6State extends State<Demo6_SpringAnimation> {
  bool _translated = false;

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRounded(10)
        .transform(.identity())
        .translate(0, _translated ? 100 : -100)
        .animate(.spring(300.ms, bounce: 0.6)); // <-- That's it!

    return Row(
      mainAxisAlignment: .center,
      spacing: 20,
      children: [
        Box(style: style),
        TextButton(
          onPressed: () => setState(() => _translated = !_translated),
          child: Text('Play'),
        ),
      ],
    );
  }
}

// =============================================================================
// DEMO 7: Keyframe Switch Toggle
// Shows: Multi-track keyframe animation, elastic physics
// File: examples/lib/api/animation/keyframe.switch.dart
// =============================================================================

class Demo7_SwitchToggle extends StatefulWidget {
  const Demo7_SwitchToggle({super.key});

  @override
  State<Demo7_SwitchToggle> createState() => _Demo7State();
}

class _Demo7State extends State<Demo7_SwitchToggle> {
  final ValueNotifier<bool> _trigger = ValueNotifier(false);

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Pressable(
        onPress: () {
          setState(() => _trigger.value = !_trigger.value);
        },
        child: Box(
          style: BoxStyler()
              .color(
                _trigger.value
                    ? Colors.deepPurpleAccent
                    : Colors.grey.shade300,
              )
              .height(30)
              .width(65)
              .borderRadiusAll(.circular(40))
              .alignment(_trigger.value ? .centerRight : .centerLeft)
              .animate(.easeOut(300.ms)),
          child: Box(
            style: BoxStyler()
                .height(30)
                .width(40)
                .color(Colors.white)
                .borderRounded(40)
                .scale(0.85)
                .shadowOnly(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: Offset(2, 4),
                  blurRadius: 4,
                  spreadRadius: 3,
                )
                .keyframeAnimation(
                  trigger: _trigger,
                  timeline: [
                    KeyframeTrack('scale', [
                      .easeOutSine(1.25, 200.ms),
                      .elasticOut(0.85, 500.ms),
                    ], initial: 0.85),
                    KeyframeTrack<double>(
                      'width',
                      [
                        .decelerate(50, 100.ms),
                        .linear(50, 100.ms),
                        .elasticOut(40, 500.ms),
                      ],
                      initial: 40,
                      tweenBuilder: Tween.new,
                    ),
                  ],
                  styleBuilder: (values, style) => style
                      .scale(values.get('scale'))
                      .width(values.get('width')),
                ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// DEMO 8: Heart Animation (Show-Stopper)
// Shows: Complex keyframe choreography with 4 simultaneous tracks
// File: examples/lib/api/animation/keyframe.heart.dart
// =============================================================================

class Demo8_HeartAnimation extends StatefulWidget {
  const Demo8_HeartAnimation({super.key});

  @override
  State<Demo8_HeartAnimation> createState() => _Demo8State();
}

class _Demo8State extends State<Demo8_HeartAnimation> {
  final ValueNotifier<int> _trigger = ValueNotifier(0);

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _trigger.value++),
      child: Box(
        style: BoxStyler().keyframeAnimation(
          trigger: _trigger,
          timeline: [
            // Track 1: Scale - grows then settles
            KeyframeTrack('scale', [
              .linear(1.0, 360.ms),
              .elasticOut(1.5, 800.ms),
              .elasticOut(1.0, 800.ms),
            ], initial: 1.0),
            // Track 2: Vertical position - dips then floats up
            KeyframeTrack('verticalOffset', [
              .linear(0.0, 100.ms),
              .easeIn(20.0, 150.ms),
              .elasticOut(-60.0, 1000.ms),
              .elasticOut(0.0, 800.ms),
            ], initial: 0.0),
            // Track 3: Squash & stretch
            KeyframeTrack('verticalStretch', [
              .ease(1.0, 100.ms),
              .ease(0.6, 150.ms),
              .ease(1.5, 100.ms),
              .ease(1.05, 150.ms),
              .ease(1.0, 880.ms),
              .ease(0.8, 100.ms),
              .ease(1.04, 400.ms),
              .ease(1.0, 220.ms),
            ], initial: 1.0),
            // Track 4: Rotation wobble
            KeyframeTrack('angle', [
              .easeIn(0.0, 580.ms),
              .easeIn(16.0 * (pi / 180), 125.ms),
              .easeIn(-16.0 * (pi / 180), 125.ms),
              .easeIn(16.0 * (pi / 180), 125.ms),
              .easeIn(0.0, 125.ms),
            ], initial: 0.0),
          ],
          styleBuilder: (values, style) {
            final scale = values.get('scale');
            final verticalOffset = values.get('verticalOffset');
            final verticalStretch = values.get('verticalStretch');
            final angle = values.get('angle');

            return style
                .wrap(.new().scale(scale, scale * verticalStretch))
                .wrap(.new().translate(x: 0, y: verticalOffset))
                .wrap(.new().rotate(radians: angle));
          },
        ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [Colors.redAccent.shade100, Colors.redAccent.shade400],
            ).createShader(bounds);
          },
          child: StyledIcon(
            icon: CupertinoIcons.heart_fill,
            style: IconMix().size(100).color(Colors.white),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// DEMO 9: Design Tokens
// Shows: Token system, MixScope, scoped overrides
// File: examples/lib/api/design_tokens/theme_tokens.dart
// =============================================================================

// Define tokens
final $primaryColor = ColorToken('primary');
final $pill = RadiusToken('pill');
final $spacing = SpaceToken('spacing.large');

class Demo9_DesignTokens extends StatelessWidget {
  const Demo9_DesignTokens({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide token values at the top of the tree
    return MixScope(
      colors: {$primaryColor: Colors.blue},
      spaces: {$spacing: 16.0},
      radii: {$pill: Radius.circular(20)},
      child: _TokenConsumer(),
    );
  }
}

class _TokenConsumer extends StatelessWidget {
  const _TokenConsumer();

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .borderRadiusTopLeft($pill())
        .color($primaryColor())
        .height(100)
        .width(100)
        .paddingAll(16.0);

    return Box(
      style: style,
      child: MixScope(
        // Override primary color to red for this subtree
        colors: {$primaryColor: Colors.red},
        child: StyledText(
          'Hello, World!',
          style: TextStyler()
              .color($primaryColor()) // Will be red here!
              .wrap(.new().padding(.all($spacing()))),
        ),
      ),
    );
  }
}

// =============================================================================
// DEMO 10: Okinawa Card (Real-World Component)
// Shows: Everything together - images, blur, layout, text, composition
// File: examples/lib/examples/okinawa.card.dart
// =============================================================================

class Demo10_OkinawaCard extends StatelessWidget {
  const Demo10_OkinawaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final boxStyle = BoxStyler()
        .height(200)
        .width(200)
        .paddingAll(8)
        .alignment(Alignment.bottomCenter)
        .borderRounded(10)
        .backgroundImageUrl(
          'https://images.pexels.com/photos/5472603/pexels-photo-5472603.jpeg',
          fit: .cover,
        )
        .borderAll(
          color: Colors.white,
          width: 6,
          strokeAlign: BorderSide.strokeAlignOutside,
        )
        .color(Colors.blueGrey.shade50)
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 100,
        );

    final columnBoxStyle = FlexBoxStyler()
        .paddingAll(8)
        .width(.infinity)
        .color(Colors.black.withValues(alpha: 0.1))
        .mainAxisSize(.min)
        .crossAxisAlignment(.start);

    final titleStyle =
        TextStyler().color(Colors.white).fontWeight(.bold).fontSize(16);

    final subtitleStyle = TextStyler().color(Colors.white70).fontSize(14);

    return Box(
      style: boxStyle,
      child: ClipRRect(
        borderRadius: .circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: ColumnBox(
            style: columnBoxStyle,
            children: [
              titleStyle('Okinawa'),
              subtitleStyle('Japan'),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// BEFORE/AFTER COMPARISON
// Shows: The same component built with and without Mix
// =============================================================================

// --- WITHOUT MIX (verbose, scattered, stateful) ---

class ButtonWithoutMix extends StatefulWidget {
  const ButtonWithoutMix({super.key});

  @override
  State<ButtonWithoutMix> createState() => _ButtonWithoutMixState();
}

class _ButtonWithoutMixState extends State<ButtonWithoutMix> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: isDark
              ? (_isHovered ? Colors.blue.shade700 : Colors.grey.shade800)
              : (_isHovered ? Colors.blue.shade300 : Colors.blue),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            style: TextStyle(
              color: isDark ? Colors.black : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            child: Text('Click me'),
          ),
        ),
      ),
    );
  }
}

// --- WITH MIX (clean, declarative, stateless) ---

class ButtonWithMix extends StatelessWidget {
  const ButtonWithMix({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .height(60)
        .width(200)
        .color(Colors.blue)
        .borderRounded(30)
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.1),
          offset: Offset(0, 4),
          blurRadius: 10,
        )
        .animate(.easeInOut(300.ms))
        .onHovered(BoxStyler().color(Colors.blue.shade300))
        .onDark(
          BoxStyler()
              .color(Colors.grey.shade800)
              .onHovered(BoxStyler().color(Colors.blue.shade700)),
        );

    return PressableBox(
      style: style,
      onPress: () {},
      child: StyledText(
        'Click me',
        style: TextStyler()
            .color(Colors.white)
            .fontSize(16)
            .fontWeight(.w600)
            .animate(.easeInOut(300.ms))
            .onDark(TextStyler().color(Colors.black)),
      ),
    );
  }
}
