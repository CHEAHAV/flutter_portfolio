import '../../api/api.dart';

Info mapInfo(Map<String, dynamic> item) => Info(
  id         : ApiObject.resolveID(item),
  name       : ApiObject.resolveName(item),
  description: ApiObject.resolveDescription(item),
  image      : ApiImage.resolveImage(item),
);
