import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/api/api.dart' hide Message;
import 'package:portfolio/shared/shared.dart';
import 'package:portfolio/web/web.dart';

ApiModel buildTestApiModel() {
  return const ApiModel(
    career: [
      Career(
        id         : '1',
        title      : 'Mobile Developer',
        subtitle   : 'Innotech',
        description: 'Building production Flutter applications.',
        date       : '2024',
      ),
    ],
    certification: [
      Certification(
        id            : '1',
        name          : 'Flutter Advanced',
        title         : 'Advanced Flutter development',
        issuer        : 'Google',
        dateEarned    : '2024',
        credentialId  : 'ABC-123',
        certificateurl: '',
        icon          : '',
      ),
    ],
    contactme: [
      ContactMe(
        id         : '1',
        name       : 'Email me',
        description: 'hello@itcheahav.dev',
        icon       : '',
        contactUrl : '',
      ),
      ContactMe(
        id         : '2',
        name       : 'Telegram',
        description: '@itcheahav',
        icon       : '',
        contactUrl : 'https://t.me/itcheahav',
      ),
    ],
    info: [
      Info(
        id         : '1',
        name       : 'Mr. IT Cheahav',
        description: 'Junior Mobile App Developer',
        image      : '',
      ),
    ],
    mycore: [
      MyCore(id: '1', name: 'Flutter', description: 'UI toolkit', image: ''),
      MyCore(
        id         : '2',
        name       : 'PostgreSQL',
        description: 'Object-relational database',
        image      : '',
      ),
      MyCore(
        id         : '3',
        name       : 'Python',
        description: 'Backend and automation',
        image      : '',
      ),
    ],
    project: [
      Project(
        id         : '1',
        name       : 'Chamnar Law Firm App',
        description: 'A complete digital transformation for a legal practice.',
        duration   : '6 months',
        role       : 'Lead Developer',
        platform   : 'Flutter, Firebase',
        challenge  : 'Offline first sync',
        image      : '',
        projecturl : '',
      ),
      Project(
        id         : '2',
        name       : 'Logistics Hub',
        description: 'Real-time sale management and logistics tracking.',
        duration   : '4 months',
        role       : 'Developer',
        platform   : 'Dart, API',
        challenge  : 'Realtime updates',
        image      : '',
        projecturl : '',
      ),
      Project(
        id         : '3',
        name       : 'Portfolio Backend',
        description: 'FastAPI service powering this portfolio.',
        duration   : '2 months',
        role       : 'Developer',
        platform   : 'Python',
        challenge  : 'Deployment',
        image      : '',
        projecturl : '',
      ),
    ],
    skill: [
      Skill(
        id         : '1',
        name       : 'Fast API',
        score      : 4.4,
        description: 'Modern, high-performance Python framework for APIs.',
        image      : '',
      ),
      Skill(
        id         : '2',
        name       : 'Flutter',
        score      : 4.5,
        description: 'Google toolkit for natively compiled applications.',
        image      : '',
      ),
      Skill(
        id         : '3',
        name       : 'Java',
        score      : 4.3,
        description: 'Robust, object-oriented language for Android.',
        image      : '',
      ),
      Skill(
        id         : '4',
        name       : 'Python',
        score      : 4.4,
        description: 'Versatile language used for automation and backend.',
        image      : '',
      ),
      Skill(
        id         : '5',
        name       : 'Dart',
        score      : 4.2,
        description: 'Client optimised language for fast apps.',
        image      : '',
      ),
    ],
    social: [
      Social(id: '1', name: 'GitHub', icon: '', socialUrl: 'https://github.com'),
      Social(
        id       : '2',
        name     : 'LinkedIn',
        icon     : '',
        socialUrl: 'https://linkedin.com',
      ),
    ],
    story: [
      Story(
        id         : '1',
        title      : 'Dev Story',
        description:
            'Every great piece of software starts with a single line of code '
            'and a curious mind. For me, that curiosity transformed into a '
            'passion during my time at the Royal University of Phnom Penh.',
        iconname   : 'Story',
        icon       : '',
      ),
      Story(
        id         : '2',
        title      : '',
        description:
            'Pursuing a degree in Computer Science, I learned how to think '
            'like an engineer.',
        iconname   : 'Story',
        icon       : '',
      ),
    ],
    study: [
      Study(
        id         : '1',
        title      : 'Computer Science',
        subtitle   : 'RUPP',
        description: 'Bachelor degree in computer science.',
        date       : '2021',
      ),
    ],
    teachstack: [
      TeachStack(
        nameleft  : 'Mobile',
        imageleft : '',
        nameright : 'Backend',
        imageright: '',
      ),
    ],
    message: [],
    experience: [
      Experience(id: '1', yearexp: '2+', project: '26', commit: '2.3k'),
    ],
  );
}

