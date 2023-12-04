import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/attendance_models.dart';
import '../models/dummy.dart';
import '../models/dummy.dart';
import '../models/dummy.dart';
import '../models/user_model.dart' as user_model;

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
//auth

  static Future<void> login(String email, String password) async {
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      await fetchUserDataFromFirestore(userCredential);
      // if (userCredential.user!.emailVerified) {
      //   fetchUserDataFromFirestore(userCredential);
      // } else {
      //   throw 'Email not yet verified, check your mail';
      // }
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      print('Registration error: $e');
      if (e.code == 'unknown') {
        throw (' kindly check your internet connection');
      }
      throw (' ${e.message}');
    } catch (error) {
      throw (' ${error.toString()}');
    }
  }

  static late user_model.User userInfo;
  static UserData? academicRecords;
  static Future<void> fetchUserDataFromFirestore(
      UserCredential userCredential) async {
    final User? user = userCredential.user;
    final String userUID = user!.uid;

    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(userUID).get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      print(userData);
      final user_model.User userDataInfo = user_model.User.fromJson(userData);
      userInfo = userDataInfo;
      // academicRecords = DUMMY.dummyAcademicRecords.last;
      print("done");
    } else {
      throw "User Details not found, kindly contact support.";
    }

    //
  }

  static Future<void> register(String name, String email, String password,
      user_model.UserType userType) async {
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      final String userUID = userCredential.user!.uid;
      final Map<String, dynamic> userData = {
        'name': name,
        'email': email,
        'id': userUID,
        'userType': userType.toStringValue(),
        'phoneNumber': "",
        'userInfo': userType == user_model.UserType.student
            ? {"imgUrl": "", "matricNumber": ""}
            : null
      };
      await firestore.collection('users').doc(userUID).set(userData);
      final user_model.User userDataInfo = user_model.User.fromJson(userData);
      userInfo = userDataInfo;
      // academicRecords = DUMMY.dummyAcademicRecords.last;
      print("print registration done !");
      //  Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (_) => DashboardScreen()),
      //       (Route<dynamic> route) => false,
      // );
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      print('Registration error: $e');
      if (e.code == 'unknown') {
        throw ('Registration failed, kindly check your internet connection');
      } else {
        throw ('Registration failed, ${e.message}');
      }
    } catch (error) {
      print(error);
      throw ('Registration failed, $error');
    }
  }

//courses
  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchAcademicData() {
    String userType = userInfo.userType.name.toLowerCase();

    // Reference to the user's document in the records collection
    return firestore
        .collection('records')
        .doc(userType)
        .collection(userType == 'staff' ? 'staffs' : 'students')
        .doc(userInfo.id)
        .snapshots();
  }

  static Future<void> removeStudent(
    StudentData student,
    String sessionYear,
    int semesterNumber,
    String courseId,
    String lecturerId, // Add the lecturerId parameter
  ) async {
    try {
      // Reference to the session document
      DocumentReference sessionRef =
          firestore.collection('sessions').doc(sessionYear);

      // Update the attendance list for the specified session, semester, and course
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot sessionSnapshot = await transaction.get(sessionRef);
        if (!sessionSnapshot.exists) {
          // Session not found
          throw "Session not found";
        }

        // Get the data
        Map<String, dynamic> sessionData =
            sessionSnapshot.data() as Map<String, dynamic>;
        List<dynamic> semesters = sessionData['semesters'];

        // Find the target semester
        Map<String, dynamic>? targetSemester;
        for (var semester in semesters) {
          if (semester['semesterNumber'] == semesterNumber) {
            targetSemester = semester;
            break;
          }
        }

        if (targetSemester == null) {
          // Semester not found
          throw "Semester not found";
        }

        // Find the target course
        List<dynamic>? courses = targetSemester['courses'];
        Map<String, dynamic>? targetCourse;
        for (var course in courses!) {
          if (course['courseId'] == courseId) {
            targetCourse = course;
            break;
          }
        }

        if (targetCourse == null) {
          // Course not found
          throw "Course not found";
        }

        // Check if the lecturerId matches the one who created the attendance
        if (targetCourse['lecturerId'] != lecturerId) {
          // Lecturer mismatch, cannot remove the student
          throw "Unable to complete action";
        }

        // Remove the student from the attendance list
        List<dynamic>? attendanceList = targetCourse['attendanceList'];
        for (var attendance in attendanceList!) {
          List<dynamic>? students = attendance['students'];
          students?.removeWhere((s) => s['studentId'] == student.studentId);
        }

        // Update Firestore with the modified data
        transaction.update(sessionRef, {'semesters': semesters});
      });
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> registerCourses() async {
    try {
      // Reference to the user's document in the records collection
      String userType = userInfo.userType.name.toLowerCase();

      // Reference to the user's document in the records collection
      DocumentReference userDocRef = firestore
          .collection('records')
          .doc(userType)
          .collection(userType == 'staff' ? 'staffs' : 'students')
          .doc(userInfo.id);

      await userDocRef.set({'academicRecords': academicRecords!.toJson()});

      print("Course registration added for a new user");

      // Get the user's document
    } catch (error) {
      // Handle errors
      print('Error registering courses: $error');
      rethrow;
    }
  }

//
//attendance
  static Future<void> addAttendanceToAcademicRecords(Session session,
      Semester semester, Course course, Attendance newAttendance) async {
    // Ensure academicRecords is not null
    if (academicRecords != null) {
      // Create a copy of academicRecords
      UserData updatedAcademicRecords = academicRecords!;

      // Find the target session
      int sessionIndex = updatedAcademicRecords.sessions.indexWhere(
        (userSession) => userSession.sessionYear == session.sessionYear,
      );

      if (sessionIndex != -1) {
        // Find the target semester
        int semesterIndex =
            updatedAcademicRecords.sessions[sessionIndex].semesters.indexWhere(
          (userSemester) =>
              userSemester.semesterNumber == semester.semesterNumber,
        );

        if (semesterIndex != -1) {
          // Find the target course
          int courseIndex = updatedAcademicRecords
              .sessions[sessionIndex].semesters[semesterIndex].courses
              .indexWhere(
            (userCourse) => userCourse.courseId == course.courseId,
          );

          if (courseIndex != -1) {
            // Add the newAttendance to the target course in the copied data
            updatedAcademicRecords.sessions[sessionIndex]
                .semesters[semesterIndex].courses[courseIndex].attendanceList
                .add(newAttendance);

            // Update the original academicRecords with the modified copy
            academicRecords = updatedAcademicRecords;

            print("Attendance added to academicRecords");
          } else {
            throw ("Course not found in academicRecords");
          }
        } else {
          throw ("Semester not found in academicRecords");
        }
      } else {
        throw ("Session not found in academicRecords");
      }
    } else {
      throw ("academicRecords is null");
    }
  }

  static Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      throw Exception('Error');
    }
    return await Geolocator.getCurrentPosition();
  }
}
