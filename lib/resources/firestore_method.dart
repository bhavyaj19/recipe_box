import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_box/models/post.dart';
import 'package:recipe_box/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserUsername(String oldUsername, String newUsername) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // bool isUsernameAvailable = await checkUsernameAvailability(newUsername);
      List<String> postId = await getDocumentIdsByUsername(oldUsername);
      if (user != null) {
        for (String i in postId) {
          await FirebaseFirestore.instance
              .collection('posts')
              .doc(i)
              .update({'username': newUsername});
        }
        print("success");
      } else {
        print("error in updating username");
      }
    } catch (e) {
      print("error $e");
    }
  }

  // checking username availability
  Future<List<String>> getDocumentIdsByUsername(String givenUsername) async {
    List<String> postId = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts') // Replace with your collection name
          .where('username', isEqualTo: givenUsername)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        postId.add(doc.id);
      }
    } catch (error) {
      print('Error fetching document IDs: $error');
    }
    print(postId.length);
    return postId;
  }

  Future<String> uploadPost(
    String title,
    String description,
    String uid,
    String username,
    Uint8List file,
  ) async {
    String res = "Some error Occured";
    try {
      String photoUrl =
          await StorageMethod().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

      Post post = Post(
        title: title,
        description: description,
        uid: uid,
        postId: postId,
        photoUrl: photoUrl,
        datePublished: DateTime.now(),
        username: username,
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    print(res);
    return res;
  }
}
