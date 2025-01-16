import 'package:atw_comm/core/routing/routes.dart';
import 'package:atw_comm/core/utils/consts.dart';
import 'package:atw_comm/features/home/views/staff_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int _countdown = 3;
  bool _isCountingDown = true;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    // Lock the device orientation to portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      print("No cameras available");
      return;
    }

    // Select the front camera by default
    int selectedCameraIndex = _cameras!.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    if (selectedCameraIndex == -1) {
      selectedCameraIndex = 0; // Fallback to any available camera
    }

    _initializeController(selectedCameraIndex);
  }

  Future<void> _initializeController(int cameraIndex) async {
    final camera = _cameras![cameraIndex];

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;

    setState(() {}); // Refresh the UI after initializing the camera

    // Start the countdown after initialization
    startSingleCountdown();
  }

  @override
  void dispose() {
    _controller?.dispose();
    // Reset orientation settings when leaving
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void startSingleCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        captureAndSendImage();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  Future<void> captureAndSendImage() async {
    try {
      await _initializeControllerFuture;
      final XFile image = await _controller!.takePicture();

      setState(() {
        _isCountingDown = false;
        _countdown = 0;
      });

      final response = await sendImageToApi(image);

      if (response.statusCode == 200) {
        String faceRecognized =
            response.data['recognized']?.toString().toLowerCase() ?? "Unknown";
        print("Face recognition result: $faceRecognized");
        if(faceRecognized != 'unknown') {
          userNameIdentified = faceRecognized;
          Navigator.of(context).pushReplacement(result: '',MaterialPageRoute(builder: (context) => StaffScreen(),));
        } else {
          Navigator.pop(context, faceRecognized);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Sorry you are not part of out staff!"),
            ),
          );
        }
      } else {
        print("Failed to get response: ${response.statusCode}");
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error capturing or sending image: $e");
      Navigator.pop(context, "Error: $e");
    }
  }

  Future<Response> sendImageToApi(XFile imageFile) async {
    final dio = Dio();
    const url = "https://ml-test.atwdemo.com/recognize_faces";

    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'image.jpg',
        ),
      });

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return response;
    } catch (e) {
      print("Error sending image to API: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RotatedBox(
        quarterTurns: 3,

        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Correctly rotated camera preview
                  Transform.scale(
                    scale: _controller!.value.aspectRatio < 1 ? 1.3 : 1,
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: CameraPreview(_controller!),
                    ),
                  ),
                  // Countdown overlay
                  if (_isCountingDown)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Text(
                          '$_countdown',
                          style: const TextStyle(
                            fontSize: 80,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
