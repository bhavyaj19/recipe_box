import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_box/models/user.dart' as model;

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkUsernameAvailability(String username) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    // required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        bool isUsernameAvailable = await checkUsernameAvailability(username);
        if (!isUsernameAvailable) {
          res = "Username is already taken";
          return res;
        }
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        try {
          await cred.user!.sendEmailVerification();
          return cred.user!.uid;
        } catch (err) {
          print("An error occured while trying to send email");
          print(err);
        }

        print(cred.user!.uid);
        // String photoUrl = await StorageMethod()
        //     .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            email: email,
            uid: cred.user!.uid,
            // photoUrl: photoUrl,
            username: username,
            followers: [],
            following: []);
        // await _firestore
        //     .collection('newusers')
        //     .doc(cred.user!.uid)
        //     .set(user.toJson());
        await _firestore.collection('newusers').add(user.toJson());
        res = "success";
      }
    } catch (err) {
      res = err.toString();
      print("error occured to create user by bhavya");
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          res = "success";
        } else if (!(FirebaseAuth.instance.currentUser!.emailVerified)) {
          res = "verify your email first";
        }
      } else {
        res = "Enter all feilds";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
