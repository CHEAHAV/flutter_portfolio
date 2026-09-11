class MyCore {
  final String id;
  final String name;
  final String description;
  final String image;

  /// Null means the backend predates this field; empty means no link is set.
  final String? officialUrl;

  const MyCore({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.officialUrl,
  });
}
