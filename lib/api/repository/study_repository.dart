import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/model/study.dart';

Study mapStudy(Map<String, dynamic> item) {
  return Study(
    id         : ApiObject.resolveID(item),
    title      : ApiObject.resolveTitle(item),
    subtitle   : ApiObject.resolveSubTitle(item),
    description: ApiObject.resolveDescription(item),
    date       : ApiObject.resolveDate(item),
  );
}
