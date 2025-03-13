import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = "0";
  String _result = "";
  bool _shouldResetInput = false;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          // Display
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: theme.scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _result,
                    style: TextStyle(
                      fontSize: 24,
                      color: theme.brightness == Brightness.dark ? Colors.grey : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _input,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Buttons
          Container(
            color: theme.brightness == Brightness.dark ? const Color(0xFF1C1C1C) : const Color(0xFFF2F2F2),
            child: Column(
              children: [
                buildButtonRow(['C', '+/-', '%', '÷']),
                buildButtonRow(['7', '8', '9', '×']),
                buildButtonRow(['4', '5', '6', '-']),
                buildButtonRow(['1', '2', '3', '+']),
                buildButtonRow(['0', '.', '=']),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget buildButtonRow(List<String> buttons) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;
    
    return Row(
      children: buttons.map((buttonText) {
        // Determine button style based on the text
        Color buttonColor;
        Color textColor;
        
        if (buttonText == 'C' || buttonText == '+/-' || buttonText == '%') {
          buttonColor = isLightMode ? const Color(0xFFD6D6D6) : const Color(0xFF323232);
          textColor = isLightMode ? Colors.black : Colors.white;
        } else if (buttonText == '÷' || buttonText == '×' || buttonText == '-' || buttonText == '+' || buttonText == '=') {
          buttonColor = Colors.orange;
          textColor = Colors.white;
        } else {
          buttonColor = isLightMode ? const Color(0xFFEAEAEA) : const Color(0xFF505050);
          textColor = isLightMode ? Colors.black : Colors.white;
        }
        
        // Create wider button for zero
        double width = buttonText == '0' ? 2 : 1;
        
        return Expanded(
          flex: width.toInt(),
          child: Container(
            margin: const EdgeInsets.all(1),
            child: ElevatedButton(
              onPressed: () => _onButtonPressed(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(vertical: 24),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  void _onButtonPressed(String buttonText) {
    setState(() {
      switch (buttonText) {
        case 'C':
          _input = "0";
          _result = "";
          break;
        case '+/-':
          if (_input.startsWith('-')) {
            _input = _input.substring(1);
          } else if (_input != "0") {
            _input = "-$_input";
          }
          break;
        case '%':
          double value = double.tryParse(_input) ?? 0;
          _input = (value / 100).toString();
          break;
        case '=':
          _calculateResult();
          _result = _input;
          _input = "0";
          _shouldResetInput = true;
          break;
        case '.':
          if (!_input.contains('.')) {
            _input = '$_input.';
          }
          break;
        case '+':
        case '-':
        case '×':
        case '÷':
          // Add operator to the result
          _result = '$_input $buttonText';
          _shouldResetInput = true;
          break;
        default:
          // Handle number inputs
          if (_input == "0" || _shouldResetInput) {
            _input = buttonText;
            _shouldResetInput = false;
          } else {
            _input += buttonText;
          }
      }
    });
  }
  
  void _calculateResult() {
    // Simple implementation for demonstration
    if (_result.isEmpty) return;
    
    final parts = _result.split(' ');
    if (parts.length >= 2) {
      final num1 = double.tryParse(parts[0]) ?? 0;
      final operator = parts[1];
      final num2 = double.tryParse(_input) ?? 0;
      
      switch (operator) {
        case '+':
          _input = (num1 + num2).toString();
          break;
        case '-':
          _input = (num1 - num2).toString();
          break;
        case '×':
          _input = (num1 * num2).toString();
          break;
        case '÷':
          _input = num2 != 0 ? (num1 / num2).toString() : 'Error';
          break;
      }
      
      // Remove trailing .0 if result is an integer
      if (_input.endsWith('.0')) {
        _input = _input.substring(0, _input.length - 2);
      }
    }
  }
}
