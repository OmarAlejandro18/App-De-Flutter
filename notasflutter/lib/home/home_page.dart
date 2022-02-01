import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:notasflutter/home/agregar_nota.dart';
import 'package:notasflutter/home/editar_nota.dart';
import 'package:notasflutter/home/lista_drawer.dart';
import 'package:notasflutter/providers/icono_provider.dart';
import 'package:notasflutter/sqlite/modelo/nota.dart';
import 'package:notasflutter/sqlite/sqlite_delete.dart';
import 'package:notasflutter/sqlite/sqlite_helper.dart';
import 'package:notasflutter/sqlite/sqlite_query.dart';
import 'package:notasflutter/sqlite/sqlite_update.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:cron/cron.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //Color colorCard = Color(0xFFFFFFFF);

  MethodChannel platform = const MethodChannel('backgroundservice');

  @override
  void initState() {
    _cargandoDatosProvider();
    initializeSetting();
    tz.initializeTimeZones();
    super.initState();
  }

  Future<void> _cargandoDatosProvider() async {
    final SQLiteQuery sqLiteQuery =
        Provider.of<SQLiteQuery>(context, listen: false);
    await _delayed(true, const Duration(milliseconds: 500));
    sqLiteQuery.updateNotas();
  }

  Future<dynamic> _delayed(dynamic valorRetornado, Duration duracion) {
    return Future.delayed(duracion, () => valorRetornado);
  }

  // ignore: non_constant_identifier_names
  final GlobalKey<ScaffoldState> _scaffold_key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold_key,
      drawer: const ListaDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: SizedBox(
              height: 116.0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 33.0,
                    left: 3.0,
                    right: 3.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: DecoratedBox(
                        decoration: cajadecoracion(),
                        child: fila_Iconos(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: SQLiteHelper.getDB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return mostrarLista(context);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        heroTag: const Text("btn1"),
        child: const Icon(Icons.add, size: 28),
        onPressed: () => _abrirAgregarNota(context),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "BuscarNotaPage");
              },
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.search, color: Colors.white54, size: 28)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "TemaPage");
              },
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.settings,
                  color: Colors.white54,
                  size: 28) // miscellaneous_services_sharp
              ),
        ]),
      ),
    );
  }

  _abrirAgregarNota(BuildContext context) {
    Navigator.pushNamed(context, const AgregarNota().toString()).then((valor) {
      Provider.of<SQLiteQuery>(context, listen: false).updateNotas();
    });
  }

  mostrarLista(BuildContext context) {
    final SQLiteQuery sqLiteQuery = Provider.of<SQLiteQuery>(context);
    return ListView.builder(
      itemCount: sqLiteQuery.notas.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(sqLiteQuery.notas[index].id.toString()),
          direction: DismissDirection.startToEnd,
          background: const Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete, /* color: Colors.amber,*/
            ),
          ),
          onDismissed: (direction) {
            SQLiteDelete().nota((Nota(
                id: sqLiteQuery.notas[index].id,
                titulo: sqLiteQuery.notas[index].titulo,
                descripcion: sqLiteQuery.notas[index].descripcion,
                fecha: sqLiteQuery.notas[index].fecha,
                hora: sqLiteQuery.notas[index].hora,
                boleano: sqLiteQuery.notas[index].boleano,
                color: sqLiteQuery.notas[index].color)));
            sqLiteQuery.updateNotas();
          },
          child: notasPrueba(
              sqLiteQuery.notas[index].titulo,
              sqLiteQuery.notas[index].descripcion,
              sqLiteQuery.notas[index].fecha,
              sqLiteQuery.notas[index].hora,
              sqLiteQuery.notas[index].boleano,
              index),
        );
      },
    );
  }

  Widget notasPrueba(String titulo, String descripcion, String fecha,
      String hora, String isSelect, int index) {
    String year = fecha.substring(0, 4);
    String mes = fecha.substring(5, 7);
    String dia = fecha.substring(8, 10);

    String formatoFecha = dia + "-" + mes + "-" + year;

    final SQLiteQuery sqLiteQuery = Provider.of<SQLiteQuery>(context);
    final iconoNotificacion = Provider.of<IconoProvider>(context);
    startService(index);

    return Card(
      key: Key(sqLiteQuery.notas[index].id.toString()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: const EdgeInsets.only(
        left: 11.0,
        right: 11.0,
        top: 5.0,
        bottom: 9.0,
      ),
      color: Color(int.parse(sqLiteQuery.notas[index]
          .color)), //color, DateTime.parse(sqLiteQuery.notas[index].fecha + " " +sqLiteQuery.notas[index].hora) ==  tz.local ? Color(0xFF36B37B) : Color(0xFFF44336),
      shadowColor: Colors.teal.shade400,
      elevation: 8,
      child: Column(
        children: [
          ListTile(
            title: Text(titulo),
            subtitle: Text(descripcion),
            trailing: Text(formatoFecha + "\n" + "          " + hora),
          ),
          SizedBox(
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.delete,
                      /*color: Colors.amber,*/ size: 27),
                  onPressed: () {
                    //sqLiteQuery.notas[index]
                    SQLiteDelete().nota((Nota(
                        id: sqLiteQuery.notas[index].id,
                        titulo: sqLiteQuery.notas[index].titulo,
                        descripcion: sqLiteQuery.notas[index].descripcion,
                        fecha: sqLiteQuery.notas[index].fecha,
                        hora: sqLiteQuery.notas[index].hora,
                        boleano: sqLiteQuery.notas[index].boleano,
                        color: sqLiteQuery.notas[index].color)));
                    sqLiteQuery.updateNotas();
                  },
                ),
                IconButton(
                  icon:
                      const Icon(Icons.edit, /*color: Colors.amber,*/ size: 27),
                  onPressed: () =>
                      abrirEditarNota(context, sqLiteQuery.notas[index]),
                ),
                IconButton(
                  key: Key(sqLiteQuery.notas[index].id.toString()),
                  icon: sqLiteQuery.notas[index].boleano == "true"
                      ? iconoNotificacion.icono
                      : const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    sqLiteQuery.notas[index].boleano =
                        (iconoNotificacion.seleccionado = "true");
                    SQLiteUpdate().nota(Nota(
                        id: sqLiteQuery.notas[index].id,
                        titulo: sqLiteQuery.notas[index].titulo,
                        descripcion: sqLiteQuery.notas[index].descripcion,
                        fecha: sqLiteQuery.notas[index].fecha,
                        hora: sqLiteQuery.notas[index].hora,
                        boleano: (sqLiteQuery.notas[index].boleano = "true"),
                        color: sqLiteQuery.notas[index].color));

                    if (sqLiteQuery.notas[index].boleano == "true") {
                      displayNotification(
                          sqLiteQuery.notas[index].id,
                          sqLiteQuery.notas[index].titulo,
                          sqLiteQuery.notas[index].descripcion,
                          DateTime.parse(sqLiteQuery.notas[index].fecha +
                              " " +
                              sqLiteQuery.notas[index].hora));

                      final snackBar = SnackBar(
                        content: Text(
                            "Notificacion de ${sqLiteQuery.notas[index].titulo} Activada"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void abrirEditarNota(BuildContext context, Nota nota) {
    Navigator.pushNamed(context, const EditarNota().toString(), arguments: nota)
        .then((valor) {
      Provider.of<SQLiteQuery>(context, listen: false).updateNotas();
    });
  }

  BoxDecoration cajadecoracion() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1.0),
        color: Colors.white);
  }

// ignore: non_constant_identifier_names
  Row fila_Iconos() {
    return Row(
      children: [
        botonMenu(),
        Expanded(
          child: barraBuscar(),
        ),
      ],
    );
  }

  ListTile barraBuscar() {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text('Buscar', style: TextStyle(color: Colors.black)),
      onTap: () {
        Navigator.pushNamed(context, "BuscarNotaPage");
      },
    );
  }

  IconButton botonMenu() {
    return IconButton(
      icon: const Icon(
        Icons.menu,
        color: Colors.amber,
      ),
      onPressed: () {
        _scaffold_key.currentState!.openDrawer();
      },
    );
  }

  Future<void> displayNotification(
      int id, String nombre, String contenido, DateTime dateTime) async {
    notificationsPlugin.zonedSchedule(
      id,
      nombre,
      contenido,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel id",
          "channel name",
          channelDescription: 'channel description',
          icon: 'icon_notificaciones',
          largeIcon: DrawableResourceAndroidBitmap('notificacion_enviada'),
          playSound: true,
          sound: RawResourceAndroidNotificationSound('sonido_notificacion'),
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> startService(int index) async {
    dynamic value = await platform.invokeMethod('startService');
    print(value);

    var cron = Cron();
    cron.schedule(Schedule.parse('* * * * *'), () async {
      int diaActual = DateTime.now().day.toInt();
      int mesActual = DateTime.now().month.toInt();
      //8,10
      //3,5

      if (diaActual <= 23) {
        int dia1 = diaActual + (1.toInt());
        int dia2 = diaActual + (2.toInt());
        int dia3 = diaActual + (3.toInt());
        int dia4 = diaActual + (4.toInt());
        int dia5 = diaActual + (5.toInt());
        diasMes(dia1, dia2, dia3, dia4, dia5, index);
      }

      if (mesActual == 2) {
        if (diaActual == 28) {
          diaActual = 0;
          int dia1 = diaActual + (1.toInt());
          int dia2 = diaActual + (2.toInt());
          int dia3 = diaActual + (3.toInt());
          int dia4 = diaActual + (4.toInt());
          int dia5 = diaActual + (5.toInt());
          diasMes(dia1, dia2, dia3, dia4, dia5, index);
        }
        if (diaActual > 23 && diaActual < 28) {
          int dia1 = diaActual + (1.toInt());
          int dia2 = diaActual + (2.toInt());
          int dia3 = diaActual + (3.toInt());
          int dia4 = diaActual + (4.toInt());
          int dia5 = diaActual + (5.toInt());
          if (dia1 <= 28 ||
              dia2 <= 28 ||
              dia3 <= 28 ||
              dia4 <= 28 ||
              dia5 <= 28) {
            diasMes(dia1, dia2, dia3, dia4, dia5, index);
          }
        }
      }

      //Logica cuando la nota se redacta en los meses de 30 dias

      if (mesActual == 4 ||
          mesActual == 6 ||
          mesActual == 9 ||
          mesActual == 11) {
        if (diaActual > 23 && diaActual < 30) {
          int dia1 = diaActual + (1.toInt());
          int dia2 = diaActual + (2.toInt());
          int dia3 = diaActual + (3.toInt());
          int dia4 = diaActual + (4.toInt());
          int dia5 = diaActual + (5.toInt());

          if (dia1 <= 30 ||
              dia2 <= 30 ||
              dia3 <= 30 ||
              dia4 <= 30 ||
              dia5 <= 30) {
            diasMes(dia1, dia2, dia3, dia4, dia5, index);
          }
        }

        if (diaActual == 30) {
          diaActual = 0;
          int dia1 = diaActual + (1.toInt());
          int dia2 = diaActual + (2.toInt());
          int dia3 = diaActual + (3.toInt());
          int dia4 = diaActual + (4.toInt());
          int dia5 = diaActual + (5.toInt());
          diasMes(dia1, dia2, dia3, dia4, dia5, index);
        }
      }

      //Logica cuando la nota se redacta en el mes donde tiene 31 dias
      if (mesActual == 1.toInt() ||
          mesActual == 3 ||
          mesActual == 5 ||
          mesActual == 7 ||
          mesActual == 8 ||
          mesActual == 10 ||
          mesActual == 12) {
        if (diaActual > 23 && diaActual < 31) {
          int dia1 = diaActual + (1.toInt());
          int dia2 = diaActual + (2.toInt());
          int dia3 = diaActual + (3.toInt());
          int dia4 = diaActual + (4.toInt());
          int dia5 = diaActual + (5.toInt());
          if (dia1 <= 31 ||
              dia2 <= 31 ||
              dia3 <= 31 ||
              dia4 <= 31 ||
              dia5 <= 31) {
            diasMes(dia1, dia2, dia3, dia4, dia5, index);
          }
        }

        if (diaActual == 31) {
          diaActual = 0;
          int dia1 = diaActual + (1.toInt());
          int dia2 = diaActual + (2.toInt());
          int dia3 = diaActual + (3.toInt());
          int dia4 = diaActual + (4.toInt());
          int dia5 = diaActual + (5.toInt());
          diasMes(dia1, dia2, dia3, dia4, dia5, index);
        }
      }
    });
  }

  //Logica del Color de las notas

  diasMes(int dia1, int dia2, int dia3, int dia4, int dia5, int index) {
    int mesActual = DateTime.now().month.toInt();

    final SQLiteQuery sqLiteQuery =
        Provider.of<SQLiteQuery>(context, listen: false);

    if (dia5 <= int.parse(sqLiteQuery.notas[index].fecha.substring(8, 10)) &&
        mesActual <=
            int.parse(sqLiteQuery.notas[index].fecha.substring(5, 7)) &&
        sqLiteQuery.notas[index].fecha != '' &&
        sqLiteQuery.notas[index].hora != '') {
      setState(() {});
      SQLiteUpdate().nota(Nota(
          id: sqLiteQuery.notas[index].id,
          titulo: sqLiteQuery.notas[index].titulo,
          descripcion: sqLiteQuery.notas[index].descripcion,
          fecha: sqLiteQuery.notas[index].fecha,
          hora: sqLiteQuery.notas[index].hora,
          boleano: sqLiteQuery.notas[index].boleano,
          color: (sqLiteQuery.notas[index].color = "0xFF1B5E20")));
    }

    if (dia4 == int.parse(sqLiteQuery.notas[index].fecha.substring(8, 10)) &&
        mesActual <=
            int.parse(sqLiteQuery.notas[index].fecha.substring(5, 7)) &&
        sqLiteQuery.notas[index].fecha != '' &&
        sqLiteQuery.notas[index].hora != '') {
      setState(() {});
      SQLiteUpdate().nota(Nota(
          id: sqLiteQuery.notas[index].id,
          titulo: sqLiteQuery.notas[index].titulo,
          descripcion: sqLiteQuery.notas[index].descripcion,
          fecha: sqLiteQuery.notas[index].fecha,
          hora: sqLiteQuery.notas[index].hora,
          boleano: sqLiteQuery.notas[index].boleano,
          color: (sqLiteQuery.notas[index].color = "0xFF4CAF50")));
    }

    if (dia3 == int.parse(sqLiteQuery.notas[index].fecha.substring(8, 10)) &&
        mesActual <=
            int.parse(sqLiteQuery.notas[index].fecha.substring(5, 7)) &&
        sqLiteQuery.notas[index].fecha != '' &&
        sqLiteQuery.notas[index].hora != '') {
      setState(() {});
      SQLiteUpdate().nota(Nota(
          id: sqLiteQuery.notas[index].id,
          titulo: sqLiteQuery.notas[index].titulo,
          descripcion: sqLiteQuery.notas[index].descripcion,
          fecha: sqLiteQuery.notas[index].fecha,
          hora: sqLiteQuery.notas[index].hora,
          boleano: sqLiteQuery.notas[index].boleano,
          color: (sqLiteQuery.notas[index].color = "0xFFFFC107")));
    }

    if (dia2 == int.parse(sqLiteQuery.notas[index].fecha.substring(8, 10)) &&
        mesActual <=
            int.parse(sqLiteQuery.notas[index].fecha.substring(5, 7)) &&
        sqLiteQuery.notas[index].fecha != '' &&
        sqLiteQuery.notas[index].hora != '') {
      setState(() {});
      SQLiteUpdate().nota(Nota(
          id: sqLiteQuery.notas[index].id,
          titulo: sqLiteQuery.notas[index].titulo,
          descripcion: sqLiteQuery.notas[index].descripcion,
          fecha: sqLiteQuery.notas[index].fecha,
          hora: sqLiteQuery.notas[index].hora,
          boleano: sqLiteQuery.notas[index].boleano,
          color: (sqLiteQuery.notas[index].color = "0xFFFF6F00")));
    }

    if (dia1 == int.parse(sqLiteQuery.notas[index].fecha.substring(8, 10)) &&
        mesActual <=
            int.parse(sqLiteQuery.notas[index].fecha.substring(5, 7)) &&
        sqLiteQuery.notas[index].fecha != '' &&
        sqLiteQuery.notas[index].hora != '') {
      setState(() {});
      SQLiteUpdate().nota(Nota(
          id: sqLiteQuery.notas[index].id,
          titulo: sqLiteQuery.notas[index].titulo,
          descripcion: sqLiteQuery.notas[index].descripcion,
          fecha: sqLiteQuery.notas[index].fecha,
          hora: sqLiteQuery.notas[index].hora,
          boleano: sqLiteQuery.notas[index].boleano,
          color: (sqLiteQuery.notas[index].color = "0xFFB71C1C")));
    }
  }
}

void initializeSetting() async {
  AndroidInitializationSettings initializeAndroid =
      const AndroidInitializationSettings('icon_notificaciones');
  InitializationSettings initializeSettings =
      InitializationSettings(android: initializeAndroid);
  await notificationsPlugin.initialize(initializeSettings);
}
