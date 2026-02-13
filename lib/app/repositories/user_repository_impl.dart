import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todolist/app/exeption/auth_exception.dart';
import 'package:todolist/app/repositories/user_repository.dart';
import 'package:todolist/app/services/snippets/cloudinary_service.dart';

class UserRepositoryImpl
    implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseStorage firebaseStorage,
  }) : _firebaseAuth = firebaseAuth;

  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  User? get currentUser =>
      _firebaseAuth.currentUser;

  @override
  Future<User?> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user
          ?.updateDisplayName(name);
      await userCredential.user?.reload();

      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(
        e,
      );
    } catch (e) {
      throw AuthException(
        code: 'unknown-error',
        message:
            'Erro desconhecido ao cadastrar. Tente novamente mais tarde!',
      );
    }
  }

  @override
  Future<User?> login(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(
        e,
      );
    } catch (e) {
      throw AuthException(
        code: 'unknown-error',
        message:
            'Erro ao fazer login. Tente novamente mais tarde!',
      );
    }
  }

  @override
  Future<void> forgotPassword(
    String email,
  ) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(
        e,
      );
    } catch (e) {
      throw AuthException(
        code: 'unknown-error',
        message:
            'Erro ao enviar email de recuperação! Tente novamente!',
      );
    }
  }

  @override
  Future<User?> googleLogin() async {
    try {
      final googleSignIn = GoogleSignIn();

      // Forçar mostrar seletor de conta
      await googleSignIn.signOut();

      final googleUser =
          await googleSignIn.signIn();

      if (googleUser != null) {
        final googleAuth =
            await googleUser.authentication;

        // Tentar fazer login com a credencial do Google
        final firebaseCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        try {
          final userCredential =
              await _firebaseAuth
                  .signInWithCredential(
            firebaseCredential,
          );
          return userCredential.user;
        } on FirebaseAuthException catch (e) {
          // Se ocorrer erro de conta existente com outro provedor
          if (e.code ==
              'account-exists-with-different-credential') {
            throw AuthException(
              code: 'account_exists_with_email',
              message:
                  'Uma conta com este email já existe usando outro método. '
                  'Faça login com o método anterior.',
            );
          }
          // Re-throw outras exceções do Firebase
          rethrow;
        }
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: e.message ??
            'Erro ao fazer login com Google',
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      print('❌ ERRO: $e');
      print(
        '📍 StackTrace: ${StackTrace.current}',
      );
      throw AuthException(
        code: 'unknown_error',
        message:
            'Erro desconhecido ao fazer login com Google: $e',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(
        e,
      );
    } catch (e) {
      throw AuthException(
        code: 'unknown-error',
        message:
            'Erro desconhecido ao sair do Todo List. Tente novamente mais tarde.',
      );
    }
  }

  @override
  Future<void> updateDisplayName(
      String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload();
    }
  }

  @override
  Future<String> uploadProfilePicture(
      String filePath) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AuthException(
          code: 'user-not-found',
          message: 'Usuário não encontrado.');
    }

    // Armazena a URL da foto antiga antes de fazer o upload da nova.
    final oldPhotoURL = user.photoURL;

    try {
      // Utilizando o método de upload com assinatura (Signed), que é mais seguro.
      // O método Unsigned foi desativado conforme solicitado.
      final newImageUrl =
          await CloudinaryService.uploadImage(
              filePath);

      await user.updatePhotoURL(newImageUrl);
      await user.reload();

      // Se existia uma foto antiga e ela era do Cloudinary, exclui-a.
      if (oldPhotoURL != null &&
          oldPhotoURL.isNotEmpty) {
        await CloudinaryService.deleteImage(
            oldPhotoURL);
      }

      return newImageUrl;
    } catch (e) {
      print(
          'Erro ao fazer upload da imagem para o Cloudinary: $e');
      rethrow;
    }
  }
}
