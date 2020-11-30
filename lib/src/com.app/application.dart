import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(
        title: 'Guess my number',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _title = "I'm thinking of a number between";
  final String _subtitle = '1 and 100.';
  final String _yourTurn = "It's your turn to guess my number!";
  final String _tryNumber = 'Try a number!';

  int _generatedNumber = Random().nextInt(100);
  final TextEditingController _givenNumber = TextEditingController();

  bool _isValid = false;

  String _message = '';

  bool _needReset = false;

  void verify() {
    print(_generatedNumber);

    final int numberFromTextField = int.parse(_givenNumber.text);

    if (numberFromTextField == _generatedNumber) {
      setState(() {
        _message = 'You tried $numberFromTextField. You guessed right.';
        _needReset = true;
        showAlertDialog(context);
        _generatedNumber = Random().nextInt(100);
      });
    } else if (numberFromTextField > _generatedNumber) {
      setState(() {
        _message = 'You tried $numberFromTextField. Try lower';
      });
    } else {
      _message = 'You tried $numberFromTextField. Try higher';
    }

    _givenNumber.clear();
  }

  void showAlertDialog(BuildContext context) {
    final Widget tryAgainButton = FlatButton(
      child: const Text('Try again!'),
      onPressed: () {
        setState(() {
          _generatedNumber = Random().nextInt(100);
          _needReset = false;
        });
        Navigator.pop(context);
      },
    );
    final Widget okButton = FlatButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    final AlertDialog alert = AlertDialog(
      title: const Text('You guessed right'),
      content: Text('It was $_generatedNumber'),
      actions: <Widget>[
        tryAgainButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Text(
                _title,
                textScaleFactor: 1.5,
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                _subtitle,
                textScaleFactor: 1.5,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Center(
              child: Text(
                _yourTurn,
                textScaleFactor: 1.3,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Center(
              child: Text(
                _message,
                textScaleFactor: 2,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            child: Card(
              elevation: 7.0,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      _tryNumber,
                      textScaleFactor: 2.2,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 10.0, right: 10.0),
                    child: !_needReset ? TextField(
                      keyboardType: TextInputType.number,
                      controller: _givenNumber,
                    ) : null,
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: _needReset ? RaisedButton(
                        onPressed: () {
                          setState(() {
                            _needReset = false;
                            _message = '';
                          });
                        },
                        color: Colors.grey[350],
                        child: const Text('Reset'),
                      ) : RaisedButton(
                        onPressed: () {
                          setState(() {
                            _givenNumber.text.isNotEmpty
                                ? _isValid = true
                                : _isValid = false;
                          });
                          if (_isValid == true) {
                            verify();
                          }
                        },
                        color: Colors.grey[350],
                        child: const Text('Guess'),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
