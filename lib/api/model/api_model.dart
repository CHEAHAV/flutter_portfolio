import '../../api/api.dart';

class ApiModel {
  final List<Career> career;
  final List<Certification> certification;
  final List<ContactMe> contactme;
  final List<Info> info;
  final List<MyCore> mycore;
  final List<Project> project;
  final List<Skill> skill;
  final List<Social> social;
  final List<Story> story;
  final List<Study> study;
  final List<TeachStack> teachstack;
  final List<Message> message;
  final List<Experience> experience;

  const ApiModel({
    required this.career,
    required this.certification,
    required this.contactme,
    required this.info,
    required this.mycore,
    required this.project,
    required this.skill,
    required this.social,
    required this.story,
    required this.study,
    required this.teachstack,
    required this.message,
    required this.experience,
  });

  bool get isEmpty {
    return career.isEmpty &&
        certification.isEmpty &&
        contactme.isEmpty &&
        info.isEmpty &&
        mycore.isEmpty &&
        project.isEmpty &&
        skill.isEmpty &&
        social.isEmpty &&
        story.isEmpty &&
        study.isEmpty &&
        teachstack.isEmpty &&
        message.isEmpty &&
        experience.isEmpty;
  }
}
