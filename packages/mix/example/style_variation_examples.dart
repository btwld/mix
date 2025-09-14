import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

/// Modern StyleVariation examples showcasing elegant patterns.

class OutlinedButton extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'outlined';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
    // Base styling with size variants
    var result = switch (activeVariants) {
      _ when hasVariant(activeVariants, small) => style
          .border(color: Colors.grey.shade400, width: 1.0)
          .borderRadius(6.0)
          .padding(horizontal: 12.0, vertical: 6.0),
      _ when hasVariant(activeVariants, large) => style
          .border(color: Colors.grey.shade400, width: 1.0)
          .borderRadius(12.0)
          .padding(horizontal: 24.0, vertical: 12.0),
      _ => style
          .border(color: Colors.grey.shade400, width: 1.0)
          .borderRadius(8.0)
          .padding(horizontal: 16.0, vertical: 8.0),
    };
    
    // Semantic color adaptations
    result = switch (activeVariants) {
      _ when hasVariant(activeVariants, primary) => result.border(color: Colors.blue.shade600, width: 1.5),
      _ when hasVariant(activeVariants, secondary) => result.border(color: Colors.grey.shade600, width: 1.0),
      _ => result,
    };
    
    // Complex combinations using tuple pattern matching
    return switch ((hasVariant(activeVariants, small), hasVariant(activeVariants, primary))) {
      (true, true) => result.border(color: Colors.blue.shade700, width: 2.0).borderRadius(4.0),
      _ => result,
    };
  }
}

class SolidButton extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'solid';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
    // Base styling with size adaptations
    var result = switch (activeVariants) {
      _ when hasVariant(activeVariants, small) => style
          .color(Colors.grey.shade200)
          .borderRadius(6.0)
          .padding(horizontal: 12.0, vertical: 6.0),
      _ when hasVariant(activeVariants, large) => style
          .color(Colors.grey.shade200)
          .borderRadius(12.0)
          .padding(horizontal: 24.0, vertical: 12.0),
      _ => style
          .color(Colors.grey.shade200)
          .borderRadius(8.0)
          .padding(horizontal: 16.0, vertical: 8.0),
    };
    
    // Semantic color adaptations
    result = switch (activeVariants) {
      _ when hasVariant(activeVariants, primary) => result.color(Colors.blue.shade600),
      _ when hasVariant(activeVariants, secondary) => result.color(Colors.grey.shade500),
      _ when hasVariant(activeVariants, danger) => result.color(Colors.red.shade600),
      _ => result,
    };
    
    // Complex combinations for emphasis
    return switch ((hasVariant(activeVariants, large), hasVariant(activeVariants, danger))) {
      (true, true) => result.color(Colors.red.shade800),
      _ => result,
    };
  }
}

class SmallSize extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'small';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) =>
    switch (activeVariants) {
      _ when hasVariant(activeVariants, outlined) => style.padding(horizontal: 6.0, vertical: 3.0).height(28.0),
      _ when hasVariant(activeVariants, solid) => style.padding(horizontal: 10.0, vertical: 4.0).height(32.0),
      _ => style.padding(horizontal: 8.0, vertical: 4.0).height(28.0),
    };
}

class LargeSize extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'large';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) =>
    switch (activeVariants) {
      _ when hasVariant(activeVariants, outlined) => style.padding(horizontal: 28.0, vertical: 14.0).height(56.0).borderRadius(12.0),
      _ when hasVariant(activeVariants, solid) => style.padding(horizontal: 36.0, vertical: 18.0).height(60.0).borderRadius(16.0),
      _ => style.padding(horizontal: 32.0, vertical: 16.0).height(56.0),
    };
}

class GhostButton extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'ghost';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
    // Base styling with size adaptations
    var result = switch (activeVariants) {
      _ when hasVariant(activeVariants, small) => style.color(Colors.transparent).borderRadius(4.0).padding(horizontal: 4.0, vertical: 2.0),
      _ when hasVariant(activeVariants, large) => style.color(Colors.transparent).borderRadius(4.0).padding(horizontal: 16.0, vertical: 8.0),
      _ => style.color(Colors.transparent).borderRadius(4.0).padding(horizontal: 8.0, vertical: 4.0),
    };
    
    // Subtle semantic tinting
    return switch (activeVariants) {
      _ when hasVariant(activeVariants, primary) => result.color(Colors.blue.shade50),
      _ when hasVariant(activeVariants, danger) => result.color(Colors.red.shade50),
      _ => result,
    };
  }
}

/// Design system showcasing modern StyleVariation patterns.
class ButtonSystem {
  static final outlined = OutlinedButton();
  static final solid = SolidButton();
  static final ghost = GhostButton();
  static final smallSize = SmallSize();
  static final largeSize = LargeSize();
}

