import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/app/models/task_model.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/core/notifier/default_listener_notifier.dart';

import 'package:todolist/app/modules/tasks/task_create_controller.dart';

import 'package:todolist/app/core/ui/theme_extensions.dart';
import 'package:todolist/app/modules/tasks/widgets/calendar_button.dart';
import 'package:validatorless/validatorless.dart';

class TaskCreatePage extends StatefulWidget {
  final TaskCreateController _controller;
  final TaskModel? task;

  const TaskCreatePage(
      {super.key,
      required TaskCreateController controller,
      this.task})
      : _controller = controller,
        super();

  @override
  State<TaskCreatePage> createState() =>
      _TaskCreatePageState();
}

class _TaskCreatePageState
    extends State<TaskCreatePage> {
  final _descriptionEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(
      changeNotifier: widget._controller,
    ).listener(
      context: context,
      sucessCallback:
          (changeNotifier, listenerInstance) {
        listenerInstance.dispose();
        Navigator.of(context).pop();
      },
    );

    if (widget.task != null) {
      _descriptionEC.text =
          widget.task!.description;
      widget._controller
          .setInitialDate(widget.task!.dateTime);
      widget._controller.task = widget.task;
    }
  }

  @override
  void dispose() {
    _descriptionEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pop(),
            icon: Stack(
              children: [
                // Camada de Sombra com Blur
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                      sigmaX: 0.8, sigmaY: 0.8),
                  child: Icon(
                    Icons.close,
                    color: Colors.transparent,
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
                // Ícone Nítido
                Icon(
                  Icons.close,
                  color: context.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton.extended(
              onPressed: () {
                final formValid = _formKey
                        .currentState
                        ?.validate() ??
                    false;
                if (formValid) {
                  widget._controller
                      .save(_descriptionEC.text);
                }
              },
              backgroundColor: context
                  .primaryColor
                  .withOpacity(0.8),
              label: Stack(
                children: [
                  // Camada de Sombra com Blur
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(
                        sigmaX: 0.8, sigmaY: 0.8),
                    child: Text(
                      'Salvar Task',
                      style: (Theme.of(context)
                                  .textTheme
                                  .bodyLarge ??
                              TextStyle())
                          .copyWith(
                        fontFamily: GoogleFonts
                                .montserrat()
                            .fontFamily,
                        fontWeight:
                            FontWeight.w900,
                        color: Colors.transparent,
                        shadows: [
                          Shadow(
                            color: Colors.black
                                .withOpacity(
                                    0.25),
                            offset: const Offset(
                                2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Texto Nítido
                  Text(
                    'Salvar Task',
                    style: (Theme.of(context)
                                .textTheme
                                .bodyLarge ??
                            TextStyle())
                        .copyWith(
                      color: Colors.white,
                      fontFamily:
                          GoogleFonts.montserrat()
                              .fontFamily,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              )),
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 30),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      // Camada de Sombra com Blur
                      ImageFiltered(
                        imageFilter:
                            ImageFilter.blur(
                                sigmaX: 0.8,
                                sigmaY: 0.8),
                        child: Text(
                            widget.task != null
                                ? 'Editar Nota'
                                : 'Criar Nota',
                            style: (Theme.of(
                                            context)
                                        .textTheme
                                        .titleLarge ??
                                    TextStyle())
                                .copyWith(
                              fontFamily: GoogleFonts
                                      .eduNswActFoundation()
                                  .fontFamily,
                              color: Colors
                                  .transparent,
                              fontSize: 30,
                              fontWeight:
                                  FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors
                                      .black
                                      .withOpacity(
                                          0.25),
                                  offset:
                                      const Offset(
                                          2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            )),
                      ),
                      // Camada de Texto Nítido
                      Text(
                        widget.task != null
                            ? 'Editar Nota'
                            : 'Criar Nota',
                        style: (Theme.of(context)
                                    .textTheme
                                    .titleLarge ??
                                TextStyle())
                            .copyWith(
                          color: context
                              .primaryColor,
                          fontFamily: GoogleFonts
                                  .eduNswActFoundation()
                              .fontFamily,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _descriptionEC,
                  maxLines: null,
                  keyboardType:
                      TextInputType.multiline,
                  decoration: InputDecoration(
                    label: Stack(
                      children: [
                        // Camada de Sombra com Blur
                        ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(
                                  sigmaX: 0.8,
                                  sigmaY: 0.8),
                          child: Text(
                            'Escreva uma nota!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors
                                  .transparent,
                              shadows: [
                                Shadow(
                                  color: Colors
                                      .black
                                      .withOpacity(
                                          0.25),
                                  offset:
                                      const Offset(
                                          1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Texto Nítido
                        Text(
                          'Escreva uma nota!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors
                                .grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              15),
                    ),
                    errorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              15),
                      borderSide: BorderSide(
                          color: Colors.red),
                    ),
                    isDense: true,
                  ),
                  validator:
                      Validatorless.required(
                          'Nota é obrigatoria!'),
                ),
                SizedBox(height: 20),
                Selector<TaskCreateController,
                    DateTime?>(
                  selector:
                      (context, controller) =>
                          controller.selectedDate,
                  builder: (context, selectedDate,
                      child) {
                    return CalendarButton(
                      selectedDate: selectedDate,
                      onTap: () async {
                        final date =
                            await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now(),
                          firstDate:
                              DateTime(2020),
                          lastDate: DateTime.now()
                              .add(const Duration(
                                  days:
                                      365 * 10)),
                        );
                        if (date != null) {
                          context
                              .read<
                                  TaskCreateController>()
                              .selectedDate = date;
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
