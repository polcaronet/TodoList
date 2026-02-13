import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/core/modules/todo_list_module.dart';
import 'package:todolist/app/models/code_snippet_model.dart';
import 'package:todolist/app/modules/snippets/code_snippet_detail_page.dart';
import 'package:todolist/app/modules/snippets/code_snippets_controller.dart';
import 'package:todolist/app/modules/snippets/code_snippets_list_page.dart';
import 'package:todolist/app/modules/snippets/code_snippets_page.dart';
import 'package:todolist/app/repositories/snippets/code_snippets_repository.dart';
import 'package:todolist/app/repositories/snippets/code_snippets_repository_impl.dart';
import 'package:todolist/app/services/snippets/code_snippets_service.dart';
import 'package:todolist/app/services/snippets/code_snippets_service_impl.dart';

class CodeSnippetsModule extends TodoListModule {
  CodeSnippetsModule()
      : super(
          bindings: [
            Provider<CodeSnippetsRepository>(
              create: (context) =>
                  CodeSnippetsRepositoryImpl(
                      sqliteConnectionFactory:
                          context.read()),
            ),
            Provider<CodeSnippetsService>(
              create: (context) =>
                  CodeSnippetsServiceImpl(
                      repository: context.read()),
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  CodeSnippetsController(
                      codeSnippetsService:
                          context.read()),
            ),
          ],
          routers: {
            '/code_snippets/create': (context) {
              final arguments =
                  ModalRoute.of(context)
                          ?.settings
                          .arguments
                      as Map<String, dynamic>?;
              return CodeSnippetsPage(
                  controller: context.read(),
                  snippet: arguments?['snippet']
                      as CodeSnippetModel?);
            },
            '/code_snippets/list': (context) {
              return CodeSnippetsListPage(
                  controller: context.read());
            },
            '/code_snippets/detail': (context) {
              final arguments =
                  ModalRoute.of(context)
                          ?.settings
                          .arguments
                      as Map<String, dynamic>;
              return CodeSnippetDetailPage(
                snippet: arguments['snippet']
                    as CodeSnippetModel,
              );
            },
          },
        );
}
