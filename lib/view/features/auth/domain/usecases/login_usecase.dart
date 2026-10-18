import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/auth/data/models/login_response.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<Result<LoginData>, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Result<LoginData>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
