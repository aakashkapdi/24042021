import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'dart:io' as io;
import 'package:contact_picker/contact_picker.dart';

class SaveContacts extends StatefulWidget {
  @override
  _SaveContactsState createState() => _SaveContactsState();
}

class _SaveContactsState extends State<SaveContacts> {
  final tts = TextToSpeech();
  final ContactPicker _contactPicker = new ContactPicker();

  io.File jsonFileSos;

  void readSosFile() async {
    try {
      io.Directory tempDir = await getApplicationDocumentsDirectory();
      String _sosPath = tempDir.path + '/sos.json';
      jsonFileSos = io.File(_sosPath);
      Map<String, dynamic> data = json.decode(jsonFileSos.readAsStringSync());
      print("before:");
      print(data);
    } catch (e) {
      print("File Exception" + e.toString());
    }
  }

  Widget showContacts() {
    try {
      Map<String, dynamic> fileContent =
          json.decode(jsonFileSos.readAsStringSync());
      var count = fileContent['Count'];
      if (int.parse(count) == 0) {
        tts.tell("You dont have any contacts saved");
        return Container(
          child: Center(
            child: Text(
              "No Contacts Saved",
              style: TextStyle(
                  fontSize: 25.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto"),
            ),
          ),
        );
      } else {
        List names = [], numbers = [];
        fileContent.forEach((key, value) {
          if (key.contains("Name"))
            names.add(value);
          else if (key.contains("Number")) numbers.add(value);
        });
        return ListView.builder(
            itemCount: int.parse(count),
            itemBuilder: (BuildContext context, int index) {
              return new Column(
                children: <Widget>[
                  Container(
                    height: SizeConfig.safeBlockVertical * 9,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: ElevatedButton(
                      onPressed: () {
                        tts.tellPress("Pick contacts");
                      },
                      onLongPress: () {
                        pickContacts();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          primary: Color(0xFF266EC0)),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            new Text(
                              names[index],
                              style: new TextStyle(
                                  fontSize: 25.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                            ),
                            new Text(
                              numbers[index],
                              style: new TextStyle(
                                  fontSize: 25.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  new Divider(
                    height: 5.0,
                  ),
                ],
              );
            });
      }
    } catch (e) {
      print(e.toString());
      Future.delayed(Duration(seconds: 2), () {
        setState(() {});
      });
      return Container();
    }
  }

  void updateSosFile(String name, String number) async {
    try {
      io.Directory tempDir = await getApplicationDocumentsDirectory();
      String _sosPath = tempDir.path + '/sos.json';
      jsonFileSos = io.File(_sosPath);
    } catch (e) {
      print("File Exception" + e.toString());
    }
    Map<String, dynamic> data = json.decode(jsonFileSos.readAsStringSync());
    int count = int.parse(data['Count']);
    if (count < 4) {
      count++;
      Map<String, dynamic> map = {
        "Name_" + count.toString(): name,
        "Number_" + count.toString(): number
      };
      Map<String, dynamic> cMap = {"Count": count.toString()};
      data.addAll(cMap);
      data.addAll(map);

      try {
        jsonFileSos.writeAsStringSync(json.encode(data));
      } catch (e) {
        print(e.toString());
      }
    } else {
      tts.tell("Maximum contacts Reached");
    }
  }

  void pickContacts() async {
    Contact contact;
    try {
      contact = await _contactPicker.selectContact();
    } catch (e) {
      print(e.toString());
    }
    String name = contact.fullName;
    String number = contact.phoneNumber.toString();
    String temp;
    if (number.contains("+91"))
      temp = number.replaceAll("+91", "").trim().split("(").first.trim();
    else
      temp = number.trim().split("(").first.trim();
    updateSosFile(name, temp);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    readSosFile();
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
                    height: SizeConfig.safeBlockVertical * 45,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: showContacts(),
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
                        try {
                          Map<String, dynamic> fileContent =
                              json.decode(jsonFileSos.readAsStringSync());
                          var count = fileContent['Count'];
                          if (int.parse(count) < 4) {
                            tts.tell("Pick Contact");
                          } else {
                            tts.tell("Maximum limit reached");
                          }
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      onLongPress: () {
                        try {
                          Map<String, dynamic> fileContent =
                              json.decode(jsonFileSos.readAsStringSync());
                          var count = fileContent['Count'];
                          if (int.parse(count) < 4) {
                            pickContacts();
                          } else {
                            tts.tell("Maximum limit reached");
                          }
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "PICK CONTACT",
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
