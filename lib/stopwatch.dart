import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'AppState.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  final Dependencies dependencies = new Dependencies();

  void leftButtonPressed() {
    setState(() {
      dependencies.stopwatch.reset();
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppStateNotifier(),
        child: Consumer<AppStateNotifier>(
            builder: (context, AppStateNotifier appState, child) {
          return new Stack(
            children: <Widget>[
              new Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: new TimerText(dependencies: dependencies),
                      ))),
              new Align(
                alignment: Alignment.bottomCenter,
                child: new Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 24 : 64),
                  child: FutureBuilder(
                      future:
                          Provider.of<AppStateNotifier>(context, listen: false)
                              .getScreen(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) =>
                          snapshot.hasData
                              ? new Visibility(
                                  visible: appState.hideScreen ? false : true,
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      ButtonTheme(
                                          minWidth: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  1024
                                              ? 128
                                              : 256,
                                          height:
                                              MediaQuery.of(context).size.width < 1024
                                                  ? 64
                                                  : 128,
                                          child: OutlineButton(
                                              child: Text("Reset",
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width <
                                                                  1024
                                                              ? 32
                                                              : 64)),
                                              onPressed: leftButtonPressed,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(10.0)))),
                                      ButtonTheme(
                                          minWidth:
                                              MediaQuery.of(context).size.width < 1024
                                                  ? 128
                                                  : 256,
                                          height: MediaQuery.of(context).size.width < 1024
                                              ? 64
                                              : 128,
                                          child: OutlineButton(
                                              child: Text(
                                                  dependencies.stopwatch.isRunning
                                                      ? "Stop"
                                                      : "Start",
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context).size.width < 1024
                                                              ? 32
                                                              : 64)),
                                              onPressed: rightButtonPressed,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(10.0)))),
                                    ],
                                  ))
                              : Text('Loading')),
                ),
              ),
            ],
          );
        }));
  }
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});
  final Dependencies dependencies;

  TimerTextState createState() =>
      new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int seconds = (milliseconds / 1000).truncate();
      final int minutes = (seconds / 60).truncate();
      final int hours = (minutes / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        seconds: seconds,
        minutes: minutes,
        hours: hours,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: new MinutesAndSeconds(dependencies: dependencies),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;
  int hours = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes ||
        elapsed.seconds != seconds ||
        elapsed.hours != hours) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
        hours = elapsed.hours;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    if (minutes < 1) {
      return new Text('$minutesStr:$secondsStr', style: dependencies.textStyle);
    } else {
      return new Text('$hoursStr:$minutesStr', style: dependencies.textStyle);
    }
  }
}

class ElapsedTime {
  final int seconds;
  final int minutes;
  final int hours;

  ElapsedTime({this.seconds, this.minutes, this.hours});
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle =
      const TextStyle(fontSize: 120.0, fontFamily: "Bebas Neue");
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 500;
}
