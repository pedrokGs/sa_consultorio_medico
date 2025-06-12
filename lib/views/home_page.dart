import 'package:flutter/material.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Placeholder para navegação",),
      drawer: CustomDrawer(),
    );
  }
}
