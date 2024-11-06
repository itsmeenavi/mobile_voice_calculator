import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  String parseCommand(String command) {
    if (command.isEmpty) {
      return "I didn't hear anything. Please try again.";
    }

    // Supported operations
    Map<String, String> operations = {
      'add': '+',
      'plus': '+',
      'subtract': '-',
      'minus': '-',
      'multiply': '*',
      'times': '*',
      'divide': '/',
      'divided by': '/',
    };

    // Replace words with operators
    operations.forEach((word, operator) {
      command = command.replaceAll(word, operator);
    });

    // Remove any non-math words (e.g., 'what is', 'calculate')
    command = command.replaceAll(RegExp(r'[^0-9+\-*/(). ]'), '');

    try {
      Parser parser = Parser();
      Expression exp = parser.parse(command);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      if (eval % 1 == 0) {
        return "The result is ${eval.toInt()}";
      } else {
        return "The result is ${eval.toStringAsFixed(2)}";
      }
    } catch (e) {
      return "Sorry, I could not perform that calculation.";
    }
  }
}
