import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class SQLiteHelper{

static Future<Database>? _db;

static Future<Database>? getDB(){
  _db ??= _initDB(); //preguntando si es nulo
  return _db;
} 

static Future<Database> _initDB() async {
  final db = await openDatabase(
    join(await getDatabasesPath(), "bd_notas.db"),
    version: 1,
    onCreate: _onCreate, 
  );
  return db;
}

static _onCreate(Database db, int version) async {
await db.execute("CREATE TABLE notas (id INTEGER PRIMARY KEY, titulo TEXT NOT NULL, descripcion TEXT, fecha TEXT, hora TEXT, boleano TEXT, color TEXT)");
}
}