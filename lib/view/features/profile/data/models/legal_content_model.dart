class LegalContentModel {
  final String type;
  final String key;
  final String title;
  final String content;
  final String? updatedAt;

  const LegalContentModel({
    this.type = '',
    this.key = '',
    this.title = '',
    required this.content,
    this.updatedAt,
  });

  factory LegalContentModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return LegalContentModel(
      type: data['type']?.toString() ?? data['key']?.toString() ?? '',
      key: data['key']?.toString() ?? data['type']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      content: data['content']?.toString() ?? '',
      updatedAt: data['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'key': key,
      'title': title,
      'content': content,
      'updatedAt': updatedAt,
    };
  }
}

