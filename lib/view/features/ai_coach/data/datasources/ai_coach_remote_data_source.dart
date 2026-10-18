import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_conversation_model.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_message_model.dart';

abstract class AiCoachRemoteDataSource {
  Future<List<AiConversationModel>> getConversations();
  Future<AiConversationModel> createConversation({required String title});
  Future<List<AiMessageModel>> getMessages(String conversationId);
}

class AiCoachRemoteDataSourceImpl implements AiCoachRemoteDataSource {
  final ApiService apiService;

  AiCoachRemoteDataSourceImpl(this.apiService);

  static Map<String, dynamic> _asMap(dynamic data) {
    if (data == null) return <String, dynamic>{};
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    if (data is String && data.trim().startsWith('{')) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry(key.toString(), value));
        }
      } catch (_) {}
    }
    return <String, dynamic>{};
  }

  static List<dynamic> _asList(dynamic data) {
    if (data == null) return const [];
    if (data is List) return data;
    if (data is String && data.trim().startsWith('[')) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is List) return decoded;
      } catch (_) {}
    }
    return const [];
  }

  @override
  Future<List<AiConversationModel>> getConversations() async {
    try {
      final response = await apiService.getData<List<AiConversationModel>>(
        '/ai-conversations',
        decoder: (json) {
          final rootMap = _asMap(json);
          final dynamic rawData =
              rootMap.containsKey('data') ? rootMap['data'] : json;
          final list = _asList(rawData);
          return list
              .map((item) => AiConversationModel.fromJson(_asMap(item)))
              .toList();
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('AiCoachRemoteDataSourceImpl.getConversations error: $e');
      rethrow;
    }
  }

  @override
  Future<AiConversationModel> createConversation({required String title}) async {
    try {
      final response = await apiService.postData<AiConversationModel>(
        '/ai-conversations',
        {'title': title},
        decoder: (json) {
          final rootMap = _asMap(json);
          final dynamic rawData =
              rootMap.containsKey('data') ? rootMap['data'] : rootMap;
          return AiConversationModel.fromJson(_asMap(rawData));
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('AiCoachRemoteDataSourceImpl.createConversation error: $e');
      rethrow;
    }
  }

  @override
  Future<List<AiMessageModel>> getMessages(String conversationId) async {
    try {
      final response = await apiService.getData<List<AiMessageModel>>(
        '/ai-messages/conversation/$conversationId',
        decoder: (json) {
          final rootMap = _asMap(json);
          final dynamic rawData =
              rootMap.containsKey('data') ? rootMap['data'] : json;
          final list = _asList(rawData);
          return list
              .map((item) => AiMessageModel.fromJson(_asMap(item)))
              .toList();
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('AiCoachRemoteDataSourceImpl.getMessages error: $e');
      rethrow;
    }
  }
}

