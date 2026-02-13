import 'package:flutter/material.dart';
import 'package:todolist/app/core/notifier/default_listener_notifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/app/core/ui/theme_extensions.dart';
import 'package:todolist/app/core/ui/todo_list_icons_icons.dart';
import 'package:todolist/app/models/task_filter_enum.dart';
import 'package:todolist/app/modules/home/home_controller.dart';
import 'package:todolist/app/modules/home/widgets/home_drawer.dart';
import 'package:todolist/app/modules/home/widgets/home_filters.dart';
import 'package:todolist/app/modules/home/widgets/home_header.dart';
import 'package:todolist/app/modules/home/widgets/home_tasks.dart';
import 'package:todolist/app/modules/home/widgets/home_week_filter.dart';
import 'package:todolist/app/modules/tasks/tasks_module.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;

  const HomePage(
      {super.key,
      required HomeController homeController})
      : _homeController = homeController;

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(
            changeNotifier:
                widget._homeController)
        .listener(
            context: context,
            sucessCallback:
                (notifier, listenerInstance) {
              listenerInstance.dispose();
            });

    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) {
      widget._homeController.findTasks(
          filter: TaskFilterEnum.today);
      widget._homeController.loadTotalTasks();
    });
  }

  Future<void> _goToCreateTask(
      BuildContext context) async {
    await Navigator.of(context)
        .push(PageRouteBuilder(
      transitionDuration:
          Duration(milliseconds: 400),
      transitionsBuilder: (context, animation,
          secondaryAnimation, child) {
        animation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInQuad);
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.bottomRight,
          child: child,
        );
      },
      pageBuilder: (context, animation,
          secondaryAnimation) {
        return TasksModule()
            .getPage('/tasks/create', context);
      },
    ));
    widget._homeController.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFAFBFE),
          iconTheme: IconThemeData(
            color: context.primaryColor,
          ),
          elevation: 0,
          shadowColor: Colors.black.withValues(
            alpha: 0.2,
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                onSelected: (value) {
                  widget._homeController
                      .showOrHideFishingTasks();
                },
                icon: const Icon(
                  // Ícone de filtro alterado para bloco de notas
                  TodoListIcons.filter,
                  size: 18,
                ),
                itemBuilder: (_) => [
                      PopupMenuItem<bool>(
                          value: true,
                          child: Text(
                            '${widget._homeController.showFinishingTasks ? 'Esconder' : 'Mostrar'} tarefas concluídas',
                            style:
                                Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                              fontFamily: GoogleFonts
                                      .dancingScript()
                                  .fontFamily,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.w700,
                              color: context
                                  .primaryColor,
                              shadows: [
                                Shadow(
                                  color: Colors
                                      .black
                                      .withOpacity(
                                          0.4),
                                  offset:
                                      const Offset(
                                          1, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ))
                    ]),
            IconButton(
              onPressed: () {
                // Altera a navegação para a nova tela de lista
                Navigator.of(context).pushNamed(
                    '/code_snippets/list');
              },
              icon: const Icon(
                  // Novo botão para snippets de código
                  Icons.code,
                  size: 28,)
            ),
          ],
        ),
        floatingActionButton:
            FloatingActionButton(
          onPressed: () =>
              _goToCreateTask(context),
          backgroundColor: context.primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFFAFBFE),
        drawer: HomeDrawer(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      HomeHeader(),
                      HomeFilters(),
                      HomeWeekFilter(),
                      HomeTasks(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
