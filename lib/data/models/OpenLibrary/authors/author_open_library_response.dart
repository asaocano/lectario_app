import 'dart:convert';

AuthorOpenLibraryResponse authorOpenLibraryResponseFromJson(String str) => AuthorOpenLibraryResponse.fromJson(json.decode(str));

String authorOpenLibraryResponseToJson(AuthorOpenLibraryResponse data) => json.encode(data.toJson());

class AuthorOpenLibraryResponse {
    final String title;
    final String name;
    final String birthDate;
    final String key;
    final String deathDate;
    final List<int> photos;
    final String personalName;

    AuthorOpenLibraryResponse({
        required this.title,
        required this.name,
        required this.birthDate,
        required this.key,
        required this.deathDate,
        required this.photos,
        required this.personalName,
    });

    factory AuthorOpenLibraryResponse.fromJson(Map<String, dynamic> json) => AuthorOpenLibraryResponse(
        title: json["title"],
        name: json["name"],
        birthDate: json["birth_date"],
        key: json["key"],
        deathDate: json["death_date"],
        photos: List<int>.from(json["photos"].map((x) => x)),
        personalName: json["personal_name"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "name": name,
        "birth_date": birthDate,
        "key": key,
        "death_date": deathDate,
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "personal_name": personalName,
    };
}
