import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String subtitle1 = "I'm thinking of a number between 1 and 100.";
  String subtitle2 = "It's your turn to guess my number!";
  String cardTitle = 'Try a number!';
  int randomNumber = 1;
  int valueOfNumber = 0;
  int isLess = -1;
  final TextEditingController fieldText = TextEditingController();
  String buttonText = 'Guess';
  bool isGuessed = false;

  void getRandomNumber(int min, int max) {
    final Random random = Random();
    randomNumber = min + random.nextInt(max - min + 1);
  }

  @override
  void initState() {
    super.initState();
    getRandomNumber(1, 100);
    // print(randomNumber);
  }

  void clearText() {
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Guess my number'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Text(
                subtitle1,
                style: const TextStyle(fontSize: 30, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                subtitle2,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (isLess == 1)
                Text(
                  'You tried $valueOfNumber\n'
                  'Try higher',
                  style: TextStyle(fontSize: 40, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                )
              else if (isLess == 0)
                Text(
                  'You tried $valueOfNumber\n'
                  'Try lower',
                  style: TextStyle(fontSize: 40, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                )
              else if (isLess == 2)
                Text(
                  'You tried $valueOfNumber\n'
                  'You guessed right.',
                  style: TextStyle(fontSize: 40, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              Card(
                elevation: 15,
                shadowColor: Colors.black,
                color: Colors.white,
                child: SizedBox(
                  width: 380,
                  height: 280,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          cardTitle,
                          style: TextStyle(fontSize: 34, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 380,
                          child: TextField(
                            onChanged: (String value) {
                              valueOfNumber = int.parse(value);
                            },
                            keyboardType: TextInputType.number,
                            controller: fieldText,
                            enabled: !isGuessed,
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                            onPressed: () {
                              //print(valueOfNumber);
                              clearText();
                              setState(
                                () {
                                  if (isGuessed) {
                                    Phoenix.rebirth(context);
                                  }

                                  if (valueOfNumber < randomNumber) {
                                    isLess = 1;
                                  } else if (valueOfNumber > randomNumber) {
                                    isLess = 0;
                                  } else {
                                    isLess = 2;
                                  }

                                  if (isLess == 2) {
                                    showDialog<String>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('You guessed right'),
                                        content: Text('It was $valueOfNumber '),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setState(
                                                () {
                                                  Phoenix.rebirth(context);
                                                },
                                              );
                                            },
                                            child: const Text('Try again!'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setState(
                                                () {
                                                  buttonText = 'Reset';
                                                  isGuessed = true;
                                                },
                                              );
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );

                              //print(isLess);
                            },
                            child: Text(buttonText))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
