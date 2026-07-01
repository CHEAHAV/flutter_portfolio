import '../../api/api.dart';

Project mapProject(Map<String, dynamic> item) {
  return Project(
    id         : ApiObject.resolveID(item),
    name       : ApiObject.resolveName(item),
    description: ApiObject.resolveDescription(item),
    duration   : ApiObject.resolveDuration(item),
    role       : ApiObject.resolveRole(item),
    platform   : ApiObject.resolvePlatform(item),
    challenge  : ApiObject.resolveChallenge(item),
    projecturl : ApiUrl.resolveProjectUrl(item),
    image      : ApiImage.resolveImage(item),
  );
}
