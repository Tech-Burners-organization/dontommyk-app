import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_message_model.dart';
import 'package:tommy/view/features/ai_coach/domain/repositories/ai_coach_repository.dart';

class GetAiMessagesUseCase
    implements UseCase<Result<List<AiMessageModel>>, String> {
  final AiCoachRepository repository;

  GetAiMessagesUseCase(this.repository);

  @override
  Future<Result<List<AiMessageModel>>> call(String conversationId) {
    return repository.getMessages(conversationId);
  }
}

