import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'dart:io' as io;

class Mute extends StatefulWidget {
  @override
  _MuteState createState() => _MuteState();
}

class _MuteState extends State<Mute> {
  final tts = TextToSpeech();
  io.File jsonFileMute;

  void readMuteFile() async {
    try {
      io.Directory tempDir = await getApplicationDocumentsDirectory();
      String _mutePath = tempDir.path + '/mute.json';
      jsonFileMute = io.File(_mutePath);
      Map<String, dynamic> data = json.decode(jsonFileMute.readAsStringSync());
      print("before:");
      print(data);
    } catch (e) {
      print("File Exception" + e.toString());
    }
  }

  void updateMuteFile(String key, String value) {
    Map<String, dynamic> data = json.decode(jsonFileMute.readAsStringSync());
    data[key] = value;
    jsonFileMute.writeAsStringSync(json.encode(data));
  }

  void unmuteAll() {
    Map<String, dynamic> data = json.decode(jsonFileMute.readAsStringSync());
    data['Obstacle'] = 'Unmute';
    data['Elevated'] = 'Unmute';
    data['Lowered'] = 'Unmute';
    data['Wet'] = 'Unmute';
    jsonFileMute.writeAsStringSync(json.encode(data));
  }

  @override
  Widget build(BuildContext context) {
    readMuteFile();
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    tts.tellCurrentScreen("Mute");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFF00B1D2),
            appBar: AppBar(
                backgroundColor: Color(0xFF1C3BC8),
                title: Text("MUTE AUDIO"),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () {
                      tts.goingBack("Home");

                      Navigator.pop(context);
                    })),
            body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) {
                  if (details.primaryDelta < -20) {
                    tts.tellDateTime();
                  }
                  if (details.primaryDelta > 20) tts.tellCurrentScreen("Mute");
                },
                child: Column(children: <Widget>[
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 18 - 12.58,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: ElevatedButton(
                      onPressed: () {
                        tts.tellPress("Mute Obstacle Detection");
                      },
                      onLongPress: () {
                        tts.tell("Muting Obstacle Detection");
                        updateMuteFile("Obstacle", "Mute");
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "MUTE OBSTACLE DETECTION",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 18 - 12.58,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: ElevatedButton(
                      onPressed: () {
                        tts.tellPress("Mute elevated surface");
                      },
                      onLongPress: () {
                        tts.tell("Muting Elevated Surface Detection");
                        updateMuteFile("Elevated", "Mute");
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "MUTE ELEVATED SURFACE DETECTION",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 18 - 12.58,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: ElevatedButton(
                      onPressed: () {
                        tts.tellPress("Mute lowered surface detection");
                      },
                      onLongPress: () {
                        tts.tell("Muting Lowered Surface Detection");
                        updateMuteFile("Lowered", "Mute");
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "MUTE LOWERED SURFACE DETECTION",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 18 - 12.58,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: ElevatedButton(
                      onPressed: () {
                        tts.tellPress("mute wet surface detection");
                      },
                      onLongPress: () {
                        tts.tell("Muting wet Surface Detection");
                        updateMuteFile("Wet", "Mute");
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "MUTE WET SURFACE DETECTION",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 18 - 12.58,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: ElevatedButton(
                      onPressed: () {
                        tts.tellPress("umnute all voice outputs");
                      },
                      onLongPress: () {
                        tts.tell("Unmuting all Voice Outputs");
                        unmuteAll();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "UNMUTE ALL",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  )
                ]))));
  }
}
