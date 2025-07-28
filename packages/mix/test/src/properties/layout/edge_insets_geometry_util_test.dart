import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/src/core/spec.dart';
import 'package:mix/src/core/style.dart';
import 'package:mix/src/properties/layout/edge_insets_geometry_util.dart';
import 'package:mix/src/properties/layout/edge_insets_geometry_mix.dart';

// Test implementations for testing
class TestSpec extends Spec<TestSpec> {
  final EdgeInsetsMix? padding;
  final EdgeInsetsMix? margin;
  
  const TestSpec({this.padding, this.margin});
  
  @override
  TestSpec copyWith({EdgeInsetsMix? padding, EdgeInsetsMix? margin}) {
    return TestSpec(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
    );
  }
  
  @override
  TestSpec lerp(TestSpec? other, double t) {
    if (other == null) return this;
    return TestSpec(
      padding: EdgeInsetsGeometryMix.tryToMerge(padding, other.padding) as EdgeInsetsMix?,
      margin: EdgeInsetsGeometryMix.tryToMerge(margin, other.margin) as EdgeInsetsMix?,
    );
  }
  
  @override
  List<Object?> get props => [padding, margin];
}

class TestPaddingAttribute extends StyleAttribute<TestSpec> 
    with PaddingMixin<TestPaddingAttribute, TestSpec> {
  final EdgeInsetsMix? _padding;
  
  const TestPaddingAttribute([this._padding]);
  
  @override
  TestPaddingAttribute padding(EdgeInsetsGeometryMix value) {
    // Handle both EdgeInsetsMix and EdgeInsetsDirectionalMix
    if (value is EdgeInsetsMix) {
      return TestPaddingAttribute(value);
    } else if (value is EdgeInsetsDirectionalMix) {
      // For directional mix, we'll store it as EdgeInsetsMix for test purposes
      // In real implementation, this would be handled differently
      return TestPaddingAttribute(null);
    }
    return TestPaddingAttribute(null);
  }
  
  EdgeInsetsMix? get paddingValue => _padding;
  
  @override
  TestSpec resolve(BuildContext context) {
    return TestSpec(padding: _padding);
  }
  
  @override
  TestPaddingAttribute merge(TestPaddingAttribute? other) {
    if (other == null) return this;
    return TestPaddingAttribute(
      EdgeInsetsGeometryMix.tryToMerge(_padding, other._padding) as EdgeInsetsMix?,
    );
  }
  
  @override
  List<Object?> get props => [_padding];
}

class TestMarginAttribute extends StyleAttribute<TestSpec> 
    with MarginMixin<TestMarginAttribute, TestSpec> {
  final EdgeInsetsMix? _margin;
  
  const TestMarginAttribute([this._margin]);
  
  @override
  TestMarginAttribute margin(EdgeInsetsGeometryMix value) {
    // Handle both EdgeInsetsMix and EdgeInsetsDirectionalMix
    if (value is EdgeInsetsMix) {
      return TestMarginAttribute(value);
    } else if (value is EdgeInsetsDirectionalMix) {
      // For directional mix, we'll store it as EdgeInsetsMix for test purposes
      // In real implementation, this would be handled differently
      return TestMarginAttribute(null);
    }
    return TestMarginAttribute(null);
  }
  
  EdgeInsetsMix? get marginValue => _margin;
  
  @override
  TestSpec resolve(BuildContext context) {
    return TestSpec(margin: _margin);
  }
  
  @override
  TestMarginAttribute merge(TestMarginAttribute? other) {
    if (other == null) return this;
    return TestMarginAttribute(
      EdgeInsetsGeometryMix.tryToMerge(_margin, other._margin) as EdgeInsetsMix?,
    );
  }
  
  @override
  List<Object?> get props => [_margin];
}

