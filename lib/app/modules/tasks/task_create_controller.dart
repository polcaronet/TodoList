import 'package:todolist/app/core/notifier/default_change_notifier.dart';
import 'package:todolist/app/models/task_model.dart';
import 'package:todolist/app/services/tasks/tasks_service.dart';

class TaskCreateController
    extends DefaultChangeNotifier {
  final TasksService _tasksService;
  DateTime? _selectedDate;
  TaskModel? task;

  TaskCreateController(
      {required TasksService tasksService})
      : _tasksService = tasksService;

  set selectedDate(DateTime? selectedDate) {
    _selectedDate = selectedDate;
    resetState();
    notifyListeners();
  }

  void setInitialDate(DateTime? date) {
    _selectedDate = date;
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save(String description) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      if (_selectedDate != null) {
        if (task != null) {
          await _tasksService.update(task!.id,
              _selectedDate!, description);
        } else {
          await _tasksService.save(
              _selectedDate!, description);
        }
        success();
      } else {
        setError('Data da task não selecionada!');
      }
    } catch (e) {
      setError('Erro ao salvar a task!');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
