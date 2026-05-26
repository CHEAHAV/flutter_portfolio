# portfolio

A new Flutter project.

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
