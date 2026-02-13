import 'package:todolist/app/models/task_model.dart';
import 'package:todolist/app/models/week_task_model.dart';
import 'package:todolist/app/repositories/tasks/tasks_repository.dart';
import 'package:todolist/app/services/tasks/tasks_service.dart';

class TasksServiceImpl implements TasksService {
  final TasksRepository _tasksRepository;

  TasksServiceImpl({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository;

  @override
  Future<void> save(
          DateTime date, String description) =>
      _tasksRepository.save(date, description);

  @override
  Future<List<TaskModel>> getToday() {
    return _tasksRepository.findByPeriod(
        DateTime.now(), DateTime.now());
  }

  @override
  Future<List<TaskModel>> getTomorrow() {
    var tomorrowDate =
        DateTime.now().add(Duration(days: 1));
    return _tasksRepository.findByPeriod(
        tomorrowDate, tomorrowDate);
  }

  @override
  Future<WeekTaskModel> getWeek() async {
    final today = DateTime.now();
    var startFilter = DateTime(
        today.year, today.month, today.day);
    DateTime endFilter = DateTime(today.year,
        today.month, today.day, 0, 0, 0);
    if (startFilter.weekday != DateTime.monday) {
      startFilter = startFilter.subtract(Duration(
          days: startFilter.weekday - 1));
    }
    endFilter =
        startFilter.add(Duration(days: 7));
    final tasks = await _tasksRepository
        .findByPeriod(startFilter, endFilter);
    return WeekTaskModel(
        startDate: startFilter,
        endDate: endFilter,
        tasks: tasks);
  }

  @override
  Future<void> checkOrUncheckTask(
          TaskModel task) =>
      _tasksRepository.checkOrUncheckTask(task);

  @override
  Future<void> deleteTask(int taskId) {
    return _tasksRepository.deleteTask(taskId);
  }

  @override
  Future<void> update(int taskId, DateTime date,
      String description) {
    return _tasksRepository.update(
        taskId, date, description);
  }

  @override
  Future<List<TaskModel>> getYesterday() {
    final yesterday = DateTime.now()
        .subtract(Duration(days: 1));
    return _tasksRepository.findByPeriod(
        yesterday, yesterday);
  }

  @override
  Future<List<TaskModel>> getMonth() {
    final today = DateTime.now();
    final startOfMonth =
        DateTime(today.year, today.month, 1);
    final endOfMonth =
        DateTime(today.year, today.month + 1, 0);
    return _tasksRepository.findByPeriod(
        startOfMonth, endOfMonth);
  }

  @override
  Future<List<TaskModel>> getYear() {
    final today = DateTime.now();
    final startOfYear =
        DateTime(today.year, 1, 1);
    final endOfYear =
        DateTime(today.year, 12, 31);
    return _tasksRepository.findByPeriod(
        startOfYear, endOfYear);
  }
}
