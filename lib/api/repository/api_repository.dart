import 'package:portfolio/api/repository/career_repository.dart';
import 'package:portfolio/api/repository/certification_repository.dart';
import 'package:portfolio/api/repository/contact_me_repository.dart';
import 'package:portfolio/api/repository/filter_repository.dart';
import 'package:portfolio/api/repository/info_repository.dart';
import 'package:portfolio/api/repository/message_repository.dart';
import 'package:portfolio/api/repository/my_core_repository.dart';
import 'package:portfolio/api/repository/project_repository.dart';
import 'package:portfolio/api/repository/skill_repository.dart';
import 'package:portfolio/api/repository/social_repository.dart';
import 'package:portfolio/api/repository/story_repository.dart';
import 'package:portfolio/api/repository/study_repository.dart';
import 'package:portfolio/api/repository/teach_stack_repository.dart';
import 'package:portfolio/api/core/api_client.dart';
import 'package:portfolio/api/model/api_model.dart';
import 'package:portfolio/routes/api_route.dart';

class ApiRepository {
  final ApiClient apiClient;

  ApiRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();

  Future<ApiModel> loadApiModel() async {
    final [
      career,
      certification,
      contactme,
      filter,
      info,
      mycore,
      project,
      skill,
      social,
      story,
      study,
      teachstack,
      message,
    ] = await Future.wait([
      apiClient.getAllWebsiteList(ApiRoutes.careers),
      apiClient.getAllWebsiteList(ApiRoutes.certifications),
      apiClient.getAllWebsiteList(ApiRoutes.contactMes),
      apiClient.getAllWebsiteList(ApiRoutes.filters),
      apiClient.getAllWebsiteList(ApiRoutes.infos),
      apiClient.getAllWebsiteList(ApiRoutes.myCores),
      apiClient.getAllWebsiteList(ApiRoutes.projects),
      apiClient.getAllWebsiteList(ApiRoutes.skills),
      apiClient.getAllWebsiteList(ApiRoutes.socials),
      apiClient.getAllWebsiteList(ApiRoutes.stories),
      apiClient.getAllWebsiteList(ApiRoutes.studies),
      apiClient.getAllWebsiteList(ApiRoutes.teachStacks),
      apiClient.getAllWebsiteList(ApiRoutes.messages),
    ]);
    return ApiModel(
      career: career.cast<Map<String, dynamic>>().map(mapCareer).toList(),
      certification: certification
          .cast<Map<String, dynamic>>()
          .map(mapCertification)
          .toList(),
      contactme: contactme
          .cast<Map<String, dynamic>>()
          .map(mapContactMe)
          .toList(),
      filter: filter.cast<Map<String, dynamic>>().map(mapFilter).toList(),
      info: info.cast<Map<String, dynamic>>().map(mapInfo).toList(),
      mycore: mycore.cast<Map<String, dynamic>>().map(mapMyCore).toList(),
      project: project.cast<Map<String, dynamic>>().map(mapProject).toList(),
      skill: skill.cast<Map<String, dynamic>>().map(mapSkill).toList(),
      social: social.cast<Map<String, dynamic>>().map(mapSocial).toList(),
      story: story.cast<Map<String, dynamic>>().map(mapStory).toList(),
      study: study.cast<Map<String, dynamic>>().map(mapStudy).toList(),
      teachstack: teachstack
          .cast<Map<String, dynamic>>()
          .map(mapTeachStack)
          .toList(),
      message: message.cast<Map<String, dynamic>>().map(mapMessage).toList(),
    );
  }
}
