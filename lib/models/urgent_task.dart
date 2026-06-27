import 'task.dart';
import 'priority.dart';

class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    required super.priority,
    super.dueDate,
    super.completed,
  });

  factory UrgentTask.fromJson(
    Map<String, dynamic> json,
  ) {
    return UrgentTask(
      id: json["id"],
      title: json["title"],
      priority: Priority.fromString(
        json["priority"],
      ),
      completed: json["completed"],
      dueDate: json["dueDate"] == null
          ? null
          : DateTime.parse(json["dueDate"]),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "priority": priority.name,
      "completed": completed,
      "dueDate": dueDate?.toIso8601String(),
    };
  }

  @override
  void display() {
    print("""
ID : $id
Titre : $title
Priorité : ${priority.label}
Terminée : ${completed ? "Oui" : "Non"}
Date limite : ${dueDate ?? "Aucune"}
-------------------------
""");
  }
}