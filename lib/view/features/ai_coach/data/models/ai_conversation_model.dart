class AiConversationModel {
  final String id;
  final String employeeId;
  final String organizationId;
  final String title;
  final int messageCount;
  final String? lastMessageAt;
  final bool isArchived;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;

  const AiConversationModel({
    required this.id,
    required this.employeeId,
    required this.organizationId,
    required this.title,
    this.messageCount = 0,
    this.lastMessageAt,
    this.isArchived = false,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  factory AiConversationModel.fromJson(Map<String, dynamic> json) {
    return AiConversationModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      organizationId: json['organizationId']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Conversation',
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
      lastMessageAt: json['lastMessageAt']?.toString(),
      isArchived: json['isArchived'] == true,
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'employeeId': employeeId,
    'organizationId': organizationId,
    'title': title,
    'messageCount': messageCount,
    'lastMessageAt': lastMessageAt,
    'isArchived': isArchived,
    'isDeleted': isDeleted,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

