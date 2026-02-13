import 'package:todolist/app/core/database/sqlite_connection_factory.dart';
import 'package:todolist/app/repositories/snippets/code_snippets_repository.dart';
import 'package:todolist/app/models/code_snippet_model.dart';

class CodeSnippetsRepositoryImpl
    implements CodeSnippetsRepository {
  final SqliteConnectionFactory
      _sqliteConnectionFactory;

  CodeSnippetsRepositoryImpl(
      {required SqliteConnectionFactory
          sqliteConnectionFactory})
      : _sqliteConnectionFactory =
            sqliteConnectionFactory;

  @override
  Future<void> save(String title, String code,
      DateTime dateTime) async {
    final conn = await _sqliteConnectionFactory
        .openConnection();
    await conn.rawInsert(
        'insert into code_snippets(title, code, date_time) values(?,?,?)',
        [
          title,
          code,
          dateTime.toIso8601String(),
        ]);
  }

  @override
  Future<List<CodeSnippetModel>> findAll() async {
    final conn = await _sqliteConnectionFactory
        .openConnection();
    final result = await conn
        .rawQuery('select * from code_snippets');
    return result
        .map((e) => CodeSnippetModel.fromDb(e))
        .toList();
  }

  @override
  Future<void> delete(int snippetId) async {
    final conn = await _sqliteConnectionFactory
        .openConnection();
    await conn.rawDelete(
        'delete from code_snippets where id = ?',
        [snippetId]);
  }

  @override
  Future<void> update(int snippetId, String title,
      String code, DateTime dateTime) async {
    final conn = await _sqliteConnectionFactory
        .openConnection();
    await conn.rawUpdate(
      'update code_snippets set title = ?, code = ?, date_time = ? where id = ?',
      [
        title,
        code,
        dateTime.toIso8601String(),
        snippetId
      ],
    );
  }
}
