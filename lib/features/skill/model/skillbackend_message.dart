class SkillbackendMessage {
  final String id;
  final String title;
  final String message;
  final String? actionLabel;

  const SkillbackendMessage({
    required this.id,
    required this.title,
    required this.message,
    this.actionLabel,
  });
}

const List<SkillbackendMessage> skillBackendMessage = [
  SkillbackendMessage(
    id: '1',
    title: 'Backend connection failed',
    message: 'Start the backend and check API_BASE_URL, then try again.',
    actionLabel: 'Try again...!',
  ),
  SkillbackendMessage(
    id: '2',
    title: 'No backend data yet',
    message: 'Add active teach stack, skill, or story records first.',
  ),
];
