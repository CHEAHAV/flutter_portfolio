import '../../api/api.dart';

Career mapCareer(Map<String, dynamic> item) {
  return Career(
    id         : ApiObject.resolveID(item),
    title      : ApiObject.resolveTitle(item),
    subtitle   : ApiObject.resolveSubTitle(item),
    description: ApiObject.resolveDescription(item),
    date       : ApiObject.resolveDate(item),
  );
}
