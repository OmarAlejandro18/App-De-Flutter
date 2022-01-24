import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notasflutter/providers/tema_provider.dart';

class OpcionTemas extends StatefulWidget {
  const OpcionTemas({Key? key}) : super(key: key);

  @override
  State<OpcionTemas> createState() => _OpcionTemasState();
}

class _OpcionTemasState extends State<OpcionTemas> {
  bool valor = true;
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración Tema"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              const Text("Activar Modo Oscuro", style: TextStyle(fontSize: 15)),
              const SizedBox(width: 150),
              IconButton(
                icon: const Icon(
                  Icons.bedtime_rounded,
                  size: 28,
                ),
                onPressed: () => theme.setTheme(
                  ThemeData(
                    colorScheme: ColorScheme(
                        primary: Colors.black54, //Color primario
                        primaryVariant: Colors.teal,
                        secondary: Colors.white,
                        secondaryVariant: Colors.purple.shade800,
                        surface: Colors.black54, //appbar
                        background: Colors.white,
                        error: Colors.red.shade800,
                        onPrimary:
                            Colors.white, //Color de las letras de los widgets
                        onSecondary: Colors.white,
                        onSurface: Colors.white,
                        onBackground: Colors.white,
                        onError: Colors.red.shade800,
                        brightness: Brightness.dark),
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: Colors.cyan.shade900,
                    ),
                    iconTheme: const IconThemeData(
                      color: Color(0XFF006064), //0XFF006064
                    ),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.cyan.shade900),
                      ),
                    ),
                    timePickerTheme: const TimePickerThemeData(
                      backgroundColor: Color(0xFF424242), //Color(0xFF212121)
                      hourMinuteTextColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(children: <Widget>[
            const SizedBox(width: 10),
            const Text("Activar Tema por defecto",
                style: TextStyle(fontSize: 15)),
            const SizedBox(width: 122),
            IconButton(
              icon: const Icon(Icons.brightness_4_outlined, size: 28),
              onPressed: () => theme.setTheme(
                ThemeData(
                  brightness: Brightness.light,
                  colorScheme: ColorScheme(
                      primary: Colors.teal.shade900, //Color primario
                      primaryVariant: Colors.teal.shade800,
                      secondary: Colors.teal.shade700,
                      secondaryVariant: Colors.teal.shade700,
                      surface: Colors.teal.shade800,
                      background: Colors.white,
                      error: Colors.red.shade800,
                      onPrimary:
                          Colors.white, //Color de las letras de los widgets
                      onSecondary: Colors.white,
                      onSurface: Colors.black,
                      onBackground: Colors.white,
                      onError: Colors.red.shade800,
                      brightness: Brightness.light),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.teal.shade800,
                  ),
                  bottomAppBarColor: Colors.teal.shade800,
                  iconTheme: const IconThemeData(
                    color: Color(0xFF880E4F),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.pink.shade900),
                    ),
                  ),
                  timePickerTheme: const TimePickerThemeData(
                    backgroundColor: Colors.white,
                    dialBackgroundColor: Colors.black26,
                  ),
                  textTheme:
                      const TextTheme(button: TextStyle(color: Colors.red)),
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}


/*
Switch(
            value: valor, 
            onChanged: (bool state){
            setState(() {
              valor = state;
            });

            if(valor == true){
              theme.setTheme(ThemeData(
               colorScheme: ColorScheme(
                 primary: Colors.black54, //Color primario
                 primaryVariant: Colors.teal,
                 secondary: Colors.white, 
                 secondaryVariant: Colors.purple.shade800, 
                 surface: Colors.black54,//appbar
                 background: Colors.white, 
                 error: Colors.red.shade800, 
                 onPrimary: Colors.white,    //Color de las letras de los widgets
                 onSecondary: Colors.white,  
                 onSurface: Colors.white, 
                 onBackground: Colors.white, 
                 onError:  Colors.red.shade800, 
                 brightness:Brightness.dark),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                   backgroundColor: Colors.cyan.shade900,
                  ),
                iconTheme: const IconThemeData(    
                   color: Color(0XFF006064), //0XFF006064
                  ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                   style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all<Color>(Colors.cyan.shade900),
                   ),
                 ),
                 timePickerTheme: const TimePickerThemeData(
                    backgroundColor:Color(0xFF424242), //Color(0xFF212121)
                    hourMinuteTextColor: Colors.white,
                 ),
                ),
              );
            }else{
            theme.setTheme(ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme(
                 primary: Colors.teal.shade900,  //Color primario
                 primaryVariant: Colors.teal.shade800, 
                 secondary: Colors.teal.shade700, 
                 secondaryVariant: Colors.teal.shade700, 
                 surface: Colors.teal.shade800,
                 background: Colors.white, 
                 error: Colors.red.shade800, 
                 onPrimary: Colors.white,    //Color de las letras de los widgets
                 onSecondary: Colors.white,  
                 onSurface: Colors.black, 
                 onBackground: Colors.white, 
                 onError:  Colors.red.shade800, 
                 brightness:Brightness.light),
                 floatingActionButtonTheme: FloatingActionButtonThemeData(
                 backgroundColor: Colors.teal.shade800,
                 ),
                 bottomAppBarColor: Colors.teal.shade800,
                 iconTheme: const IconThemeData(
                 color: Color(0xFF880E4F),
                 ),
                 elevatedButtonTheme: ElevatedButtonThemeData(
                   style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all<Color>(Colors.pink.shade900),
                   ),
                 ),
                 timePickerTheme: const TimePickerThemeData(
                   backgroundColor: Colors.white,
                   dialBackgroundColor: Colors.black26,
                 ),
              textTheme: const TextTheme(
                button: TextStyle(
                  color: Colors.red
                )
              ), 
              ),
              );
            }
            }
            ),

*/