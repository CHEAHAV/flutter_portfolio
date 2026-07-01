import '../../api/api.dart';

ContactMe mapContactMe(Map<String, dynamic> item) {
  return ContactMe(
    id         : ApiObject.resolveID(item),
    name       : ApiObject.resolveName(item),
    description: ApiObject.resolveDescription(item),
    icon       : ApiImage.resolveIcon(item),
    contactUrl : ApiUrl.resolveContactUrl(item),
  );
}
