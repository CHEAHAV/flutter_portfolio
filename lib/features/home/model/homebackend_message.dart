class HomeBackendMessage {
  final String id;
  final String title;
  final String message;
  final String? actionLabel;

  const HomeBackendMessage({
    required this.id,
    required this.title,
    required this.message,
    this.actionLabel,
  });
}

const List<HomeBackendMessage> homeBackendMessage = [
  HomeBackendMessage(
    id: '1',
    title: 'Backend connection failed',
    message: 'Start the backend and check API_BASE_URL, then try again.',
    actionLabel: 'Try again...!',
  ),
  HomeBackendMessage(
    id: '2',
    title: 'No backend data yet',
    message: 'Add active home records in the backend first.',
  ),

  HomeBackendMessage(
    id: '3',
    title: 'No profile info yet',
    message: 'Add an info record in the backend first.',
  ),

  HomeBackendMessage(
    id: '4',
    title: 'Certification not found',
    message: 'This certification is no longer available.',
  ),
];
