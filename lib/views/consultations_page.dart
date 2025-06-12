import 'package:flutter/material.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class ConsultationsPage extends StatefulWidget {
  const ConsultationsPage({super.key});

  @override
  State<ConsultationsPage> createState() => _ConsultationsPageState();
}

class _ConsultationsPageState extends State<ConsultationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Consultas",),
      drawer: CustomDrawer(),
    );
  }
}