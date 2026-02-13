import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/models/task_filter_enum.dart';
import 'package:todolist/app/models/total_tasks_model.dart';
import 'package:todolist/app/modules/home/home_controller.dart';
import 'package:todolist/app/modules/home/widgets/todo_card_filter.dart';

class HomeFilters extends StatelessWidget {
  const HomeFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Camada de Sombra com Blur
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: 0.8, sigmaY: 0.8),
                child: Text(
                  'Filtros',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontFamily:
                        GoogleFonts.montserrat()
                            .fontFamily,
                    color: Colors.transparent,
                    fontSize: 20,
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
                'Filtros',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontFamily:
                          GoogleFonts.montserrat()
                              .fontFamily,
                      color: const Color.fromRGBO(
                          159, 172, 196, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 174,
                  height: 174,
                  child: TodoCardFilter(
                    label: 'HOJE',
                    taskFilter:
                        TaskFilterEnum.today,
                    totalTasksModel: context.select<
                            HomeController,
                            TotalTasksModel?>(
                        (controller) => controller
                            .todayTotalTasks),
                    selected: context.select<
                                HomeController,
                                TaskFilterEnum>(
                            (value) => value
                                .filterSelected) ==
                        TaskFilterEnum.today,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 174,
                  height: 174,
                  child: TodoCardFilter(
                    label: 'ONTEM',
                    taskFilter:
                        TaskFilterEnum.yesterday,
                    totalTasksModel: context.select<
                            HomeController,
                            TotalTasksModel?>(
                        (controller) => controller
                            .yesterdayTotalTasks),
                    selected: context.select<
                                HomeController,
                                TaskFilterEnum>(
                            (value) => value
                                .filterSelected) ==
                        TaskFilterEnum.yesterday,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 174,
                  height: 174,
                  child: TodoCardFilter(
                    label: 'AMANHÃ',
                    taskFilter:
                        TaskFilterEnum.tomorrow,
                    totalTasksModel: context.select<
                            HomeController,
                            TotalTasksModel?>(
                        (controller) => controller
                            .tomorrowTotalTasks),
                    selected: context.select<
                                HomeController,
                                TaskFilterEnum>(
                            (value) => value
                                .filterSelected) ==
                        TaskFilterEnum.tomorrow,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 174,
                  height: 174,
                  child: TodoCardFilter(
                    label: 'SEMANA',
                    taskFilter:
                        TaskFilterEnum.week,
                    totalTasksModel: context.select<
                            HomeController,
                            TotalTasksModel?>(
                        (controller) => controller
                            .weekTotalTasks),
                    selected: context.select<
                                HomeController,
                                TaskFilterEnum>(
                            (value) => value
                                .filterSelected) ==
                        TaskFilterEnum.week,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 174,
                  height: 174,
                  child: TodoCardFilter(
                    label: 'MÊS',
                    taskFilter:
                        TaskFilterEnum.month,
                    totalTasksModel: context.select<
                            HomeController,
                            TotalTasksModel?>(
                        (controller) => controller
                            .monthTotalTasks),
                    selected: context.select<
                                HomeController,
                                TaskFilterEnum>(
                            (value) => value
                                .filterSelected) ==
                        TaskFilterEnum.month,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 174,
                  height: 174,
                  child: TodoCardFilter(
                    label: 'ANO',
                    taskFilter:
                        TaskFilterEnum.year,
                    totalTasksModel: context.select<
                            HomeController,
                            TotalTasksModel?>(
                        (controller) => controller
                            .yearTotalTasks),
                    selected: context.select<
                                HomeController,
                                TaskFilterEnum>(
                            (value) => value
                                .filterSelected) ==
                        TaskFilterEnum.year,
                  ),
                ),
              ],
            ),
          ),
        ]);
  }
}
