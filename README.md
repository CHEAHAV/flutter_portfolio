# portfolio

Mr. IT Cheahav's portfolio of Flutter mobile apps, back-end projects, skills, and experience.

## Web branding and SEO

The browser, installed web app, and social sharing previews use
`assets/icons/portfolio.png`. The original artwork is also copied to
`web/icons/portfolio.png` so previews are available without running Flutter.
The SEO preparation step publishes the same artwork at
`/social/portfolio-preview-v2.png` and uses its absolute URL for Open Graph and
Twitter previews. This dedicated filename avoids reusing an older cached icon
when a crawler fetches fresh metadata. Increment the filename in
`tool/prepare_web_seo.dart` when replacing the preview artwork.

Social previews use `Mr. IT Cheahav` as the site name and
`Mobile App Developer Portfolio` as the headline. The description explains the
work without repeating the name. Search/browser and Twitter titles include the
name once: `Mr. IT Cheahav | Mobile App Developer`. Keep the Flutter app title,
HTML title, web manifest, and WebSite structured data aligned when rebranding.

To regenerate the web icons after changing the artwork:

```powershell
dart run flutter_launcher_icons -f flutter_launcher_icons-web.yaml
Copy-Item assets/icons/portfolio.png web/icons/portfolio.png
```

Vercel's build command prepares the canonical URL, absolute social image URLs,
WebSite/Person structured data, robots.txt, and sitemap.xml automatically using
`VERCEL_PROJECT_PRODUCTION_URL`. Set `SITE_URL` to your preferred public HTTPS
origin if you want to override that domain. Enable Vercel's system environment
variables for this build step.

For another host, build and then supply the actual public URL:

```powershell
flutter build web --release
dart run tool/prepare_web_seo.dart https://your-portfolio-domain.com
```

Deploy the resulting `build/web` directory. The sitemap lists the homepage;
Flutter's hash routes are not separate indexable HTML pages. Project-specific
search results would require pages with their own crawlable content and metadata.
The HTML includes a visible introduction while Flutter loads, and the app keeps
the same descriptive browser title after startup.

After deployment, verify `/robots.txt`, `/sitemap.xml`, and
`/social/portfolio-preview-v2.png`,
then submit the sitemap in Google Search Console. Existing search results and
social previews may retain cached artwork until they are crawled again.
After deploying metadata changes, refresh the URL through Telegram's
`@WebpageBot` and share the original homepage URL again. No query string is
required. Changing website files cannot clear Telegram's stored page preview;
the bot must refetch the original URL. Existing messages may continue to show
cached cards.

## Connect to the backend on a real phone

1. Make sure your computer and phone are on the same Wi-Fi.
2. From the project root, run the backend:

```powershell
.\run_backend_wifi.ps1
```

3. In a second terminal, run the Flutter app:

```powershell
.\run_frontend_phone.ps1
```

The app reads `API_BASE_URL` from `--dart-define`. If you run Flutter manually,
use:

```powershell
flutter run --dart-define="API_BASE_URL=http://YOUR_COMPUTER_WIFI_IP:8000"
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
