import 'package:sa_consultorio/database/db_helper.dart';
import 'package:sa_consultorio/models/consulta.dart';

class ConsultasController {
  final MedPlusDBHelper _dbHelper = MedPlusDBHelper();

  Future<List<Consulta>> getConsultasByPaciente(int pacienteId) async{
    return await _dbHelper.getConsultaForPaciente(pacienteId);
  }

  Future<int> insertConsulta(Consulta consulta) async{
    return await _dbHelper.insertConsulta(consulta);
  }

  Future<int> deleteConsulta(int id) async{
    return await _dbHelper.deleteConsulta(id);
  }
}