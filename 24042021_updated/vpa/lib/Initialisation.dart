import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpa/SaveContacts.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';

class Initialisation extends StatefulWidget {
  @override
  _InitialisationState createState() => _InitialisationState();
}

class _InitialisationState extends State<Initialisation> {
  String selectedPage;

  void _handlePageTapped(String page) {
    setState(() {
      selectedPage = page;
    });
    print(page);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Home Page",
        home: Navigator(
          pages: [
            if (selectedPage == null)
              MaterialPage(
                  child: InitialisationPage(
                onTap: _handlePageTapped,
              )),
            if (selectedPage != null)
              if (selectedPage == "SaveContacts")
                MaterialPage(
                    child: SaveContacts()) //TODO:- add more routes for pages
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) return false;
            setState(() {
              selectedPage = null;
            });
            return true;
          },
        ));
  }
}

class InitialisationPage extends StatelessWidget {
  final tts = TextToSpeech();
  final ValueChanged<String> onTap;

  InitialisationPage({Key key, this.onTap}) : super(key: key);

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
                      Navigator.of(context).pop();
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
                        onTap("SaveContacts");
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
                      onLongPress: () {},
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
                      onLongPress: () {},
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
                        tts.tellPress("Reset Settings to Default");
                      },
                      onLongPress: () {},
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
