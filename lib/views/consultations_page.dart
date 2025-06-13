import 'package:flutter/material.dart';
import 'package:sa_consultorio/controllers/consulta_controller.dart';
import 'package:sa_consultorio/controllers/paciente_controller.dart';
import 'package:sa_consultorio/models/consulta.dart';
import 'package:sa_consultorio/views/consultations_details_page.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class ConsultationsPage extends StatefulWidget {
  const ConsultationsPage({super.key});

  @override
  State<ConsultationsPage> createState() => _ConsultationsPageState();
}

class _ConsultationsPageState extends State<ConsultationsPage> {
    final _pacientesController = PacienteController();
    final _consultasController = ConsultasController();
    bool _isLoading = true;
    List<Consulta> _consultas = [];

      @override
  void initState() {
    super.initState();
    _loadData();
  }

Map<int, String> _pacientesMap = {};

Future<void> _loadData() async {
  setState(() {
    _isLoading = true;
    _consultas = [];
    _pacientesMap = {};
  });

  try {
    final pacientes = await _pacientesController.fetchPacientes();
    _pacientesMap = {
      for (var p in pacientes) p.id!: p.nome
    };

    print(pacientes);

    _consultas = await _consultasController.fetchConsultas();

    print(_consultas);
  } catch (erro) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exception: $erro")),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Consultas", actions: BackButton(
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },)),
      drawer: CustomDrawer(),

        body: ListView.builder(
        itemCount: _consultas.length,
        itemBuilder: (context, index) {
                    final consulta = _consultas[index];
          return ListTile(
            leading: CircleAvatar(child: Icon(Icons.medical_information),),
            title: Text(consulta.tipoServico),
            subtitle: Text(_pacientesMap[consulta.pacienteId] ?? 'Paciente não encontrado'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await _consultasController.deleteConsulta(consulta.id!);
                _loadData();
              },
            ),
            onTap: () => Navigator.push(context,
             MaterialPageRoute(builder: (context)=> ConsultationsDetailsPage(consultaId: consulta.id!)))
          );
        },
      ),
    );
  }
}