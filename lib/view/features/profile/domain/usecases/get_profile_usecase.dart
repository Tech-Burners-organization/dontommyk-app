import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase implements UseCase<Result<EmployeeProfile>, NoParams> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Result<EmployeeProfile>> call(NoParams params) {
    return repository.getProfile();
  }
}

