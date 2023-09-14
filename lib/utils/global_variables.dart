import 'package:flutter/material.dart';
import 'package:recipe_box/screens/add_a_post.dart';
import 'package:recipe_box/screens/feed_screen.dart';
import 'package:recipe_box/screens/profile_screen.dart';
import 'package:recipe_box/screens/saved_screen.dart';
import 'package:recipe_box/screens/search_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const SavedScreen(),
  const ProfileScreen(),
];
