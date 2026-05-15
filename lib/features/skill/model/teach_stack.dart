// teach_stack.dart

class TeachStack {
  final String imageLeft;
  final String labelLeft;
  final String profile;
  final String imageRight;
  final String labelRight;

  const TeachStack({
    required this.imageLeft,
    required this.labelLeft,
    required this.profile,
    required this.imageRight,
    required this.labelRight,
  });
}

const TeachStack teachStack = TeachStack( 
  imageLeft: 'assets/images/computer.png',
  labelLeft: 'PYTHON',
  profile: 'assets/images/profile.png',
  imageRight: 'assets/images/computer.png',
  labelRight: 'FLUTTER',
);