import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notasflutter/home/buscar_notas.dart';
import 'package:notasflutter/home/editar_nota.dart';
import 'package:notasflutter/sqlite/modelo/nota.dart';
import 'package:notasflutter/sqlite/sqlite_query.dart';

class NoteTile extends StatelessWidget {
  final Nota note;

  const NoteTile(this.note, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        left: 11.0,
        right: 11.0,
        top: 5.0,
        bottom: 9.0,
      ),
      shadowColor: Colors.teal.shade500,
      elevation: 8,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Text(
            note.titulo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Text(
            note.descripcion.replaceAll('\n', ' '),
            maxLines: 6,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        onTap: () {
          if (ModalRoute.of(context)!.settings.name ==
              const SearchNotePage().toString()) {
            Navigator.popAndPushNamed(
              context,
              const EditarNota().toString(),
              arguments: note,
            );
            Provider.of<SQLiteQuery>(context, listen: false).updateNotas();
          } else {
            Navigator.popAndPushNamed(
              context,
              const EditarNota().toString(),
              arguments: note,
            );
            Provider.of<SQLiteQuery>(context, listen: false).updateNotas();
          }
          Provider.of<SQLiteQuery>(context, listen: false).updateNotas();
        },
      ),
    );
  }
}