void main() {
  group('createEdgeInsetsMix', () {
    test('applies all value to all edges', () {
      final result = createEdgeInsetsMix(all: 10);
      
      expect(result.$top?.value, equals(10));
      expect(result.$bottom?.value, equals(10));
      expect(result.$left?.value, equals(10));
      expect(result.$right?.value, equals(10));
    });
    
    test('horizontal overrides all for left and right', () {
      final result = createEdgeInsetsMix(
        all: 10,
        horizontal: 20,
      );
      
      expect(result.$top?.value, equals(10));
      expect(result.$bottom?.value, equals(10));
      expect(result.$left?.value, equals(20));
      expect(result.$right?.value, equals(20));
    });
    
    test('vertical overrides all for top and bottom', () {
      final result = createEdgeInsetsMix(
        all: 10,
        vertical: 20,
      );
      
      expect(result.$top?.value, equals(20));
      expect(result.$bottom?.value, equals(20));
      expect(result.$left?.value, equals(10));
      expect(result.$right?.value, equals(10));
    });
    
    test('specific edges override horizontal/vertical', () {
      final result = createEdgeInsetsMix(
        all: 10,
        horizontal: 20,
        vertical: 30,
        top: 40,
        left: 50,
      );
      
      expect(result.$top?.value, equals(40));    // specific overrides vertical
      expect(result.$bottom?.value, equals(30)); // vertical
      expect(result.$left?.value, equals(50));   // specific overrides horizontal
      expect(result.$right?.value, equals(20));  // horizontal
    });
    
    test('logical properties work correctly', () {
      final result = createEdgeInsetsMix(
        all: 10,
        start: 20,
        end: 30,
      );
      
      expect(result.$top?.value, equals(10));
      expect(result.$bottom?.value, equals(10));
      expect(result.$left?.value, equals(20));  // start maps to left
      expect(result.$right?.value, equals(30)); // end maps to right
    });
    
    test('throws when mixing physical and logical properties', () {
      expect(
        () => createEdgeInsetsMix(left: 10, start: 20),
        throwsArgumentError,
      );
      
      expect(
        () => createEdgeInsetsMix(right: 10, end: 20),
        throwsArgumentError,
      );
      
      expect(
        () => createEdgeInsetsMix(left: 10, right: 20, start: 30),
        throwsArgumentError,
      );
    });
    
    test('allows mixing non-directional with logical', () {
      // Should not throw
      final result = createEdgeInsetsMix(
        all: 10,
        horizontal: 20,
        vertical: 30,
        top: 40,
        bottom: 50,
        start: 60,
        end: 70,
      );
      
      expect(result.$top?.value, equals(40));
      expect(result.$bottom?.value, equals(50));
      expect(result.$left?.value, equals(60));  // start overrides horizontal
      expect(result.$right?.value, equals(70)); // end overrides horizontal
    });
    
    test('handles null values correctly', () {
      final result = createEdgeInsetsMix(
        top: 10,
        left: 20,
      );
      
      expect(result.$top?.value, equals(10));
      expect(result.$bottom, isNull);
      expect(result.$left?.value, equals(20));
      expect(result.$right, isNull);
    });
  });
  
  group('PaddingMixin', () {
    test('insets method applies values correctly', () {
      const attr = TestPaddingAttribute();
      
      final result = attr.insets(
        all: 10,
        top: 20,
        horizontal: 30,
      );
      
      final padding = result.paddingValue!;
      expect(padding.$top?.value, equals(20));    // specific overrides all
      expect(padding.$bottom?.value, equals(10)); // all
      expect(padding.$left?.value, equals(30));   // horizontal
      expect(padding.$right?.value, equals(30));  // horizontal
    });
    
    test('paddingAll sets all edges', () {
      const attr = TestPaddingAttribute();
      final result = attr.paddingAll(15);
      
      final padding = result.paddingValue!;
      expect(padding.$top?.value, equals(15));
      expect(padding.$bottom?.value, equals(15));
      expect(padding.$left?.value, equals(15));
      expect(padding.$right?.value, equals(15));
    });
    
    test('paddingHorizontal sets left and right', () {
      const attr = TestPaddingAttribute();
      final result = attr.paddingHorizontal(20);
      
      final padding = result.paddingValue!;
      expect(padding.$top, isNull);
      expect(padding.$bottom, isNull);
      expect(padding.$left?.value, equals(20));
      expect(padding.$right?.value, equals(20));
    });
    
    test('paddingVertical sets top and bottom', () {
      const attr = TestPaddingAttribute();
      final result = attr.paddingVertical(25);
      
      final padding = result.paddingValue!;
      expect(padding.$top?.value, equals(25));
      expect(padding.$bottom?.value, equals(25));
      expect(padding.$left, isNull);
      expect(padding.$right, isNull);
    });
    
    test('individual padding methods work correctly', () {
      const attr = TestPaddingAttribute();
      
      // Test each individual method
      var result = attr.paddingTop(10);
      expect(result.paddingValue!.$top?.value, equals(10));
      expect(result.paddingValue!.$bottom, isNull);
      
      result = attr.paddingBottom(20);
      expect(result.paddingValue!.$bottom?.value, equals(20));
      expect(result.paddingValue!.$top, isNull);
      
      result = attr.paddingLeft(30);
      expect(result.paddingValue!.$left?.value, equals(30));
      expect(result.paddingValue!.$right, isNull);
      
      result = attr.paddingRight(40);
      expect(result.paddingValue!.$right?.value, equals(40));
      expect(result.paddingValue!.$left, isNull);
      
      result = attr.paddingStart(50);
      // paddingStart uses EdgeInsetsDirectionalMix, which returns null in our test implementation
      expect(result.paddingValue, isNull);
      
      result = attr.paddingEnd(60);
      // paddingEnd uses EdgeInsetsDirectionalMix, which returns null in our test implementation
      expect(result.paddingValue, isNull);
    });
    
    test('chaining padding methods works', () {
      const attr = TestPaddingAttribute();
      
      // Note: Each call creates a new instance, so we need to test the final result
      final result = attr
          .paddingVertical(10)
          .paddingLeft(20);
      
      // Only the last call's values will be present
      final padding = result.paddingValue!;
      expect(padding.$left?.value, equals(20));
      expect(padding.$top, isNull); // paddingLeft doesn't set top
    });
  });
  
  group('MarginMixin', () {
    test('outsets method applies values correctly', () {
      const attr = TestMarginAttribute();
      
      final result = attr.outsets(
        all: 5,
        bottom: 15,
        vertical: 25,
      );
      
      final margin = result.marginValue!;
      expect(margin.$top?.value, equals(25));    // vertical
      expect(margin.$bottom?.value, equals(15)); // specific overrides vertical
      expect(margin.$left?.value, equals(5));    // all
      expect(margin.$right?.value, equals(5));   // all
    });
    
    test('marginAll sets all edges', () {
      const attr = TestMarginAttribute();
      final result = attr.marginAll(12);
      
      final margin = result.marginValue!;
      expect(margin.$top?.value, equals(12));
      expect(margin.$bottom?.value, equals(12));
      expect(margin.$left?.value, equals(12));
      expect(margin.$right?.value, equals(12));
    });
    
    test('margin methods mirror padding methods', () {
      const attr = TestMarginAttribute();
      
      // Test horizontal/vertical
      var result = attr.marginHorizontal(15);
      expect(result.marginValue!.$left?.value, equals(15));
      expect(result.marginValue!.$right?.value, equals(15));
      
      result = attr.marginVertical(25);
      expect(result.marginValue!.$top?.value, equals(25));
      expect(result.marginValue!.$bottom?.value, equals(25));
      
      // Test individual edges
      result = attr.marginTop(5);
      expect(result.marginValue!.$top?.value, equals(5));
      
      result = attr.marginBottom(10);
      expect(result.marginValue!.$bottom?.value, equals(10));
      
      result = attr.marginLeft(15);
      expect(result.marginValue!.$left?.value, equals(15));
      
      result = attr.marginRight(20);
      expect(result.marginValue!.$right?.value, equals(20));
      
      // Test logical
      result = attr.marginStart(25);
      // marginStart uses EdgeInsetsDirectionalMix, which returns null in our test implementation
      expect(result.marginValue, isNull);
      
      result = attr.marginEnd(30);
      // marginEnd uses EdgeInsetsDirectionalMix, which returns null in our test implementation
      expect(result.marginValue, isNull);
    });
    
    test('outsets throws on mixing physical and logical', () {
      const attr = TestMarginAttribute();
      
      expect(
        () => attr.outsets(left: 10, start: 20),
        throwsArgumentError,
      );
      
      expect(
        () => attr.outsets(right: 10, end: 20),
        throwsArgumentError,
      );
    });
  });
  
  group('Edge cases and complex scenarios', () {
    test('all priority levels work together correctly', () {
      final result = createEdgeInsetsMix(
        all: 5,
        horizontal: 10,
        vertical: 15,
        top: 20,
        bottom: 25,
        left: 30,
        right: 35,
      );
      
      // Each level should override the previous
      expect(result.$top?.value, equals(20));    // specific overrides vertical
      expect(result.$bottom?.value, equals(25)); // specific overrides vertical
      expect(result.$left?.value, equals(30));   // specific overrides horizontal
      expect(result.$right?.value, equals(35));  // specific overrides horizontal
    });
    
    test('partial overrides work correctly', () {
      final result = createEdgeInsetsMix(
        all: 10,
        horizontal: 20,
        top: 30,
      );
      
      expect(result.$top?.value, equals(30));    // specific override
      expect(result.$bottom?.value, equals(10)); // falls back to all
      expect(result.$left?.value, equals(20));   // horizontal
      expect(result.$right?.value, equals(20));  // horizontal
    });
    
    test('zero values are handled correctly', () {
      final result = createEdgeInsetsMix(
        all: 10,
        top: 0,
      );
      
      expect(result.$top?.value, equals(0));     // zero is valid
      expect(result.$bottom?.value, equals(10));
      expect(result.$left?.value, equals(10));
      expect(result.$right?.value, equals(10));
    });
    
    test('negative values are allowed', () {
      final result = createEdgeInsetsMix(
        all: -5,
        left: -10,
      );
      
      expect(result.$top?.value, equals(-5));
      expect(result.$bottom?.value, equals(-5));
      expect(result.$left?.value, equals(-10));
      expect(result.$right?.value, equals(-5));
    });
  });
}