import '../../api/api.dart';

MyCore mapMyCore(Map<String, dynamic> item) => MyCore(
  id         : ApiObject.resolveID(item),
  name       : ApiObject.resolveName(item),
  description: ApiObject.resolveDescription(item),
  image      : ApiImage.resolveImage(item),
);
