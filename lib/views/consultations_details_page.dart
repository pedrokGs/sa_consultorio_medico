import 'package:flutter/material.dart';
import 'package:sa_consultorio/controllers/consulta_controller.dart';
import 'package:sa_consultorio/controllers/paciente_controller.dart';
import 'package:sa_consultorio/models/consulta.dart';
import 'package:sa_consultorio/models/paciente.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class ConsultationsDetailsPage extends StatefulWidget {
  final int consultaId;
  const ConsultationsDetailsPage({super.key, required this.consultaId});

  @override
  State<ConsultationsDetailsPage> createState() => _ConsultationsDetailsPageState();
}

class _ConsultationsDetailsPageState extends State<ConsultationsDetailsPage> {
  final PacienteController _controllerPacientes = PacienteController();
  final ConsultasController _controllerConsultas = ConsultasController();
  bool _isLoading = true;

  Consulta? _consulta;
  Paciente? _paciente;

  @override
  void initState() {
    super.initState();
    _loadPacienteConsulta();
  }

  Future<void> _loadPacienteConsulta() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _consulta = await _controllerConsultas.findConsultaById(widget.consultaId);
      if (_consulta != null) {
        _paciente = await _controllerPacientes.findPacienteById(_consulta!.pacienteId);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar detalhes: $e")),
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
      appBar: CustomAppBar(title: "Detalhes da Consulta", automaticallyImplyLeading: true, backButton: true),
      drawer: CustomDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _consulta == null || _paciente == null
              ? const Center(child: Text("Consulta ou paciente não encontrado"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      const CircleAvatar(
                        radius: 75,
                        child: Icon(Icons.calendar_today, size: 75),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _paciente!.nome,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.medical_services, size: 40),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _consulta!.tipoServico,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month, size: 40),
                                const SizedBox(width: 16),
                                Text(
                                  _consulta!.dataHoraFormata,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.description, size: 40),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _consulta!.observacao.isNotEmpty
                                        ? _consulta!.observacao
                                        : "Sem observações.",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                    ],
                  ),
                ),
    );
  }
}
