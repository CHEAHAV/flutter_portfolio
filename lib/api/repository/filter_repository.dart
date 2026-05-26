import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/model/filter.dart';

Filter mapFilter(Map<String, dynamic> item) {
  return Filter(
    id  : ApiObject.resolveID(item),
    name: ApiObject.resolveName(item),
  );
}
