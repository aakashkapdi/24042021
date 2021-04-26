import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'dart:io' as io;

class Initialisation extends StatefulWidget {
  @override
  _InitialisationState createState() => _InitialisationState();
}

class _InitialisationState extends State<Initialisation> {
  final tts = TextToSpeech();
  int resetCount = 0;
  io.File jsonFileSos, jsonFileMute;

  void resetSosFile() async {
    try {
      io.Directory tempDir = await getApplicationDocumentsDirectory();
      String _sosPath = tempDir.path + '/sos.json';
      jsonFileSos = new io.File(_sosPath);
    } catch (e) {
      print(e.toString());
    }

    Map<String, dynamic> message = {"Message": ""};
    Map<String, dynamic> count = {"Count": "0"};
    Map<String, dynamic> emptyForSos = {};
    emptyForSos.addAll(message);
    emptyForSos.addAll(count);
    jsonFileSos.writeAsStringSync(json.encode(emptyForSos));
    print("sos file created");
  }

  void resetMuteFile() async {
    try {
      io.Directory tempDir = await getApplicationDocumentsDirectory();
      String _mutePath = tempDir.path + '/mute.json';
      jsonFileMute = io.File(_mutePath);
    } catch (e) {
      print("File Exception" + e.toString());
    }
    Map<String, dynamic> obstacle = {"Obstacle": "Unmute"};
    Map<String, dynamic> elevated = {"Elevated": "Unmute"};
    Map<String, dynamic> lowered = {"Lowered": "Unmute"};
    Map<String, dynamic> wet = {"Wet": "Unmute"};
    Map<String, dynamic> emptyForMute = {};

    emptyForMute.addAll(obstacle);
    emptyForMute.addAll(elevated);
    emptyForMute.addAll(lowered);
    emptyForMute.addAll(wet);

    jsonFileMute.writeAsStringSync(json.encode(emptyForMute));
  }

  void resetAllFiles() {
    resetSosFile();
    resetMuteFile(); //TODO Add remaining file to reset
  }

  void incrementReset() {
    resetCount++;
    Future.delayed(Duration(seconds: 5), () {
      resetCount = 0;
    });
    if (resetCount == 6) {
      tts.tell("Resetting All Files to Default");
      resetAllFiles();
      resetCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    tts.tellCurrentScreen("Initialisation");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFF00B1D2),
            appBar: AppBar(
                backgroundColor: Color(0xFF1C3BC8),
                title: Text("INITIALISATION"),
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
                  if (details.primaryDelta > 20)
                    tts.tellCurrentScreen("Initialisation");
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
                        tts.tellPress("Save Contacts");
                      },
                      onLongPress: () {
                        Navigator.pushNamed(context, '/saveContacts');
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "SAVE CONTACTS",
                        style: TextStyle(
                            fontSize: 34.0,
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
                        tts.tellPress("Save SOS Message");
                      },
                      onLongPress: () {
                        Navigator.pushNamed(context, '/saveMessage');
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "SAVE SOS MESSAGE",
                        style: TextStyle(
                            fontSize: 34.0,
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
                        tts.tellPress("Save Faces");
                      },
                      onLongPress: () {
                        Navigator.pushNamed(context, '/saveFaces');
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "SAVE FACES",
                        style: TextStyle(
                            fontSize: 34.0,
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
                        if (resetCount == 0)
                          tts.tell(
                              "Press this button 5 times to Reset Settings to Default");
                        incrementReset();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "RESET",
                        style: TextStyle(
                            fontSize: 34.0,
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
                ]))));
  }
}
