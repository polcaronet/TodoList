class CodeSnippetModel {
  final int id;
  final String title;
  final String code;
  final DateTime dateTime;

  CodeSnippetModel({
    required this.id,
    required this.title,
    required this.code,
    required this.dateTime,
  });

  // Exemplo de um construtor para carregar do banco de dados
  factory CodeSnippetModel.fromDb(
      Map<String, dynamic> db) {
    return CodeSnippetModel(
      id: db['id'],
      title: db['title'],
      code: db['code'],
      dateTime: DateTime.parse(db['date_time']),
    );
  }
}
