import 'package:flutter_code_example/api/user_api.dart';
import 'package:flutter_code_example/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserRepository {
  UserRepository() {
    init();
  }

  final UserAPI _userAPI = UserAPI();
  List<User> currentUserList = [];

  Future<void> init() async {
    currentUserList = await _getUserListFromCache();
  }

  Future<User?> getUser(int id) async {
    return await _userAPI.getUserById(id);
  }

  Stream<List<User>> getUserList() async* {
    yield currentUserList;
    currentUserList = await _userAPI.getUserList();
    yield currentUserList;
    _saveUserListToCache(currentUserList);
  }

  Future<User> addNewUser(String name) async {
    User user = await _userAPI.addUser(name);
    currentUserList.add(user);
    await _addUserToCache(user);
    return user;
  }

  Future<User> deleteUser(User user) async {
    await _userAPI.deleteUser(user);
    currentUserList.remove(user);
    await _removeUserFromCache(user);
    return user;
  }

  Future<List<User>> _getUserListFromCache() async {
    FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
    String? userList = await flutterSecureStorage.read(key: 'user_list');

    if (userList != null) {
      return (json.decode(userList) as List)
        .map((i) => User.fromJson(i))
        .toList();
    } else {
      return [];
    }
  }

  Future<void> _saveUserListToCache(List<User> userList) async {
    FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

    flutterSecureStorage.write(key: 'user_list', value: json.encode(userList.map((e) => e.toJson()).toList()));
  }

  Future<void> _addUserToCache(User user) async {
    List<User> userList = await _getUserListFromCache();
    userList.add(user);
    await _saveUserListToCache(userList);
  }

  Future<void> _removeUserFromCache(User user) async {
    List<User> userList = await _getUserListFromCache();
    userList.remove(user);
    await _saveUserListToCache(userList);
  }
}