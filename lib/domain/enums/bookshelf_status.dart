enum BookshelfStatus {
  wantToRead(1),
  favorite(2),
  read(3);

  final int value;

  const BookshelfStatus(this.value);
}
