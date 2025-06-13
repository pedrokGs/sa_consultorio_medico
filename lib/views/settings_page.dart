import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sa_consultorio/theme/theme_provider.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Configurações", actions: BackButton(
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
      ),),
      drawer: CustomDrawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 85,
                    child: Row(
                      children: [
                        Icon(
                          size: 60,
                          themeProvider.themeMode == ThemeMode.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        SizedBox(width: 24,),
                        Text("Alterar Modo", style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  if (themeProvider.themeMode == ThemeMode.dark) {
                    themeProvider.toggleTheme(false);
                  } else {
                    themeProvider.toggleTheme(true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
