import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrscaner/src/models/scan_model.dart';

openScan(BuildContext context, ScanModel scanModel) async {
  if (scanModel.tipo == 'http') {
    String url = scanModel.valor.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } else {
    Navigator.pushNamed(context, "mapa", arguments: scanModel);
  }
}
