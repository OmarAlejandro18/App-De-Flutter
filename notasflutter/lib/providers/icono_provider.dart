import 'package:flutter/material.dart';

class IconoProvider with ChangeNotifier {
  Icon _icono = Icon(Icons.notifications);

  Icon get icono {
    return _icono;
  }

  set seleccionado(String select) {
    _icono = (select == "true")
        ? const Icon(Icons.notifications, color: Colors.cyan)
        : const Icon(Icons.notifications, color: Colors.blue);
    notifyListeners();
  }
}
