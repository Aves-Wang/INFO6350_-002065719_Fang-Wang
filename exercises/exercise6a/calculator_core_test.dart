import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/calculator_core.dart';

void main() {
  test('Addition works', () {
    expect(add(2, 3), 5);
  });

  test('Subtraction works', () {
    expect(subtract(5, 2), 3);
  });

  test('Multiplication works', () {
    expect(multiply(4, 5), 20);
  });

  test('Division works', () {
    expect(divide(6, 3), 2);
  });

  test('Division by zero throws error', () {
    expect(() => divide(4, 0), throwsA(isA<ArgumentError>()));
  });
}
