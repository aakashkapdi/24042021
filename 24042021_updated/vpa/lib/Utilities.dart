import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:android_intent/android_intent.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';

class Utilities extends StatefulWidget {
  @override
  _UtilitiesState createState() => _UtilitiesState();
}

class _UtilitiesState extends State<Utilities> {
  final tts = TextToSpeech();
  stt.SpeechToText speech = new stt.SpeechToText();

  bool internet = false;

  void checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)
      internet = true;
    else
      internet = false;
  }

  void launchNavigation(String destination) {
    final AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('google.navigation:q=' + destination),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  void launchRbiMani() {
    try {
      AppAvailability.launchApp('com.rbi.mani');
    } catch (e) {
      tts.tell(
          'Error opening R B I mani app. ensure that you have R B I mani app installed on the phone');
    }
  }

  void resultListener(result) {
    speech.initialize();
    if (result.finalResult) {
      String temp = '${result.recognizedWords}';
      tts.tell("the entered Destination is " + temp);
      launchNavigation(temp);
    }
  }

  void recordInputDestination() async {
    bool available = await speech.initialize();
    if (available) {
      tts.tell("Give Voice input for the Destination");
      Future.delayed(Duration(seconds: 2), () {
        speech.listen(onResult: resultListener);
      });
    } else {
      tts.tell("The user has denied the use of speech recognition.");
    }
  }

  void navigation() {
    if (!internet)
      tts.tell(
          "You dont have an active internet connection, exiting Navigation");
    else {
      recordInputDestination();
    }
  }

  @override
  Widget build(BuildContext context) {
    checkInternet();
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    tts.tellCurrentScreen("Utilities");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFF00B1D2),
            appBar: AppBar(
                backgroundColor: Color(0xFF1C3BC8),
                title: Text("UTILITIES"),
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
                    tts.tellCurrentScreen("Utilities");
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
                        tts.tellPress("Navigation");
                      },
                      onLongPress: () {
                        navigation();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "NAVIGATION",
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
                        tts.tellPress("Currency detection");
                      },
                      onLongPress: () {
                        launchRbiMani();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "DETECT CURRENCY",
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
                        tts.tellPress("Face Detection");
                      },
                      onLongPress: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "FACE DETECTION",
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
                        tts.tellPress("Object Detection");
                      },
                      onLongPress: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "OBJECT DETECTION",
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
                        tts.tellPress("Read Text");
                      },
                      onLongPress: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "READ TEXT",
                        style: TextStyle(
                            fontSize: 34.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  )
                ]))));
  }
}
