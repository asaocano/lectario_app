class BookCategory {
  final String id;
  final String title;
  final String apiValue;
  final Set<String> subjects;

  const BookCategory({
    required this.id,
    required this.title,
    required this.apiValue,
    required this.subjects,
  });

  bool matches(Iterable<String> bookSubjects) {
    final normalizedSubjects = bookSubjects.map(
      (subject) => subject.toLowerCase().trim(),
    );

    return normalizedSubjects.any(subjects.contains);
  }
}
