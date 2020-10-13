import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrscaner/src/bloc/scans_bloc.dart';
import 'package:qrscaner/src/models/scan_model.dart';
import 'package:qrscaner/src/pages/direcciones_page.dart';
import 'package:qrscaner/src/pages/mapas_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrscaner/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _callPage(currentIndex),
      appBar: AppBar(
        title: Text("QR Scanner"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          )
        ],
      ),
      bottomNavigationBar: _crearBottonNavigationBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor.withBlue(160),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _scanQR(BuildContext context) async {
    // https://www.google.com/
    // geo:40.74400455355701,-73.98671522578128
    // dynamic futureString = '';
    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch (e) {
    //   futureString = e.toString();
    // }

    dynamic futureString = 'https://www.facebook.com/';
    print("Future String: ${futureString}");
    if (futureString != null) {
      final newScan = ScanModel(valor: futureString.toString());
      scansBloc.addScan(newScan);
      // final newScan2 =
      //     ScanModel(valor: "geo:40.74400455355701,-73.98671522578128");
      // scansBloc.addScan(newScan2);
      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.openScan(context, newScan);
        });
      } else {
        utils.openScan(context, newScan);
      }
    }
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  Widget _crearBottonNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: Colors.white,
            ),
            title: Text(
              "Mapas",
              style: TextStyle(color: Colors.white),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.brightness_5,
              color: Colors.white,
            ),
            title: Text(
              "Direcciones",
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}
