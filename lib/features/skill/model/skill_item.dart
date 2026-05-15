class SkillItem {
  final String name;
  final int score;
  final String description;

  const SkillItem({
    required this.name,
    required this.score,
    required this.description,
  });
}

const List<SkillItem> skillItems = [
  SkillItem(
    name: 'Python',
    score: 8,
    description: 'Advanced data processing, REST APIs, and backend...',
  ),
  SkillItem(
    name: 'Flutter',
    score: 9,
    description: 'Cross-platform mobile apps, complex UI animations, state...',
  ),
  SkillItem(
    name: 'FastAPI',
    score: 5,
    description:
        'Building fast, asynchronous Python APIs with automatic interactive documentation.',
  ),
];

const List<String> tabs = ['SKILLS', 'PROJECTS', 'TIMELINE', 'REVIEWS'];

const String detail = 'Detailed Expertise';
