import 'package:notasflutter/sqlite/modelo/nota.dart';
import 'package:notasflutter/sqlite/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteUpdate {
  Future<void> nota(Nota nota) async {
    final Database? db = await SQLiteHelper.getDB();
    await db!
        .update('notas', nota.toMap(), where: 'id=?', whereArgs: [nota.id]);
  }
}
