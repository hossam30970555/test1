import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(CupertinoIcons.clock, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.black.withOpacity(0.9),
                  context: context,
                  builder: (context) => _buildHistorySheet(),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Display section
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_operation.isNotEmpty)
                    Text(
                      '$_firstOperand $_operation',
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _input.isEmpty ? _result : _input,
                    style: TextStyle(
                      fontSize: 64.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Buttons section
          Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                _buildButtonRow(['C', '±', '%', '÷']),
                _buildButtonRow(['7', '8', '9', '×']),
                _buildButtonRow(['4', '5', '6', '-']),
                _buildButtonRow(['1', '2', '3', '+']),
                _buildButtonRow(['0', '.', '^', '=']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySheet() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'History',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _history.clear();
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _history[_history.length - index - 1],
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    // Optionally, allow reusing previous calculations
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((button) => _buildButton(button)).toList(),
      ),
    );
  }

  Widget _buildButton(String text) {
    final double buttonSize = MediaQuery.of(context).size.width * 0.2;
    final bool isZeroButton = text == '0';
    final double buttonWidth = isZeroButton ? buttonSize * 2 + 10 : buttonSize;
    
    return Container(
      width: buttonWidth,
      height: buttonSize,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(text),
          foregroundColor: _getButtonTextColor(text),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonSize / 2),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () => _handleButtonPress(text),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(String text) {
    if (text == 'C' || text == '±' || text == '%') {
      return const Color(0xFFA5A5A5); // Light gray
    } else if (_isOperator(text) || text == '=') {
      return const Color(0xFFFF9F0A); // Orange
    } else {
      return const Color(0xFF333333); // Dark gray
    }
  }

  Color _getButtonTextColor(String text) {
    if (text == 'C' || text == '±' || text == '%') {
      return Colors.black;
    } else {
      return Colors.white;
    }
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
