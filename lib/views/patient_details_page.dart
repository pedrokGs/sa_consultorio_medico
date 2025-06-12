import 'package:flutter/material.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class PatientDetailsPage extends StatefulWidget {
  final int? pacienteId;
  const PatientDetailsPage({super.key, this.pacienteId});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Pacientes",),
      drawer: CustomDrawer(),
    );
  }
}