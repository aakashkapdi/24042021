import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'dart:io' as io;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path_provider/path_provider.dart';

class SaveMessage extends StatefulWidget {
  @override
  _SaveMessageState createState() => _SaveMessageState();
}

class _SaveMessageState extends State<SaveMessage> {
  final tts = TextToSpeech();
  stt.SpeechToText speech = new stt.SpeechToText();
  io.File jsonFileSos;

  void updateFile(String message) async {
    try {
      io.Directory tempDir = await getApplicationDocumentsDirectory();
      String _sosPath = tempDir.path + '/sos.json';
      jsonFileSos = io.File(_sosPath);
    } catch (e) {
      print("File Exception" + e.toString());
    }
    Map<String, dynamic> data = json.decode(jsonFileSos.readAsStringSync());
    print("before:");
    print(data);
    data['Message'] = message;
    jsonFileSos.writeAsStringSync(json.encode(data));
    print("after:");
    print(data);
  }

  void resultListener(result) {
    speech.initialize();
    if (result.finalResult) {
      String temp = '${result.recognizedWords}';
      tts.tell("the entered message is " + temp);
      updateFile(temp);
    }
  }

  void recordSosMssg() async {
    bool available = await speech.initialize();
    if (available) {
      tts.tell("Give Voice input for the S O S Message");
      Future.delayed(Duration(seconds: 2), () {
        speech.listen(onResult: resultListener);
      });
    } else {
      tts.tell("The user has denied the use of speech recognition.");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    tts.tellCurrentScreen("Save Message");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFF00B1D2),
            appBar: AppBar(
                backgroundColor: Color(0xFF1C3BC8),
                title: Text("SAVE MESSAGE"),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () {
                      tts.goingBack("Initialisation");
                      Navigator.pop(context);
                    })),
            body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) {
                  if (details.primaryDelta < -20) {
                    tts.tellDateTime();
                  }
                  if (details.primaryDelta > 20)
                    tts.tellCurrentScreen("save contacts");
                },
                child: Column(children: <Widget>[
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 35,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 18,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: ElevatedButton(
                      onPressed: () {
                        tts.tellPress("Save S O S Message");
                      },
                      onLongPress: () {
                        recordSosMssg();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "SAVE S O S MESSAGE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 31.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ),
                ]))));
  }
}
