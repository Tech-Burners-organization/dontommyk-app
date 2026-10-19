import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String designation;
  final int? age;
  final String? location;
  final String? imagePath;
  final String? token;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.designation,
    this.age,
    this.location,
    this.imagePath,
    this.token,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    designation,
    age,
    location,
    imagePath,
    token,
  ];
}

class UpdateProfileUseCase
    implements UseCase<Result<EmployeeProfile>, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Result<EmployeeProfile>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      designation: params.designation,
      age: params.age,
      location: params.location,
      imagePath: params.imagePath,
      token: params.token,
    );
  }
}

