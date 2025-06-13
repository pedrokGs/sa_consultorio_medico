import 'dart:async';

import 'package:path/path.dart';
import 'package:sa_consultorio/models/consulta.dart';
import 'package:sa_consultorio/models/paciente.dart';
import 'package:sqflite/sqflite.dart';

class MedPlusDBHelper {
  static Database? _database;
  static final MedPlusDBHelper _instance = MedPlusDBHelper._internal();

  //construtor do Singleton
  MedPlusDBHelper._internal();
  factory MedPlusDBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!; //se o banco já existe , retorna ele mesmo
    }
    //se não existe - inicia a conexão
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final _dbPath = await getDatabasesPath();
    final path = join(_dbPath, "medplus.db"); //caminho do banco de Dados

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future<void> _onCreateDB(Database db, int version) async {
    // Cria a tabela 'pacientes'
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pacientes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        cpf TEXT NOT NULL,
        email TEXT NOT NULL,
        endereco TEXT NOT NULL,
        dataNascimento TEXT NOT NULL,
        contato TEXT NOT NULL
      )
    ''');
    print("banco pacientes criado");

    // Cria a tabela 'consultas'
    await db.execute('''
      CREATE TABLE IF NOT EXISTS consultas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        paciente_id INTEGER NOT NULL,
        data_hora TEXT NOT NULL,
        tipo_servico TEXT NOT NULL,
        observacao TEXT NOT NULL,
        FOREIGN KEY (paciente_id) REFERENCES paciente(id) ON DELETE CASCADE
      )
    ''');
    print("banco consultas criado");
  }

  //MÉTODOS CRUD PARA pets
  Future<int> insertPaciente(Paciente paciente) async {
    final db = await database;
    return await db.insert("pacientes", paciente.toMap()); //retorna o ID do pet
  }

  Future<List<Paciente>> getPacientes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "pacientes",
    ); // recebe todos os pets cadastros
    //converter em objetos
    return maps.map((e) => Paciente.fromMap(e)).toList();
    // adiciona elem por elem na lista já convertido em obj
  }

  Future<Paciente?> getPacienteById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      //faz a busca no BD
      "pacientes",
      where: "id=?",
      whereArgs: [id],
    ); // A partir do ID solicitado
    // Se Encontrado
    if (maps.isNotEmpty) {
      return Paciente.fromMap(maps.first); //cria o obj com 1º elementos da list
    } else {
      return null;
    }
  }

  Future<int> deletePaciente(int id) async {
    final db = await database;
    return await db.delete("pacientes", where: "id=?", whereArgs: [id]);
    // deleta o pet da tabela que tenha o id igual ao passado pelo parametro
  }

  //métodos CRUDs para Consultas

  Future<int> insertConsulta(Consulta consulta) async {
    final db = await database;
    //insere a consulta no BD
    return await db.insert("consultas", consulta.toMap());
  }

  Future<List<Consulta>> getConsultaForPaciente(int pacienteId) async {
    final db = await database;
    //Consulta  por pet especifico
    final List<Map<String, dynamic>> maps = await db.query(
      "consultas",
      where: "paciente_id = ?",
      whereArgs: [pacienteId],
      // orderBy: "data_hora ASC" //ordena pela DAta/Hora
    );
    //converter a map para obj
    return maps.map((e) => Consulta.fromMap(e)).toList();
  }

  Future<int> deleteConsulta(int id) async {
    final db = await database;
    //delete pelo ID
    return await db.delete("consultas", where: "id = ?", whereArgs: [id]);
  }

  Future<List<Consulta>> getConsultas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("consultas");
    return maps.map((e) => Consulta.fromMap(e)).toList();
  }

  Future<Consulta?> getConsultaById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "consultas",
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Consulta.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
