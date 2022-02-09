class NewUserEvent {}

class ChangeNewUserName extends NewUserEvent{
  ChangeNewUserName({required this.username});
  String username;
}

class AddNewUser extends NewUserEvent {}