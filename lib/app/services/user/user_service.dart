import 'package:firebase_auth/firebase_auth.dart';

abstract class UserService {
  Future<User?> register({
    required String email,
    required String password,
    required String name,
  });
  Future<User?> login(
    String email,
    String password,
  );

  Future<void> forgotPassword(String email);

  Future<User?> googleLogin();

  Future<void> logout();
  Future<void> updateDisplayName(String name);
  Future<String> uploadProfilePicture(
      String filePath);
}
