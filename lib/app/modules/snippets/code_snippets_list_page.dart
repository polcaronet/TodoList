import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:todolist/app/core/ui/theme_extensions.dart';
import 'package:todolist/app/modules/snippets/code_snippets_controller.dart';
import 'package:todolist/app/models/code_snippet_model.dart';

class CodeSnippetsListPage
    extends StatefulWidget {
  final CodeSnippetsController _controller;

  const CodeSnippetsListPage(
      {super.key,
      required CodeSnippetsController controller})
      : _controller = controller;

  @override
  State<CodeSnippetsListPage> createState() =>
      _CodeSnippetsListPageState();
}

class _CodeSnippetsListPageState
    extends State<CodeSnippetsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      widget._controller.findAllSnippets();
    });
  }

  Future<bool> _showDeleteConfirmationDialog(
      CodeSnippetModel snippet) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title:
                  const Text('Excluir Snippet'),
              content: Text(
                  'Confirma a exclusão do snippet "${snippet.title}"?'),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(context)
                          .pop(false),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                        color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context)
                          .pop(true),
                  child: const Text('Excluir',
                      style: TextStyle(
                          color: Colors.blue)),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: context.primaryColor,
        ),
        title: Stack(
          children: [
            // Camada de Sombra
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                  sigmaX: 0.8, sigmaY: 0.8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Meus Snippets de Código',
                  style:
                      context.titleStyle.copyWith(
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
            ),
            // Texto Nítido
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Meus Snippets de Código',
                style:
                    context.titleStyle.copyWith(
                  color: context.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<CodeSnippetsController>(
        builder: (context, controller, child) {
          if (controller.loading) {
            return const Center(
                child:
                    CircularProgressIndicator());
          }

          if (controller.snippets.isEmpty) {
            return Center(
              child: Stack(
                children: [
                  // Camada de Sombra
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(
                        sigmaX: 0.8, sigmaY: 0.8),
                    child: const Text(
                      'Nenhum snippet salvo ainda.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.transparent,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Texto Nítido
                  const Text(
                    'Nenhum snippet salvo ainda.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(
                          159,
                          172,
                          196,
                          1), // Tom de azul acinzentado
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.snippets.length,
            itemBuilder: (context, index) {
              final snippet =
                  controller.snippets[index];
              return Dismissible(
                key: ValueKey(snippet.id),
                direction:
                    DismissDirection.horizontal,
                confirmDismiss:
                    (direction) async {
                  if (direction ==
                      DismissDirection
                          .endToStart) {
                    return await _showDeleteConfirmationDialog(
                        snippet);
                  } else {
                    final confirmed =
                        await showDialog<bool>(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                        title: const Text(
                            'Editar Snippet'),
                        content: Text(
                            'Deseja editar o snippet "${snippet.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(
                                        context)
                                    .pop(false),
                            child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                    color: Colors
                                        .red)),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(
                                        context)
                                    .pop(true),
                            child: const Text(
                                'Editar',
                                style: TextStyle(
                                    color: Colors
                                        .blue)),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      Navigator.of(context)
                          .pushNamed(
                        '/code_snippets/create',
                        arguments: {
                          'snippet': snippet
                        },
                      );
                    }
                    return false;
                  }
                },
                onDismissed: (_) {
                  widget._controller
                      .deleteSnippet(snippet.id);
                },
                secondaryBackground: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  margin:
                      const EdgeInsets.symmetric(
                          vertical: 8),
                  alignment:
                      Alignment.centerRight,
                  padding: const EdgeInsets.only(
                      right: 20),
                  child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 30),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  margin:
                      const EdgeInsets.symmetric(
                          vertical: 8),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                      left: 20),
                  child: const Icon(
                    Icons.edit_note,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.4),
                        offset:
                            const Offset(2, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  margin:
                      const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8),
                  child: ListTile(
                    title: Text(snippet.title),
                    subtitle: Text(
                      snippet.code,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(
                        '/code_snippets/detail',
                        arguments: {
                          'snippet': snippet
                        },
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              12),
                      side: BorderSide(
                        width: 1,
                        color: Colors.grey
                            .withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .pushNamed('/code_snippets/create');
          widget._controller.findAllSnippets();
        },
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add,
            color: Colors.white),
      ),
    );
  }
}
