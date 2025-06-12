import 'package:flutter/material.dart';
import 'package:sa_consultorio/controllers/paciente_controller.dart';
import 'package:sa_consultorio/models/paciente.dart';
import 'package:sa_consultorio/views/patient_add_page.dart';
import 'package:sa_consultorio/views/patient_details_page.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final _pacientesController = PacienteController();
    bool _isLoading = true;
    List<Paciente> _pacientes = [];

      @override
  void initState() {
    super.initState();
    _loadPacientes();
  }


    Future<void> _loadPacientes() async{
    setState(() {
      _isLoading = true;
      _pacientes = [];
    });
    try {
        _pacientes = await _pacientesController.fetchPacientes();
    } catch (erro) { //pega o erro do sistema
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $erro")));
    } finally{ //execução obrigatória
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Pacientes"),
      drawer: CustomDrawer(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientAddPage()),
        ),
      ),

      body: ListView.builder(
        itemCount: _pacientes.length,
        itemBuilder: (context, index) {
                    final paciente = _pacientes[index];
          return ListTile(
            title: Text(paciente.nome),
            subtitle: Text(paciente.cpf),
            onTap: () => Navigator.push(context,
             MaterialPageRoute(builder: (context)=> PatientDetailsPage(pacienteId: paciente.id!)))
              
          );
        },
      ),
    );
  }
}
