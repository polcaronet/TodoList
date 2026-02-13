import 'package:todolist/app/core/notifier/default_change_notifier.dart';
import 'package:todolist/app/services/snippets/code_snippets_service.dart';
import 'package:todolist/app/models/code_snippet_model.dart';

class CodeSnippetsController
    extends DefaultChangeNotifier {
  final CodeSnippetsService _codeSnippetsService;
  List<CodeSnippetModel> _snippets = [];
  DateTime? _selectedDate;
  CodeSnippetModel? snippet;

  CodeSnippetsController(
      {required CodeSnippetsService
          codeSnippetsService})
      : _codeSnippetsService =
            codeSnippetsService;

  List<CodeSnippetModel> get snippets =>
      _snippets;

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setInitialDate(DateTime? date) {
    _selectedDate = date;
  }

  Future<void> saveSnippet(
      String title, String code) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      if (_selectedDate != null) {
        if (snippet != null) {
          await _codeSnippetsService.update(
              snippet!.id,
              title,
              code,
              _selectedDate!);
        } else {
          await _codeSnippetsService.save(
              title, code, _selectedDate!);
        }
        success();
      } else {
        setError(
            'Data do snippet não selecionada!');
      }
    } catch (e) {
      setError(
          'Erro ao salvar o snippet de código');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> findAllSnippets() async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      _snippets =
          await _codeSnippetsService.findAll();
    } catch (e) {
      setError('Erro ao buscar os snippets');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> deleteSnippet(
      int snippetId) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      await _codeSnippetsService
          .delete(snippetId);
      await findAllSnippets();
    } catch (e) {
      setError('Erro ao deletar o snippet');
    }
  }
}
