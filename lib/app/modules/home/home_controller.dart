import 'package:flutter/material.dart';
import 'package:todolist/app/core/notifier/default_change_notifier.dart';
import 'package:todolist/app/models/task_filter_enum.dart';
import 'package:todolist/app/models/task_model.dart';
import 'package:todolist/app/models/total_tasks_model.dart';
import 'package:todolist/app/models/week_task_model.dart';
import 'package:todolist/app/modules/tasks/tasks_module.dart';
import 'package:todolist/app/services/tasks/tasks_service.dart';

class HomeController
    extends DefaultChangeNotifier {
  final TasksService _tasksService;
  var filterSelected = TaskFilterEnum.today;
  final Map<TaskFilterEnum, TotalTasksModel>
      _totalTasks = {};
  TotalTasksModel? get todayTotalTasks =>
      _totalTasks[TaskFilterEnum.today];
  TotalTasksModel? get tomorrowTotalTasks =>
      _totalTasks[TaskFilterEnum.tomorrow];
  TotalTasksModel? get weekTotalTasks =>
      _totalTasks[TaskFilterEnum.week];
  TotalTasksModel? get yesterdayTotalTasks =>
      _totalTasks[TaskFilterEnum.yesterday];
  TotalTasksModel? get monthTotalTasks =>
      _totalTasks[TaskFilterEnum.month];
  TotalTasksModel? get yearTotalTasks =>
      _totalTasks[TaskFilterEnum.year];

  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];
  DateTime? initialDateOfWeek;
  DateTime? seletedDay;
  bool showFinishingTasks = false;

  HomeController(
      {required TasksService tasksService,
      required TaskFilterEnum
          initialFilterSelected})
      : _tasksService = tasksService {
    filterSelected = initialFilterSelected;
    findTasks(filter: filterSelected);
  }

  Future<void> loadTotalTasks() async {
    final allTasks = await Future.wait([
      _tasksService.getToday(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek(),
      _tasksService.getYesterday(),
      _tasksService.getMonth(),
      _tasksService.getYear(),
    ]);

    final todayTasks =
        allTasks[0] as List<TaskModel>;
    final tomorrowTasks =
        allTasks[1] as List<TaskModel>;
    final weekModel =
        allTasks[2] as WeekTaskModel;
    final yesterdayTasks =
        allTasks[3] as List<TaskModel>;
    final monthTasks =
        allTasks[4] as List<TaskModel>;
    final yearTasks =
        allTasks[5] as List<TaskModel>;

    _totalTasks[TaskFilterEnum.today] =
        TotalTasksModel(
            totalTasks: todayTasks.length,
            totalTasksFinish: todayTasks
                .where((task) => task.finished)
                .length);
    _totalTasks[TaskFilterEnum.tomorrow] =
        TotalTasksModel(
            totalTasks: tomorrowTasks.length,
            totalTasksFinish: tomorrowTasks
                .where((task) => task.finished)
                .length);
    _totalTasks[TaskFilterEnum.week] =
        TotalTasksModel(
            totalTasks: weekModel.tasks.length,
            totalTasksFinish: weekModel.tasks
                .where((task) => task.finished)
                .length);
    _totalTasks[TaskFilterEnum.yesterday] =
        TotalTasksModel(
            totalTasks: yesterdayTasks.length,
            totalTasksFinish: yesterdayTasks
                .where((task) => task.finished)
                .length);
    _totalTasks[TaskFilterEnum.month] =
        TotalTasksModel(
            totalTasks: monthTasks.length,
            totalTasksFinish: monthTasks
                .where((task) => task.finished)
                .length);
    _totalTasks[TaskFilterEnum.year] =
        TotalTasksModel(
            totalTasks: yearTasks.length,
            totalTasksFinish: yearTasks
                .where((task) => task.finished)
                .length);
  }

  Future<void> findTasks(
      {required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoadingAndResetState();
    notifyListeners();
    List<TaskModel> tasks;
    switch (filter) {
      // O switch continua buscando os dados para cada filtro
      case TaskFilterEnum.today:
        tasks = await _tasksService.getToday();
        break;

      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow();
        break;

      case TaskFilterEnum.week:
        final weekModel =
            await _tasksService.getWeek();
        tasks = weekModel.tasks;
        initialDateOfWeek = weekModel.startDate;
        break;
      case TaskFilterEnum.yesterday:
        tasks =
            await _tasksService.getYesterday();
        break;
      case TaskFilterEnum.month:
        tasks = await _tasksService.getMonth();
        break;
      case TaskFilterEnum.year:
        tasks = await _tasksService.getYear();
        break;
    }
    filteredTasks = tasks;
    allTasks = tasks;

    if (filter == TaskFilterEnum.week) {
      if (seletedDay != null) {
        filterByDay(seletedDay!);
      } else if (initialDateOfWeek != null) {
        filterByDay(initialDateOfWeek!);
      }
    } else {
      seletedDay = null;
    }

    if (!showFinishingTasks) {
      filteredTasks = filteredTasks
          .where((task) => !task.finished)
          .toList();
    }

    hideLoading();
    notifyListeners();
  }

  void filterByDay(DateTime date) {
    seletedDay = date;
    filteredTasks = allTasks
        .where((task) => DateUtils.isSameDay(
            task.dateTime, date))
        .toList();
    if (!showFinishingTasks) {
      filteredTasks = filteredTasks
          .where((task) => !task.finished)
          .toList();
    }
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await findTasks(filter: filterSelected);
    await loadTotalTasks(); // Carrega os totais após buscar as tarefas
    notifyListeners(); // Notifica a UI uma única vez no final
  }

  Future<void> checkOrUncheckTask(
      TaskModel task) async {
    // Otimização: Inverte o estado localmente para uma resposta visual imediata
    final taskUpdate =
        task.copyWith(finished: !task.finished);
    final taskIndex = filteredTasks.indexWhere(
        (taskInList) => taskInList.id == task.id);
    if (taskIndex > -1) {
      filteredTasks[taskIndex] = taskUpdate;
    }
    notifyListeners();
    await _tasksService
        .checkOrUncheckTask(taskUpdate);
    await refreshPage();
  }

  void reorderTasks(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final task = filteredTasks.removeAt(oldIndex);
    filteredTasks.insert(newIndex, task);
    notifyListeners();
  }

  void showOrHideFishingTasks() {
    showFinishingTasks = !showFinishingTasks;
    if (filterSelected == TaskFilterEnum.week &&
        seletedDay != null) {
      filterByDay(seletedDay!);
    } else {
      refreshPage();
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    showLoadingAndResetState();
    notifyListeners();
    await _tasksService.deleteTask(task.id);
    await refreshPage();
  }

  Future<void> goToEditTask(BuildContext context,
      TaskModel task) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration:
            const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation,
            secondaryAnimation, child) {
          animation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInQuad);
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: child,
          );
        },
        pageBuilder: (context, animation,
            secondaryAnimation) {
          return TasksModule()
              .getPage('/tasks/create', context);
        },
        settings: RouteSettings(
          arguments: {'task': task},
        ),
      ),
    );
    await refreshPage();
  }
}
