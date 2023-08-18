import 'package:flutter/material.dart';
import 'package:recipe_box/screens/feed_screen.dart';
import 'package:recipe_box/screens/profile_screen.dart';
import 'package:recipe_box/screens/saved_screen.dart';
import 'package:recipe_box/screens/search_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const SavedScreen(),
  const ProfileScreen(),
];
