import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'dart:io' as io;

class ReadText extends StatefulWidget {
  @override
  _ReadTextState createState() => _ReadTextState();
}

class _ReadTextState extends State<ReadText> {
  final tts = TextToSpeech();
  CameraController _camera;
  List<String> words = [];
  bool _isRecognising = false;

  List<CameraDescription> cameras;

  void _initializeCamera() async {
    cameras = await availableCameras();

    _camera =
        CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);
    await _camera.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Widget _showCamera() {
    if (_camera == null || _isRecognising)
      return Center(
          child: Container(
              height: 200, width: 200, child: CircularProgressIndicator()));
    else
      return CameraPreview(_camera);
  }

  void detectText(String path) async {
    FirebaseVisionImage img = new FirebaseVisionImage.fromFilePath(path);
    TextRecognizer recog = FirebaseVision.instance.textRecognizer();
    VisionText recognizedText = await recog.processImage(img);
    if (recognizedText.text.isEmpty)
      tts.tell("No Recognisable Text");
    else {
      tts.tell(recognizedText.text);
      print(recognizedText.text);
    }
    var dir = io.Directory(path);
    dir.deleteSync(recursive: true);
    setState(() {
      _isRecognising = false;
    });
  }

  Future<String> takePicture() async {
    if (!_camera.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }
    setState(() {
      _isRecognising = true;
    });
    final io.Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    String dateTime = DateTime.now().day.toString() +
        DateTime.now().month.toString() +
        DateTime.now().year.toString() +
        DateTime.now().hour.toString() +
        DateTime.now().minute.toString() +
        DateTime.now().second.toString() +
        DateTime.now().millisecond.toString() +
        DateTime.now().microsecond.toString();
    await io.Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/$dateTime.jpg';

    if (_camera.value.isTakingPicture) {
      return null;
    }

    try {
      await _camera.takePicture(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    print(filePath);
    detectText(filePath);
  }

  @override
  void initState() {
    super.initState();
    tts.tellCurrentScreen("Read text");
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFF00B1D2),
            appBar: AppBar(
                backgroundColor: Color(0xFF1C3BC8),
                title: Text("READ TEXT"),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () {
                      tts.goingBack("Utilities");
                      Navigator.pop(context);
                    })),
            body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) {
                  if (details.primaryDelta < -20) {
                    tts.tellDateTime();
                  }
                  if (details.primaryDelta > 20)
                    tts.tellCurrentScreen("Read Text");
                },
                child: Column(children: <Widget>[
                  Container(
                      height: SizeConfig.safeBlockVertical * 60,
                      width: SizeConfig.safeBlockHorizontal * 100,
                      child: _showCamera()),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 18,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: ElevatedButton(
                      onPressed: () {
                        tts.tellPress("Long press to Capture and Read text");
                      },
                      onLongPress: () {
                        takePicture();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "Capture Image",
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
