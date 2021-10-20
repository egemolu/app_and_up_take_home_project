class Book {
  final String id;

  final String title;

  final String author;

  final String description;

  final String category;

  final double averageRating;

  final Map<String, Uri> imageLinks;

  const Book(
      {required this.id,
      required this.title,
      required this.author,
      required this.description,
      required this.category,
      required this.averageRating,
      required this.imageLinks});

  static Book fromJson(Map<String, dynamic> json) {
    final imageLinks = <String, Uri>{};
    (json['volumeInfo']['imageLinks'] as Map<String, dynamic>?)
        ?.forEach((key, value) {
      Uri uri = Uri.parse(value.toString());
      imageLinks.addAll({key: uri});
    });

    return Book(
        id: json['id'],
        title: json['volumeInfo']['title'] ?? '',
        author: ((json['volumeInfo']['authors'] as List<dynamic>?) ?? [''])[0],
        averageRating:
            ((json['volumeInfo']['averageRating'] ?? 0) as num).toDouble(),
        category:
            ((json['volumeInfo']['categories'] as List<dynamic>?) ?? [''])[0],
        description: json['volumeInfo']['description'] ?? '',
        imageLinks: imageLinks);
  }
}
