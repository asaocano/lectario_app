// To parse this JSON data, do
//
//     final authorBooksOpenLibraryResponse = authorBooksOpenLibraryResponseFromJson(jsonString);

import 'dart:convert';

AuthorBooksOpenLibraryResponse authorBooksOpenLibraryResponseFromJson(String str) => AuthorBooksOpenLibraryResponse.fromJson(json.decode(str));

String authorBooksOpenLibraryResponseToJson(AuthorBooksOpenLibraryResponse data) => json.encode(data.toJson());

class AuthorBooksOpenLibraryResponse {
    final int numFound;
    final int start;
    final bool numFoundExact;
    final int authorBooksOpenLibraryResponseNumFound;
    final String documentationUrl;
    final String q;
    final dynamic offset;
    final List<Doc> docs;

    AuthorBooksOpenLibraryResponse({
        required this.numFound,
        required this.start,
        required this.numFoundExact,
        required this.authorBooksOpenLibraryResponseNumFound,
        required this.documentationUrl,
        required this.q,
        required this.offset,
        required this.docs,
    });

    factory AuthorBooksOpenLibraryResponse.fromJson(Map<String, dynamic> json) => AuthorBooksOpenLibraryResponse(
        numFound: json["numFound"],
        start: json["start"],
        numFoundExact: json["numFoundExact"],
        authorBooksOpenLibraryResponseNumFound: json["num_found"],
        documentationUrl: json["documentation_url"],
        q: json["q"],
        offset: json["offset"],
        docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "numFound": numFound,
        "start": start,
        "numFoundExact": numFoundExact,
        "num_found": authorBooksOpenLibraryResponseNumFound,
        "documentation_url": documentationUrl,
        "q": q,
        "offset": offset,
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
    };
}

class Doc {
    final List<String> authorKey;
    final List<String> authorName;
    final int coverI;
    final int firstPublishYear;
    final int editionCount;
    final String key;
    final String title;

    Doc({
        required this.authorKey,
        required this.authorName,
        required this.coverI,
        required this.firstPublishYear,
        required this.key,
        required this.title,
        required this.editionCount,
    });

    factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        authorKey: List<String>.from(json["author_key"].map((x) => x)),
        authorName: List<String>.from(json["author_name"].map((x) => x)),
        coverI: json["cover_i"] ?? 0,
        editionCount: json["edition_count"],
        firstPublishYear: json["first_publish_year"],
        key: json["key"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "author_key": List<dynamic>.from(authorKey.map((x) => x)),
        "author_name": List<dynamic>.from(authorName.map((x) => x)),
        "cover_i": coverI,
        "first_publish_year": firstPublishYear,
        "key": key,
        "title": title,
    };
}
