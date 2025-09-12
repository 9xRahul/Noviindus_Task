import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { unknown, loading, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final LoginUsecase loginUsecase;
  final AuthRepository authRepository;

  User? user;
  AuthStatus status = AuthStatus.unknown;
  String? errorMessage;

  AuthProvider({required this.loginUsecase, required this.authRepository});

  Future<void> tryAutoLogin() async {
    final token = await authRepository.getToken();

    await Future.delayed(const Duration(seconds: 2));
    if (token != null && token.isNotEmpty) {
      user = User(username: 'unknown', token: token);
      status = AuthStatus.authenticated;
    } else {
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    
    // notifyListeners();

    try {
      final u = await loginUsecase.call(username, password);
      user = u;
      status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = "LoginFaild";
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
