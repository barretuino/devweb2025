import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF1C1C1C), // Cor de fundo escura
        brightness: Brightness.dark, // Tema escuro
      ),
      home: const Calculator(),
    );
  }
}

// --------------------------------------------------
// 2. O Widget da Tela da Calculadora (Lógica e UI)
// --------------------------------------------------

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0"; // O número atual exibido na tela
  String _currentOperation = ""; // A operação completa para o display
  double _num1 = 0.0;
  String _operator = ""; // O operador (+, -, x, /)
  bool _shouldClearDisplay = false; // Flag para limpar o display ao digitar um novo número

  // Lógica de manipulação de botão
  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        // Limpar tudo
        _output = "0";
        _currentOperation = "";
        _num1 = 0.0;
        _operator = "";
        _shouldClearDisplay = false;
      } else if (buttonText == 'DEL') {
        // Deletar o último dígito
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
      } else if (buttonText == '.') {
        // Adicionar ponto decimal
        if (!_output.contains('.')) {
          _output += buttonText;
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == 'x' || buttonText == '/') {
        // Operadores
        if (_operator.isNotEmpty && !_shouldClearDisplay) {
            _calculate(); // Calcula o resultado intermediário se houver uma operação pendente
        }
        _num1 = double.parse(_output);
        _operator = buttonText;
        _currentOperation = _output + " " + _operator + " ";
        _shouldClearDisplay = true;
      } else if (buttonText == '=') {
        // Calcular resultado final
        if (_operator.isNotEmpty) {
          _calculate();
          _operator = "";
          _currentOperation = _output;
        }
        _shouldClearDisplay = true;
      } else {
        // Números
        if (_output == "0" || _shouldClearDisplay) {
          _output = buttonText;
          _shouldClearDisplay = false;
        } else {
          _output += buttonText;
        }
        
        // Atualiza a operação atual para o display auxiliar
        if (_operator.isNotEmpty) {
          // Atualiza o segundo número na string de operação
          String secondNum = _output;
          _currentOperation = "${_num1.toString().replaceAll(RegExp(r'\.0*$'), '')} $_operator $secondNum";
        } else {
          // Apenas o primeiro número
           _currentOperation = _output;
        }
      }
      
      // Remove o ".0" para números inteiros no display final
      if (_output.endsWith('.0') && _output.length > 2) {
         _output = _output.substring(0, _output.length - 2);
      }
    });
  }

  // Lógica de cálculo
  void _calculate() {
    double num2 = double.parse(_output);
    double result = 0.0;

    switch (_operator) {
      case '+':
        result = _num1 + num2;
        break;
      case '-':
        result = _num1 - num2;
        break;
      case 'x':
        result = _num1 * num2;
        break;
      case '/':
        if (num2 != 0) {
          result = _num1 / num2;
        } else {
          _output = "Erro";
          _currentOperation = "Divisão por zero";
          _num1 = 0.0;
          return;
        }
        break;
      default:
        return;
    }

    // Atualiza o display com o resultado, removendo o ".0" se for um inteiro
    String resultString = result.toString();
    if (resultString.endsWith('.0')) {
      _output = resultString.substring(0, resultString.length - 2);
    } else {
      // Limita as casas decimais para evitar números muito longos
      _output = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 4).replaceAll(RegExp(r'\.0*$'), '');
    }
    
    // Configura o próximo passo
    _num1 = result;
    _shouldClearDisplay = true;
  }

  // Cria um widget de linha para os botões
  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((buttonText) {
          // Define cores específicas para operadores e botões de controle
          Color buttonColor = const Color(0xFF333333); // Cor padrão
          Color textColor = Colors.white;

          if (buttonText == 'C' || buttonText == 'DEL') {
            buttonColor = const Color(0xFFA5A5A5);
            textColor = Colors.black;
          } else if (buttonText == '+' || buttonText == '-' || buttonText == 'x' || buttonText == '/' || buttonText == '=') {
            buttonColor = Colors.orange;
            textColor = Colors.white;
          }

          return CalculatorButton(
            text: buttonText,
            fillColor: buttonColor,
            textColor: textColor,
            onPressed: () => _onButtonPressed(buttonText),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Área de exibição do resultado e operação
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    _currentOperation, // Display da operação
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _output, // Display do resultado/número atual
                    style: const TextStyle(
                      fontSize: 68.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const Expanded(child: Divider(color: Colors.white12, height: 1)),
            
            // Layout dos botões em 5 linhas
            _buildButtonRow(['C', 'DEL', '/', 'x']),
            _buildButtonRow(['7', '8', '9', '-']),
            _buildButtonRow(['4', '5', '6', '+']),
            _buildButtonRow(['1', '2', '3', '=']),
            
            // Linha especial com 0
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Botão 0 com o dobro da largura (flex: 2)
                  CalculatorButton(
                    text: '0',
                    fillColor: const Color(0xFF333333),
                    textColor: Colors.white,
                    onPressed: () => _onButtonPressed('0'),
                    flex: 2,
                  ),
                  CalculatorButton(
                    text: '.',
                    fillColor: const Color(0xFF333333),
                    textColor: Colors.white,
                    onPressed: () => _onButtonPressed('.'),
                  ),
                  // O botão de igualdade já está na linha acima, então colocamos um espaço ou outro botão
                  // Como o '=' já está, esta linha só precisa de três botões se o 0 for duplo.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 3. O Widget do Botão Personalizado
// --------------------------------------------------

class CalculatorButton extends StatelessWidget {
  final String text;
  final Color fillColor;
  final Color textColor;
  final VoidCallback onPressed;
  final int flex; // Para o botão '0' ter largura dupla

  const CalculatorButton({
    super.key,
    required this.text,
    required this.fillColor,
    required this.textColor,
    required this.onPressed,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: fillColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            padding: const EdgeInsets.all(16.0),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 32.0,
              color: textColor,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }
}