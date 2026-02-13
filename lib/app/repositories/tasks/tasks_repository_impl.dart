import 'package:todolist/app/core/database/sqlite_connection_factory.dart';
import 'package:todolist/app/models/task_model.dart';
import 'package:todolist/app/repositories/tasks/tasks_repository.dart';

class TasksRepositoryImpl
    implements TasksRepository {
  final SqliteConnectionFactory
      _sqliteConnectionFactory;

  TasksRepositoryImpl({
    required SqliteConnectionFactory
        sqliteConnectionFactory,
  }) : _sqliteConnectionFactory =
            sqliteConnectionFactory;

  @override
  Future<void> save(
      DateTime date, String description) async {
    final conn = await _sqliteConnectionFactory
        .openConnection();
    await conn.rawInsert(
      'INSERT Into todo(id, descricao, data_hora, finalizado) values(?, ?, ?, ?)',
      [
        null,
        description,
        date.toIso8601String(),
        0,
      ],
    );
  }

  @override
  Future<List<TaskModel>> findByPeriod(
      DateTime startDate,
      DateTime endDate) async {
    final startFilter = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      0,
      0,
      0,
    );
    final endFilter = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
    );

    final conn = await _sqliteConnectionFactory
        .openConnection();

    final result =
        await conn.rawQuery('''select * from todo
      where data_hora between '${startFilter.toIso8601String()}' and '${endFilter.toIso8601String()}'
      order by data_hora''');

    if (result.isEmpty) {
      return [];
    }

    return result
        .map((e) => TaskModel.loadFromDB(e))
        .toList();
  }

  @override
  Future<void> checkOrUncheckTask(
      TaskModel task) async {
    final conn = await _sqliteConnectionFactory
        .openConnection();
    final finished = task.finished ? 1 : 0;
    await conn.rawUpdate(
      'update todo set finalizado = ? where id = ?',
      [finished, task.id],
    );
  }

  @override
  Future<void> deleteTask(int taskId) async {
    final conn = await _sqliteConnectionFactory
        .openConnection();
    await conn.rawDelete(
        'delete from todo where id = ?',
        [taskId]);
  }

  @override
  Future<void> update(int taskId, DateTime date,
      String description) async {
    final conn = await _sqliteConnectionFactory
        .openConnection();
    await conn.rawUpdate(
      'update todo set descricao = ?, data_hora = ? where id = ?',
      [
        description,
        date.toIso8601String(),
        taskId
      ],
    );
  }
}
