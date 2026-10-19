import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/ai_coach/domain/repositories/ai_coach_repository.dart';

class DeleteAiConversationUseCase implements UseCase<Result<void>, String> {
  final AiCoachRepository repository;

  DeleteAiConversationUseCase(this.repository);

  @override
  Future<Result<void>> call(String conversationId) {
    return repository.deleteConversation(conversationId);
  }
}