Widget wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3           : true,
      fontFamily             : 'Geist',
      scaffoldBackgroundColor: AppColors.bgDeep,
      colorScheme: ColorScheme.fromSeed(
        seedColor : AppColors.accent,
        brightness: Brightness.dark,
        surface   : AppColors.bgCard,
      ),
    ),
    home: Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SingleChildScrollView(child: child),
    ),
  );
}

Future<void> pumpAt(
  WidgetTester tester,
  Size size,
  Widget child,
) async {
  tester.view.physicalSize         = size;
  tester.view.devicePixelRatio     = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(wrap(child));
  await tester.pump(const Duration(milliseconds: 1200));
}

Widget fullSite(ApiModel content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      WebHero(
        info        : content.info.first,
        experience  : content.experience,
        story       : content.story,
        socials     : content.social,
        mycore      : content.mycore,
        onContactTap: () {},
        onWorkTap   : () {},
      ),
      WebSection(
        child: WebAbout(
          stories     : content.story,
          study       : content.study,
          career      : content.career,
          teachstack  : content.teachstack,
          onContactTap: () {},
        ),
      ),
      WebSection(
        background: AppColors.bgCard,
        child: WebSkills(
          skills    : content.skill,
          teachstack: content.teachstack,
          onSkillTap: (_) {},
        ),
      ),
      WebSection(
        child: WebWork(projects: content.project, onProjectTap: (_) {}),
      ),
      WebSection(
        background: AppColors.bgCard,
        child: WebCareer(
          study             : content.study,
          career            : content.career,
          certification     : content.certification,
          onCertificationTap: (_) {},
        ),
      ),
      WebSection(
        selectable: false,
        child: WebContactSection(
          contactme: content.contactme,
          socials  : content.social,
        ),
      ),
      WebFooter(
        info       : content.info.first,
        socials    : content.social,
        contactme  : content.contactme,
        onNavigate : (_) {},
        onBackToTop: () {},
      ),
    ],
  );
}

