import '../../api/api.dart';

Certification mapCertification(Map<String, dynamic> item) {
  return Certification(
    id            : ApiObject.resolveID(item),
    name          : ApiObject.resolveName(item),
    title         : ApiObject.resolveTitle(item),
    issuer        : ApiObject.resolveIssuer(item),
    dateEarned    : ApiObject.resolveDateEarned(item),
    credentialId  : ApiObject.resolveCredentialId(item),
    certificateurl: ApiUrl.resolveCertificateUrl(item),
    icon          : ApiImage.resolveImage(item),
  );
}
