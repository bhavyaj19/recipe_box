import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String description;
  final String photoUrl;
  final String uid;
  final String postId;
  final String username;
  final datePublished;

  const Post({
    required this.username,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.uid,
    required this.postId,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "photoUrl": photoUrl,
        "uid": uid,
        "postId": postId,
        "datePublished": datePublished,
        "username": username,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        title: snapshot['title'],
        description: snapshot['description'],
        uid: snapshot['uid'],
        photoUrl: snapshot['photoUrl'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        username: snapshot['username']);
  }
}
