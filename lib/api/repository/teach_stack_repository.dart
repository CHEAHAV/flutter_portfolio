import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/model/teach_stack.dart';

TeachStack mapTeachStack(Map<String, dynamic> item) {
  return TeachStack(
    nameleft  : ApiObject.resolveNameLeft(item),
    imageleft : ApiImage.resolveImageLeft(item),
    nameright : ApiObject.resolveNameRight(item),
    imageright: ApiImage.resolveImageRight(item),
  );
}
