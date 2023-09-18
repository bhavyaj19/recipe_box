import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_box/models/post.dart';
import 'package:recipe_box/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
