import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/profile/data/models/legal_content_model.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';

class GetLegalContentUseCase
    implements UseCase<Result<LegalContentModel>, String> {
  final ProfileRepository repository;

  GetLegalContentUseCase(this.repository);

  @override
  Future<Result<LegalContentModel>> call(String slug) {
    return repository.getLegalContent(slug);
  }
}

