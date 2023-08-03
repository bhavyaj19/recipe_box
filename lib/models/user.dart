class User {
  final String email;
  final String uid;
  // final String photoUrl;
  final String username;
  final List followers;
  final List following;

  const User(
      {required this.email,
      required this.uid,
      // required this.photoUrl,
      required this.username,
      required this.followers,
      required this.following});
  Map<String, dynamic> toJson() => {
    "email": email,
    "uid": uid,
    // "photoUrl": photoUrl,
    "username": username,
    "followers": followers,
    "following": following,
  };
}
