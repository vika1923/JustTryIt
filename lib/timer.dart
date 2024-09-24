import 'package:flutter/material.dart';
import 'dart:async';

import 'package:hive/hive.dart';

class MyTimer extends StatefulWidget {
  final int hours;
  final int minutes;
  final String taskName;
  final Function(bool, int) switchTimerRunning;
  final bool noTimerIsRunning;
  final int index;
  final int? lastCountingTimerIndex;
  final String priority;

  const MyTimer(
      {super.key,
      required this.hours,
      required this.minutes,
      required this.taskName,
      required this.switchTimerRunning,
      required this.noTimerIsRunning,
      required this.index,
      required this.lastCountingTimerIndex, required this.priority});

  @override
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  int timeLeft = 0;
  Timer? countdownTimer;
  bool isNotRunning = true;

  @override
  void initState() {
    super.initState();

    if (widget.index == widget.lastCountingTimerIndex) {
      updateHive();
      startCountdown();
      setState(() {
        isNotRunning = false;
      });
    }

    timeLeft = widget.hours * 60 + widget.minutes;
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft -= 1;
        } else {
          timer.cancel();
        }
      });
    updateHive();
    },);
  }

  void updateHive() async{
    var box = Hive.box('tasksBox');
    int key = box.keys.toList()[widget.index];
    box.put(key, [widget.taskName, timeLeft~/60, timeLeft%60, widget.priority]);
  }

  void startOrStopCountdown() {
    // print("1");
    if (isNotRunning) {
      // print("2");
      if (widget.noTimerIsRunning) {
        // print("3");
        startCountdown();
        setState(() {
          isNotRunning = false;
          widget.switchTimerRunning(false, widget.index);
        });
      }
    } else {
      countdownTimer?.cancel();
      setState(() {
        isNotRunning = true;
        widget.switchTimerRunning(true, widget.index);
      });
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    if (!isNotRunning) {
      setState(() {
        widget.switchTimerRunning(true, widget.index);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(isNotRunning ? Icons.play_arrow : Icons.pause),
          onPressed: startOrStopCountdown,
        ),
        Text(timeLeft.toString()),
      ],
    );
  }
}
