import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notasflutter/home/lista_notas.dart';
import 'package:notasflutter/sqlite/modelo/nota.dart';
import 'package:notasflutter/sqlite/sqlite_query.dart';

class SearchNotePage extends StatefulWidget {
  const SearchNotePage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SearchNotePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Nota> _notes = [];
  List<Nota> _filtroNotas = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_search);
    _notes = Provider.of<SQLiteQuery>(context, listen: false).notas;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 80,
            floating: true,
            title: Column(
              children: [
                TextFormField(
                  cursorColor: Colors.white,
                  autofocus: false,
                  maxLength: 20,
                  style: const TextStyle(color: Colors.white),
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    focusColor: Colors.white,
                    hintText: 'Buscar Nota',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Provider.of<SQLiteQuery>(context, listen: true).updateNotas();
                return NoteTile(_filtroNotas[index]);
              },
              childCount: _filtroNotas.length,
            ),
          ),
        ],
      ),
    );
  }

  void _search() {
    setState(() {
      _filtroNotas = _notes.where((nota) {
        final find = '${nota.titulo} ${nota.descripcion}'.trim().toLowerCase();
        return find.contains(_searchController.text.trim().toLowerCase());
      }).toList();
    });
  }
}
