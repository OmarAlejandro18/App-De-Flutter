import 'package:flutter/material.dart';

class Comentarios extends StatelessWidget {
  const Comentarios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ayuda y Comentarios"),
      ),
      body: FormComentario(),
    );
  }
}

// ignore: must_be_immutable
class FormComentario extends StatelessWidget {
  FormComentario({Key? key}) : super(key: key);

  final TextEditingController _descripcionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double margen = 25.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: margen,
        left: margen,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _formComentario(),
              const SizedBox(
                height: 4,
              ),
              ElevatedButton.icon(
                /*style: const ButtonStyle(
                  backgroundColor:MaterialStateProperty.all<Color>(Colors.amber),
                 ),*/
                label: const Text("Enviar"),
                icon: const Icon(Icons.save),
                onPressed: () => _enviar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _formComentario() {
    return TextFormField(
      controller: _descripcionController,
      maxLength: 400,
      maxLines: 6,
      validator: (valor) => _validarDescripcion(valor!),
      decoration: const InputDecoration(
        labelText: "Comentario",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  String? _validarDescripcion(String valor) {
    if (valor.trim().isEmpty) {
      return "Campo Vacio";
    } else {
      return null;
    }
  }

  void _enviar(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }
}
