import 'dart:convert';
import 'dart:io';

/// Run after `flutter build web`. Vercel supplies the production domain;
/// other hosts can pass their public HTTPS URL as the first argument.
void main(List<String> arguments) {
  final environment = Platform.environment;
  final configuredUrl = arguments.isNotEmpty
      ? arguments.first
      : environment['SITE_URL'] ?? environment['VERCEL_PROJECT_PRODUCTION_URL'];
  if (configuredUrl == null || configuredUrl.trim().isEmpty) {
    stderr.writeln('Set SITE_URL or pass the public HTTPS URL as an argument.');
    exitCode = 1;
    return;
  }

  final value = configuredUrl.trim();
  final uri = Uri.tryParse(value.contains('://') ? value : 'https://$value');
  if (uri == null ||
      uri.scheme != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment ||
      (uri.path.isNotEmpty && uri.path != '/')) {
    stderr.writeln(
      'SITE_URL must be a root HTTPS URL without a query or fragment.',
    );
    exitCode = 1;
    return;
  }

  final siteUrl = '${uri.origin}/';
  final imageUrl = '${siteUrl}icons/portfolio.png';
  final index = File('build/web/index.html');
  final marker = RegExp(
    r'<!-- seo:production:start -->.*?<!-- seo:production:end -->',
    dotAll: true,
  );
  var html = index.readAsStringSync();
  if (!marker.hasMatch(html)) {
    throw StateError(
      'SEO marker missing. Rebuild the web app before preparing SEO.',
    );
  }
  const escape = HtmlEscape(HtmlEscapeMode.attribute);
  final safeUrl = escape.convert(siteUrl);
  final structuredData = jsonEncode({
    '@context': 'https://schema.org',
    '@graph': [
      {
        '@type': 'WebSite',
        '@id': '$siteUrl#website',
        'url': siteUrl,
        'name': 'Mr. IT Cheahav | Portfolio',
        'inLanguage': 'en',
        'about': {'@id': '$siteUrl#person'},
      },
      {
        '@type': 'Person',
        '@id': '$siteUrl#person',
        'name': 'Mr. IT Cheahav',
        'jobTitle': 'Mobile App Developer',
        'url': siteUrl,
        'knowsAbout': [
          'Flutter',
          'Mobile application development',
          'Back-end development',
        ],
      },
    ],
  }).replaceAll('<', r'\u003c');
  html = html.replaceFirst(marker, '''<!-- seo:production:start -->
  <link rel="canonical" href="$safeUrl">
  <meta property="og:url" content="$safeUrl">
  <script type="application/ld+json">$structuredData</script>
  <!-- seo:production:end -->''');
  for (final tag in ['property="og:image"', 'name="twitter:image"']) {
    html = html.replaceFirst(
      RegExp('<meta $tag content="[^"]*">'),
      '<meta $tag content="${escape.convert(imageUrl)}">',
    );
  }
  index.writeAsStringSync(html);
  File('assets/icons/portfolio.png').copySync('build/web/icons/portfolio.png');
  File('build/web/robots.txt').writeAsStringSync(
    'User-agent: *\nAllow: /\n\nSitemap: ${siteUrl}sitemap.xml\n',
  );
  // Flutter's hash routes share one HTML document; only index the public root.
  File('build/web/sitemap.xml').writeAsStringSync(
    '''<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>$safeUrl</loc></url>
</urlset>
''',
  );
  stdout.writeln(
    'Prepared canonical URL, social images, structured data, and sitemap for $siteUrl',
  );
}
