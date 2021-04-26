import 'package:flutter/material.dart';
import 'package:vpa/Initialisation.dart';
import 'package:vpa/Mute.dart';
import 'package:vpa/ObjectDetection.dart';
import 'package:vpa/SaveContacts.dart';
import 'package:vpa/SaveFaces.dart';
import 'package:vpa/SaveMessage.dart';
import 'package:vpa/Utilities.dart';
import 'Home.dart';
import 'package:vpa/ReadText.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '360 VPA',
      routes: {
        '/': (context) => Home(),
        '/saveContacts': (context) => SaveContacts(),
        '/initialisation': (context) => Initialisation(),
        '/saveMessage': (context) => SaveMessage(),
        '/saveFaces': (context) => SaveFaces(),
        '/mute': (context) => Mute(),
        '/utilities': (context) => Utilities(),
        '/objectDetection': (context) => ObjectDetection(),
        '/readText': (context) => ReadText()
      },
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
