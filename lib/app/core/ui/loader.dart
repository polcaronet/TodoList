import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart'
    as overlay;
import 'package:todolist/app/core/ui/todo_list_ui_config.dart';

class Loader {
  static void show(BuildContext context) {
    overlay.Loader.show(
      context,
      progressIndicator:
          CircularProgressIndicator(
        color:
            TodoListUiConfig.theme.primaryColor,
      ),
      overlayColor: Colors.black.withOpacity(0.4),
    );
  }

  static void hide() {
    overlay.Loader.hide();
  }
}
