class ContactBackendMessage {
  final String id;
  final String title;
  final String message;
  final String? actionLabel;

  const ContactBackendMessage({
    required this.id,
    required this.title,
    required this.message,
    this.actionLabel,
  });
}

const List<ContactBackendMessage> contactBackendMessage = [
  ContactBackendMessage(
    id: '1',
    title: 'Backend connection failed',
    message: 'Start the backend and check API_BASE_URL, then try again.',
    actionLabel: 'Try again...!'
  ),
  ContactBackendMessage(
    id: '2',
    title: 'No backend data yet',
    message: 'Add active contact and social records first.',
  ),
];
