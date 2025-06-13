import 'package:flutter/material.dart';
import 'package:sa_consultorio/controllers/consulta_controller.dart';
import 'package:sa_consultorio/controllers/paciente_controller.dart';
import 'package:sa_consultorio/models/consulta.dart';
import 'package:sa_consultorio/models/paciente.dart';
import 'package:sa_consultorio/views/consultations_add_page.dart';
import 'package:sa_consultorio/views/consultations_details_page.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class PatientDetailsPage extends StatefulWidget {
  final int pacienteId;
  const PatientDetailsPage({super.key, required this.pacienteId});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  final PacienteController _controllerPacientes = PacienteController();
  final ConsultasController _controllerConsultas = ConsultasController();
  bool _isLoading = true;

  Paciente? _paciente;

  List<Consulta> _consultas = []; //

  @override
  void initState() {
    super.initState();
    _loadPacienteConsultas();
  }

  Future<void> _loadPacienteConsultas() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _paciente = await _controllerPacientes.findPacienteById(
        widget.pacienteId,
      );
      _consultas = await _controllerConsultas.getConsultasByPaciente(
        widget.pacienteId,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Exception $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteConsulta(int consultaId) async {
    try {
      await _controllerConsultas.deleteConsulta(consultaId);
      // Recarrega as consultas após a exclusão para atualizar a lista
      await _loadPacienteConsultas();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Consulta deletada com sucesso!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao deletar consulta: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Pacientes", automaticallyImplyLeading: true, backButton: true,),
      drawer: CustomDrawer(),

      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 24),
              SizedBox(
                height: 250,
                width: 250,
                child: CircleAvatar(child: Icon(Icons.person, size: 250)),
              ),
              SizedBox(height: 24),
              Text(_paciente!.nome, style: TextStyle(fontSize: 24)),

              SizedBox(height: 24),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.phone, size: 60),
                        SizedBox(width: 32),
                        Text(
                          _paciente!.contato,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.email, size: 60),
                        SizedBox(width: 32),
                        Text(_paciente!.email, style: TextStyle(fontSize: 16)),
                      ],
                    ),

                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.calendar_month, size: 60),
                        SizedBox(width: 32),
                        Text(
                          '${_paciente!.dataNascimento.day}/${_paciente!.dataNascimento.month}/${_paciente!.dataNascimento.year.toString()}', style: TextStyle(fontSize: 16)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12,),

              const Divider(),
              SizedBox(height: 12,),
                      const Text("Consultas:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      _consultas.isEmpty
                          ? const Center(child: Text("Não existem consultas cadastradas para este paciente."))
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _consultas.length,
                                itemBuilder: (context, index) {
                                  final consulta = _consultas[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      title: Text(consulta.tipoServico),
                                      subtitle: Text(consulta.dataHoraFormata),
                                      trailing: IconButton(
                                        onPressed: () => _deleteConsulta(consulta.id!),
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ConsultationsDetailsPage(consultaId: consulta.id!),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
            ],
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          // Aguarda o retorno da tela de adicionar consulta para recarregar as consultas
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>   ConsultationsAddPage(pacienteId: widget.pacienteId),
            ),
          );
          _loadPacienteConsultas(); // Recarrega as consultas quando voltar para esta tela
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
      ),
    );
  }
}
