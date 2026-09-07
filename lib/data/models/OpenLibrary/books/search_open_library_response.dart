import 'dart:convert';

SearchOpenLibraryResponse searchOpenLibraryResponseFromJson(String str) => SearchOpenLibraryResponse.fromJson(json.decode(str));

String searchOpenLibraryResponseToJson(SearchOpenLibraryResponse data) => json.encode(data.toJson());

class SearchOpenLibraryResponse {
    final int numFound;
    final int start;
    final bool numFoundExact;
    final int searchOpenLibraryResponseNumFound;
    final String documentationUrl;
    final String q;
    final dynamic offset;
    final List<Doc> docs;

    SearchOpenLibraryResponse({
        required this.numFound,
        required this.start,
        required this.numFoundExact,
        required this.searchOpenLibraryResponseNumFound,
        required this.documentationUrl,
        required this.q,
        required this.offset,
        required this.docs,
    });

    factory SearchOpenLibraryResponse.fromJson(Map<String, dynamic> json) => SearchOpenLibraryResponse(
        numFound: json["numFound"],
        start: json["start"],
        numFoundExact: json["numFoundExact"],
        searchOpenLibraryResponseNumFound: json["num_found"],
        documentationUrl: json["documentation_url"],
        q: json["q"],
        offset: json["offset"],
        docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "numFound": numFound,
        "start": start,
        "numFoundExact": numFoundExact,
        "num_found": searchOpenLibraryResponseNumFound,
        "documentation_url": documentationUrl,
        "q": q,
        "offset": offset,
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
    };
}

class Doc {
    final List<String> authorKey;
    final List<String> authorName;
    final int? coverI;
    final int editionCount;
    final int firstPublishYear;
    final String key;
    final String title;

    Doc({
        required this.authorKey,
        required this.authorName,
        this.coverI,
        required this.editionCount,
        required this.firstPublishYear,
        required this.key,
        required this.title,
    });

    factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        authorKey: List<String>.from((json["author_key"] ?? []).map((x) => x)),
        authorName: List<String>.from((json["author_name"] ?? []).map((x) => x)),
        coverI: json["cover_i"] ?? 0,
        editionCount: json["edition_count"] ?? 0,
        firstPublishYear: json["first_publish_year"] ?? 0,
        key: json["key"] ?? "",
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "author_key": List<dynamic>.from(authorKey.map((x) => x)),
        "author_name": List<dynamic>.from(authorName.map((x) => x)),
        "cover_i": coverI,
        "edition_count": editionCount,
        "first_publish_year": firstPublishYear,
        "key": key,
        "title": title,
    };
}