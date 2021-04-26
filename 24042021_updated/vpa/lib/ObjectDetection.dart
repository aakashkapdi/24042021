import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart' as tfl;

class ObjectDetection extends StatefulWidget {
  @override
  _ObjectDetectionState createState() => _ObjectDetectionState();
}

class _ObjectDetectionState extends State<ObjectDetection>
    with WidgetsBindingObserver {
  final tts = TextToSpeech();
  CameraController _camera;
  List<CameraDescription> cameras;
  bool _isDetecting = false;

  List<String> objects = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state.index == 2) _camera?.dispose();
    if (state.index == 0) {
      tts.tell("Going back to Utilities screen");
      Navigator.pop(context);
    }
  }

  void giveOutput(String s) {
    if (objects.contains(s)) {
    } else {
      objects.insert(objects.length, s);
      print("inserted at " + objects.length.toString());
      tts.tell(s);
      Future.delayed(Duration(seconds: 5), () {
        objects = [];
      });
    }
  }

  loadTfModel() async {
    await tfl.Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    try {
      _camera?.dispose();
    } catch (err) {
      print(err);
    }
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void _initializeCamera() async {
    cameras = await availableCameras();
    _camera =
        CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);
    await _camera.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
    await Future.delayed(Duration(milliseconds: 500));
    Future.delayed(Duration(seconds: 2));
    _camera.startImageStream((image) {
      if (!_isDetecting) {
        _isDetecting = true;
        tfl.Tflite.detectObjectOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          model: "SSDMobileNet",
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 127.5,
          imageStd: 127.5,
          numResultsPerClass: 3,
          threshold: 0.7,
        ).then((recognitions) {
          recognitions.forEach((element) {
            giveOutput(element['detectedClass']);
          });
          _isDetecting = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tts.tellCurrentScreen("Object Detection");

    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
    loadTfModel();
  }

  void launchGoogleLookout() {
    try {
      AppAvailability.launchApp('com.google.android.apps.accessibility.reveal');
    } catch (e) {
      tts.tell(
          'Error opening Google Lookout app. ensure that you have R B I mani app installed on the phone');
    }
  }

  Widget _showCamera() {
    if (_camera == null) {
      return Center(
          child: Container(
              height: 200, width: 200, child: CircularProgressIndicator()));
    } else
      return CameraPreview(_camera);
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
                title: Text("OBJECT DETECTION"),
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
                    tts.tellCurrentScreen("Object Detection");
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
                        tts.tellPress("Open Google Lookout");
                      },
                      onLongPress: () {
                        launchGoogleLookout();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xFF266EC0)),
                      child: Text(
                        "Google LOOKOUT",
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
