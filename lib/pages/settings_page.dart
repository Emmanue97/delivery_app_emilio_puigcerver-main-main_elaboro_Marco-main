import 'package:delivery_app_emilio_puigcerver/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("herramientas"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      //estaes la estructura del boton de dark mode
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Container(
            decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
              ),
              margin:const EdgeInsets.only(left: 25, top: 10, right: 25),
              padding: const EdgeInsets.all(25),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, //hace que el botón de dark mode se ponga del lado derecho
              children: [
                //dark mode para que se ponga oscura la pantalla con un botón
                Text (
                  "Dark Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                // switch
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                  .isDarkMode,
                  onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}