import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/core/api_url.dart';
import 'package:portfolio/api/model/contact_me.dart';

ContactMe mapContactMe(Map<String, dynamic> item) {
  return ContactMe(
    id         : ApiObject.resolveID(item),
    name       : ApiObject.resolveName(item),
    description: ApiObject.resolveDescription(item),
    icon       : ApiImage.resolveIcon(item),
    contactUrl : ApiUrl.resolveContactUrl(item),
  );
}
