import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/internal/internal_extensions.dart';

void main() {
  group('ChangeCase - _groupWords', () {
    final cases = {
      'HelloWorld': ['Hello', 'World'],
      'Hello_World': ['Hello', 'World'],
      'Hello-World': ['Hello', 'World'],
      'Hello World': ['Hello', 'World'],
      'helloWorld': ['hello', 'World'],
      'HELLOWORLD': ['HELLOWORLD'],
      'HELLO_WORLD': ['HELLO', 'WORLD'],
      'HELLO-WORLD': ['HELLO', 'WORLD'],
      'HELLO WORLD': ['HELLO', 'WORLD'],
      'HelloWorldHello': ['Hello', 'World', 'Hello'],
      '': [], // Edge case: Empty string
      'hello': ['hello'], // Single word
      'Hello': ['Hello'], // Single capitalized word
      'HELLO': ['HELLO'], // Single uppercase word
      '12345': ['12345'], // Numbers
      'hello123World': ['hello123', 'World'], // Mix of numbers and letters
      '!@#\$%^&*()': ['!@#\$%^&*()'], // Special characters only
      'Hello!World': [
        'Hello!',
        'World',
      ], // Words separated by a non-standard separator
    };

    cases.forEach((input, expectedOutput) {
      test('should group words for input: $input', () {
        expect(input.words, expectedOutput);
      });
    });

    final paramCases = {
      'HelloWorld': 'hello-world',
      'Hello_World': 'hello-world',
      'Hello-World': 'hello-world',
      'Hello World': 'hello-world',
      'helloWorld': 'hello-world',
      'HELLOWORLD': 'helloworld',
      'HELLO_WORLD': 'hello-world',
      'HELLO-WORLD': 'hello-world',
      'HELLO WORLD': 'hello-world',
      'HelloWorldHello': 'hello-world-hello',
      '': '', // Edge case: Empty string
      'hello': 'hello', // Single word
      'Hello': 'hello', // Single capitalized word
      'HELLO': 'hello', // Single uppercase word
      '12345': '12345', // Numbers
      'hello123World': 'hello123-world', // Mix of numbers and letters
      '!@#\$%^&*()': '!@#\$%^&*()', // Special characters only
      'Hello!World':
          'hello!-world', // Words separated by a non-standard separator
    };

    paramCases.forEach((input, expectedOutput) {
      test('should convert to paramCase for input: $input', () {
        expect(input.paramCase, expectedOutput);
      });
    });

    final pascalCases = {
      'HelloWorld': 'HelloWorld',
      'Hello_World': 'HelloWorld',
      'Hello-World': 'HelloWorld',
      'Hello World': 'HelloWorld',
      'helloWorld': 'HelloWorld',
      'HELLOWORLD': 'Helloworld',
      'HELLO_WORLD': 'HelloWorld',
      'HELLO-WORLD': 'HelloWorld',
      'HELLO WORLD': 'HelloWorld',
      'HelloWorldHello': 'HelloWorldHello',
      '': '', // Edge case: Empty string
      'hello': 'Hello', // Single word
      'Hello': 'Hello', // Single capitalized word
      'HELLO': 'Hello', // Single uppercase word
      '12345': '12345', // Numbers
      'hello123World': 'Hello123World', // Mix of numbers and letters
      '!@#\$%^&*()': '!@#\$%^&*()', // Special characters only
      'Hello!World':
          'Hello!World', // Words separated by a non-standard separator
    };

    pascalCases.forEach((input, expectedOutput) {
      test('should convert to PascalCase for input: $input', () {
        expect(input.pascalCase, expectedOutput);
      });
    });

    final camelCases = {
      'HelloWorld': 'helloWorld',
      'Hello_World': 'helloWorld',
      'Hello-World': 'helloWorld',
      'Hello World': 'helloWorld',
      'helloWorld': 'helloWorld',
      'HELLOWORLD': 'helloworld',
      'HELLO_WORLD': 'helloWorld',
      'HELLO-WORLD': 'helloWorld',
      'HELLO WORLD': 'helloWorld',
      'HelloWorldHello': 'helloWorldHello',
      '': '', // Edge case: Empty string
      'hello': 'hello', // Single word
      'Hello': 'hello', // Single capitalized word
      'HELLO': 'hello', // Single uppercase word
      '12345': '12345', // Numbers
      'hello123World': 'hello123World', // Mix of numbers and letters
      '!@#\$%^&*()': '!@#\$%^&*()', // Special characters only
      'Hello!World':
          'hello!World', // Words separated by a non-standard separator
    };

    camelCases.forEach((input, expectedOutput) {
      test('should convert to camelCase for input: $input', () {
        expect(input.camelCase, expectedOutput);
      });
    });
  });
}
