import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/core/ui/theme_extensions.dart';
import 'package:todolist/app/models/task_filter_enum.dart';
import 'package:todolist/app/models/total_tasks_model.dart';
import 'package:todolist/app/modules/home/home_controller.dart';

class TodoCardFilter extends StatelessWidget {
  final String label;
  final TaskFilterEnum taskFilter;
  final TotalTasksModel? totalTasksModel;
  final bool selected;

  const TodoCardFilter({
    super.key,
    required this.label,
    required this.taskFilter,
    this.totalTasksModel,
    required this.selected,
  });

  double _getPercentFinish() {
    final total =
        totalTasksModel?.totalTasks ?? 0.0;
    final totalFinish =
        totalTasksModel?.totalTasksFinish ?? 0.1;

    if (total == 0) {
      return 0.0;
    } else {
      final percent = (totalFinish * 100) / total;
      return percent / 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks =
        totalTasksModel?.totalTasks ?? 0;
    final totalTasksFinish =
        totalTasksModel?.totalTasksFinish ?? 0;
    final pendingTasks =
        totalTasks - totalTasksFinish;
    final tasksText = selected
        ? '$pendingTasks PENDENTES'
        : '$totalTasks TASKS';

    return InkWell(
      onTap: () => context
          .read<HomeController>()
          .findTasks(filter: taskFilter),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 120,
          maxWidth: 150,
        ),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected
              ? context.primaryColor
              : Colors.white,
          border: Border.all(
              width: 1,
              color:
                  Colors.grey.withOpacity(0.8)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tasksText,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    fontSize: 12,
                    color: selected
                        ? Colors.white
                        : Colors.grey,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                      fontSize: 28,
                      color: selected
                          ? Colors.white
                          : Colors.black87,
                      fontWeight:
                          FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(4),
                child:
                    TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0.0,
                    end: _getPercentFinish(),
                  ),
                  duration: Duration(seconds: 1),
                  builder:
                      (context, value, child) {
                    return LinearProgressIndicator(
                      backgroundColor: selected
                          ? context
                              .primaryColorLight
                          : Colors.grey.shade300,
                      valueColor:
                          AlwaysStoppedAnimation<
                                  Color>(
                              selected
                                  ? Colors.white
                                  : context
                                      .primaryColor),
                      value: value,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
