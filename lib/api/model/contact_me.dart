class ContactMe {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String contactUrl;

  const ContactMe({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.contactUrl,
  });

  String get effectiveContactUrl {
    final trimmedUrl = contactUrl.trim();
    final email = _emailFrom(description);

    if (email != null && trimmedUrl.isEmpty) {
      return 'mailto:$email';
    }

    if (email != null &&
        trimmedUrl.contains('mail.google.com') &&
        !trimmedUrl.contains('to=')) {
      return 'https://mail.google.com/mail/?view=cm&fs=1&to=${Uri.encodeComponent(email)}';
    }

    if (email != null && trimmedUrl.toLowerCase() == email.toLowerCase()) {
      return 'mailto:$email';
    }

    return trimmedUrl;
  }

  static String? _emailFrom(String value) {
    final match = RegExp(r'[\w.+-]+@[\w-]+(?:\.[\w-]+)+').firstMatch(value);
    return match?.group(0);
  }
}
