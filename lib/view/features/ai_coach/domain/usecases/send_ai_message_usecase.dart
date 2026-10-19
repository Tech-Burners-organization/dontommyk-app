import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_message_model.dart';
import 'package:tommy/view/features/ai_coach/domain/repositories/ai_coach_repository.dart';

class SendAiMessageParams {
  final String conversationId;
  final String content;

  const SendAiMessageParams({
    required this.conversationId,
    required this.content,
  });
}

class SendAiMessageUseCase
    implements UseCase<Result<AiMessageModel>, SendAiMessageParams> {
  final AiCoachRepository repository;

  SendAiMessageUseCase(this.repository);

  @override
  Future<Result<AiMessageModel>> call(SendAiMessageParams params) {
    return repository.sendRestMessage(
      conversationId: params.conversationId,
      content: params.content,
    );
  }
}

