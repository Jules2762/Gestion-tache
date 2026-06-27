import 'dart:convert';
import 'dart:io';

import '../exceptions/storage_exception.dart';
import '../models/task.dart';
import '../models/urgent_task.dart';

class FileStorage {
  final String path;

  FileStorage({
    this.path = "data/tasks.json",
  });

  Future<File> _getFile() async {
    final file = File(path);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString("[]");
    }

    return file;
  }

  Future<List<Task>> loadTasks() async {
    try {
      final file = await _getFile();

      final jsonString = await file.readAsString();

      if (jsonString.trim().isEmpty) {
        return [];
      }

      final List<dynamic> jsonData = jsonDecode(jsonString);

      return jsonData
          .map((e) => UrgentTask.fromJson(e))
          .toList();
    } catch (e) {
      throw StorageException(
        "Impossible de lire les tâches : $e",
      );
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final file = await _getFile();

      final json = tasks
          .map((task) => task.toJson())
          .toList();

      await file.writeAsString(
        JsonEncoder.withIndent("  ").convert(json),
      );
    } catch (e) {
      throw StorageException(
        "Impossible d'enregistrer les tâches : $e",
      );
    }
  }
}