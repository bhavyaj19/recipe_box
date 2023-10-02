import 'package:flutter/material.dart';
import 'package:recipe_box/screens/add_a_post.dart';
import 'package:recipe_box/screens/feed_screen.dart';
import 'package:recipe_box/screens/profile_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const AddPostScreen(),
  const ProfileScreen(),
];
