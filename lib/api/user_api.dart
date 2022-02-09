import 'package:dio/dio.dart';
import 'package:flutter_code_example/models/user.dart';

class UserAPI {
  static const String _baseUrl = 'https://api-test.ru/api';

  Future<User> addUser(String name) async {
    String path = '/users/';

    Response response = await Dio().post(
      _baseUrl + path, 
      data: {
        'name': name
      }
    );

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw(Exception);
    }
  }

  Future<User> deleteUser(User user) async {
    String path = '/users/${user.id}';

    Response response = await Dio().delete(
      _baseUrl + path, 
      data: {
        'name': user.name
      }
    );

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw(Exception);
    }
  }

  Future<User> getUserById(int id) async {
    String path = '/users/$id';

    Response response = await Dio().get(_baseUrl + path);

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw(Exception);
    }
  }

  Future<List<User>> getUserList() async {
    String path = '/users';

    Response response = await Dio().get(_baseUrl + path);

    if (response.statusCode == 200) {
      List<User> userlist = (response.data as List)
        .map((i) {return User.fromJson(i);})
        .toList();
      return userlist;
    } else {
      throw(Exception);
    }
  }
}