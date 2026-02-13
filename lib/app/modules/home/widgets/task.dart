import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todolist/app/core/ui/theme_extensions.dart';
import 'package:todolist/app/models/task_model.dart';
import 'package:todolist/app/modules/home/home_controller.dart';

class Task extends StatelessWidget {
  static final _dateFormat =
      DateFormat('dd/MM/yyyy');
  final TaskModel model;

  const Task({
    super.key,
    required this.model,
  });

  Future<bool> _showConfirmationDialog(
      BuildContext context,
      DismissDirection direction) async {
    final isDelete =
        direction == DismissDirection.endToStart;
    final title = isDelete
        ? 'Excluir Tarefa'
        : 'Editar Tarefa';
    final content = isDelete
        ? 'Confirma a exclusão da tarefa "${model.description}"?'
        : 'Deseja editar a tarefa "${model.description}"?';
    final confirmText =
        isDelete ? 'Excluir' : 'Editar';

    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(context)
                          .pop(false),
                  child: Text('Cancelar',
                      style: TextStyle(
                          color: isDelete
                              ? Colors.red
                              : null)),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context)
                          .pop(true),
                  child: Text(confirmText),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(model.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction ==
            DismissDirection.endToStart) {
          return _showConfirmationDialog(
              context, direction);
        } else {
          final confirmed =
              await _showConfirmationDialog(
                  context, direction);
          if (confirmed == true) {
            context
                .read<HomeController>()
                .goToEditTask(context, model);
          }
          return false;
        }
      },
      onDismissed: (_) {
        context
            .read<HomeController>()
            .deleteTask(model);
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(
            vertical: 5),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.edit_note,
            color: Colors.white, size: 30),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(
            vertical: 5),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline,
            color: Colors.white, size: 30),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.4),
              offset: const Offset(2, 3),
              blurRadius: 6,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(
            vertical: 5),
        child: ListTile(
          onTap: () {
            context
                .read<HomeController>()
                .goToEditTask(context, model);
          },
          contentPadding: EdgeInsets.all(8),
          leading: Checkbox(
            onChanged: (value) => context
                .read<HomeController>()
                .checkOrUncheckTask(model),
            value: model.finished,
            activeColor: context.primaryColor,
          ),
          title: Text(
            model.description,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontSize: 16,
                  fontFamily:
                      GoogleFonts.montserrat()
                          .fontFamily,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  decoration: model.finished
                      ? TextDecoration.lineThrough
                      : null,
                ),
          ),
          subtitle: Text(
            _dateFormat.format(model.dateTime),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  fontSize: 14,
                  fontFamily:
                      GoogleFonts.montserrat()
                          .fontFamily,
                  color: Colors.grey.shade600,
                  decoration: model.finished
                      ? TextDecoration.lineThrough
                      : null,
                ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
              side: BorderSide(
                width: 1,
                color:
                    Colors.grey.withOpacity(0.8),
              )),
        ),
      ),
    );
  }
}
