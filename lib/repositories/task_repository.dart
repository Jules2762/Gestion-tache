
import '../exceptions/task_not_found_exception.dart';
import '../models/task.dart';
import '../services/file_storage.dart';
import 'repository.dart';

class TaskRepository implements Repository<Task> {
  final FileStorage storage;

  TaskRepository(this.storage);

  @override
  Future<List<Task>> getAll() async {
    return await storage.loadTasks();
  }

  @override
  Future<void> add(Task task) async {
    final tasks = await storage.loadTasks();

    tasks.add(task);

    await storage.saveTasks(tasks);
  }

  @override
  Future<void> update(Task task) async {
    final tasks = await storage.loadTasks();

    final index = tasks.indexWhere(
      (t) => t.id == task.id,
    );

    if (index == -1) {
      throw TaskNotFoundException(
        "La tâche avec l'id ${task.id} est introuvable.",
      );
    }

    tasks[index] = task;

    await storage.saveTasks(tasks);
  }

  @override
  Future<void> delete(int id) async {
    final tasks = await storage.loadTasks();

    final index = tasks.indexWhere(
      (task) => task.id == id,
    );

    if (index == -1) {
      throw TaskNotFoundException(
        "La tâche avec l'id $id est introuvable.",
      );
    }

    tasks.removeAt(index);

    await storage.saveTasks(tasks);
  }
}