import 'package:flutter/material.dart';

class DetailedScreen extends StatelessWidget {
  const DetailedScreen({Key? key, required this.snap});

  final snap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Blog Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    snap['photoUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
      
              // Title
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Blog Title",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      
              // Username
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "By: ${snap['username']}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
      
              const SizedBox(height: 16), // Spacer
      
              // Blog Body
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et leo nec nisl facilisis volutpat.",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
