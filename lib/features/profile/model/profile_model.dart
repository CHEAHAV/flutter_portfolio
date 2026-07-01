import '../../../api/api.dart';

class ProfileExperienceStat {
  final String title;
  final String data;

  const ProfileExperienceStat({required this.title, required this.data});
}

List<ProfileExperienceStat> buildExperienceStats(List<Experience> items) {
  final item = items.isNotEmpty ? items.first : null;

  return [
    ProfileExperienceStat(title: 'years Exp', data: item?.yearexp ?? '0'),
    ProfileExperienceStat(title: 'Project', data: item?.project ?? '0'),
    ProfileExperienceStat(title: 'Commits', data: item?.commit ?? '0'),
  ];
}
