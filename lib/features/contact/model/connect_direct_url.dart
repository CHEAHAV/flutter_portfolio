class ConnectDirectUrl {
  static const String emailUrl = 'mailto:cheahav7171@gmail.com';
  static const String facebookUrl = 'https://www.facebook.com/IT.CHEAHAV';
  static const String phoneUrl = 'tel:099920164';
  static const String telegramUrl = 'https://t.me/IT_CHEAHAV';

  static String? urlForName(String name) {
    final normalizedName = name.toLowerCase();

    if (normalizedName.contains('email') ||
        normalizedName.contains('gmail') ||
        normalizedName.contains('mail')) {
      return emailUrl;
    }
    if (normalizedName.contains('facebook') || normalizedName.contains('fb')) {
      return facebookUrl;
    }
    if (normalizedName.contains('telegram') ||
        normalizedName.contains('t.me') ||
        normalizedName.contains('tg') ||
        normalizedName.contains('tele')) {
      return telegramUrl;
    }
    if (normalizedName.contains('phone') ||
        normalizedName.contains('tel') ||
        normalizedName.contains('call')) {
      return phoneUrl;
    }

    return null;
  }
}
