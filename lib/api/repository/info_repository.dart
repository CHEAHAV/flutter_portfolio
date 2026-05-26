import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/model/info.dart';

Info mapInfo(Map<String, dynamic> item) => Info(
  id         : ApiObject.resolveID(item),
  name       : ApiObject.resolveName(item),
  description: ApiObject.resolveDescription(item),
  image      : ApiImage.resolveImage(item),
);
