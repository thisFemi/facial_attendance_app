// ignore_for_file: use_build_context_synchronously

import 'package:attend_sense/widgets/custom_appBar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';
import '../../utils/colors.dart';
import '../../utils/dialogs.dart';

class AttendanceCapture extends StatefulWidget {
  AttendanceCapture(
      {required this.session,
      required this.attendance,
      required this.course,
      required this.semester});
  Session session;
  Semester semester;
  Course course;
  Attendance attendance;

  @override
  _AttendanceCaptureState createState() => _AttendanceCaptureState();
}

class _AttendanceCaptureState extends State<AttendanceCapture> {
  late CameraController? _controller;
  late Future<void>? _initializeControllerFuture;
  bool isCaptured = false;
  late XFile? capturedImage;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;

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
              child: isCaptured ? _buildCapturedImage() : _buildCameraPreview(),
            ),
            const SizedBox(height: 16.0),
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
                        child: _isLoading
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            onPressed: _recaptureImage,
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.black,
                            ),
                            child: _isLoading
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
                            onPressed: () async {
                              await verifyandMarkAttendance(
                                  File(capturedImage!.path));
                              // Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.green,
                            ),
                            child: const Text(
                                    'Mark Attendance',
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

  bool _isVerifyLoading = false;

  Widget _buildCameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller!);
        } else {
          return const Center(child: CircularProgressIndicator());
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

  Future<void> verifyandMarkAttendance(
    File file,
  ) async {
    try {
      Dialogs.showProgressBar(context);
      DetectionStatus result = await APIs.sendRecognitionRequest(file);
      print("result is ${result.name}");
      if (result == DetectionStatus.success) {
        StudentData newStudent = StudentData(
            studentId: APIs.userInfo.id,
            matricNumber: APIs.userInfo.userInfo!.matricNumber,
            studentName: APIs.userInfo.name,
            isEligible: true,
            isPresent: true);

        await APIs.updateStudentAttendanceAndLecturerList(
            APIs.academicRecords!,
            widget.session,
            widget.semester,
            widget.course,
            widget.attendance,
            true,
            newStudent);
        Navigator.pop(context);
        Dialogs.showSuccessDialog(context, "Successful",
            "Your attendance has been recorded", "Continue", () {
          Navigator.pop(context);
        });
        Navigator.pop(context);
      } else if (result == DetectionStatus.fail) {
        Navigator.pop(context);
        Dialogs.showSnackbar(
            context, "Face not recognized, you can try again".toString());
      } else if (result == DetectionStatus.noFace) {
       
        Navigator.pop(context);
        Dialogs.showSnackbar(
            context, "No human face detected, try again".toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Dialogs.showSnackbar(context, error.toString());
    }
  }
}
