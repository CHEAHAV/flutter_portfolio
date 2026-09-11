class Skill {
  final String id;
  final String name;
  final double score;
  final String description;
  final String image;

  /// Null means the backend predates this field; empty means no link is set.
  final String? officialUrl;

  const Skill({
    required this.id,
    required this.name,
    required this.score,
    required this.description,
    required this.image,
    this.officialUrl,
  });
}
