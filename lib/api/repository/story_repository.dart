import '../../api/api.dart';

Story mapStory(Map<String, dynamic> item) => Story(
  id         : ApiObject.resolveID(item),
  title      : ApiObject.resolveTitle(item),
  description: ApiObject.resolveDescription(item),
  iconname   : ApiObject.resolveIconName(item),
  icon       : ApiImage.resolveIcon(item),
);
