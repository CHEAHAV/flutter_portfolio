import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/core/api_url.dart';
import 'package:portfolio/api/model/social.dart';

Social mapSocial(Map<String, dynamic> item) => Social(
  id       : ApiObject.resolveID(item),
  name     : ApiObject.resolveName(item),
  icon     : ApiImage.resolveIcon(item),
  socialUrl: ApiUrl.resolveSocialUrl(item),
);
