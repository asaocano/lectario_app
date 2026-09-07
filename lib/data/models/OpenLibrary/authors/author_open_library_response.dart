import 'dart:convert';

AuthorOpenLibraryResponse authorOpenLibraryResponseFromJson(String str) =>
    AuthorOpenLibraryResponse.fromJson(json.decode(str));

String authorOpenLibraryResponseToJson(AuthorOpenLibraryResponse data) =>
    json.encode(data.toJson());

class AuthorOpenLibraryResponse {
  final String name;
  final String birthDate;
  final String key;
  final String deathDate;
  final String bio;
  final List<int> photos;
  final String personalName;

  AuthorOpenLibraryResponse({
    required this.name,
    required this.birthDate,
    required this.key,
    required this.deathDate,
    required this.bio,
    required this.photos,
    required this.personalName,
  });

  factory AuthorOpenLibraryResponse.fromJson(Map<String, dynamic> json) =>
      AuthorOpenLibraryResponse(
        name: json["name"],
        birthDate: json["birth_date"],
        key: json["key"],
        deathDate: json["death_date"] ?? '',
        bio: _bioToString(json["bio"]),
        photos: List<int>.from(json["photos"].map((x) => x)),
        personalName: json["personal_name"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "birth_date": birthDate,
    "key": key,
    "death_date": deathDate,
    "photos": List<dynamic>.from(photos.map((x) => x)),
    "personal_name": personalName,
  };

  static String _bioToString(dynamic bio) {
    if (bio is String) {
      return bio;
    } else if (bio is Map<String, String>) {
      return bio['value'] ?? '';
    }

    return "";
  }
}
