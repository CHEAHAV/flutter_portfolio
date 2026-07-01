import '../../api/api.dart';

Skill mapSkill(Map<String, dynamic> item) => Skill(
  id         : ApiObject.resolveID(item),
  name       : ApiObject.resolveName(item),
  score      : ApiObject.resolveScore(item),
  description: ApiObject.resolveDescription(item),
  image      : ApiImage.resolveImage(item),
);
