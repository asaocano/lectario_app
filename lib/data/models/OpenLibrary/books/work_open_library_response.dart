class WorkOpenLibraryResponse {
  final String key;
  final String title;
  final String? description;
  final List<String> subjects;

  WorkOpenLibraryResponse({
    required this.key,
    required this.title,
    this.description,
    required this.subjects,
  });

  factory WorkOpenLibraryResponse.fromJson(Map<String, dynamic> json) {
    return WorkOpenLibraryResponse(
      key: json['key'],
      title: json['title'],
      description: _parseDescription(json['description']),
      subjects: List<String>.from(json['subjects'] ?? []),
    );
  }

  static String? _parseDescription(dynamic description) {
    if (description == null) return null;

    if (description is String) {
      return description;
    }

    if (description is Map<String, dynamic>) {
      return description['value'] as String?;
    }

    return null;
  }
}