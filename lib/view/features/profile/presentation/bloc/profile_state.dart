part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  final EmployeeProfile employee;

  const ProfileLoaded(this.employee);

  @override
  List<Object?> get props => [employee];
}

final class ProfileSuccess extends ProfileState {
  final EmployeeProfile employee;
  final String message;

  const ProfileSuccess({
    required this.employee,
    required this.message,
  });

  @override
  List<Object?> get props => [employee, message];
}

final class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class ProfileDeleting extends ProfileState {
  const ProfileDeleting();
}

final class ProfileDeleteSuccess extends ProfileState {
  final String message;

  const ProfileDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class ProfileDeleteFailure extends ProfileState {
  final String message;

  const ProfileDeleteFailure(this.message);

  @override
  List<Object?> get props => [message];
}

