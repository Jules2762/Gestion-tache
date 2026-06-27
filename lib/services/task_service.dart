import '../models/priority.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskService {
  final TaskRepository repository;

  TaskService(this.repository);

  Future<List<Task>> getTasks({
    bool sortByPriority = false,
    bool sortByDate = false,
  }) async {
    final tasks = await repository.getAll();

    if (sortByPriority) {
      tasks.sort(
        (a, b) => b.priority.level.compareTo(a.priority.level),
      );
    }

    if (sortByDate) {
      tasks.sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) {
          return 0;
        }

        if (a.dueDate == null) {
          return 1;
        }

        if (b.dueDate == null) {
          return -1;
        }

        return a.dueDate!.compareTo(b.dueDate!);
      });
    }

    return tasks;
  }

  Future<void> addTask(Task task) async {
    final tasks = await repository.getAll();

    final exists = tasks.any((t) => t.id == task.id);

    if (exists) {
      throw Exception(
        "Une tâche avec l'id ${task.id} existe déjà.",
      );
    }

    await repository.add(task);
  }

  Future<void> completeTask(int id) async {
    final tasks = await repository.getAll();

    final task = tasks.firstWhere(
      (t) => t.id == id,
    );

    task.markCompleted();

    await repository.update(task);
  }

  Future<void> deleteTask(int id) async {
    await repository.delete(id);
  }

  Future<int> completedCount() async {
    final tasks = await repository.getAll();

    return tasks
        .where((task) => task.completed)
        .length;
  }

  Future<int> pendingCount() async {
    final tasks = await repository.getAll();

    return tasks
        .where((task) => !task.completed)
        .length;
  }

  Future<int> totalTasks() async {
    final tasks = await repository.getAll();

    return tasks.length;
  }

  Future<Map<Priority, int>> tasksPerPriority() async {
    final tasks = await repository.getAll();

    final result = <Priority, int>{};

    for (final priority in Priority.values) {
      result[priority] = tasks
          .where((task) => task.priority == priority)
          .length;
    }

    return result;
  }
}