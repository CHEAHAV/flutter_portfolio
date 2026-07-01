import '../../api/api.dart';

Social mapSocial(Map<String, dynamic> item) => Social(
  id       : ApiObject.resolveID(item),
  name     : ApiObject.resolveName(item),
  icon     : ApiImage.resolveIcon(item),
  socialUrl: ApiUrl.resolveSocialUrl(item),
);
