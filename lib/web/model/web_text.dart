import '../../api/api.dart';

// ── Navigation ──────────────────────────────────────────────
const String webBrand        = 'PORTFOLIO';
const String webResume       = 'Resume';
const String webEmailTooltip = 'Email';
const String webBackToTop    = 'Back to top';

// ── Hero ────────────────────────────────────────────────────
const String webHelloLabel   = '// Hello, world.';
const String webAvailable    = 'Available for new projects';
const String webContactMe    = 'Get in touch';
const String webViewWork     = 'View my work';
const String webScrollHint   = 'SCROLL';

// ── About ───────────────────────────────────────────────────
const String webAboutLabel    = '// About me';
const String webAboutTitle    = 'The developer behind the code';
const String webFactsTitle    = 'At a glance';
const String webFactCurrent   = 'Currently';
const String webFactEducation = 'Education';
const String webFactFocus     = 'Focus';
const String webAboutMore     = 'Read the full story';
const String webAboutLess     = 'Show less';

// ── Skills ──────────────────────────────────────────────────
const String webSkillsLabel = '// Technical stack';
const String webSkillsTitle = 'My core competencies';
const String webSkillsLead  =
    'The tools I reach for every day, rated by how much production work I '
    'have shipped with each one.';

// ── Work ────────────────────────────────────────────────────
const String webWorkLabel     = '// Selected work';
const String webWorkTitle     = 'Featured projects';
const String webWorkLead      =
    'A closer look at the products I have designed, built and shipped.';
const String webWorkAction    = 'View case study';
const String webWorkLive      = 'Live project';
const String webMetaDuration  = 'Duration';
const String webMetaRole      = 'Role';
const String webMetaPlatform  = 'Platform';

// ── Career ──────────────────────────────────────────────────
const String webCareerLabel      = '// Journey';
const String webCareerTitle      = 'Education & experience';
const String webCareerLead       =
    'Where I studied, where I have worked, and what I have earned along the '
    'way.';
const String webEducationHeading = 'Education';
const String webCareerHeading    = 'Experience';
const String webCertHeading      = 'Certifications';
const String webCertAction       = 'View credential';
const String webCredentialLabel  = 'ID';

// ── Contact ─────────────────────────────────────────────────
const String webContactLabel  = '// Get in touch';
const String webContactLead   =
    'Have a project in mind, a role to fill, or just want to say hello? '
    'The form goes straight to my inbox.';
const String webFormTitle     = 'Send a message';
const String webConnectTitle  = 'Connect directly';
const String webFollowTitle   = 'Find me online';

// ── Footer ──────────────────────────────────────────────────
const String webFooterNote  = 'Built with Flutter code.';
const String webFooterLinks = 'Navigate';
const String webFooterReach = 'Reach me';

// ── Fallbacks ───────────────────────────────────────────────
const String webNoProject = 'No backend project yet.';
const String webNoSkill   = 'No backend skill yet.';
const String webLinkError = 'Could not open this contact link';

/// Short hero paragraph taken from the same backend story the phone shows.
/// Cuts on a sentence boundary so the hero never ends mid-thought.
String webHeroBlurb(List<Story> stories, {int maxLength = 240}) {
  if (stories.isEmpty) return '';

  final text = stories.first.description.trim();
  if (text.length <= maxLength) return text;

  final cut     = text.substring(0, maxLength);
  final lastEnd = cut.lastIndexOf(RegExp(r'[.!?]'));
  if (lastEnd >= maxLength * 0.5) {
    return cut.substring(0, lastEnd + 1);
  }

  final lastSpace = cut.lastIndexOf(' ');
  return '${lastSpace > 0 ? cut.substring(0, lastSpace) : cut}…';
}

/// Platform / role chips rendered on a project card.
List<String> webProjectTags(Project project) {
  final raw = [project.platform, project.role]
      .expand((value) => value.split(RegExp(r'[,/|]')))
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList();

  final tags = <String>[];
  for (final tag in raw) {
    if (!tags.any((item) => item.toLowerCase() == tag.toLowerCase())) {
      tags.add(tag);
    }
    if (tags.length == 3) break;
  }
  return tags;
}

/// Two digit counter shown beside a project, e.g. `01`.
String webIndexLabel(int index) => (index + 1).toString().padLeft(2, '0');

bool webIsEmailContact(ContactMe item) {
  final name        = item.name.toLowerCase();
  final description = item.description.toLowerCase();
  final url         = item.effectiveContactUrl.toLowerCase();

  return name.contains('email') ||
      name.contains('mail') ||
      description.contains('@') ||
      url.startsWith('mailto:') ||
      url.contains('mail.google.com');
}
