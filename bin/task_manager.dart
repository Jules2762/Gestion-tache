import 'dart:io';

import 'package:task_manager/models/priority.dart';
import 'package:task_manager/models/urgent_task.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:task_manager/services/file_storage.dart';
import 'package:task_manager/services/task_service.dart';

Future<void> main() async {
  final service = TaskService(
    TaskRepository(
      FileStorage(),
    ),
  );

  while (true) {
    print("");
    print("========== TASK MANAGER ==========");
    print("1. Ajouter une tâche");
    print("2. Lister les tâches");
    print("3. Marquer comme terminée");
    print("4. Supprimer une tâche");
    print("5. Statistiques");
    print("0. Quitter");
    print("");

    stdout.write("Votre choix : ");

    final choice = stdin.readLineSync();

    switch (choice) {
      case "1":
        await addTask(service);
        break;

      case "2":
        await showTasks(service);
        break;

      case "3":
        await completeTask(service);
        break;

      case "4":
        await deleteTask(service);
        break;

      case "5":
        await statistics(service);
        break;

      case "0":
        print("Au revoir !");
        exit(0);

      default:
        print("Choix invalide.");
    }
  }
}
Future<void> addTask(TaskService service) async {
  stdout.write("ID : ");
  final id = int.parse(stdin.readLineSync()!);

  stdout.write("Titre : ");
  final title = stdin.readLineSync()!;

  stdout.write("Priorité (low/medium/high) : ");
  final priorityString = stdin.readLineSync()!;

  stdout.write("Date limite (yyyy-MM-dd) ou vide : ");
  final dateString = stdin.readLineSync();

  final dueDate = (dateString == null || dateString.isEmpty)
      ? null
      : DateTime.parse(dateString);

  final task = UrgentTask(
    id: id,
    title: title,
    priority: Priority.fromString(priorityString),
    dueDate: dueDate,
  );

  try {
    await service.addTask(task);

    print("Tâche ajoutée.");
  } catch (e) {
    print(e);
  }
}
Future<void> showTasks(TaskService service) async {
  print("");
  print("1. Sans tri");
  print("2. Trier par priorité");
  print("3. Trier par date");

  stdout.write("Choix : ");

  final choice = stdin.readLineSync();

  final tasks = switch (choice) {
    "2" => await service.getTasks(sortByPriority: true),
    "3" => await service.getTasks(sortByDate: true),
    _ => await service.getTasks(),
  };

  if (tasks.isEmpty) {
    print("Aucune tâche.");
    return;
  }

  for (final task in tasks) {
    task.display();
  }
}
Future<void> completeTask(
    TaskService service) async {

  stdout.write("ID de la tâche : ");

  final id = int.parse(stdin.readLineSync()!);

  try {
    await service.completeTask(id);

    print("Tâche terminée.");
  } catch (e) {
    print(e);
  }
}
Future<void> deleteTask(
    TaskService service) async {

  stdout.write("ID de la tâche : ");

  final id = int.parse(stdin.readLineSync()!);

  try {
    await service.deleteTask(id);

    print("Tâche supprimée.");
  } catch (e) {
    print(e);
  }
}
Future<void> statistics(
    TaskService service) async {

  print("");

  print(
      "Nombre total : ${await service.totalTasks()}");

  print(
      "Terminées : ${await service.completedCount()}");

  print(
      "En attente : ${await service.pendingCount()}");

  final stats =
      await service.tasksPerPriority();

  print("");

  for (final entry in stats.entries) {
    print(
        "${entry.key.label} : ${entry.value}");
  }
}