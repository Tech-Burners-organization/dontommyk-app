import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_conversation_model.dart';
import 'package:tommy/view/features/ai_coach/domain/repositories/ai_coach_repository.dart';

class GetAiConversationsUseCase
    implements UseCase<Result<List<AiConversationModel>>, NoParams> {
  final AiCoachRepository repository;

  GetAiConversationsUseCase(this.repository);

  @override
  Future<Result<List<AiConversationModel>>> call(NoParams params) {
    return repository.getConversations();
  }
}

