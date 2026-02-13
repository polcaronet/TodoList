import 'package:todolist/app/core/notifier/default_change_notifier.dart';
import 'package:todolist/app/exeption/auth_exception.dart';
import 'package:todolist/app/services/user/user_service.dart';

class RegisterController
    extends DefaultChangeNotifier {
  final UserService _userService;

  RegisterController({
    required UserService userService,
  }) : _userService = userService;

  Future<void> registerUser(
    String email,
    String password,
    String name,
  ) async {
    try {
      showLoadingAndResetState();
      notifyListeners();

      final user = await _userService.register(
        email: email,
        password: password,
        name: name,
      );

      if (user != null) {
        success();
      } else {
        setError('Erro ao registrar usuário!');
      }
    } on AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError(
        'Erro ao registrar: ${e.toString()}',
      );
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
