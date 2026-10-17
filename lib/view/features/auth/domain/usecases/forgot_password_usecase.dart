import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<Result<String>, String> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Result<String>> call(String email) {
    return repository.forgotPassword(email);
  }
}

