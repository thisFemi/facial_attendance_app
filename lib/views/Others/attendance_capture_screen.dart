import 'package:attend_sense/widgets/custom_appBar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';

import '../../utils/colors.dart';

class AttendanceCapture extends StatefulWidget {
  const AttendanceCapture({Key? key}) : super(key: key);

  @override
  _AttendanceCaptureState createState() => _AttendanceCaptureState();
}

class _AttendanceCaptureState extends State<AttendanceCapture> {
  late CameraController? _controller;
  late Future<void>? _initializeControllerFuture;
  bool isCaptured = false;
  late XFile? capturedImage;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture!;

      final XFile imageFile = await _controller!.takePicture();

      setState(() {
        isCaptured = true;
        capturedImage = imageFile;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        showArrowBack: true,
        title: "Facial Verification",
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildCameraPreview(),
            ),
            SizedBox(height: 16.0),
            if (isCaptured) _buildCapturedImage(),
            SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: isCaptured ? _recaptureImage : _captureImage,
            //   child: Text(isCaptured ? 'Recapture' : 'Capture'),
            // ),
            !isCaptured
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: SizedBox(
                      height: 50.0,
                      // width: Screen.deviceSize(context).width * 0.85,
                      child: TextButton(
                        onPressed: _captureImage,
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.black,
                        ),
                        child: !_isLoading
                            ? const SpinKitThreeBounce(
                                color: AppColors.offwhite, size: 40)
                            : const Text(
                                'Capture',
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'Raleway-SemiBold'),
                              ),
                      ),
                    ),
                  ))
                : Row(
                  mainAxisAlignment:MainAxisAlignment.center
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 40,
                        ),
                        child: SizedBox(
                          height: 50.0,
                          // width: Screen.deviceSize(context).width * 0.85,
                          child: TextButton(
                            onPressed:
                              _recaptureImage,
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.black,
                            ),
                            child: !_isLoading
                                ? const SpinKitThreeBounce(
                                    color: AppColors.offwhite, size: 40)
                                : const Text(
                                    'Recapture',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontFamily: 'Raleway-SemiBold'),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 40,
                        ),
                        child: SizedBox(
                          height: 50.0,
                          // width: Screen.deviceSize(context).width * 0.85,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.green,
                            ),
                            child: !_isLoading
                                ? const SpinKitThreeBounce(
                                    color: AppColors.offwhite, size: 40)
                                : const Text(
                                    'Verify',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontFamily: 'Raleway-SemiBold'),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller!);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCapturedImage() {
    return Expanded(
      child: capturedImage != null
          ? Image.file(File(capturedImage!.path))
          : Container(),
    );
  }

  void _recaptureImage() {
    setState(() {
      isCaptured = false;
    });
  }
}
