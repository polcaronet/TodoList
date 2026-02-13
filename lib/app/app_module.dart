import 'package:firebase_auth/firebase_auth.dart'
    hide AuthProvider;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/app_widget.dart';
import 'package:todolist/app/core/database/sqlite_connection_factory.dart';
import 'package:todolist/app/repositories/user_repository.dart';
import 'package:todolist/app/core/auth/auth_provider.dart';
import 'package:todolist/app/repositories/user_repository_impl.dart';
import 'package:todolist/app/services/user/user_service.dart';
import 'package:todolist/app/services/user/user_service_impl.dart';

class AppModule extends StatelessWidget {
  const AppModule({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => FirebaseAuth.instance,
        ),
        Provider(
          create: (_) => FirebaseStorage.instance,
        ),
        Provider(
          create: (_) =>
              SqliteConnectionFactory(),
          lazy: false,
        ),
        Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(
              firebaseAuth: context.read(),
              firebaseStorage: context.read()),
        ),
        Provider<UserService>(
          create: (context) => UserServiceImpl(
            userRepository: context.read(),
          ),
        ),
        ChangeNotifierProvider(
            create: (context) => AuthProvider(
                  firebaseAuth: context.read(),
                  userService: context.read(),
                  sqliteConnectionFactory:
                      context.read(),
                )..loadListenner(),
            lazy: false)
      ],
      child: AppWidget(),
    );
  }
}
