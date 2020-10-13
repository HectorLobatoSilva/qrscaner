import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscaner/src/models/scan_model.dart';

class MapaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text("Coordenadas QR"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {},
            )
          ],
        ),
        body: _crearFlutterMap(scan));
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      options: MapOptions(center: scan.getLatLng(), zoom: 10),
      layers: [_crearMapa()],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiaGVjdG9ybG9iYXRvIiwiYSI6ImNrZXVreTNwNjAzZWgycnA1MHBrejR3OXAifQ.yIHLRUXMHpUWKGS76IHjyA',
          'id': 'mapbox.streets'
        });
  }
}
