import '../interfaces/json_serializable.dart';
import 'priority.dart';

abstract class Task implements JsonSerializable {
  int id;
  String title;
  Priority priority;
  DateTime? dueDate;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.completed = false,
  });

  void display();

  void markCompleted() {
    completed = true;
  }
}