import 'package:flutter/material.dart';
import 'dart:async';

import 'package:snagbug/snagbug.dart';

void main() {
  Snagbug.handleEveryError(() => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Snagbug Example'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                throw new Exception(
                    "You pressed the 'Throw Exception' button!");
              },
              child: Text('Gesture exception'),
            ),
            RaisedButton(
              onPressed: () {
                Timer.run(() {
                  throw new Exception(
                      "You pressed the 'Throw Exception' button!");
                });
              },
              child: Text('Background exception'),
            ),
            RaisedButton(
              onPressed: () {
                try {
                  throw new Exception(
                      "You pressed the 'Throw Exception' button!");
                } on Object catch (e, s) {
                  Snagbug.handleError(e, s);
                }
              },
              child: Text('Try/catch'),
            ),
          ],
        ),
      ),
    );
  }
}
