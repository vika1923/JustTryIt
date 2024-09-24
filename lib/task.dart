import 'package:flutter/material.dart';
import 'package:my_app1/timer.dart';

class Task extends StatelessWidget {
  final int hours;
  final int minutes;
  final String taskName;
  final String priority;
  final VoidCallback deleteTask;
  final Function(bool, int) switchTimerRunning; // Add the callback here
  final bool noTimerIsRunning;
  final int index;
  final int? lastCountingTimerIndex;

  const Task({
    required this.hours,
    required this.minutes,
    required this.taskName,
    required this.priority,
    required this.deleteTask,
    required this.switchTimerRunning, // Accept the callback
    required this.noTimerIsRunning,
    required this.index,
    required this.lastCountingTimerIndex,
    super.key, // Accept a key as a parameter
  });

  int priorityToColor(String priority) {
    return (["low", "medium", "high"].indexOf(priority)) * 50;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue[priorityToColor(priority)],
          ),
          child: ListTile(
            minVerticalPadding: 20,
            title: Text(taskName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Time left: $hours:$minutes, Priority: $priority"),
            tileColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.delete_outlined),
              onPressed: deleteTask,
            ),
            trailing: SizedBox(
              width: 80,
              height: 70,
              child: MyTimer(
                hours: hours,
                minutes: minutes,
                taskName: taskName,
                switchTimerRunning: switchTimerRunning,
                noTimerIsRunning: noTimerIsRunning,
                index: index,
                lastCountingTimerIndex: lastCountingTimerIndex,
                priority: priority, // Pass the callback),
              ),
            ),
          ),
        ));
  }
}
