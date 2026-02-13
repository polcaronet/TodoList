import 'package:todolist/app/core/notifier/default_change_notifier.dart';
import 'package:todolist/app/exeption/auth_exception.dart';
import 'package:todolist/app/services/user/user_service.dart';

class LoginController
    extends DefaultChangeNotifier {
  final UserService _userService;
  String? infoMessage;

  LoginController({
    required UserService userService,
  }) : _userService = userService;

  bool get hasInfo => infoMessage != null;

  Future<void> googleLogin() async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      final user =
          await _userService.googleLogin();

      if (user != null) {
        success();
      } else {
        _userService.logout();
        setError(
          'Erro ao fazer login com Google!',
        );
      }
    } on AuthException catch (e) {
      _userService.logout();
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    try {
      showLoadingAndResetState();
      await _userService.login(
        email.trim(),
        password,
      );
      success();
    } on AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError(
        'Erro ao fazer login: ${e.toString()}',
      );
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(
    String email,
  ) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      await _userService
          .forgotPassword(email.trim());
      infoMessage =
          'Reset de senha enviado para seu e-mail!';
    } on AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError(
        'Erro ao enviar reset de senha: ${e.toString()}',
      );
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
