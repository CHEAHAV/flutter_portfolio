class ContactUrl {
  static const String githubUrl = 'https://github.com/CHEAHAV';
  static const String linkedinUrl = 'https://kh.linkedin.com';
  static const String resumeUrl =
      'https://www.pinterest.com/pin/802555596101887248/';
  static const String tiktokUrl =
      'https://www.tiktok.com/@hav_jumper';

  static String? urlForName(String name) {
    final normalizedName = name.toLowerCase();

    if (normalizedName.contains('github') ||
        normalizedName.contains('Github') ||
        normalizedName.contains('GitHub')) {
      return githubUrl;
    }

    if (normalizedName.contains('linkedin') ||
        normalizedName.contains('LinkedIn') ||
        normalizedName.contains('Linkedin')) {
      return linkedinUrl;
    }

    if (normalizedName.contains('Resume') ||
        normalizedName.contains('resume')) {
      return resumeUrl;
    }

    if (normalizedName.contains('TikTok') ||
        normalizedName.contains('tiktok')) {
      return tiktokUrl;
    }

    return null;
  }
}
