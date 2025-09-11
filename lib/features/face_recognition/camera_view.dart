import 'dart:io';

import 'package:atw_comm/core/routing/routes.dart';
import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/utils/consts.dart';
import 'package:atw_comm/features/staff/views/staff_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int _countdown = 3;
  bool _isCountingDown = true;
  bool _isProcessing = false;
  List<CameraDescription>? _cameras;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        _showError("No cameras available");
        return;
      }

      int selectedCameraIndex = _cameras!.indexWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      if (selectedCameraIndex == -1) {
        selectedCameraIndex = 0;
      }

      await _initializeController(selectedCameraIndex);
    } catch (e) {
      _showError("Failed to initialize camera: $e");
    }
  }

  Future<void> _initializeController(int cameraIndex) async {
    final camera = _cameras![cameraIndex];

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
      if (mounted) {
        setState(() {});
        startSingleCountdown();
      }
    } catch (e) {
      _showError("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pulseController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void startSingleCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

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

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> captureAndSendImage() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _isCountingDown = false;
    });

    try {
      await _initializeControllerFuture;
      final XFile image = await _controller!.takePicture();

      final response = await sendImageToApi(image);

      if (response.statusCode == 200) {
        String faceRecognized =
            response.data['recognized']['name']?.toString().toLowerCase() ?? "unknown";

        if (faceRecognized != 'unknown') {
          userNameIdentified = faceRecognized;
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const StaffScreen()),
            );
          }
        } else {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sorry, you are not part of our staff!"),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } else {
        _showError("Failed to process image: ${response.statusCode}");
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      _showError("Error: $e");
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<Response> sendImageToApi(XFile imageFile) async {
    final dio = Dio();
    const url = "https://ml-test.atwdemo.com/recognize";

    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'image.jpg',
        ),
      });

      return await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } catch (e) {
      throw "Network error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Camera Preview
                  Positioned.fill(
                    child: Platform.isIOS
                        ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(0),
                      child: CameraPreview(_controller!),
                    )
                        : Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14159),
                        child: CameraPreview(_controller!),
                      ),
                    ),
                  ),
                  // Overlay
                  _buildOverlay(),

                  // Countdown or Processing
                  if (_isCountingDown || _isProcessing)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: _isProcessing
                            ? _buildProcessingIndicator()
                            : _buildCountdown(),
                      ),
                    ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Stack(
      children: [
        // Top text
        Positioned(
          top: 20.h,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Face Recognition',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Face outline
        Center(
          child: Container(
            width: 350.w,
            height: 350.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        // Bottom text
        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Position your face within the frame',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountdown() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.2),
          child: Text(
            '$_countdown',
            style: TextStyle(
              fontSize: 80.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProcessingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: Colors.white,
        ),
        SizedBox(height: 20.h),
        Text(
          'Processing...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
