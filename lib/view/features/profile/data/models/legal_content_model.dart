class LegalContentModel {
  final String type;
  final String content;
  final String? updatedAt;

  const LegalContentModel({
    required this.type,
    required this.content,
    this.updatedAt,
  });

  factory LegalContentModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return LegalContentModel(
      type: data['type']?.toString() ?? '',
      content: data['content']?.toString() ?? '',
      updatedAt: data['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'updatedAt': updatedAt,
    };
  }
}

