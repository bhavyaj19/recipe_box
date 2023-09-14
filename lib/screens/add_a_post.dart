// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_box/models/user.dart' as model;
import 'package:recipe_box/providers/user_provider.dart';
import 'package:recipe_box/resources/firestore_method.dart';
import 'package:recipe_box/screens/main_screen.dart';
import 'package:recipe_box/utils/utils.dart';
import 'package:recipe_box/widgets/text_feild_input.dart';

class AddPostScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AddPostScreen({Key? key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPosting = false; // To track whether the post is being uploaded.

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    
  }

  Future<void> postImage(String uid, String username) async {
    setState(() {
      _isPosting = true; // Start showing the progress indicator.
    });

    try {
      String res = await FirestoreMethod().uploadPost(
        _titleController.text,
        _descriptionController.text,
        uid,
        _file!,
      );

      if (res == "success") {
        showSnackBar(context, "Posted");
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setState(() {
        _isPosting = false; // Stop showing the progress indicator.
      });

      // Navigate back to the starting screen of AddPostScreen.
      Navigator.of(context).pop(); // Close the dialog.
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const TabScreen(),
        ),
      ); // Navigate back to the home screen.
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create a post"),
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text("Take a Photo"),
              onTap: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Create Post"),
        centerTitle: true,
        actions: [
          Visibility(
            visible: _file != null && !_isPosting,
            child: IconButton(
              icon: const Icon(Icons.check_circle_outline_rounded),
              onPressed: () async {
                postImage(
                  user!.uid,
                  user.username,
                );
                await showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevent dismissing the dialog on tap.
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _file == null
              ? Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectImage(context),
                    icon: const Icon(Icons.image_outlined),
                    label: const Text("Select an Image"),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AspectRatio(
                          aspectRatio: 200 / 200,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFeildInput(
                            textEditingController: _titleController,
                            hintText: "Enter Title",
                            textInputType: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFeildInput(
                            textEditingController: _descriptionController,
                            hintText: "Enter Description...",
                            textInputType: TextInputType.multiline,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
