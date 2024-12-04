import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tanku/models/task.dart';
import 'package:tanku/widgets/my_app_bar2.dart';

class QuickTaskSelectionPage extends StatefulWidget {
  final User user;
  final Function(List<Task> selectedTasks) onSelectionComplete;

  QuickTaskSelectionPage(
      {required this.user, required this.onSelectionComplete});

  @override
  State<QuickTaskSelectionPage> createState() => _QuickTaskSelectionPageState();
}

class _QuickTaskSelectionPageState extends State<QuickTaskSelectionPage> {
  List<Task> tasks = [];
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    tasks = [
      Task(widget.user.uid, 'Water change'),
      Task(widget.user.uid, 'Feed'),
      Task(widget.user.uid, 'Glasses clean')
    ];
    isSelected = List.generate(tasks.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar2(
              title: 'Add Tank',
              subtitle: 'Add new tank',
              icon: Ionicons.checkmark_circle_outline,
              onTap: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    SystemChrome.setSystemUIOverlayStyle(
                        const SystemUiOverlayStyle(
                      systemNavigationBarColor: Color(0xffffffff),
                      systemNavigationBarIconBrightness: Brightness.dark,
                    ));
                    List<Task> selectedTasks = [
                      for (int i = 0; i < tasks.length; i++)
                        if (isSelected[i]) tasks[i]
                    ];
                    widget.onSelectionComplete(selectedTasks);
                    Navigator.pop(context, selectedTasks);
                  });
                });
              },
              isBackAllowed: true,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(Ionicons.today),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  tasks[index].name,
                                  style: const TextStyle(
                                    fontFamily: 'NotoSans',
                                    fontSize: 12,
                                    color: Color(0xff282a29),
                                  ),
                                ),
                              ),
                              isSelected[index]
                                  ? const Icon(Ionicons.checkbox)
                                  : const Icon(Ionicons.checkbox_outline)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
