import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;
  LoginUsecase(this.repository);

  Future<User> call(String username, String password) {
    return repository.login(username: username, password: password);
  }
  
}
