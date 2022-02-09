import 'package:flutter_code_example/models/user.dart';

class UserEvent {}

class InitUserList extends UserEvent {}

class DeleteUser extends UserEvent {
  DeleteUser({required this.user});
  User user;
}

class UpdateUserList extends UserEvent {}