enum WebAnchor { home, about, skills, work, career, contact }

class WebNavItem {
  final String id;
  final String label;
  final WebAnchor anchor;

  const WebNavItem({
    required this.id,
    required this.label,
    required this.anchor,
  });
}

const List<WebNavItem> webNavItems = [
  WebNavItem(id: '1', label: 'Home', anchor: WebAnchor.home),
  WebNavItem(id: '2', label: 'About', anchor: WebAnchor.about),
  WebNavItem(id: '3', label: 'Skills', anchor: WebAnchor.skills),
  WebNavItem(id: '4', label: 'Work', anchor: WebAnchor.work),
  WebNavItem(id: '5', label: 'Career', anchor: WebAnchor.career),
  WebNavItem(id: '6', label: 'Contact', anchor: WebAnchor.contact),
];

/// The phone tabs and the named routes still address the site by index, so a
/// deep link such as `/contact` opens the matching section.
WebAnchor webAnchorForTab(int index) {
  switch (index) {
    case 1:
      return WebAnchor.skills;
    case 2:
      return WebAnchor.contact;
    case 3:
      return WebAnchor.about;
    default:
      return WebAnchor.home;
  }
}
