import 'dart:convert';

OpenLibraryResponse openLibraryResponseFromJson(String str) => OpenLibraryResponse.fromJson(json.decode(str));

String openLibraryResponseToJson(OpenLibraryResponse data) => json.encode(data.toJson());

class OpenLibraryResponse {
    final String key;
    final String name;
    final String subjectType;
    final String solrQuery;
    final int workCount;
    final List<Work> works;

    OpenLibraryResponse({
        required this.key,
        required this.name,
        required this.subjectType,
        required this.solrQuery,
        required this.workCount,
        required this.works,
    });

    factory OpenLibraryResponse.fromJson(Map<String, dynamic> json) => OpenLibraryResponse(
        key: json["key"],
        name: json["name"],
        subjectType: json["subject_type"],
        solrQuery: json["solr_query"],
        workCount: json["work_count"],
        works: List<Work>.from(json["works"].map((x) => Work.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
        "subject_type": subjectType,
        "solr_query": solrQuery,
        "work_count": workCount,
        "works": List<dynamic>.from(works.map((x) => x.toJson())),
    };
}

class Work {
    final String key;
    final String title;
    final int editionCount;
    final int coverId;
    final String? coverEditionKey;
    final List<String> subject;
    final bool printdisabled;
    final String lendingEdition;
    final String lendingIdentifier;
    final List<Author> authors;
    final int firstPublishYear;
    final bool publicScan;
    final bool hasFulltext;

    Work({
        required this.key,
        required this.title,
        required this.editionCount,
        required this.coverId,
        required this.coverEditionKey,
        required this.subject,
        required this.printdisabled,
        required this.lendingEdition,
        required this.lendingIdentifier,
        required this.authors,
        required this.firstPublishYear,
        required this.publicScan,
        required this.hasFulltext,
    });

    factory Work.fromJson(Map<String, dynamic> json) => Work(
        key: json["key"],
        title: json["title"],
        editionCount: json["edition_count"],
        coverId: json["cover_id"],
        coverEditionKey: json["cover_edition_key"],
        subject: List<String>.from(json["subject"].map((x) => x)),
        printdisabled: json["printdisabled"],
        lendingEdition: json["lending_edition"],
        lendingIdentifier: json["lending_identifier"],
        authors: List<Author>.from(json["authors"].map((x) => Author.fromJson(x))),
        firstPublishYear: json["first_publish_year"],
        publicScan: json["public_scan"],
        hasFulltext: json["has_fulltext"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "title": title,
        "edition_count": editionCount,
        "cover_id": coverId,
        "cover_edition_key": coverEditionKey,
        "subject": List<dynamic>.from(subject.map((x) => x)),
        "printdisabled": printdisabled,
        "lending_edition": lendingEdition,
        "lending_identifier": lendingIdentifier,
        "authors": List<dynamic>.from(authors.map((x) => x.toJson())),
        "first_publish_year": firstPublishYear,
        "public_scan": publicScan,
        "has_fulltext": hasFulltext,
    };
}

class Author {
    final String key;
    final String name;

    Author({
        required this.key,
        required this.name,
    });

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        key: json["key"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
    };
}


enum Src {
    CORE_MODELS_LENDING_GET_AVAILABILITY
}

final srcValues = EnumValues({
    "core.models.lending.get_availability": Src.CORE_MODELS_LENDING_GET_AVAILABILITY
});

enum Status {
    BORROW_AVAILABLE,
    OPEN
}

final statusValues = EnumValues({
    "borrow_available": Status.BORROW_AVAILABLE,
    "open": Status.OPEN
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
