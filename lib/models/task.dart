import 'package:firebase_database/firebase_database.dart';

class Task {
  // ignore: unused_field
  late DatabaseReference id;
  String uid;
  String name;
  String createdAt;

  Task(this.uid, this.name, {String? createdAt})
      : this.createdAt = createdAt ?? DateTime.now().toIso8601String();

  void setId(DatabaseReference id) {
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'name': this.name,
      'createdAt': this.createdAt,
    };
  }
}

Task createTask(Map<String, dynamic> record) {
  Map<String, dynamic> attributes = {
    'uid': record['uid'] ?? '',
    'name': record['name'] ?? '',
    'createdAt': record['createdAt'] ?? DateTime.now().toIso8601String(),
  };

  Task task = Task(
    attributes['uid'],
    attributes['name'],
    createdAt: attributes['createdAt'],
  );

  return task;
}
