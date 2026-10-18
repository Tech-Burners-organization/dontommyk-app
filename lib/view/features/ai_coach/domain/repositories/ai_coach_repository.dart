import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_conversation_model.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_message_model.dart';

abstract class AiCoachRepository {
  Future<Result<List<AiConversationModel>>> getConversations();
  Future<Result<AiConversationModel>> createConversation({required String title});
  Future<Result<List<AiMessageModel>>> getMessages(String conversationId);
}

