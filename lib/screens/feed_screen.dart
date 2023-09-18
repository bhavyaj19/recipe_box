import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_box/models/user.dart' as model;
import 'package:recipe_box/providers/user_provider.dart';
import 'package:recipe_box/screens/detailed_post.dart';
import 'package:recipe_box/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "CookBook",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: const [
          CircleAvatar(
            backgroundColor: Color(0xFF4a4458),
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailedScreen(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ),
                );
              },
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
      //  const PostCard(
      //   image:
      //       // 'https://media.istockphoto.com/id/1180155588/vector/vector-design-template-for-business-team-work-abstract-icon.jpg?s=2048x2048&w=is&k=20&c=sseNt72GZDevGR51n1sESHMnnJ13nFvAGgKpunA_-I0=',
      //       'https://images.pexels.com/photos/12601624/pexels-photo-12601624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      // ),
    );
  }
}
