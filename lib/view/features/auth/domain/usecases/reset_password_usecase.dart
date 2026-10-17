import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordParams extends Equatable {
  final String newPassword;
  final String confirmPassword;
  final String? token;

  const ResetPasswordParams({
    required this.newPassword,
    required this.confirmPassword,
    this.token,
  });

  @override
  List<Object?> get props => [newPassword, confirmPassword, token];
}

class ResetPasswordUseCase implements UseCase<Result<String>, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Result<String>> call(ResetPasswordParams params) {
    return repository.resetPassword(
      params.newPassword,
      params.confirmPassword,
      token: params.token,
    );
  }
}

