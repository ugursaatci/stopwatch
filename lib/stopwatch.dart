import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchApp extends StatefulWidget {
  @override
  _StopwatchAppState createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> with WidgetsBindingObserver {
  int milliseconds = 0;
  Timer? timer;
  final laps = <int>[];
  bool appResumed = true; // Assume the app is initially in the resumed state

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        if (appResumed) {
          print('flutter:onPause');
          appResumed = false;
        }
        break;
      case AppLifecycleState.resumed:
        if (!appResumed) {
          print('flutter:onResume');
          appResumed = true;
        }
        break;
      default:
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    milliseconds = 0;
    timer = Timer.periodic(Duration(milliseconds: 100), onTick);

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  void onTick(Timer time) {
    setState(() {
      milliseconds += 100;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 100), onTick);
  }

  void _lap() {
    setState(() {
      laps.add(milliseconds);
      milliseconds = 0;
    });
  }

  void _stopTimer() {
    setState(() {
      timer?.cancel();
      timer = null;
    });
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          child: Text('Start'),
          onPressed: timer == null ? _startTimer : null,
        ),
         SizedBox(width: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
          ),
          child: Text('Lap'),
          onPressed: timer != null ? _lap : null,
        ),
        SizedBox(width: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          child: Text('Stop'),
          onPressed: timer != null ? _stopTimer : null,
        ),
       
      ],
    );
  }

  Widget _buildCounter(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Lap ${laps.length + 1}',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: Colors.white),
          ),
          Text(
            _secondsText(milliseconds),
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.white),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildLapDisplay() {
    return ListView(
      children: [
        for (int milliseconds in laps)
          ListTile(
            title: Text(_secondsText(milliseconds)),
          ),
      ],
    );
  }

  String _secondsText(int milliseconds) {
    final seconds = milliseconds / 1000;
    return '$seconds seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildCounter(context)),
          Expanded(child: _buildLapDisplay()),
        ],
      ),
    );
  }
}