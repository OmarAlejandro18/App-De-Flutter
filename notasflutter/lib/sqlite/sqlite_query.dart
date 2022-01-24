import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notasflutter/sqlite/modelo/nota.dart';
import 'package:notasflutter/sqlite/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteQuery with ChangeNotifier {
  List<Nota>? _notas;
  List<Nota> get notas => [...?_notas];

  Future<void> updateNotas() async {
    final Database? db = await SQLiteHelper.getDB();
    final List<Map<String, dynamic>> maps = await db!.query("notas");
    _notas = List.generate(
      maps.length,
      (i) {
        return Nota(
          id: maps[i]['id'],
          titulo: maps[i]['titulo'],
          descripcion: maps[i]['descripcion'],
          fecha: maps[i]['fecha'],
          hora: maps[i]['hora'],
          boleano: maps[i]['boleano'],
          color: maps[i]['color'],
        );
      },
    );
    notifyListeners();
  }
}
