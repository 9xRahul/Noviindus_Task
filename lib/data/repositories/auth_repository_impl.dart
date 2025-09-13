
import 'package:noviindus_task/core/storage_helper.dart';
import 'package:noviindus_task/data/data_sources/auth_remote_data_sourse.dart';
import 'package:noviindus_task/data/models/UserModel.dart';

import 'package:noviindus_task/domain/entities/user.dart';
import 'package:noviindus_task/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final StorageHelper storage;

  AuthRepositoryImpl(this.remote, this.storage);

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    print(username);
    print(password);
    final json = await remote.login(username, password);

    final userModel = UserModel.fromJson(json, getUsername: username);

    if (userModel.token.isEmpty) {
      throw Exception('Token not found in login response');
    }

    await storage.saveToken(userModel.token, userModel.username);

    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await storage.clearToken();
  }

  @override
  Future<String?> getToken() async {
    return storage.getToken();
  }
}
