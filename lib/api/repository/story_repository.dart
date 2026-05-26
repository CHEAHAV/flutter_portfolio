import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/model/story.dart';

Story mapStory(Map<String, dynamic> item) => Story(
  id         : ApiObject.resolveID(item),
  title      : ApiObject.resolveTitle(item),
  description: ApiObject.resolveDescription(item),
  iconname   : ApiObject.resolveIconName(item),
  icon       : ApiImage.resolveIcon(item),
);
