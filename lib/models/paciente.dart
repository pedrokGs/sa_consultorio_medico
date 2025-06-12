class Paciente {
  final int? id;
  final String nome;
  final String cpf;
  final String email;
  final String endereco;
  final DateTime dataNascimento;
  final String contato;

  //construtor
  Paciente({
    this.id,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.endereco,
    required this.dataNascimento,
    required this.contato
  });

  //Converter um obj em um Map(inserir as info no BD)
  Map<String,dynamic> toMap() {
    return{
      "id":id,
      "nome":nome,
      "cpf": cpf,
      "email": email,
      "endereco": endereco,
      "dataNascimento": dataNascimento.toIso8601String(),
      "contato": contato
    };
  }

  //Criar um objeto a partir  de um Map ( ler uma info do BD)
  factory Paciente.fromMap(Map<String,dynamic> map) {
    return Paciente(
      id: map["id"] as int,
      nome: map["nome"] as String, 
      cpf: map["cpf"] as String,
      email: map["email"] as String,
      endereco: map["endereco"] as String,
      dataNascimento: DateTime.parse(map["dataNascimento"] as String),
      contato: map["contato"] as String
    );
  }
}