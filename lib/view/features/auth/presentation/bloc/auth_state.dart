part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final LoginData loginData;

  const AuthSuccess(this.loginData);

  @override
  List<Object?> get props => [loginData];
}

final class AuthNeedsVerification extends AuthState {
  final String email;
  final String message;

  const AuthNeedsVerification({
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [email, message];
}

final class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class VerifyEmailSuccess extends AuthState {
  final String token;
  final String message;

  const VerifyEmailSuccess({required this.token, required this.message});

  @override
  List<Object?> get props => [token, message];
}

final class ResendOtpSuccess extends AuthState {
  final String message;

  const ResendOtpSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class ChangePasswordSuccess extends AuthState {
  final String message;

  const ChangePasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
