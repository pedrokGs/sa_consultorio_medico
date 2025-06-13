import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_consultorio/controllers/consulta_controller.dart';
import 'package:sa_consultorio/views/patient_details_page.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

import '../models/consulta.dart';

class ConsultationsAddPage extends StatefulWidget {
  final pacienteId;
  const ConsultationsAddPage({super.key, required this.pacienteId});

  @override
  State<ConsultationsAddPage> createState() => _ConsultationsAddPageState();
}

class _ConsultationsAddPageState extends State<ConsultationsAddPage> {
  final _formKey = GlobalKey<FormState>();
  final ConsultasController _controllerConsulta = ConsultasController();

  late String tipoServico;
  String observacao = "";
  DateTime _selectedDate =
      DateTime.now(); //data Selecionada é a data atual inicalmente
  TimeOfDay _selectedTime =
      TimeOfDay.now(); //hora Selecioanda é a hora atual Inicialmente

  // método para Seleção da Data
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // Não permite selecionar data do passado
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // método para Seleção de hora
  Future<void> _selecionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        // Adicionado setState para atualizar a UI com a hora selecionada
        _selectedTime = picked;
      });
    }
  }

  // método para Salvar Consulta
  Future<void> _salvarConsulta() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // ESSENCIAL: Salva os valores do formulário

      final DateTime finalDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // criar a consulta (obj)
      final newConsulta = Consulta(
        pacienteId: widget.pacienteId,
        dataHora: finalDateTime,
        tipoServico: tipoServico,
        observacao: observacao.isEmpty
            ? "."
            : observacao,
      );

      try {
        await _controllerConsulta.insertConsulta(newConsulta);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Consulta agendada com sucesso!")),
        );
        // Retorna para a tela anterior (PetDetalheScreen)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PatientDetailsPage(pacienteId: widget.pacienteId),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao agendar consulta: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat("dd/MM/yyyy");
    final DateFormat timeFormatter = DateFormat("HH:mm");

    return Scaffold(
      appBar: CustomAppBar(title: "Adicionar Consulta", backButton: true),
      drawer: CustomDrawer(),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Tipo de consulta",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Campo não Preenchido!!!" : null,
                      onSaved: (value) => tipoServico = value!,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Observação (opcional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSaved: (value) => observacao = value!,
                    ),
                    SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Data: ${dateFormatter.format(_selectedDate)}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selecionarData(
                            context,
                          ), // Chamada correta do método
                          child: const Text("Selecionar Data"),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Hora: ${timeFormatter.format(DateTime(0, 0, 0, _selectedTime.hour, _selectedTime.minute))}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selecionarHora(
                            context,
                          ),
                          child: const Text("Selecionar Hora"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: Icon(Icons.medical_information),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _salvarConsulta,
                      label: const Text(
                        "Agendar Consulta",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
