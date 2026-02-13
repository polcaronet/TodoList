import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/core/modules/todo_list_module.dart';
import 'package:todolist/app/models/task_model.dart';
import 'package:todolist/app/modules/tasks/task_create_controller.dart';
import 'package:todolist/app/modules/tasks/task_create_page.dart';
import 'package:todolist/app/repositories/tasks/tasks_repository.dart';
import 'package:todolist/app/repositories/tasks/tasks_repository_impl.dart';
import 'package:todolist/app/services/tasks/tasks_service.dart';
import 'package:todolist/app/services/tasks/tasks_service_impl.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(bindings: [
          Provider<TasksRepository>(
            create: (context) =>
                TasksRepositoryImpl(
                    sqliteConnectionFactory:
                        context.read()),
          ),
          Provider<TasksService>(
            create: (context) => TasksServiceImpl(
                tasksRepository: context.read()),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                TaskCreateController(
                    tasksService: context.read()),
          )
        ], routers: {
          '/tasks/create': (context) {
            final arguments =
                ModalRoute.of(context)
                        ?.settings
                        .arguments
                    as Map<String, dynamic>?;
            final task =
                arguments?['task'] as TaskModel?;

            return TaskCreatePage(
              controller: context.read(),
              task: task,
            );
          }
        });
}
