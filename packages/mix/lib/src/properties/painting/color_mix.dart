// ignore_for_file: avoid-commented-out-code

// import 'package:flutter/widgets.dart';

// import '../../core/modifier.dart';
// import '../../core/internal/color_values.dart';
// import '../../core/prop.dart';
// import '../../core/prop_source.dart';
// import '../../theme/tokens/mix_token.dart';

// /// A Mix-compatible wrapper for Color values that provides a fluent API
// /// for color transformations and token resolution.
// ///
// /// ColorProp allows you to work with colors in the Mix framework while
// /// maintaining support for tokens, modifiers, and merging operations.
// class ColorProp extends Prop<Color> {
//   static final red = ColorProp.value(ColorValues.red);
//   static final pink = ColorProp.value(ColorValues.pink);
//   static final purple = ColorProp.value(ColorValues.purple);
//   static final deepPurple = ColorProp.value(ColorValues.deepPurple);
//   static final indigo = ColorProp.value(ColorValues.indigo);
//   static final blue = ColorProp.value(ColorValues.blue);
//   static final lightBlue = ColorProp.value(ColorValues.lightBlue);
//   static final cyan = ColorProp.value(ColorValues.cyan);
//   static final teal = ColorProp.value(ColorValues.teal);
//   static final green = ColorProp.value(ColorValues.green);
//   static final lightGreen = ColorProp.value(ColorValues.lightGreen);
//   static final lime = ColorProp.value(ColorValues.lime);
//   static final yellow = ColorProp.value(ColorValues.yellow);
//   static final amber = ColorProp.value(ColorValues.amber);
//   static final orange = ColorProp.value(ColorValues.orange);
//   static final deepOrange = ColorProp.value(ColorValues.deepOrange);
//   static final brown = ColorProp.value(ColorValues.brown);
//   static final grey = ColorProp.value(ColorValues.grey);
//   static final blueGrey = ColorProp.value(ColorValues.blueGrey);
//   static final redAccent = ColorProp.value(ColorValues.redAccent);
//   static final pinkAccent = ColorProp.value(ColorValues.pinkAccent);
//   static final purpleAccent = ColorProp.value(ColorValues.purpleAccent);
//   static final deepPurpleAccent = ColorProp.value(ColorValues.deepPurpleAccent);
//   static final indigoAccent = ColorProp.value(ColorValues.indigoAccent);
//   static final blueAccent = ColorProp.value(ColorValues.blueAccent);
//   static final lightBlueAccent = ColorProp.value(ColorValues.lightBlueAccent);
//   static final cyanAccent = ColorProp.value(ColorValues.cyanAccent);
//   static final tealAccent = ColorProp.value(ColorValues.tealAccent);
//   static final greenAccent = ColorProp.value(ColorValues.greenAccent);
//   static final lightGreenAccent = ColorProp.value(ColorValues.lightGreenAccent);
//   static final limeAccent = ColorProp.value(ColorValues.limeAccent);
//   static final yellowAccent = ColorProp.value(ColorValues.yellowAccent);
//   static final amberAccent = ColorProp.value(ColorValues.amberAccent);
//   static final orangeAccent = ColorProp.value(ColorValues.orangeAccent);
//   static final deepOrangeAccent = ColorProp.value(ColorValues.deepOrangeAccent);
//   static final transparent = ColorProp.value(ColorValues.transparent);
//   static final black = ColorProp.value(ColorValues.black);
//   static final white = ColorProp.value(ColorValues.white);
//   static final black87 = ColorProp.value(ColorValues.black87);
//   static final black54 = ColorProp.value(ColorValues.black54);
//   static final black45 = ColorProp.value(ColorValues.black45);
//   static final black38 = ColorProp.value(ColorValues.black38);
//   static final black26 = ColorProp.value(ColorValues.black26);
//   static final black12 = ColorProp.value(ColorValues.black12);
//   static final white70 = ColorProp.value(ColorValues.white70);
//   static final white60 = ColorProp.value(ColorValues.white60);
//   static final white54 = ColorProp.value(ColorValues.white54);
//   static final white38 = ColorProp.value(ColorValues.white38);
//   static final white30 = ColorProp.value(ColorValues.white30);
//   static final white24 = ColorProp.value(ColorValues.white24);
//   static final white12 = ColorProp.value(ColorValues.white12);
//   static final white10 = ColorProp.value(ColorValues.white10);

