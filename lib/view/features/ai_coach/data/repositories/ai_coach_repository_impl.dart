import 'package:flutter/foundation.dart';
import 'package:tommy/core/errors/failure_mapper.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/ai_coach/data/datasources/ai_coach_remote_data_source.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_conversation_model.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_message_model.dart';
import 'package:tommy/view/features/ai_coach/domain/repositories/ai_coach_repository.dart';

class AiCoachRepositoryImpl implements AiCoachRepository {
  final AiCoachRemoteDataSource remoteDataSource;

  AiCoachRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<AiConversationModel>>> getConversations() async {
    try {
      final conversations = await remoteDataSource.getConversations();
      return ResultSuccess(conversations);
    } catch (e, st) {
      debugPrint('AiCoachRepositoryImpl.getConversations error: $e\n$st');
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<AiConversationModel>> createConversation({
    required String title,
  }) async {
    try {
      final conversation =
          await remoteDataSource.createConversation(title: title);
      return ResultSuccess(conversation);
    } catch (e, st) {
      debugPrint('AiCoachRepositoryImpl.createConversation error: $e\n$st');
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<List<AiMessageModel>>> getMessages(
    String conversationId,
  ) async {
    try {
      final messages = await remoteDataSource.getMessages(conversationId);
      return ResultSuccess(messages);
    } catch (e, st) {
      debugPrint('AiCoachRepositoryImpl.getMessages error: $e\n$st');
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<AiMessageModel>> sendRestMessage({
    required String conversationId,
    required String content,
  }) async {
    try {
      final message = await remoteDataSource.sendRestMessage(
        conversationId: conversationId,
        content: content,
      );
      return ResultSuccess(message);
    } catch (e, st) {
      debugPrint('AiCoachRepositoryImpl.sendRestMessage error: $e\n$st');
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<void>> deleteConversation(String conversationId) async {
    try {
      await remoteDataSource.deleteConversation(conversationId);
      return const ResultSuccess(null);
    } catch (e, st) {
      debugPrint('AiCoachRepositoryImpl.deleteConversation error: $e\n$st');
      return ResultFailure(FailureMapper.from(e));
    }
  }
}

