import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:todolist/app/models/code_snippet_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/core/notifier/default_listener_notifier.dart';
import 'package:todolist/app/core/ui/theme_extensions.dart';
import 'package:todolist/app/modules/tasks/widgets/calendar_button.dart';
import 'package:todolist/app/modules/snippets/code_snippets_controller.dart';
import 'package:validatorless/validatorless.dart';

class CodeSnippetsPage extends StatefulWidget {
  final CodeSnippetsController _controller;
  final CodeSnippetModel? snippet;

  const CodeSnippetsPage(
      {super.key,
      required CodeSnippetsController controller,
      this.snippet})
      : _controller = controller;

  @override
  State<CodeSnippetsPage> createState() =>
      _CodeSnippetsPageState();
}

class _CodeSnippetsPageState
    extends State<CodeSnippetsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleEC = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(
            changeNotifier: widget._controller)
        .listener(
      context: context,
      sucessCallback:
          (notifier, listenerInstance) {
        listenerInstance.dispose();
        Navigator.of(context).pop();
      },
    );

    if (widget.snippet != null) {
      _titleEC.text = widget.snippet!.title;
      _codeController.text = widget.snippet!.code;
      widget._controller.setInitialDate(
          widget.snippet!.dateTime);
      widget._controller.snippet = widget.snippet;
    }
  }

  @override
  void dispose() {
    _titleEC.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
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
                  Icon(
                    Icons.close,
                    color: context.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              bottom:
                  80.0), // Adiciona espaço na parte inferior
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context)
                        .size
                        .height *
                    .8,
                margin:
                    const EdgeInsets.symmetric(
                        horizontal: 30),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        widget.snippet != null
                            ? 'Editar Snippet'
                            : 'Criar Snippet',
                        style: context.titleStyle
                            .copyWith(
                          fontSize: 22,
                          color: context
                              .primaryColor,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _titleEC,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Título do Snippet',
                        border:
                            OutlineInputBorder(),
                        isDense: true,
                      ),
                      validator:
                          Validatorless.required(
                              'Título obrigatório'),
                    ),
                    const SizedBox(height: 20),
                    Selector<
                        CodeSnippetsController,
                        DateTime?>(
                      selector: (context,
                              controller) =>
                          controller.selectedDate,
                      builder: (context,
                          selectedDate, child) {
                        return CalendarButton(
                          selectedDate:
                              selectedDate,
                          onTap: () async {
                            final date =
                                await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.now(),
                              firstDate:
                                  DateTime(2020),
                              lastDate: DateTime
                                      .now()
                                  .add(const Duration(
                                      days: 365 *
                                          10)),
                            );
                            if (date != null) {
                              widget._controller
                                      .selectedDate =
                                  date;
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TextFormField(
                        controller:
                            _codeController,
                        maxLines: null,
                        keyboardType:
                            TextInputType
                                .multiline,
                        expands: true,
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Cole seu código aqui...',
                          border:
                              OutlineInputBorder(),
                          alignLabelWithHint:
                              true,
                        ),
                        style: const TextStyle(
                            fontFamily:
                                'monospace',
                            fontSize: 14),
                        validator: Validatorless
                            .required(
                                'Código obrigatório'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton:
            FloatingActionButton.extended(
          onPressed: () {
            final formValid = _formKey
                    .currentState
                    ?.validate() ??
                false;
            if (formValid) {
              widget._controller.saveSnippet(
                  _titleEC.text,
                  _codeController.text);
            }
          },
          backgroundColor: context.primaryColor
              .withOpacity(0.8),
          label: Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: 0.8, sigmaY: 0.8),
                child: Text(
                  widget.snippet != null
                      ? 'Atualizar'
                      : 'Salvar Code',
                  style: (Theme.of(context)
                              .textTheme
                              .bodyLarge ??
                          const TextStyle())
                      .copyWith(
                    fontFamily:
                        GoogleFonts.montserrat()
                            .fontFamily,
                    fontWeight: FontWeight.w900,
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
              ),
              Text(
                widget.snippet != null
                    ? 'Atualizar'
                    : 'Salvar Code',
                style: (Theme.of(context)
                            .textTheme
                            .bodyLarge ??
                        const TextStyle())
                    .copyWith(
                  color: Colors.white,
                  fontFamily:
                      GoogleFonts.montserrat()
                          .fontFamily,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
