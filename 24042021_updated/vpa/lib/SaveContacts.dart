import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';

class SaveContacts extends StatefulWidget {
  @override
  _SaveContactsState createState() => _SaveContactsState();
}

class _SaveContactsState extends State<SaveContacts> {
  final tts = TextToSpeech();
  @override
  Widget build(BuildContext context) {
    String selectedPage;
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    tts.tellCurrentScreen("Save Contacts");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFF00B1D2),
            appBar: AppBar(
                backgroundColor: Color(0xFF1C3BC8),
                title: Text("SAVE CONTACTS"),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
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
                    height: SizeConfig.safeBlockVertical * 25,
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
                        tts.tellPress("Pick contacts");
                      },
                      onLongPress: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "PICK CONTACT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ),
                ]))));
  }
}
