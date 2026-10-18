import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:tommy/view/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:tommy/view/features/profile/domain/usecases/update_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final GetProfileUseCase? getProfileUseCase;
  final DeleteAccountUseCase? deleteAccountUseCase;

  ProfileBloc({
    required this.updateProfileUseCase,
    this.getProfileUseCase,
    this.deleteAccountUseCase,
  }) : super(const ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<UpdateProfileSubmitted>(_onUpdateProfileSubmitted);
    on<DeleteAccountSubmitted>(_onDeleteAccountSubmitted);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (getProfileUseCase == null) return;
    emit(const ProfileLoading());

    final result = await getProfileUseCase!(const NoParams());

    switch (result) {
      case ResultSuccess(data: final profile):
        emit(ProfileLoaded(profile));
      case ResultFailure(failure: final failure):
        emit(ProfileFailure(failure.message));
    }
  }

  Future<void> _onUpdateProfileSubmitted(
    UpdateProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await updateProfileUseCase(
      UpdateProfileParams(
        firstName: event.firstName,
        lastName: event.lastName,
        designation: event.designation,
        age: event.age,
        location: event.location,
        imagePath: event.imagePath,
      ),
    );

    switch (result) {
      case ResultSuccess(data: final profile):
        emit(ProfileSuccess(
          employee: profile,
          message: 'Employee updated successfully',
        ));
      case ResultFailure(failure: final failure):
        emit(ProfileFailure(failure.message));
    }
  }

  Future<void> _onDeleteAccountSubmitted(
    DeleteAccountSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    if (deleteAccountUseCase == null) return;
    emit(const ProfileDeleting());

    final result = await deleteAccountUseCase!(const NoParams());

    switch (result) {
      case ResultSuccess(data: final message):
        emit(ProfileDeleteSuccess(message));
      case ResultFailure(failure: final failure):
        emit(ProfileDeleteFailure(failure.message));
    }
  }
}

