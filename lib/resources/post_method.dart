import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_box/models/post.dart';
import 'package:uuid/uuid.dart';

class PostMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String title,
    String description,
    String uid,
  ) async {
    String res = "Some error Occured";
    try {
      String postId = const Uuid().v1();

      Post post = Post(
          title: title, description: description, uid: uid, postId: postId);

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    print(res);
    return res;
  }
}
