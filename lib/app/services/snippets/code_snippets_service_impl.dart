import 'package:todolist/app/repositories/snippets/code_snippets_repository.dart';
import 'package:todolist/app/services/snippets/code_snippets_service.dart';
import 'package:todolist/app/models/code_snippet_model.dart';

class CodeSnippetsServiceImpl
    implements CodeSnippetsService {
  final CodeSnippetsRepository _repository;

  CodeSnippetsServiceImpl(
      {required CodeSnippetsRepository
          repository})
      : _repository = repository;

  @override
  Future<void> save(String title, String code,
          DateTime dateTime) =>
      _repository.save(title, code, dateTime);

  @override
  Future<List<CodeSnippetModel>> findAll() =>
      _repository.findAll();

  @override
  Future<void> delete(int snippetId) =>
      _repository.delete(snippetId);

  @override
  Future<void> update(int snippetId, String title,
          String code, DateTime dateTime) =>
      _repository.update(
          snippetId, title, code, dateTime);
}
