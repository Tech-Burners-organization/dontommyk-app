import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/domain/usecases/update_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({required this.updateProfileUseCase})
      : super(const ProfileInitial()) {
    on<UpdateProfileSubmitted>(_onUpdateProfileSubmitted);
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
}

