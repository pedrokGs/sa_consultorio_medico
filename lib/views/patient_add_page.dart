import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_consultorio/controllers/paciente_controller.dart';
import 'package:sa_consultorio/models/paciente.dart';
import 'package:sa_consultorio/views/patients_page.dart';
import 'package:sa_consultorio/widgets/custom_app_bar.dart';
import 'package:sa_consultorio/widgets/custom_drawer.dart';

class PatientAddPage extends StatefulWidget {
  const PatientAddPage({super.key});

  @override
  State<PatientAddPage> createState() => _PatientAddPageState();
}

class _PatientAddPageState extends State<PatientAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _pacienteController = PacienteController();

  String _nome = "";
  String _cpf = "";
  String _email = "";
  String _endereco = "";
  DateTime _dataNascimento = DateTime.now();
  String _contato = "";

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento,
      firstDate: DateTime.now(), // Não permite selecionar data do passado
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dataNascimento) {
      setState(() {
        _dataNascimento = picked;
      });
    }
  }

  Future<void> _salvarPaciente() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // ESSENCIAL: Salva os valores do formulário

      final DateTime finalDateTime = DateTime(
        _dataNascimento.year,
        _dataNascimento.month,
        _dataNascimento.day,
      );

      // criar a consulta (obj)
      final newPaciente = Paciente(
        nome: _nome,
        cpf: _cpf,
        email: _email,
        endereco: _endereco,
        dataNascimento: finalDateTime,
        contato: _contato,
      );

      try {
        await _pacienteController.insertPaciente(newPaciente);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paciente Inserido com sucesso!")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientsPage()),
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

    return Scaffold(
      appBar: CustomAppBar(
        title: "Adicionar Paciente",
        automaticallyImplyLeading: true,
        backButton: true,
      ),
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
                        labelText: "Nome Completo",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        return value!.length < 3
                            ? "Digite um nome válido com pelo menos 3 caracteres"
                            : null;
                      },
                      onSaved: (value) => _nome = value!,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "CPF",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        String pattern = r'^\d{3}\.\d{3}\.\d{3}-\d{2}$';
                        RegExp regex = RegExp(pattern);
                        if (value!.isEmpty) {
                          return "Campo não Preenchido!!!";
                        } else if (!regex.hasMatch(value)) {
                          return "CPF inválido";
                        }
                        return null;
                      },

                      onSaved: (value) => _cpf = value!,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        String pattern =
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                        RegExp regex = RegExp(pattern);
                        if (value == null || value.isEmpty) {
                          return "Campo não Preenchido!!!";
                        }
                        return regex.hasMatch(value) ? null : "Email inválido";
                      },
                      onSaved: (value) => _email = value!,
                    ),

                    SizedBox(height: 24),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Endereço",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Campo não Preenchido!!!" : null,
                      onSaved: (value) => _endereco = value!,
                    ),

                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Data: ${dateFormatter.format(_dataNascimento)}",
                            style: TextStyle(fontSize: 24),
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Contato",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Telefone não pode ser vazio';
                        } else if (!RegExp(r'^\+?[0-9\s]+$').hasMatch(value)) {
                          return 'Telefone inválido';
                        } else if (value.length < 10 || value.length > 15) {
                          return 'Telefone deve ter entre 10 e 15 dígitos';
                        }
                        return null;
                      },
                      onSaved: (value) => _contato = value!,
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
                      onPressed: _salvarPaciente,
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
