import 'package:flutter/material.dart';
import 'package:notasflutter/sqlite/modelo/nota.dart';
import 'package:notasflutter/sqlite/sqlite_update.dart';

Nota _nota = Nota(
  id: 0,
  titulo: '',
  descripcion: '',
  fecha: '',
  hora: '',
  boleano: '',
  color: '0x62FFFFFF',
);

class EditarNota extends StatelessWidget {
  const EditarNota({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _nota = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Nota
        : _nota;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Nota"),
      ),
      body: _Formulario(_nota),
    );
  }
}

// ignore: must_be_immutable
class _Formulario extends StatelessWidget {
  String alarma = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _activarAlarma = TextEditingController();

  int _selectedColor = Color(0x62FFFFFF).value;
  double margen = 25.0;
  String _fecha = "";
  String _fechaEditada = "";
  String _hora = '';
  String _horaEditada = "";

  final Nota _nota;
  _Formulario(this._nota) {
    _tituloController.text = _nota.titulo;
    _descripcionController.text = _nota.descripcion;
    _colorController.text = _nota.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: margen,
        left: margen,
        top: 12,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 4,
              ),
              _formTitulo(),
              const SizedBox(
                height: 4,
              ),
              _formDescripcion(),
              const SizedBox(
                height: 4,
              ),
              _formColor(context),
              const SizedBox(
                height: 5,
              ),
              Row(children: [
                const Text(
                  "Notificación",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 176,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notification_add_sharp,
                    size: 27,
                  ),
                  onPressed: () {
                    alarma = "false";
                    _activarAlarma.text = alarma;

                    _showDialog(context);
                  },
                  autofocus: false,
                ),
              ]),
              /*
              _formFecha(context),
              const SizedBox(
                height: 7,
                ),
              _formHora(context)
              ,*/
              const SizedBox(
                height: 9,
              ),
              ElevatedButton.icon(
                label: const Text("Actualizar"),
                icon: const Icon(Icons.save),
                onPressed: () => _actualizar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _formColor(BuildContext context) {
    return TextFormField(
        controller: _colorController,
        decoration: const InputDecoration(
          labelText: "Color de Nota",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onTap: () {
          _showColorDialog(context);
          FocusScope.of(context).unfocus(); //oculta el teclado
        });
  }

  final List<String> colorNames = [
    "Azul Light",
    "Cafe Light",
    "Cafe",
    "Gris",
    "Naranja",
    "Peach",
    "Purpura Light",
    "Rojo",
    "Teal Light",
    "Teal",
    "Verde Light",
  ];

  void _showColorDialog(BuildContext context) {
    Map<String, Color> _finalcolor = {
      "Azul Light": const Color(0xFF2196F3),
      "Cafe Light": const Color(0xFF795548),
      "Cafe": const Color(0xFF3E2723),
      "Gris": const Color(0xFF636363),
      "Naranja": const Color(0xFFFC571D),
      "Peach": const Color(0xFFE47C73),
      "Purpura Light": const Color(0xFF673AB7),
      "Rojo": const Color(0xFFF44336),
      "Teal Light": const Color(0xFF009688),
      "Teal": const Color(0xFF004D40),
      "Verde Light": const Color(0xFF36B37B),
    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Selecciona Color'),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: colorNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.brightness_1_outlined,
                        color: _finalcolor[colorNames[index]]),
                    title: Text(colorNames[index]),
                    onTap: () {
                      _selectedColor = _finalcolor[colorNames[index]]!.value;
                      _colorController.text = _selectedColor.toString();
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Seleccione Fecha & Hora"),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _formFecha(context),
                const SizedBox(
                  height: 15,
                ),
                _formHora(context),
              ],
            ),
          ),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Ok"),
            )
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        );

        /*return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      title: const Text("Seleccione Fecha & Hora"),
      children: [
        _formFecha(context),
        const SizedBox(
        height: 15,
        ),
        _formHora(context),
      ],
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF2A8068), width:3),
          borderRadius:  BorderRadius.all(Radius.circular(20)),
          ),
    );
    */
      },
    );
  }

//FORMULARIO DEL CAMPO TITULO DE LA TAREA
  TextFormField _formTitulo() {
    return TextFormField(
      controller: _tituloController,
      maxLength: 50,
      validator: (valor) => _validarTitulo(valor!),
      decoration: const InputDecoration(
        labelText: "Titulo",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

//FORMULARIO DEL CAMPO DESCRIPCIÓN DE LA TAREA
  TextFormField _formDescripcion() {
    return TextFormField(
      controller: _descripcionController,
      maxLength: 200,
      maxLines: 3,
      validator: (valor) => _validarDescripcion(valor!),
      decoration: const InputDecoration(
        labelText: "Descripción",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

//CREACIÓN DEL DATAPICKER
  TextFormField _formFecha(BuildContext context) {
    return TextFormField(
        controller: _fechaController,
        maxLength: 23,
        decoration: const InputDecoration(
          labelText: "Fecha",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode()); //oculta el teclado
          llamadaDatePicker(context);
        });
  }

  void llamadaDatePicker(BuildContext context) async {
    var selectedDate = await obtenerFechaPickerWidget(context);
    if (selectedDate != null) {
      _fecha = selectedDate.toString();
      _fechaEditada = _fecha.toString();
      _fechaController.text = _fechaEditada.substring(0, 10);
    }
  }

  Future<DateTime?> obtenerFechaPickerWidget(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2028),
      /* builder: (context, child) {
        return temaDatePicker(context, child);
      },*/
      // locale: const Locale('es','ES'),
    );
  }

//CREACION DEL TIME PICKER
  TextFormField _formHora(BuildContext context) {
    return TextFormField(
      controller: _horaController,
      maxLength: 13,
      decoration: const InputDecoration(
        labelText: "Hora",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        llamadaTimePicker(context);
      },
    );
  }

  void llamadaTimePicker(BuildContext context) async {
    var seleccionHora = await obtenerHoraPickerWidget(context);
    if (seleccionHora != null) {
      _hora = seleccionHora.toString();
      _horaEditada = _hora.toString();
      _horaController.text = _horaEditada.substring(10, 15);
    }
  }

  Future<TimeOfDay?> obtenerHoraPickerWidget(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return temaDatePicker(context, child);
      },
    );
  }

  Theme temaDatePicker(context, child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.teal.shade800, // color de la cabecera
          onPrimary: Colors.white, // color del texto e icono de la cabecera
          onSurface: Colors.black, // color del cuerpo
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.amber, // button text color
          ),
        ),
      ),
      child: child!,
    );
  }

  String? _validarTitulo(String valor) {
    if (valor.trim().isEmpty) {
      return "Campo Vacio";
    } else {
      return null;
    }
  }

  String? _validarDescripcion(String valor) {
    if (valor.trim().isEmpty) {
      return "Campo Vacio";
    } else {
      return null;
    }
  }

  void _actualizar(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      SQLiteUpdate().nota(Nota(
        id: _nota.id,
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        fecha: _fechaController.text,
        hora: _horaController.text,
        boleano: _activarAlarma.text,
        color: _colorController.text,
        //fechayhora: _fechaController.text + " " + _horaController.text,
      ));
      Navigator.pop(context);
    }
  }
}
