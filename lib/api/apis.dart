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
    final user = userCredential.user;
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
            await registerCourses();
            await addAttendanceToFilteredStudents(
                session, semester, course, newAttendance);
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

  static Future<List<UserData>> getAllStudents() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore.collection('students').get();

      List<UserData> students = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserData.fromJson(data); // Assuming you have a Student class
      }).toList();

      return students;
    } catch (error) {
      throw ('Error getting students: $error');
    }
  }

  static Future<void> addAttendanceToFilteredStudents(
    Session session,
    Semester semester,
    Course course,
    Attendance newAttendance,
  ) async {
    try {
      // Fetch the filtered students
      List<UserData> filteredStudents =
          await getFilteredStudents(session, semester, course);

      // Update attendance for each student
      for (UserData student in filteredStudents) {
        // Find the target session
        int sessionIndex = student.sessions.indexWhere(
          (userSession) => userSession.sessionYear == session.sessionYear,
        );

        if (sessionIndex != -1) {
          // Find the target semester
          int semesterIndex =
              student.sessions[sessionIndex].semesters.indexWhere(
            (userSemester) =>
                userSemester.semesterNumber == semester.semesterNumber,
          );

          if (semesterIndex != -1) {
            // Find the target course
            int courseIndex = student
                .sessions[sessionIndex].semesters[semesterIndex].courses
                .indexWhere(
              (userCourse) => userCourse.courseId == course.courseId,
            );

            if (courseIndex != -1) {
              // Add the newAttendance to the target course in the student's data
              student.sessions[sessionIndex].semesters[semesterIndex]
                  .courses[courseIndex].attendanceList
                  .add(newAttendance);
            }
          }
        }
      }

      // Save the modified attendance back to Firestore for each student
      for (UserData student in filteredStudents) {
        await updateUsersRecord(
            user_model.UserType.student, student.studentId, student);
      }

      print('Attendance added to filtered students');
    } catch (error) {
      throw ('Error adding attendance to filtered students: $error');
    }
  }

  static updateUsersRecord(
      user_model.UserType type, String id, UserData record) async {
    String userType = type.name.toLowerCase();

    // Reference to the user's document in the records collection
    DocumentReference userDocRef = firestore
        .collection('records')
        .doc(userType)
        .collection(userType == 'staff' ? 'staffs' : 'students')
        .doc(id);

    await userDocRef.set({'academicRecords': record.toJson()});
  }

  static Future<List<UserData>> getFilteredStudents(
    Session session,
    Semester semester,
    Course course,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore.collection('students').get();

      List<UserData> students = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserData.fromJson(data); // Assuming you have a Student class
      }).where((student) {
        // Replace the conditions with your logic
        return isStudentEnrolled(student, session, semester) &&
            student.sessions.any((s) => s.semesters.any((sem) =>
                sem.courses.any((c) => c.courseId == course.courseId)));
      }).toList();

      return students;
    } catch (error) {
      throw ('Error getting students: $error');
    }
  }

  static bool isStudentEnrolled(
    UserData student,
    Session session,
    Semester semester,
  ) {
    // Replace this with your logic to check if the student is enrolled
    return student.sessions.any((s) =>
        s.sessionYear == session.sessionYear &&
        s.semesters.any((sem) =>
            sem.semesterNumber == semester.semesterNumber &&
            sem.courses.any((c) => studentIsEnrolledInCourse(student, c))));
  }

  static bool studentIsEnrolledInCourse(UserData student, Course course) {
    // Replace this with your logic to check if the student is enrolled in the course
    return course.attendanceList.any((attendance) => student.sessions.any((s) =>
        s.semesters.any(
            (sem) => sem.courses.any((c) => c.courseId == course.courseId))));
  }

  static Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    return await Geolocator.getCurrentPosition();
  }
}
