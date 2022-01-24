import 'package:flutter/material.dart';

class ListaDrawer extends StatefulWidget {
  const ListaDrawer({Key? key}) : super(key: key);
  
  @override
  _ListaDrawerState createState() => _ListaDrawerState();

}

class _ListaDrawerState extends State<ListaDrawer> {

 Drawer _getDrawer(BuildContext context){
  var header = const UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text("Notas Desarrollo Movil"),
            decoration: BoxDecoration(
              color: Color(0xFF303030),
              image: DecorationImage(
                image: AssetImage("assets/logoUaemHD.png")),
            ),
          );

  var info = const AboutListTile(
      child: Text("Informacion App"),
      applicationVersion: "v.1.0.0\nby: Omar Alejandro",
      applicationName: "Notas App",
      applicationIcon: Icon(Icons.pending_actions, size:50),
      icon: Icon(Icons.info),
    );

ListTile _getItem(Icon icon, String nombre, String ruta) {
    return ListTile(
      leading: icon,
      title: Text(nombre),
      onTap: () {
        setState(() {
          Navigator.pop(context);
          Navigator.pushNamed(context, ruta);
        });
      },                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    );
  }
  
ListView listView = ListView(
  padding: EdgeInsets.zero,
  children: <Widget> [
     header,
    _getItem(const Icon(Icons.home), "Pagina Principal", "/"),
   // _getItem(const Icon(Icons.pending_actions), "Recordatorios", "Recordatorios"),
    _getItem(const Icon(Icons.help_outline), "Ayuda y comentarios", "Comentarios"),
     info,
    ],
  );
return Drawer(
 child:  listView
);
 }  

  @override
  Widget build(BuildContext context) {
    return _getDrawer(context); 
  }
}
