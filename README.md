# Workly

**Workly** is a project for managing employees and daily work, available as a **mobile app** and **web app**. It aims to simplify employee attendance tracking, salary management, and detailed reporting in an easy and smooth way.

---

## Features

- Employee login and profile display.
- Attendance management and working hours calculation.
- Automatic monthly salary release.
- Attendance and salary reports for each employee.
- Easy-to-use interface for both web and mobile.
- Multi-language support (expandable).
- Notifications and alerts when salaries are released or status is updated.

---

## Technologies Used

### Mobile
- **Framework:** Flutter
- **State Management:** BLoC / Cubit
- **Backend:** Firebase Firestore & Firebase Auth
- **Localization:** `flutter_localizations`
- **Key Packages:**
  - `geolocator` for location tracking
  - `month_picker_dialog` for selecting months
  - `firebase_storage` for image management
  - `auto_route` for navigation between screens

### Web
- **Frontend:** HTML, CSS, JavaScript
- **Backend:** Firebase Firestore & Firebase Auth
- **Deployment:** Firebase Hosting

---

## Project Structure

Workly/
├── mobile/ # Flutter mobile app
│ ├── lib/
│ │ ├── screens/
│ │ ├── cubits/
│ │ ├── models/
│ │ ├── widgets/
│ │ └── main.dart
├── web/ # Web app
│ ├── index.html
│ ├── styles.css
│ └── app.js
└── README.md

1. Make sure [Flutter SDK](https://flutter.dev/docs/get-started/install) and [Android Studio / VSCode] are installed.
2. Open the project:
   ```bash
   cd mobile
   flutter pub get
