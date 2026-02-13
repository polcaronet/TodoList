import 'package:provider/provider.dart';
import 'package:todolist/app/core/modules/todo_list_module.dart';
import 'package:todolist/app/modules/home/home_controller.dart';
import 'package:todolist/app/modules/home/home_page.dart';
import 'package:todolist/app/repositories/tasks/tasks_repository.dart';
import 'package:todolist/app/models/task_filter_enum.dart';
import 'package:todolist/app/repositories/tasks/tasks_repository_impl.dart';
import 'package:todolist/app/services/tasks/tasks_service.dart';
import 'package:todolist/app/services/tasks/tasks_service_impl.dart';

class HomeModule extends TodoListModule {
  HomeModule()
      : super(
          bindings: [
            Provider<TasksRepository>(
              create: (context) =>
                  TasksRepositoryImpl(
                      sqliteConnectionFactory:
                          context.read()),
            ),
            Provider<TasksService>(
              create: (context) =>
                  TasksServiceImpl(
                      tasksRepository:
                          context.read()),
            ),
            ChangeNotifierProvider(
              create: (context) => HomeController(
                tasksService: context.read(),
                initialFilterSelected:
                    TaskFilterEnum.today,
              ),
            )
          ],
          routers: {
            '/home': (context) => HomePage(
                  homeController: context.read(),
                ),
          },
        );
}
