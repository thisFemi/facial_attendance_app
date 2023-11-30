import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        'studentInfo': userType == user_model.UserType.student
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
  static  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchAcademicData() {
    return firestore
        .collection(
            'yourFirestoreCollection') // Replace with your actual collection
        .doc('yourDocumentId') // Replace with your actual document ID
        .snapshots();
  }
}
