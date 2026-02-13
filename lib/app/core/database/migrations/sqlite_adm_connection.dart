import 'package:flutter/widgets.dart';
import 'package:todolist/app/core/database/sqlite_connection_factory.dart';

class SqliteAdmConnection
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    final connection = SqliteConnectionFactory();

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        connection.closeConnection();
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
