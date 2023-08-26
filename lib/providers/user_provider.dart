import 'package:flutter/material.dart';
import 'package:recipe_box/models/user.dart';
import 'package:recipe_box/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethod _authMethod = AuthMethod();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
