part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class ForgotPasswordSubmitted extends AuthEvent {
  final String email;

  const ForgotPasswordSubmitted({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyEmailSubmitted extends AuthEvent {
  final String email;
  final String otp;

  const VerifyEmailSubmitted({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class ResendOtpSubmitted extends AuthEvent {
  final String email;

  const ResendOtpSubmitted({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordSubmitted extends AuthEvent {
  final String newPassword;
  final String confirmPassword;
  final String? token;

  const ResetPasswordSubmitted({
    required this.newPassword,
    required this.confirmPassword,
    this.token,
  });

  @override
  List<Object?> get props => [newPassword, confirmPassword, token];
}
