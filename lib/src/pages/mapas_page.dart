import 'package:flutter/material.dart';
import 'package:qrscaner/src/bloc/scans_bloc.dart';
import 'package:qrscaner/src/models/scan_model.dart';
// import 'package:qrscaner/src/providers/db_provider.dart';
import 'package:qrscaner/src/utils/utils.dart' as utils;

class MapasPage extends StatelessWidget {
  final scansBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanModel>>(
      // future: DBProvider.db.getAllScans(),
      stream: scansBloc.scansStreams,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        final scans = snapshot.data;
        if (scans.length == 0) {
          return Center(
            child: Text("No hay informacion"),
          );
        }
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, index) => Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) =>
                // DBProvider.db.deleteScan(scans[index].id),
                scansBloc.deleteScan(scans[index].id),
            child: ListTile(
              onTap: () => utils.openScan(context, scans[index]),
              leading: Icon(
                Icons.cloud_queue,
                // color: Theme.of(context).primaryColor,
              ),
              title: Text(scans[index].valor),
              subtitle: Text(
                scans[index].id.toString(),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                // color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
