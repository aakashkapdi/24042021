import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:connectivity/connectivity.dart';
import 'package:sms/sms.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final tts = TextToSpeech();
  io.File jsonFileSos;
  Map<String, dynamic> emptyForSos = {};
  bool internet = false;

  void checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)
      internet = true;
    else
      internet = false;
  }

  Future<String> prepareMessage() async {
    Map<String, dynamic> data = json.decode(jsonFileSos.readAsStringSync());
    String message;
    checkInternet();
    if (data["Message"].toString().isEmpty) {
      message = "Emergency! I need Help.";
    } else
      message = data["Message"].toString();
    if (internet) {
      Position pos = await GeolocatorPlatform.instance.getCurrentPosition();
      message = message +
          "...My current location is http://maps.google.com/maps?q=" +
          pos.latitude.toString() +
          "," +
          pos.longitude.toString();
    }
    return message;
  }

  void sendSos() async {
    Map<String, dynamic> data = json.decode(jsonFileSos.readAsStringSync());
    if (int.parse(data['Count']) == 0)
      tts.tell("No Contacts Saved Exiting S O S");
    else {
      String message = await prepareMessage();
      print(message);
      List numbers = [];
      data.forEach((key, value) {
        if (key.contains("Number")) numbers.add(value);
        SmsSender sender = new SmsSender();
        numbers.forEach((number) async {
          String address = "+91" + number.toString();
          SmsMessage result =
              await sender.sendSms(SmsMessage(address, message));
          result.onStateChanged.listen((state) {
            if (state == SmsMessageState.Fail)
              tts.tell("S O S Message Failed due to no network");
            else if (state == SmsMessageState.Sending)
              tts.tell("Sending S O S Message ");
            else if (state == SmsMessageState.Sent)
              tts.tell("S O S Message Sent");
          });
        });
      });
    }
  }

  void checkFileSOS() async {
    io.Directory tempDir = await getApplicationDocumentsDirectory();
    String _sosPath = tempDir.path + '/sos.json';
    if (await io.File(_sosPath).exists()) {
      print("SOS File Exists");
      jsonFileSos = io.File(_sosPath);
    } else {
      jsonFileSos = new io.File(_sosPath);
      Map<String, dynamic> message = {"Message": ""};
      Map<String, dynamic> count = {"Count": "0"};
      emptyForSos.addAll(message);
      emptyForSos.addAll(count);
      jsonFileSos.writeAsStringSync(json.encode(emptyForSos));
      print("sos file created");
    }
  }

  @override
  Widget build(BuildContext context) {
    checkFileSOS();
    tts.tellCurrentScreen("home");
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("360 VPA"),
          backgroundColor: Color(0xFF1C3BC8),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta < -20) {
              tts.tellDateTime();
            }
            if (details.primaryDelta > 20) {
              tts.tellCurrentScreen("Home");
            }
          },
          child: Column(
            children: <Widget>[
              Container(
                height: SizeConfig.safeBlockVertical * 49.5 - 28,
                width: SizeConfig.safeBlockHorizontal * 100,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: SizeConfig.safeBlockVertical * 49.5 - 28,
                        width: SizeConfig.safeBlockHorizontal * 49,
                        color: Colors.purple,
                        child: ElevatedButton(
                          onPressed: () {
                            tts.tellPress("Send S O S");
                          },
                          onLongPress: () {
                            sendSos();
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF266EC0)),
                          child: Text(
                            "SEND SOS",
                            style: TextStyle(
                                fontSize: 21.0,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                        )),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 49.5 - 28,
                      width: SizeConfig.safeBlockHorizontal * 2,
                    ),
                    Container(
                        height: SizeConfig.safeBlockVertical * 49.5 - 28,
                        width: SizeConfig.safeBlockHorizontal * 49,
                        color: Colors.purple,
                        child: ElevatedButton(
                          onPressed: () {
                            tts.tellPress("MUTE AUDIO");
                          },
                          onLongPress: () {
                            Navigator.pushNamed(context, '/mute');
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF00B1D2)),
                          child: Text(
                            "MUTE AUDIO",
                            style: TextStyle(
                                fontSize: 21.0,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 1,
                width: SizeConfig.safeBlockHorizontal * 100,
              ),
              Container(
                height: SizeConfig.safeBlockVertical * 49.5 - 28,
                width: SizeConfig.safeBlockHorizontal * 100,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: SizeConfig.safeBlockVertical * 49.5 - 28,
                        width: SizeConfig.safeBlockHorizontal * 49,
                        color: Colors.purple,
                        child: ElevatedButton(
                          onPressed: () {
                            tts.tellPress("UTILITIES");
                          },
                          onLongPress: () {
                            Navigator.pushNamed(context, '/utilities');
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF00B1D2)),
                          child: Text(
                            "UTILITIES",
                            style: TextStyle(
                                fontSize: 21.0,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                        )),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 49.5 - 28,
                      width: SizeConfig.safeBlockHorizontal * 2,
                    ),
                    Container(
                        height: SizeConfig.safeBlockVertical * 49.5 - 28,
                        width: SizeConfig.safeBlockHorizontal * 49,
                        color: Colors.purple,
                        child: ElevatedButton(
                          onPressed: () {
                            tts.tellPress("INITIALISATION");
                          },
                          onLongPress: () {
                            Navigator.pushNamed(context, '/initialisation');
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF266EC0)),
                          child: Text(
                            "INITIALISATION",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
