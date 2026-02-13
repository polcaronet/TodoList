import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/models/task_filter_enum.dart';
import 'package:todolist/app/models/task_model.dart';
import 'package:todolist/app/modules/home/widgets/task.dart';
import 'package:todolist/app/modules/home/home_controller.dart';

class HomeTasks extends StatelessWidget {
  const HomeTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Selector<HomeController, String>(
          selector: (context, controller) {
            return controller
                .filterSelected.description;
          },
          builder: (context, description, child) {
            return Stack(
              children: [
                // Camada de Sombra com Blur
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                      sigmaX: 0.8, sigmaY: 0.8),
                  child: Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontFamily:
                          GoogleFonts.montserrat()
                              .fontFamily,
                      color: Colors.transparent,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black
                              .withOpacity(0.25),
                          offset:
                              const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                // Camada de Texto Nítido
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontFamily: GoogleFonts
                                .montserrat()
                            .fontFamily,
                        color:
                            const Color.fromRGBO(
                                159, 172, 196, 1),
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                      ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Selector<HomeController, List<TaskModel>>(
          selector: (context, controller) =>
              controller.filteredTasks,
          builder: (context, tasks, child) {
            return ReorderableListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Task(
                  key: ValueKey(task
                      .id), // Chave é essencial para reordenação
                  model: task,
                );
              },
              onReorder: (oldIndex, newIndex) {
                context
                    .read<HomeController>()
                    .reorderTasks(
                        oldIndex, newIndex);
              },
            );
          },
        )
      ],
    );
  }
}
