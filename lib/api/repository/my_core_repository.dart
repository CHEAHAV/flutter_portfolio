import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/model/my_core.dart';

MyCore mapMyCore(Map<String, dynamic> item) => MyCore(
  id         : ApiObject.resolveID(item),
  name       : ApiObject.resolveName(item),
  description: ApiObject.resolveDescription(item),
  image      : ApiImage.resolveImage(item),
);
