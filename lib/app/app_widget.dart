import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todolist/app/core/database/migrations/sqlite_adm_connection.dart';
import 'package:todolist/app/core/navigator/todo_list_navigator.dart';

import 'package:todolist/app/core/ui/todo_list_ui_config.dart';
import 'package:todolist/app/modules/auth/auth_module.dart';
import 'package:todolist/app/modules/snippets/code_snippets_module.dart';
import 'package:todolist/app/modules/home/home_module.dart';
import 'package:todolist/app/modules/splash/splash_page.dart';
import 'package:todolist/app/modules/tasks/tasks_module.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() =>
      _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final sqliteAdmConnection =
      SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    WidgetsBinding.instance.addObserver(
      sqliteAdmConnection,
    );
    print(auth);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(
      sqliteAdmConnection,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List Provider',
      theme: TodoListUiConfig.theme,
      navigatorKey:
          TodoListNavigator.navigatorKey,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      routes: {
        ...AuthModule().routers,
        ...HomeModule().routers,
        ...TasksModule().routers,
        ...CodeSnippetsModule().routers,
      },
      home: SplashPage(),
    );
  }
}
