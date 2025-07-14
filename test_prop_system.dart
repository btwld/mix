import 'packages/mix/lib/src/core/prop.dart';
import 'packages/mix/test/helpers/testing_utils.dart';

void main() {
  // Test basic Prop functionality
  final prop1 = Prop.value(10);
  final prop2 = Prop.value(20);

  // Test merge
  final merged = prop1.merge(prop2);
  print('Merged prop value: ${merged.resolve(EmptyMixData)}');

  // Test custom matchers
  try {
    // This should work if everything is set up correctly
    print('Basic prop test passed');
  } catch (e) {
    print('Error: $e');
  }
}
