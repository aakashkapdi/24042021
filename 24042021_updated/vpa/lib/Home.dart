import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpa/Initialisation.dart';
import 'package:vpa/Mute.dart';
import 'package:vpa/Utilities.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  child: HomeView(
                onTap: _handlePageTapped,
              )),
            if (selectedPage != null)
              if (selectedPage == "Initialisation")
                MaterialPage(child: Initialisation())
              else if (selectedPage == "Utilities")
                MaterialPage(child: Utilities())
              else if (selectedPage == "Mute")
                MaterialPage(child: Mute()) //TODO:- add more routes for pages
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

class HomeView extends StatelessWidget {
  final tts = TextToSpeech();

  final ValueChanged<String> onTap;

  HomeView({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    tts.tellCurrentScreen("home");
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
                          onLongPress: () {},
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
                            onTap("Mute");
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
                            onTap("Utilities");
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
                            onTap("Initialisation");
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
