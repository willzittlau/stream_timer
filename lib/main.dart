import 'package:flutter/material.dart';
import 'stopwatch.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        title: 'Stream Timer',
        theme: new ThemeData(
          primarySwatch: Colors.grey,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
            brightness: Brightness.dark, primarySwatch: Colors.grey),
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: new Text("Stream Timer"),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                            (isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
                            color: (isDarkMode ? Colors.white : Colors.black)),
                      ),
                      Switch(
                        value: isDarkMode,
                        activeColor: (isDarkMode ? Colors.white : Colors.black),
                        inactiveThumbColor: (isDarkMode ? Colors.white : Colors.black),
                        activeTrackColor: Colors.grey[600],
                        onChanged: (boolVal) {
                          toggleTheme(boolVal);
                        },
                      ),
                    ],
                  ),
                  body: new Container(child: new TimerPage()),
                )));
  }

bool _isDarkMode = false;
bool get isDarkMode => _isDarkMode;

void toggleTheme(bool _isDarkMode) {
  this._isDarkMode = _isDarkMode;
}}