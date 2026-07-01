import '../../api/api.dart';

TeachStack mapTeachStack(Map<String, dynamic> item) {
  return TeachStack(
    nameleft  : ApiObject.resolveNameLeft(item),
    imageleft : ApiImage.resolveImageLeft(item),
    nameright : ApiObject.resolveNameRight(item),
    imageright: ApiImage.resolveImageRight(item),
  );
}
