import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<User?> register(
    String email,
    String password,
    String name,
  );
  Future<User?> login(
    String email,
    String password,
  );
  Future<void> forgotPassword(
    String email,
  );
  Future<User?> googleLogin();

  Future<void> logout();
  Future<void> updateDisplayName(String name);
  Future<String> uploadProfilePicture(
      String filePath);
}
