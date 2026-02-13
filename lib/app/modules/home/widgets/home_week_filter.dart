import 'dart:ui';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/app/core/ui/theme_extensions.dart';
import 'package:todolist/app/models/task_filter_enum.dart';
import 'package:todolist/app/modules/home/home_controller.dart';

class HomeWeekFilter extends StatelessWidget {
  const HomeWeekFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible:
          context.select<HomeController, bool>(
              (controller) =>
                  controller.filterSelected ==
                  TaskFilterEnum.week),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              // Camada de Sombra com Blur
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: 0.8, sigmaY: 0.8),
                child: Text(
                  'DIA DA SEMANA',
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
                'DIA DA SEMANA',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontFamily:
                          GoogleFonts.montserrat()
                              .fontFamily,
                      color: const Color.fromRGBO(
                          159, 172, 196, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 95,
            child: Selector<HomeController,
                DateTime>(
              selector: (context, controller) =>
                  controller.initialDateOfWeek ??
                  DateTime.now(),
              builder: (_, value, __) {
                return DatePicker(
                  value,
                  locale: 'pt_BR',
                  initialSelectedDate:
                      value,
                  selectionColor:
                      context.primaryColor,
                  selectedTextColor: Colors.white,
                  daysCount: 7,
                  monthTextStyle:
                      TextStyle(fontSize: 8),
                  dayTextStyle:
                      TextStyle(fontSize: 13),
                  dateTextStyle:
                      TextStyle(fontSize: 13),
                  onDateChange: (date){
                    context.read<HomeController>().filterByDay(date);
                  },    
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
