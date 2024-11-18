import 'package:flutter/material.dart';
import 'package:tanku/components/my_app_bar.dart';
import 'package:tanku/components/my_button.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_text.dart';

class QuickTaskSelectionPage extends StatefulWidget {
  final Function(List<String> selectedTasks) onSelectionComplete;

  QuickTaskSelectionPage({required this.onSelectionComplete});

  @override
  State<QuickTaskSelectionPage> createState() => _QuickTaskSelectionPageState();
}

class _QuickTaskSelectionPageState extends State<QuickTaskSelectionPage> {
  List<String> tasks = ['Water change', 'Feed', 'Clean glass'];
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
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
                List<String> selectedTasks = [
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
                      child: MyText(text: tasks[index], letterSpacing: 2.0),
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
