import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qrscaner/src/models/scan_model.dart';
export 'package:qrscaner/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._private();
  DBProvider._private();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentDirectory.path, 'ScansDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Scans('
            'id INTEGER PRIMARY KEY,'
            'tipo TEXT,'
            'valor TEXT'
            ')');
      },
    );
  }

  // Crear registros
  newScanRaw(ScanModel nuevoScan) async {
    final db = await database;
    final resultado = await db.rawInsert("INSERT INTO Scans (id, tipo, valor) "
        "VALUES ( ${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}' )");
    return resultado;
  }

  newScan(ScanModel nuevoScan) async {
    final db = await database;
    final respuesta = await db.insert("Scans", nuevoScan.toJson());
    return respuesta;
  }

  // Obtener informacion
  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    final respuesta = await db.query("Scans", where: "id = ?", whereArgs: [id]);
    return respuesta.isNotEmpty ? ScanModel.fromJson(respuesta.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final respuesta = await db.query("Scans");
    List<ScanModel> lista = respuesta.isNotEmpty
        ? respuesta.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
    return lista;
  }

  Future<List<ScanModel>> getAllScansByType(String tipo) async {
    final db = await database;
    final respuesta =
        await db.query("Scans", where: "tipo = ?", whereArgs: [tipo]);
    List<ScanModel> lista = respuesta.isNotEmpty
        ? respuesta.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
    return lista;
  }

  // Actualizar registros
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final respuesta = await db.update("Scans", nuevoScan.toJson(),
        where: "id = ?", whereArgs: [nuevoScan.id]);
    return respuesta;
  }

  // Borrar registros
  Future<int> deleteScan(int id) async {
    final db = await database;
    final respuesta = db.delete("Scans", where: "id = ?", whereArgs: [id]);
    return respuesta;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final respuesta = db.delete("Scans");
    return respuesta;
  }
}
