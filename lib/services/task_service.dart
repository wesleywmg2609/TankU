import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/models/task.dart';

class TaskService with ChangeNotifier {
  late final User user;
  late final DatabaseReference databaseRef;
  final List<VoidCallback> _listeners = [];
  List<Task?> _tasks = [];
  Task? _task;
  bool _isLoading = true;

  Task? get task => _task;
  List<Task?> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskService() {
    user = FirebaseAuth.instance.currentUser!;
    databaseRef = FirebaseDatabase.instance.ref().child('tanks/${user.uid}');
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void addTasksToDatabase(DatabaseReference tankRef, List<Task> tasks) {
    try {
      // Reference to tasks under tanks/{uid}/{tank.id}/tasks
      final tasksRef = tankRef.child('tasks');

      for (var task in tasks) {
        // Generate a unique ID for each task
        var newTaskRef = tasksRef.push();

        // Assign the generated ID to the task
        task.setId(newTaskRef);

        // Save the task data to the database
        newTaskRef.set(task.toJson());
      }

      logger('Tasks added successfully.');
    } catch (e) {
      logger('Error adding tasks: $e');
    }
  }
}
