import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String code;
  final String message;

  AuthException({
    required this.code,
    required this.message,
  });

  factory AuthException.fromFirebaseException(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthException(
          code: 'email-already-in-use',
          message:
              'Este email já está registrado, por favor tente outro email.',
        );
      case 'weak-password':
        return AuthException(
          code: 'weak-password',
          message:
              'A senha deve ter pelo menos 6 caracteres para sua segurança no Todo List.',
        );
      case 'invalid-email':
        return AuthException(
          code: 'invalid-email',
          message:
              'O email fornecido não é válido. Verifique e tente novamente no Todo List.',
        );
      case 'user-not-found':
        return AuthException(
          code: 'user-not-found',
          message:
              'Usuário não encontrado no Todo List. Faça seu cadastro ou tente outro email.',
        );
      case 'wrong-password':
        return AuthException(
          code: 'wrong-password',
          message:
              'Senha incorreta. Verifique sua senha ou clique em "Esqueceu a senha?".',
        );
      case 'user-disabled':
        return AuthException(
          code: 'user-disabled',
          message:
              'Este usuário foi desativado no Todo List. Entre em contato com o suporte.',
        );
      case 'account-exists-with-different-credential':
        return AuthException(
          code:
              'account-exists-with-different-credential',
          message:
              'Este email já está associado a outra conta no Todo List. Tente fazer login com Google ou use outro método.',
        );
      case 'invalid-credential':
        return AuthException(
          code: 'invalid-credential',
          message:
              'Credenciais inválidas. Tente fazer login novamente no Todo List!',
        );
      case 'operation-not-allowed':
        return AuthException(
          code: 'operation-not-allowed',
          message:
              'Este método de autenticação não está habilitado no Todo List. Tente "Continuar com Google".',
        );
      case 'too-many-requests':
        return AuthException(
          code: 'too-many-requests',
          message:
              'Muitas tentativas de login. Aguarde alguns minutos antes de tentar novamente no Todo List.',
        );
      case 'network-request-failed':
        return AuthException(
          code: 'network-request-failed',
          message:
              'Erro de conexão. Verifique sua internet e tente novamente no Todo List.',
        );
      case 'invalid-display-name':
        return AuthException(
          code: 'invalid-display-name',
          message:
              'Nome inválido. Verifique e tente novamente no Todo List.',
        );
      default:
        return AuthException(
          code: e.code,
          message:
              e.message ??
              'Erro na autenticação do Todo List. Tente novamente.',
        );
    }
  }

  @override
  String toString() => message;
}
