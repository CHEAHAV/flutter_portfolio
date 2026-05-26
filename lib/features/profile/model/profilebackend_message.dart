class ProfileBackendMessage {
  final String id;
  final String title;
  final String message;
  final String? actionLabel;

  const ProfileBackendMessage({
    required this.id,
    required this.title,
    required this.message,
    this.actionLabel,
  });
}

const List<ProfileBackendMessage> profileBackendMessage = [
  ProfileBackendMessage(
    id: '1',
    title: 'Backend connection failed',
    message: 'Start the backend and check API_BASE_URL, then try again.',
    actionLabel: 'Try again...!',
  ),
  ProfileBackendMessage(
    id: '2',
    title: 'No backend data yet',
    message:
        'Add active info, story, study, career, or certification records first.',
  ),

  ProfileBackendMessage(
    id: '3',
    title: 'No profile info yet',
    message: 'Add an info record in the backend first.',
  ),
];
