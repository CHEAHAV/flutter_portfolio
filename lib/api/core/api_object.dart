class ApiObject {
  static String resolveID(Map<String, dynamic> item) {
    return (item['id'] ?? item['ID'] ?? '').toString();
  }

  static String resolveName(Map<String, dynamic> item) {
    return (item['name'] ?? item['Name'] ?? '').toString();
  }

  static String resolveTitle(Map<String, dynamic> item) {
    return (item['title'] ?? item['Title'] ?? '').toString();
  }

  static String resolveSubTitle(Map<String, dynamic> item) {
    return (item['subtitle'] ?? item['sub_title'] ?? item['SubTitle'] ?? '')
        .toString();
  }

  static String resolveDescription(Map<String, dynamic> item) {
    return (item['description'] ?? item['Description'] ?? '').toString();
  }

  static String resolveIconName(Map<String, dynamic> item) {
    return (item['iconname'] ?? item['icon_name'] ?? item['IconName'] ?? '')
        .toString();
  }

  static String resolveDate(Map<String, dynamic> item) {
    return (item['date'] ?? item['Date'] ?? '').toString();
  }

  static double resolveScore(Map<String, dynamic> item) {
    final value = item['score'] ?? item['Score'] ?? 0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static String resolveNameLeft(Map<String, dynamic> item) {
    return (item['nameleft'] ?? item['name_left'] ?? '').toString();
  }

  static String resolveNameRight(Map<String, dynamic> item) {
    return (item['nameright'] ?? item['name_right'] ?? '').toString();
  }

  static String resolveDuration(Map<String, dynamic> item) {
    return (item['duration'] ?? item['Duration'] ?? '').toString();
  }
  static String resolvePhone(Map<String, dynamic> item) {
    return (item['phone'] ?? item['Phone'] ?? '').toString();
  }

  static String resolveRole(Map<String, dynamic> item) {
    return (item['role'] ?? item['Role'] ?? '').toString();
  }

  static String resolvePlatform(Map<String, dynamic> item) {
    return (item['platform'] ?? item['Platform'] ?? '').toString();
  }

  static String resolveChallenge(Map<String, dynamic> item) {
    return (item['challenge'] ?? item['Challenge'] ?? '').toString();
  }

  static String resolveIssuer(Map<String, dynamic> item) {
    return (item['issuer'] ?? item['Issuer'] ?? '').toString();
  }

  static String resolveDateEarned(Map<String, dynamic> item) {
    return (item['date_earned'] ??
            item['DateEarned'] ??
            item['dateearned'] ??
            '')
        .toString();
  }

  static String resolveCredentialId(Map<String, dynamic> item) {
    return (item['credential_id'] ??
            item['CredentialId'] ??
            item['credentialid'] ??
            '')
        .toString();
  }

  static String resolveFirstName(Map<String, dynamic> item) {
    return (item['first_name'] ?? item['firstname'] ?? item['FirstName'] ?? '')
        .toString();
  }

  static String resolveLastName(Map<String, dynamic> item) {
    return (item['last_name'] ?? item['lastname'] ?? item['LastName'] ?? '')
        .toString();
  }

  static String resolveEmail(Map<String, dynamic> item) {
    return (item['email'] ?? item['Email'] ?? '').toString();
  }

  static String resolveSubject(Map<String, dynamic> item) {
    return (item['subject'] ?? item['Subject'] ?? '').toString();
  }

  static String resolveMessage(Map<String, dynamic> item) {
    return (item['message'] ?? item['Message'] ?? '').toString();
  }
}
