import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todolist/app/core/notifier/default_change_notifier.dart';
import 'package:todolist/app/core/ui/messages.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;
  DefaultListenerNotifier({
    required this.changeNotifier,
  });

  void listener({
    required BuildContext context,
    required SucessVoidCallback sucessCallback,
    EverVoidCallback? everCallback,
    ErrorVoidCallback? errorCallback,
  }) {
    changeNotifier.addListener(() {
      if (everCallback != null) {
        everCallback(changeNotifier, this);
      }

      if (changeNotifier.loading) {
        Loader.show(context);
      } else {
        Loader.hide();
      }

      if (changeNotifier.hasError) {
        if (errorCallback != null) {
          errorCallback(changeNotifier, this);
        }
        Messages.of(context).showError(
          changeNotifier.error ?? 'Erro interno!',
        );
      } else if (changeNotifier.isSuccess) {
        sucessCallback(changeNotifier, this);
      }
    });
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SucessVoidCallback =
    void Function(
      DefaultChangeNotifier changeNotifier,
      DefaultListenerNotifier listenerInstance,
    );
typedef ErrorVoidCallback =
    void Function(
      DefaultChangeNotifier changeNotifier,
      DefaultListenerNotifier listenerInstance,
    );
typedef EverVoidCallback =
    void Function(
      DefaultChangeNotifier changeNotifier,
      DefaultListenerNotifier listenerInstance,
    );
