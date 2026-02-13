import 'package:todolist/app/models/task_model.dart';

abstract class TasksRepository {
  Future<void> save(
      DateTime date, String description);
  Future<List<TaskModel>> findByPeriod(
      DateTime startDate, DateTime endDate);
  Future<void> checkOrUncheckTask(TaskModel task);
  Future<void> deleteTask(int taskId);
  Future<void> update(int taskId, DateTime date,
      String description);
}
