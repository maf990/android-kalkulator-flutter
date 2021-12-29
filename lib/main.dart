import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: kIsWeb ? Container(width: 400, child: Home()) : Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userInput = '';
  String answer = '';
  List<String> buttons = [
    'C',
    'D',
    '%',
    '÷',
    '1',
    '2',
    '3',
    'x',
    '4',
    '5',
    '6',
    '-',
    '7',
    '8',
    '9',
    '+',
    '00',
    '0',
    '.',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Column(
          children: [
            AppBar(
              leading: Icon(Icons.calculate_outlined),
              title: const Text('Kalkulator'),foregroundColor: Colors.orange,backgroundColor: Colors.white,
              centerTitle: true,
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.orange,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (answer != '')
                          Text(
                            userInput,
                            style:
                            TextStyle(fontSize: 32, color: Colors.white70),
                            textAlign: TextAlign.right,
                          ),
                        Text(
                          answer != '' ? answer : userInput,
                          style: TextStyle(
                              fontSize: 48, fontWeight: FontWeight.w500,color: Colors.white),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  child: GridView.count(
                    padding: const EdgeInsets.all(12),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    crossAxisCount: 4,
                    children: buttons
                        .map((text) => MyButton(
                      text: text,
                      onTap: () {
                        if (text == 'C') {
                          setState(() {
                            userInput = '';
                            answer = '';
                          });
                        } else if (text == 'D') {
                          setState(() {
                            userInput = userInput.substring(
                                0, userInput.length - 1);
                          });
                        } else if (text == '=') {
                          calculate();
                        } else {
                          setState(() {
                            userInput += text;
                          });
                        }
                      },
                    ))
                        .toList(),
                  ),
                ))
          ],
        ),
      );
  }

  void calculate() {
    String userInputToCalculate = userInput;
    userInputToCalculate = userInputToCalculate.replaceAll('x', '*');
    userInputToCalculate = userInputToCalculate.replaceAll('÷', '/');

    Parser p = Parser();
    Expression exp = p.parse(userInputToCalculate);

    // Bind variables:
    ContextModel cm = ContextModel();

    // Evaluate expression:
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    setState(() {
      answer = eval.toString();
      if (answer.substring(answer.length - 2, answer.length) == '.0')
        answer = answer.substring(0, answer.length - 2);
    });
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const MyButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Card(
          shape: CircleBorder(),
          color: isOperator(text) ? Colors.orange : Colors.white,
          child: Center(
              child: text == 'D'
                  ? Icon(
                Icons.backspace,
                color: Colors.white,
              )
                  : Text(text,
                  style: TextStyle(
                    color: isOperator(text) ? Colors.white : Colors.orangeAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: 36,
                  ))),
        ));
  }

  bool isOperator(String value) {
    if (value == 'C' ||
        value == 'D' ||
        value == '%' ||
        value == '÷' ||
        value == 'x' ||
        value == '-' ||
        value == '+' ||
        value == '=')
      return true;
    else
      return false;
  }
}
