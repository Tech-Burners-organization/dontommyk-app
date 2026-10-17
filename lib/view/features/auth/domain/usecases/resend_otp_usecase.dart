import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUseCase implements UseCase<Result<String>, String> {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  @override
  Future<Result<String>> call(String email) {
    return repository.resendOtp(email);
  }
}

