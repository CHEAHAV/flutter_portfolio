/// Official destinations and display metadata for the portfolio's technologies.
class SkillResource {
  const SkillResource(this.url, this.category, this.uses);

  final String url;
  final String category;
  final List<String> uses;

  static SkillResource? forName(String name) {
    final normalized = name.toLowerCase().replaceAll(RegExp(r'[\s._-]+'), '');
    return _resources[_aliases[normalized] ?? normalized];
  }

  static const _aliases = {
    'posgresql': 'postgresql',
    'postgres': 'postgresql',
    'javaspring': 'spring',
    'springboot': 'spring',
    'c#': 'csharp',
    'js': 'javascript',
    'nuxtjs': 'nuxt',
    'html5': 'html',
    'css3': 'css',
  };

  static const _resources = <String, SkillResource>{
    'python': SkillResource('https://www.python.org/', 'Programming language', [
      'Web development',
      'Automation',
      'Data & AI',
    ]),
    'fastapi': SkillResource(
      'https://fastapi.tiangolo.com/',
      'Backend framework',
      ['REST APIs', 'Python', 'Backend development'],
    ),
    'postgresql': SkillResource(
      'https://www.postgresql.org/',
      'Relational database',
      ['SQL', 'Data storage', 'Backend development'],
    ),
    'java': SkillResource('https://dev.java/', 'Programming language', [
      'Backend development',
      'Android',
      'Enterprise applications',
    ]),
    'flutter': SkillResource('https://flutter.dev/', 'Application framework', [
      'Mobile apps',
      'Cross-platform UI',
      'Dart',
    ]),
    'dart': SkillResource('https://dart.dev/', 'Programming language', [
      'Mobile apps',
      'Web development',
      'Flutter',
    ]),
    'nuxt': SkillResource('https://nuxt.com/', 'Web framework', [
      'Vue',
      'Web applications',
      'Server rendering',
    ]),
    'mysql': SkillResource('https://www.mysql.com/', 'Relational database', [
      'SQL',
      'Data storage',
      'Web applications',
    ]),
    'spring': SkillResource('https://spring.io/', 'Backend framework', [
      'Java',
      'REST APIs',
      'Enterprise applications',
    ]),
    'mongodb': SkillResource('https://www.mongodb.com/', 'Document database', [
      'NoSQL',
      'Data storage',
      'Web applications',
    ]),
    'sql': SkillResource(
      'https://www.iso.org/standard/76583.html',
      'Query language',
      ['Database queries', 'Data analysis', 'Relational data'],
    ),
    'javascript': SkillResource(
      'https://tc39.es/ecma262/',
      'Programming language',
      ['Web development', 'Interactive interfaces', 'Web applications'],
    ),
    'csharp': SkillResource(
      'https://dotnet.microsoft.com/en-us/languages/csharp',
      'Programming language',
      ['.NET', 'Application development', 'Games'],
    ),
    'github': SkillResource('https://github.com/', 'Developer platform', [
      'Version control',
      'Collaboration',
      'Code hosting',
    ]),
    'laravel': SkillResource('https://laravel.com/', 'Backend framework', [
      'PHP',
      'Web applications',
      'REST APIs',
    ]),
    'html': SkillResource('https://html.spec.whatwg.org/', 'Markup language', [
      'Web structure',
      'Semantic content',
      'Accessibility',
    ]),
    'css': SkillResource(
      'https://www.w3.org/Style/CSS/',
      'Style sheet language',
      ['Responsive layouts', 'Visual design', 'Web styling'],
    ),
    'docker': SkillResource('https://www.docker.com/', 'Developer tool', [
      'Containers',
      'Development environments',
      'Deployment',
    ]),
    'php': SkillResource('https://www.php.net/', 'Programming language', [
      'Web development',
      'Server-side scripting',
      'Backend development',
    ]),
  };
}
