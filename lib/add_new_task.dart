import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_app1/hours.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  late TextEditingController controller;
  late String taskName = "(no name)";
  late int hours = 0;
  late int minutes = 0;
  late String priority = "medium";

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void saveTask() {
  try {
    var box = Hive.box('tasksBox');
    List<dynamic> taskData = [controller.text, hours, minutes, priority];
    box.add(taskData);
    Navigator.of(context).pop();
  } catch (e) {
    print("Error saving task: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add task", style: TextStyle(fontSize: 20)),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Task"),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 80,
                    padding: const EdgeInsets.all(20),
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 25,
                      useMagnifier: true,
                      magnification: 1.5,
                      physics: const FixedExtentScrollPhysics(),
                      perspective: 0.005,
                      diameterRatio: 1.3,
                      onSelectedItemChanged: (i) {
                        hours = i;
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 9,
                        builder: (context, index) {
                          return MyHours(hours: index);
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                    width: 80,
                    padding: const EdgeInsets.all(20),
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 25,
                      useMagnifier: true,
                      magnification: 1.3,
                      onSelectedItemChanged: (i) {
                        minutes = i * 10;
                      },
                      physics: const FixedExtentScrollPhysics(),
                      perspective: 0.005,
                      diameterRatio: 1.5,
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 6,
                        builder: (context, index) {
                          return MyHours(hours: index * 10);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Text("Priority: "),
                SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: "high",
                      label: Text("HIGH"),
                    ),
                    ButtonSegment<String>(
                      value: "medium",
                      label: Text("MEDIUM"),
                    ),
                    ButtonSegment<String>(
                      value: "low",
                      label: Text("LOW"),
                    ),
                  ],
                  selected: {priority},
                  onSelectionChanged: (newSelected) {
                    setState(() {
                      priority = newSelected.first;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                saveTask();
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
