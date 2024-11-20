import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tanku/models/task.dart';
import 'package:tanku/widgets/my_app_bar.dart';
import 'package:tanku/widgets/my_button.dart';
import 'package:tanku/widgets/my_icon.dart';
import 'package:tanku/widgets/my_text.dart';

class QuickTaskSelectionPage extends StatefulWidget {
  final User user;
  final Function(List<Task> selectedTasks) onSelectionComplete;

  QuickTaskSelectionPage({
  required this.user,
  required this.onSelectionComplete
});

  @override
  State<QuickTaskSelectionPage> createState() => _QuickTaskSelectionPageState();
}

class _QuickTaskSelectionPageState extends State<QuickTaskSelectionPage> {
  List<Task> tasks = [];
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    tasks = [Task(widget.user.uid, 'Water change'), Task(widget.user.uid, 'Feed'), Task(widget.user.uid, 'Glasses clean')];
    isSelected = List.generate(tasks.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(
              title: 'Quick Tasks',
              onLeadingPressed: () {
                Navigator.pop(context);
              },
              trailing: const MyIcon(icon: Icons.check),
              onTrailingPressed: () {
                List<Task> selectedTasks = [
                  for (int i = 0; i < tasks.length; i++)
                    if (isSelected[i]) tasks[i]
                ];
                widget.onSelectionComplete(selectedTasks);
                Navigator.pop(context, selectedTasks);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: MyButton(
                      onPressed: () {
                        setState(() {
                          isSelected[index] = !isSelected[index];
                        });
                      },
                      isPressed: isSelected[index],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: MyText(text: tasks[index].name, letterSpacing: 2.0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
