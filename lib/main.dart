import 'package:flutter/material.dart';
import 'stopwatch.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      showPerformanceOverlay: false,
      title: 'Stream Timer',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Stream Timer"),
      ),
      body: new Container(
        child: new TimerPage()
      ),
    );
  }
}
