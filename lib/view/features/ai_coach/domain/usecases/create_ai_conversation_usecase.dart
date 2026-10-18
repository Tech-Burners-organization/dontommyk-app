import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_conversation_model.dart';
import 'package:tommy/view/features/ai_coach/domain/repositories/ai_coach_repository.dart';

class CreateAiConversationUseCase
    implements UseCase<Result<AiConversationModel>, String> {
  final AiCoachRepository repository;

  CreateAiConversationUseCase(this.repository);

  @override
  Future<Result<AiConversationModel>> call(String params) {
    return repository.createConversation(title: params);
  }
}

