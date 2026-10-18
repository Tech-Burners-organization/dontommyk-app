import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/auth/data/models/login_response.dart';
import 'package:tommy/view/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/login_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/verify_email_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final ChangePasswordUseCase? changePasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyEmailUseCase,
    required this.resendOtpUseCase,
    required this.resetPasswordUseCase,
    this.changePasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
    on<VerifyEmailSubmitted>(_onVerifyEmailSubmitted);
    on<ResendOtpSubmitted>(_onResendOtpSubmitted);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
  }

  Future<void> _onChangePasswordSubmitted(
    ChangePasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (changePasswordUseCase == null) return;
    emit(AuthLoading());
    final result = await changePasswordUseCase!(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      ),
    );

    switch (result) {
      case ResultSuccess(data: final message):
        emit(ChangePasswordSuccess(message));
      case ResultFailure(failure: final failure):
        emit(AuthFailure(failure.message));
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    switch (result) {
      case ResultSuccess(data: final loginData):
        emit(AuthSuccess(loginData));
      case ResultFailure(failure: final failure):
        emit(AuthFailure(failure.message));
    }
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await forgotPasswordUseCase(event.email);

    switch (result) {
      case ResultSuccess(data: final message):
        emit(ForgotPasswordSuccess(message));
      case ResultFailure(failure: final failure):
        emit(AuthFailure(failure.message));
    }
  }

  Future<void> _onVerifyEmailSubmitted(
    VerifyEmailSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyEmailUseCase(
      VerifyEmailParams(email: event.email, otp: event.otp),
    );

    switch (result) {
      case ResultSuccess(data: final token):
        emit(VerifyEmailSuccess(
          token: token,
          message: 'Email verified successfully',
        ));
      case ResultFailure(failure: final failure):
        emit(AuthFailure(failure.message));
    }
  }

  Future<void> _onResendOtpSubmitted(
    ResendOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resendOtpUseCase(event.email);

    switch (result) {
      case ResultSuccess(data: final message):
        emit(ResendOtpSuccess(message));
      case ResultFailure(failure: final failure):
        emit(AuthFailure(failure.message));
    }
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(
      ResetPasswordParams(
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
        token: event.token,
      ),
    );

    switch (result) {
      case ResultSuccess(data: final message):
        emit(ResetPasswordSuccess(message));
      case ResultFailure(failure: final failure):
        emit(AuthFailure(failure.message));
    }
  }
}
