// To parse this JSON data, do
//
//     final isbnResponse = isbnResponseFromJson(jsonString);

import 'dart:convert';

IsbnResponse isbnResponseFromJson(String str) => IsbnResponse.fromJson(json.decode(str));

String isbnResponseToJson(IsbnResponse data) => json.encode(data.toJson());

class IsbnResponse {
    final List<Type> works;
    final String title;
    final List<String> publishers;
    final String publishDate;
    final String key;
    final Type type;
    final Identifiers identifiers;
    final List<int> covers;
    final List<String> isbn13;
    final List<String> isbn10;
    final List<String> publishPlaces;
    final String copyrightDate;
    final List<Contributor> contributors;
    final Created description;
    final String physicalFormat;
    final int numberOfPages;
    final int latestRevision;
    final int revision;
    final Created created;
    final Created lastModified;

    IsbnResponse({
        required this.works,
        required this.title,
        required this.publishers,
        required this.publishDate,
        required this.key,
        required this.type,
        required this.identifiers,
        required this.covers,
        required this.isbn13,
        required this.isbn10,
        required this.publishPlaces,
        required this.copyrightDate,
        required this.contributors,
        required this.description,
        required this.physicalFormat,
        required this.numberOfPages,
        required this.latestRevision,
        required this.revision,
        required this.created,
        required this.lastModified,
    });

    factory IsbnResponse.fromJson(Map<String, dynamic> json) => IsbnResponse(
        works: List<Type>.from(json["works"].map((x) => Type.fromJson(x))),
        title: json["title"],
        publishers: List<String>.from(json["publishers"].map((x) => x)),
        publishDate: json["publish_date"],
        key: json["key"],
        type: Type.fromJson(json["type"]),
        identifiers: Identifiers.fromJson(json["identifiers"]),
        covers: List<int>.from(json["covers"].map((x) => x)),
        isbn13: List<String>.from(json["isbn_13"].map((x) => x)),
        isbn10: List<String>.from(json["isbn_10"].map((x) => x)),
        publishPlaces: List<String>.from(json["publish_places"].map((x) => x)),
        copyrightDate: json["copyright_date"],
        contributors: List<Contributor>.from(json["contributors"].map((x) => Contributor.fromJson(x))),
        description: Created.fromJson(json["description"]),
        physicalFormat: json["physical_format"],
        numberOfPages: json["number_of_pages"],
        latestRevision: json["latest_revision"],
        revision: json["revision"],
        created: Created.fromJson(json["created"]),
        lastModified: Created.fromJson(json["last_modified"]),
    );

    Map<String, dynamic> toJson() => {
        "works": List<dynamic>.from(works.map((x) => x.toJson())),
        "title": title,
        "publishers": List<dynamic>.from(publishers.map((x) => x)),
        "publish_date": publishDate,
        "key": key,
        "type": type.toJson(),
        "identifiers": identifiers.toJson(),
        "covers": List<dynamic>.from(covers.map((x) => x)),
        "isbn_13": List<dynamic>.from(isbn13.map((x) => x)),
        "isbn_10": List<dynamic>.from(isbn10.map((x) => x)),
        "publish_places": List<dynamic>.from(publishPlaces.map((x) => x)),
        "copyright_date": copyrightDate,
        "contributors": List<dynamic>.from(contributors.map((x) => x.toJson())),
        "description": description.toJson(),
        "physical_format": physicalFormat,
        "number_of_pages": numberOfPages,
        "latest_revision": latestRevision,
        "revision": revision,
        "created": created.toJson(),
        "last_modified": lastModified.toJson(),
    };
}

class Contributor {
    final String role;
    final String name;

    Contributor({
        required this.role,
        required this.name,
    });

    factory Contributor.fromJson(Map<String, dynamic> json) => Contributor(
        role: json["role"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "role": role,
        "name": name,
    };
}

class Created {
    final String type;
    final String value;

    Created({
        required this.type,
        required this.value,
    });

    factory Created.fromJson(Map<String, dynamic> json) => Created(
        type: json["type"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "value": value,
    };
}

class Identifiers {
    Identifiers();

    factory Identifiers.fromJson(Map<String, dynamic> json) => Identifiers(
    );

    Map<String, dynamic> toJson() => {
    };
}

class Type {
    final String key;

    Type({
        required this.key,
    });

    factory Type.fromJson(Map<String, dynamic> json) => Type(
        key: json["key"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
    };
}
