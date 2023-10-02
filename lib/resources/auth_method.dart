import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_box/models/user.dart' as model;

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  updateUserUsername
  Future<void> updateUserUsername(String newUsername) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      bool isUsernameAvailable = await checkUsernameAvailability(newUsername);
      if (user != null && isUsernameAvailable) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'username': newUsername});
        print("success");
      } else {
        print("error in updating username");
      }
    } catch (e) {
      print("error $e");
    }
  }

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // checking username availability
  Future<bool> checkUsernameAvailability(String username) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  // signUp function
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
          print(cred.user!.uid);
          print("adding user to firestore");
          model.User user = model.User(
              email: email,
              uid: cred.user!.uid,
              // photoUrl: photoUrl,
              username: username,
              followers: [],
              following: []);
          await _firestore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());
          return cred.user!.uid;
        } catch (err) {
          print("An error occured while trying to send email");
          print(err);
        }

        res = "success";
      }
    } catch (err) {
      res = err.toString();
      print("error occured to create user by bhavya");
    }
    return res;
  }

  // login functionality
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
