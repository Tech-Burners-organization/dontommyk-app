import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';

class DeleteAccountUseCase implements UseCase<Result<String>, NoParams> {
  final ProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  @override
  Future<Result<String>> call(NoParams params) {
    return repository.deleteAccount();
  }
}

