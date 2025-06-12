import 'package:flutter/material.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class PatientAddPage extends StatefulWidget {
  const PatientAddPage({super.key});

  @override
  State<PatientAddPage> createState() => _PatientAddPageState();
}

class _PatientAddPageState extends State<PatientAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Adicionar Paciente", automaticallyImplyLeading: true,),
      drawer: CustomDrawer(),
    );
  }
}