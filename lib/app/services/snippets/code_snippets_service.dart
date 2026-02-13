import 'package:todolist/app/models/code_snippet_model.dart';

abstract class CodeSnippetsService {
  Future<void> save(String title, String code,
      DateTime dateTime);
  Future<List<CodeSnippetModel>> findAll();
  Future<void> delete(int snippetId);
  Future<void> update(int snippetId, String title,
      String code, DateTime dateTime);
}