//   const ColorProp.create({super.source, super.modifiers, super.animation})
//     : super.internal();

//   /// Creates a ColorMix from a color token.
//   factory ColorProp.token(MixToken<Color> token) {
//     return ColorProp.create(source: TokenPropSource(token));
//   }

//   /// Creates a ColorMix with a color modifier applied.
//   factory ColorProp.modifier(Modifier<Color> modifier) {
//     return ColorProp.create(modifiers: [modifier]);
//   }

//   factory ColorProp.value(Color color) {
//     return ColorProp.create(source: ValuePropSource(color));
//   }

//   /// Creates a ColorMix with an opacity modifier.
//   factory ColorProp.withOpacity(double opacity) {
//     return ColorProp.modifier(OpacityColorModifier(opacity));
//   }

//   /// Creates a ColorMix with an alpha modifier.
//   factory ColorProp.withAlpha(int alpha) {
//     return ColorProp.modifier(AlphaColorModifier(alpha));
//   }

//   /// Creates a ColorMix with a darken modifier.
//   factory ColorProp.darken(int amount) {
//     return ColorProp.modifier(DarkenColorModifier(amount));
//   }

//   /// Creates a ColorMix with a lighten modifier.
//   factory ColorProp.lighten(int amount) {
//     return ColorProp.modifier(LightenColorModifier(amount));
//   }

//   /// Creates a ColorMix with a saturate modifier.
//   factory ColorProp.saturate(int amount) {
//     return ColorProp.modifier(SaturateColorModifier(amount));
//   }

//   /// Creates a ColorMix with a desaturate modifier.
//   factory ColorProp.desaturate(int amount) {
//     return ColorProp.modifier(DesaturateColorModifier(amount));
//   }

//   /// Creates a ColorMix with a tint modifier.
//   factory ColorProp.tint(int amount) {
//     return ColorProp.modifier(TintColorModifier(amount));
//   }

//   /// Creates a ColorMix with a shade modifier.
//   factory ColorProp.shade(int amount) {
//     return ColorProp.modifier(ShadeColorModifier(amount));
//   }

//   /// Creates a ColorMix with a withRed modifier.
//   factory ColorProp.withRed(int red) {
//     return ColorProp.modifier(WithRedColorModifier(red));
//   }

//   /// Creates a ColorMix with a withGreen modifier.
//   factory ColorProp.withGreen(int green) {
//     return ColorProp.modifier(WithGreenColorModifier(green));
//   }

//   /// Creates a ColorMix with a withBlue modifier.
//   factory ColorProp.withBlue(int blue) {
//     return ColorProp.modifier(WithBlueColorModifier(blue));
//   }

//   /// Creates a ColorMix from a nullable Color value.
//   /// Returns null if the color is null, otherwise returns a ColorMix.
//   static ColorProp? maybeValue(Color? color) {
//     if (color == null) return null;

//     return ColorProp.value(color);
//   }

//   /// Merges this ColorMix with a color modifier.
//   ColorProp modifier(Modifier<Color> modifier) {
//     return merge(ColorProp.modifier(modifier));
//   }

//   ColorProp darken(int amount) {
//     return merge(ColorProp.darken(amount));
//   }

//   ColorProp lighten(int amount) {
//     return merge(ColorProp.lighten(amount));
//   }

//   ColorProp saturate(int amount) {
//     return merge(ColorProp.saturate(amount));
//   }

//   ColorProp desaturate(int amount) {
//     return merge(ColorProp.desaturate(amount));
//   }

//   ColorProp tint(int amount) {
//     return merge(ColorProp.tint(amount));
//   }

//   ColorProp shade(int amount) {
//     return merge(ColorProp.shade(amount));
//   }

//   ColorProp withOpacity(double opacity) {
//     return merge(ColorProp.withOpacity(opacity));
//   }

//   ColorProp withAlpha(int alpha) {
//     return merge(ColorProp.withAlpha(alpha));
//   }

//   ColorProp withToken(MixToken<Color> token) {
//     return merge(ColorProp.token(token));
//   }

//   @override
//   ColorProp merge(ColorProp? other) {
//     if (other == null) return this;

//     final merged = super.merge(other);

//     return ColorProp.create(
//       source: merged.source,
//       modifiers: merged.$modifiers,
//       animation: merged.$animation,
//     );
//   }
// }