void main() {
  final content = buildTestApiModel();

  const sizes = <String, Size>{
    'narrow tablet': Size(650, 2400),
    'tablet'       : Size(800, 2000),
    'desktop'      : Size(1440, 1400),
    'wide'         : Size(1920, 1400),
  };

  for (final entry in sizes.entries) {
    final label = entry.key;
    final size  = entry.value;

    testWidgets('hero renders on $label', (tester) async {
      await pumpAt(
        tester,
        size,
        WebHero(
          info        : content.info.first,
          experience  : content.experience,
          story       : content.story,
          socials     : content.social,
          mycore      : content.mycore,
          onContactTap: () {},
          onWorkTap   : () {},
        ),
      );

      expect(find.text('Mr. IT Cheahav'), findsOneWidget);
      expect(find.text('Junior Mobile App Developer'), findsOneWidget);
      expect(find.text(webContactMe), findsOneWidget);
      expect(find.text(webViewWork), findsOneWidget);
      expect(find.text('2+'), findsOneWidget);
      expect(find.byType(WebHeroPortrait), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('about renders on $label', (tester) async {
      await pumpAt(
        tester,
        size,
        WebAbout(
          stories     : content.story,
          study       : content.study,
          career      : content.career,
          teachstack  : content.teachstack,
          onContactTap: () {},
        ),
      );

      expect(find.text(webAboutTitle), findsOneWidget);
      expect(find.text(webFactsTitle), findsOneWidget);
      expect(find.text('Mobile Developer'), findsOneWidget);
      expect(find.text('Computer Science'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('skills render on $label', (tester) async {
      await pumpAt(
        tester,
        size,
        WebSkills(
          skills    : content.skill,
          teachstack: content.teachstack,
          onSkillTap: (_) {},
        ),
      );

      expect(find.text(webSkillsTitle), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.byType(WebSkillCard), findsNWidgets(content.skill.length));
      expect(tester.takeException(), isNull);
    });

    testWidgets('work renders on $label', (tester) async {
      await pumpAt(
        tester,
        size,
        WebWork(projects: content.project, onProjectTap: (_) {}),
      );

      expect(find.text(webWorkTitle), findsOneWidget);
      expect(find.text('Chamnar Law Firm App'), findsOneWidget);
      expect(find.text('Logistics Hub'), findsOneWidget);
      expect(
        find.byType(WebProjectRow),
        findsNWidgets(content.project.length),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('career renders on $label', (tester) async {
      await pumpAt(
        tester,
        size,
        WebCareer(
          study             : content.study,
          career            : content.career,
          certification     : content.certification,
          onCertificationTap: (_) {},
        ),
      );

      expect(find.text(webCareerTitle), findsOneWidget);
      expect(find.text(webEducationHeading), findsOneWidget);
      expect(find.text(webCareerHeading), findsOneWidget);
      expect(find.text('Flutter Advanced'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('contact renders on $label', (tester) async {
      await pumpAt(
        tester,
        size,
        WebContactSection(
          contactme: content.contactme,
          socials  : content.social,
        ),
      );

      expect(find.text(webConnectTitle), findsOneWidget);
      expect(find.text(webFormTitle), findsOneWidget);
      expect(find.text('hello@itcheahav.dev'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('nav bar renders on $label', (tester) async {
      await pumpAt(
        tester,
        size,
        WebNavBar(
          activeAnchor: WebAnchor.home,
          onNavigate  : (_) {},
          contactme   : content.contactme,
          scrolled    : true,
          progress    : 0.35,
        ),
      );

      expect(find.text(webBrand), findsOneWidget);
      for (final item in webNavItems) {
        expect(find.text(item.label), findsOneWidget);
      }
      expect(find.text(webResume), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('footer renders on $label', (tester) async {
      await pumpAt(
        tester,
        size,
        WebFooter(
          info       : content.info.first,
          socials    : content.social,
          contactme  : content.contactme,
          onNavigate : (_) {},
          onBackToTop: () {},
        ),
      );

      expect(find.text(webBackToTop), findsOneWidget);
      expect(find.textContaining('Built with precision'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the whole site lays out on $label', (tester) async {
      await pumpAt(tester, size, fullSite(content));

      expect(find.text('Mr. IT Cheahav'), findsWidgets);
      expect(find.text(webSkillsTitle), findsOneWidget);
      expect(find.text(webWorkTitle), findsOneWidget);
      expect(find.text(webCareerTitle), findsOneWidget);
      expect(find.text(webFormTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  test('breakpoints map widths to the right device', () {
    expect(Breakpoints.of(390), DeviceType.mobile);
    expect(Breakpoints.of(649), DeviceType.mobile);
    expect(Breakpoints.of(650), DeviceType.tablet);
    expect(Breakpoints.of(1099), DeviceType.tablet);
    expect(Breakpoints.of(1100), DeviceType.desktop);
  });

  test('named routes map to the matching site section', () {
    expect(webAnchorForTab(0), WebAnchor.home);
    expect(webAnchorForTab(1), WebAnchor.skills);
    expect(webAnchorForTab(2), WebAnchor.contact);
    expect(webAnchorForTab(3), WebAnchor.about);
  });
}
