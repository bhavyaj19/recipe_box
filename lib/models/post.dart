class Post {
  final String title;
  final String description;
  // final String photoUrl;
  final String uid;
  final String postId;

  const Post(
      {required this.title,
      required this.description,
      // required this.photoUrl,
      required this.uid,
      required this.postId});
  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        // "photoUrl": photoUrl,
        "uid": uid,
        "postId": postId,
      };
}
