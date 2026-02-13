import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/app/core/database/sqlite_connection_factory.dart';
import 'package:todolist/app/core/navigator/todo_list_navigator.dart';
import 'package:todolist/app/services/user/user_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService;
  final SqliteConnectionFactory
      _sqliteConnectionFactory;

  AuthProvider({
    required FirebaseAuth firebaseAuth,
    required UserService userService,
    required SqliteConnectionFactory
        sqliteConnectionFactory,
  })  : _firebaseAuth = firebaseAuth,
        _userService = userService,
        _sqliteConnectionFactory =
            sqliteConnectionFactory;

  Future<void> logout() {
    _sqliteConnectionFactory.closeConnection();
    return _userService.logout();
  }

  User? get user => _firebaseAuth.currentUser;
  void loadListenner() {
    _firebaseAuth
        .userChanges()
        .listen((_) => notifyListeners());
    _firebaseAuth
        .idTokenChanges()
        .listen((user) async {
      await user?.reload();
      if (user != null) {
        TodoListNavigator.to
            .pushNamedAndRemoveUntil(
                '/home', (route) => false);
      } else {
        TodoListNavigator.to
            .pushNamedAndRemoveUntil(
                '/login', (route) => false);
      }
    });
  }

  Future<void> updateDisplayName(
      String name) async {
    await _userService.updateDisplayName(name);
    notifyListeners();
  }

  Future<void> uploadProfilePicture(
      String filePath) async {
    await _userService
        .uploadProfilePicture(filePath);
    notifyListeners();
  }
}
