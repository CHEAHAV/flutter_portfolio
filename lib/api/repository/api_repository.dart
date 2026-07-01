import '../../api/api.dart';
import '../../routes/route.dart';

class ApiRepository {
  final ApiClient apiClient;

  ApiRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();

  Future<ApiModel> loadApiModel() async {
    final [
      careerResult,
      certificationResult,
      contactmeResult,
      infoResult,
      mycoreResult,
      projectResult,
      skillResult,
      socialResult,
      storyResult,
      studyResult,
      teachstackResult,
      messageResult,
      experienceResult,
    ] = await Future.wait([
      _loadSection('careers', ApiRoutes.careers),
      _loadSection('certifications', ApiRoutes.certifications),
      _loadSection('contact-mes', ApiRoutes.contactMes),
      _loadSection('infos', ApiRoutes.infos),
      _loadSection('my-cores', ApiRoutes.myCores),
      _loadSection('projects', ApiRoutes.projects),
      _loadSection('skills', ApiRoutes.skills),
      _loadSection('socials', ApiRoutes.socials),
      _loadSection('stories', ApiRoutes.stories),
      _loadSection('studies', ApiRoutes.studies),
      _loadSection('teach-stacks', ApiRoutes.teachStacks),
      _loadSection('messages', ApiRoutes.messages),
      _loadSection('experience', ApiRoutes.experience),
    ]);

    final results = [
      careerResult,
      certificationResult,
      contactmeResult,
      infoResult,
      mycoreResult,
      projectResult,
      skillResult,
      socialResult,
      storyResult,
      studyResult,
      teachstackResult,
      messageResult,
      experienceResult,
    ];

    if (results.every((result) => !result.loaded)) {
      throw ApiException(
        'Unable to load backend data: '
        '${results.map((result) => result.error).whereType<String>().join(', ')}',
      );
    }

    if (!experienceResult.loaded) {
      throw ApiException(
        'Unable to load experience data: ${experienceResult.error}',
      );
    }

    return ApiModel(
      career       : _mapItems(careerResult.items, mapCareer),
      certification: _mapItems(certificationResult.items, mapCertification),
      contactme    : _mapItems(contactmeResult.items, mapContactMe),
      info         : _mapItems(infoResult.items, mapInfo),
      mycore       : _mapItems(mycoreResult.items, mapMyCore),
      project      : _mapItems(projectResult.items, mapProject),
      skill        : _mapItems(skillResult.items, mapSkill),
      social       : _mapItems(socialResult.items, mapSocial),
      story        : _mapItems(storyResult.items, mapStory),
      study        : _mapItems(studyResult.items, mapStudy),
      teachstack   : _mapItems(teachstackResult.items, mapTeachStack),
      message      : _mapItems(messageResult.items, mapMessage),
      experience   : _mapItems(experienceResult.items, mapExperience),
    );
  }

  Future<_SectionResult> _loadSection(String name, String path) async {
    try {
      return _SectionResult.loaded(await apiClient.getAllWebsiteList(path));
    } catch (error) {
      return _SectionResult.failed('$name: $error');
    }
  }

  List<T> _mapItems<T>(
    List<Map<String, dynamic>> items,
    T Function(Map<String, dynamic>) mapper,
  ) {
    return items
        .map((item) {
          try {
            return mapper(item);
          } catch (_) {
            return null;
          }
        })
        .whereType<T>()
        .toList();
  }
}

class _SectionResult {
  const _SectionResult({required this.loaded, required this.items, this.error});

  factory _SectionResult.loaded(List<Map<String, dynamic>> items) {
    return _SectionResult(loaded: true, items: items);
  }

  factory _SectionResult.failed(String error) {
    return _SectionResult(loaded: false, items: const [], error: error);
  }

  final bool loaded;
  final List<Map<String, dynamic>> items;
  final String? error;
}
