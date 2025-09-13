import 'package:noviindus_task/domain/entities/user.dart';

class UserModel {
  final String username;
  final String token;

  UserModel({required this.username, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json, {String? getUsername}) {
    String token = '';

    print(json);
    //assumption values since api is giving error
    if (json.containsKey('token'))
      token = json['token'].toString();
    else if (json.containsKey('access_token'))
      token = json['access_token'].toString();
    else if (json['data'] != null && json['data']['token'] != null)
      token = json['data']['token'].toString();

    final username = json['username']?.toString() ?? getUsername ?? '';

    return UserModel(username: username, token: token);
  }

  Map<String, dynamic> toJson() => {'username': username, 'token': token};

  User toEntity() => User(username: username, token: token);
}
