import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/attendance_models.dart';
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
      if (userCredential.user!.emailVerified) {
        fetchUserDataFromFirestore(userCredential);
      } else {
        throw 'Email not yet verified, check your mail';
      }
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
  static Future<void> fetchUserDataFromFirestore(
      UserCredential userCredential) async {
    final User? user = userCredential.user;
    final String userUID = user!.uid;

    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(userUID).get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      final user_model.User userDataInfo = user_model.User.fromJson(userData);
      userInfo = userDataInfo;
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
        'UserData': userType == user_model.UserType.student
            ? {"imgUrl": "", "matricNumber": ""}
            : null
      };
      await firestore.collection('users').doc(userUID).set(userData);
      final user_model.User userDataInfo = user_model.User.fromJson(userData);
      userInfo = userDataInfo;
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
      throw ('Registration failed, ${error}');
    }
  }

//courses
  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchAcademicData() {
    return firestore
        .collection(
            'yourFirestoreCollection') // Replace with your actual collection
        .doc('yourDocumentId') // Replace with your actual document ID
        .snapshots();
  }

  static Future<void> removeStudent(
    UserData student,
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
}
