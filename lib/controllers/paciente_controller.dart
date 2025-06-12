import 'package:sa_consultorio/database/db_helper.dart';
import 'package:sa_consultorio/models/paciente.dart';

class PacienteController {
  //atributo -> é conexão com DB
  final MedPlusDBHelper _dbHelper = MedPlusDBHelper();


  Future<int> addPet(Paciente paciente) async{
    return await _dbHelper.insertPaciente(paciente);
  }

  Future<List<Paciente>> fetchPacientes() async{
    return await _dbHelper.getPacientes();
  }

  Future<Paciente?> findPacienteById(int id) async{
    return await _dbHelper.getPacienteById(id);
  }

  Future<int> deletePaciente(int id) async{
    return await _dbHelper.deletePaciente(id);
  }
}