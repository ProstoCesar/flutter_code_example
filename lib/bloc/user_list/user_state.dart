import 'package:flutter_code_example/models/user.dart';

class UserState {}

class Loading extends UserState {}

class UserList extends UserState {
  UserList({required this.userList});

  List<User> userList;
}

class InitError extends UserState {
  InitError({required this.message});

  String message;
}