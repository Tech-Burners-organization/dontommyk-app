import 'package:intl/intl.dart';

class AiMessageModel {
  final String id;
  final String conversationId;
  final String role;
  final String content;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? metadata;

  const AiMessageModel({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  bool get isUser => role.trim().toLowerCase() == 'user';
  bool get isAssistant => role.trim().toLowerCase() == 'assistant';

  String get formattedTime {
    if (createdAt == null || createdAt!.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt!).toLocal();
      return DateFormat('h:mm a').format(dt);
    } catch (_) {
      return '';
    }
  }

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      content: json['content']?.toString() ?? '',
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      metadata: json['metadata'] is Map<String, dynamic>
          ? json['metadata'] as Map<String, dynamic>
          : (json['metadata'] is Map
              ? (json['metadata'] as Map).map((k, v) => MapEntry(k.toString(), v))
              : null),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'conversationId': conversationId,
    'role': role,
    'content': content,
    'isDeleted': isDeleted,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    if (metadata != null) 'metadata': metadata,
  };
}

