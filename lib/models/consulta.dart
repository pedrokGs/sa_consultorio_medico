import 'package:intl/intl.dart';

class Consulta{
  final int? id;
  final int pacienteId;
  final DateTime dataHora;
  final String tipoServico;
  final String observacao; // pode ser nulo

  //CONSTRUTOR
  Consulta({
    this.id,
    required this.pacienteId,
    required this.dataHora,
    required this.tipoServico,
    required this.observacao
  });

  //Converter Map: Obj => BD
  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "paciente_id":pacienteId,
      "data_hora": dataHora.toIso8601String(),
      "tipo_servico":tipoServico,
      "observacao":observacao
    };
  }

  //Converte Obj: BD => Obj
  factory Consulta.fromMap(Map<String,dynamic> map){
    return Consulta(
      id: map["id"] as int,
      pacienteId: map["paciente_id"] as int, 
      dataHora: DateTime.parse(map["data_hora"] as String),
      tipoServico: map["tipo_servico"] as String,
      observacao: map["observacao"] as String
      );
  }

  //Formatacao de data e Hora em formato Regional
  String get dataHoraFormata {
    final formatter = DateFormat("dd/MM/yyyy HH:mm");
    return formatter.format(dataHora);
  }
}

