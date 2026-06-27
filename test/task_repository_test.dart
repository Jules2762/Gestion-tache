import 'dart:io';

import 'package:task_manager/models/priority.dart';
import 'package:task_manager/models/urgent_task.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:task_manager/services/file_storage.dart';
import 'package:test/test.dart';

void main() {
  late TaskRepository repository;

  setUp(() async {
    final file = File("data/test_tasks.json");

    if (await file.exists()) {
      await file.delete();
    }

    repository = TaskRepository(
      FileStorage(
        path: "data/test_tasks.json",
      ),
    );
  });

  test("Ajouter une tâche", () async {
    final task = UrgentTask(
      id: 1,
      title: "Apprendre Dart",
      priority: Priority.high,
    );

    await repository.add(task);

    final tasks = await repository.getAll();

    expect(tasks.length, 1);
    expect(tasks.first.title, "Apprendre Dart");
  });

  test("Supprimer une tâche", () async {
    final task = UrgentTask(
      id: 1,
      title: "Supprimer",
      priority: Priority.low,
    );

    await repository.add(task);

    await repository.delete(1);

    final tasks = await repository.getAll();

    expect(tasks.isEmpty, true);
  });

  test("Modifier une tâche", () async {
    final task = UrgentTask(
      id: 1,
      title: "Ancien titre",
      priority: Priority.medium,
    );

    await repository.add(task);

    task.title = "Nouveau titre";

    await repository.update(task);

    final tasks = await repository.getAll();

    expect(tasks.first.title, "Nouveau titre");
  });

  test("Marquer comme terminée", () async {
    final task = UrgentTask(
      id: 1,
      title: "Cours",
      priority: Priority.high,
    );

    task.markCompleted();

    expect(task.completed, true);
  });

  test("Récupérer toutes les tâches", () async {
    await repository.add(
      UrgentTask(
        id: 1,
        title: "A",
        priority: Priority.low,
      ),
    );

    await repository.add(
      UrgentTask(
        id: 2,
        title: "B",
        priority: Priority.high,
      ),
    );

    final tasks = await repository.getAll();

    expect(tasks.length, 2);
  });
}