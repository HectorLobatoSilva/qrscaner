import 'dart:async';

import 'package:qrscaner/src/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = new ScansBloc._internal();
  factory ScansBloc() {
    return _singleton;
  }
  ScansBloc._internal() {
    // Obtener scans de base de datos
    getScans();
  }
  // Stream
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStreams => _scansController.stream;

  dispose() {
    _scansController?.close();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  addScan(ScanModel scanModel) async {
    await DBProvider.db.newScan(scanModel);
    getScans();
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAllScans();
    getScans();
  }
}
