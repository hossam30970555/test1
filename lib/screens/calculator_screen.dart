import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _result = '0';
  String _operation = '';
  String _firstOperand = '';
  bool _isNewOperation = true;
  List<String> _history = [];

  void _addDigit(String digit) {
    setState(() {
      if (_isNewOperation) {
        _input = digit;
        _isNewOperation = false;
      } else {
        _input += digit;
      }
    });
  }

  void _addDecimalPoint() {
    setState(() {
      if (_isNewOperation) {
        _input = '0.';
        _isNewOperation = false;
      } else if (!_input.contains('.')) {
        _input += '.';
      }
    });
  }

  void _setOperation(String operation) {
    setState(() {
      if (_input.isNotEmpty) {
        _firstOperand = _input;
        _operation = operation;
        _isNewOperation = true;
      } else if (_result != '0') {
        _firstOperand = _result;
        _operation = operation;
        _isNewOperation = true;
      }
    });
  }

  void _calculateResult() {
    if (_operation.isEmpty || _firstOperand.isEmpty || _input.isEmpty) return;

    double result;
    double firstOperand = double.parse(_firstOperand);
    double secondOperand = double.parse(_input);

    switch (_operation) {
      case '+':
        result = firstOperand + secondOperand;
        break;
      case '-':
        result = firstOperand - secondOperand;
        break;
      case '×':
        result = firstOperand * secondOperand;
        break;
      case '÷':
        result = firstOperand / secondOperand;
        break;
      case '^':
        result = pow(firstOperand, secondOperand).toDouble();
        break;
      default:
        return;
    }

    String calculation = '$_firstOperand $_operation $_input = ${result.toString()}';
    
    setState(() {
      _result = result.toString();
      if (_result.endsWith('.0')) {
        _result = _result.substring(0, _result.length - 2);
      }
      _input = '';
      _firstOperand = '';
      _operation = '';
      _isNewOperation = true;
      _history.add(calculation);
    });
  }

  void _clear() {
    setState(() {
      _input = '';
      _result = '0';
      _operation = '';
      _firstOperand = '';
      _isNewOperation = true;
    });
  }

  void _clearHistory() {
    setState(() {
      _history = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // History section
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            _history[_history.length - index - 1],
                            style: const TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                  if (_history.isNotEmpty)
                    TextButton(
                      onPressed: _clearHistory,
                      child: const Text('Clear History'),
                    ),
                ],
              ),
            ),
          ),
          
          // Display section
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _input.isEmpty ? _result : _input,
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_operation.isNotEmpty)
                  Text(
                    '$_firstOperand $_operation',
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          
          // Buttons section
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  _buildButtonRow(['7', '8', '9', '÷']),
                  _buildButtonRow(['4', '5', '6', '×']),
                  _buildButtonRow(['1', '2', '3', '-']),
                  _buildButtonRow(['0', '.', '=', '+']),
                  _buildButtonRow(['C', '±', '^', '√']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((button) => _buildButton(button)).toList(),
      ),
    );
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(text),
            foregroundColor: _isOperator(text) ? Colors.white : Colors.black,
          ),
          onPressed: () => _handleButtonPress(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(String text) {
    if (text == '=') return Colors.blue;
    if (text == 'C') return Colors.red.shade200;
    if (_isOperator(text)) return Colors.orange.shade300;
    return Colors.white;
  }

  bool _isOperator(String text) {
    return text == '+' || text == '-' || text == '×' || text == '÷' || text == '^' || text == '√';
  }

  void _handleButtonPress(String text) {
    switch (text) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        _addDigit(text);
        break;
      case '.':
        _addDecimalPoint();
        break;
      case '+':
      case '-':
      case '×':
      case '÷':
      case '^':
        _setOperation(text);
        break;
      case '=':
        _calculateResult();
        break;
      case 'C':
        _clear();
        break;
      case '±':
        setState(() {
          if (_input.isNotEmpty && _input != '0') {
            if (_input.startsWith('-')) {
              _input = _input.substring(1);
            } else {
              _input = '-' + _input;
            }
          } else if (_result != '0') {
            _input = _result.startsWith('-') 
                ? _result.substring(1) 
                : '-' + _result;
            _result = '0';
            _isNewOperation = false;
          }
        });
        break;
      case '√':
        setState(() {
          double value = _input.isNotEmpty 
              ? double.parse(_input) 
              : double.parse(_result);
          
          if (value < 0) {
            _result = 'Error';
          } else {
            double sqrtResult = sqrt(value);
            _result = sqrtResult.toString();
            if (_result.endsWith('.0')) {
              _result = _result.substring(0, _result.length - 2);
            }
            _history.add('√$value = $_result');
          }
          
          _input = '';
          _firstOperand = '';
          _operation = '';
          _isNewOperation = true;
        });
        break;
    }
  }
}
