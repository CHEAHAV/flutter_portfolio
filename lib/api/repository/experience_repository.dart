import '../../api/api.dart';

Experience mapExperience(Map<String, dynamic> item) {
  return Experience(
    id     : ApiObject.resolveID(item),
    yearexp: ApiObject.resolveYearExp(item),
    project: ApiObject.resolveProject(item),
    commit : ApiObject.resolveCommit(item),
  );
}
