import 'package:todolist/app/models/task_model.dart';
import 'package:todolist/app/models/week_task_model.dart';

abstract class TasksService {
  Future<void> save(
      DateTime date, String description);

  Future<List<TaskModel>> getToday();
  Future<List<TaskModel>> getTomorrow();
  Future<WeekTaskModel> getWeek();
  Future<void> checkOrUncheckTask(TaskModel task);
  Future<void> deleteTask(int taskId);
  Future<void> update(int taskId, DateTime date,
      String description);
  Future<List<TaskModel>> getYesterday();
  Future<List<TaskModel>> getMonth();
  Future<List<TaskModel>> getYear();
}
