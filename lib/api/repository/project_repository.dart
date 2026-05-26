import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/model/project.dart';

Project mapProject(Map<String, dynamic> item) {
  return Project(
    id         : ApiObject.resolveID(item),
    name       : ApiObject.resolveName(item),
    description: ApiObject.resolveDescription(item),
    duration   : ApiObject.resolveDuration(item),
    role       : ApiObject.resolveRole(item),
    platform   : ApiObject.resolvePlatform(item),
    challenge  : ApiObject.resolveChallenge(item),
    image      : ApiImage.resolveImage(item),
  );
}
