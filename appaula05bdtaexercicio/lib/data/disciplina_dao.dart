import 'package:appaula05bdtaexercicio/data/app_database.dart';
import 'package:appaula05bdtaexercicio/models/disciplina.dart';
import 'package:sqflite/sqflite.dart';

class DisciplinaDao {
  static const table = 'disciplinas';

  Future<int> insert(Disciplina disciplina) async {
    final db = await AppDatabase.instance.database;
    return db.insert(
      table,
      disciplina.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Disciplina>> getAll() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(table, orderBy: 'id DESC');
    return maps.map((m) => Disciplina.fromMap(m)).toList();
  }

  Future<int> update(Disciplina disciplina) async {
    final db = await AppDatabase.instance.database;
    return db.update(
      table,
      disciplina.toMap(),
      where: 'id = ?',
      whereArgs: [disciplina.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Disciplina>> searchByName(String query) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      table,
      where: 'nome LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'nome ASC',
    );
    return maps.map((m) => Disciplina.fromMap(m)).toList();
  }
}