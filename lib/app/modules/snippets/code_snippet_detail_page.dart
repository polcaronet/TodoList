import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:todolist/app/models/code_snippet_model.dart';

class CodeSnippetDetailPage
    extends StatelessWidget {
  final CodeSnippetModel snippet;

  const CodeSnippetDetailPage(
      {super.key, required this.snippet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(snippet.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/code_snippets/create',
                arguments: {'snippet': snippet},
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SyntaxView(
        code: snippet.code,
        syntax: Syntax.DART,
        syntaxTheme: SyntaxTheme
            .dracula(), // Changed to use SyntaxTheme.dracula()
        withZoom: true,
        withLinesCount: true,
        expanded: true,
      ),
    );
  }
}
