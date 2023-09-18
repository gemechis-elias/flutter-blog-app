import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/user/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRemoteDataSource {
  Future<void> registerUser(Map<String, dynamic> userData);
  Future<Map<String, dynamic>> loginUser(Map<String, dynamic> loginData);
  Future<User> getUser();
  Future<User> updateProfilePhoto(File userData);
}

abstract class UserLocalDataSource {
  Future<void> saveUserData(User user);
  Future<User?> getUserData();
  Future<void> clearUserData();
}
