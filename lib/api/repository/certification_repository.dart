import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/core/api_url.dart';
import 'package:portfolio/api/model/certification.dart';

Certification mapCertification(Map<String, dynamic> item) {
  return Certification(
    id          : ApiObject.resolveID(item),
    name        : ApiObject.resolveName(item),
    title       : ApiObject.resolveTitle(item),
    issuer      : ApiObject.resolveIssuer(item),
    dateEarned  : ApiObject.resolveDateEarned(item),
    credentialId: ApiObject.resolveCredentialId(item),
    certificateurl: ApiUrl.resolveCertificateUrl(item),
    icon        : ApiImage.resolveImage(item),
  );
}
