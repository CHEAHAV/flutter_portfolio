import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/model/skill.dart';

Skill mapSkill(Map<String, dynamic> item) => Skill(
  id         : ApiObject.resolveID(item),
  name       : ApiObject.resolveName(item),
  score      : ApiObject.resolveScore(item),
  description: ApiObject.resolveDescription(item),
  image      : ApiImage.resolveImage(item),
);
