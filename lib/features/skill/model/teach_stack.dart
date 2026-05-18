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
  imageLeft: 'assets/icons/flutter.png',
  labelLeft: 'FLUTTER',
  profile: 'assets/images/profile.png',
  imageRight: 'assets/icons/fast.png',
  labelRight: 'FASTAPI',
);

const String textstack = 'My Text Stack';
const String name = 'IT CHEAHAV';
