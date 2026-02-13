import 'package:sqflite/sqflite.dart';
import 'package:todolist/app/core/database/migrations/migration.dart';

class MigrationV2 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
      create table code_snippets(
        id integer primary key autoincrement,
        title varchar(500) not null,
        code text not null,
        date_time datetime not null
      )
    ''');
  }

  @override
  void update(Batch batch) {}
}
