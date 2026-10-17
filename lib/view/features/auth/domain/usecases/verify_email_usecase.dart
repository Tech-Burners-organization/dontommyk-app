import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailParams extends Equatable {
  final String email;
  final String otp;

  const VerifyEmailParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class VerifyEmailUseCase implements UseCase<Result<String>, VerifyEmailParams> {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  @override
  Future<Result<String>> call(VerifyEmailParams params) {
    return repository.verifyEmail(params.email, params.otp);
  }
}

