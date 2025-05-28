# gnb_flutter_task

#  Property Listing App

A cross-platform **Flutter** application for browsing and managing real estate property listings. This app includes features such as filtering, viewing property details, push notifications, local analytics tracking, and charts for insights.

##  Features

- Home, Properties, and Analytics tabs for easy navigation
- Filter properties by price, location, status, and tags
- Analytics screen with chart visualizations using `fl_chart`
- Infinite scroll with pagination
- Capture images using device camera (via `image_picker`)
- Firebase Cloud Messaging for push notifications
- Local analytics tracking
- State management using BLoC pattern
- Local notification support

---

##  Dependencies

| Package                    | Description                                  |
|---------------------------|----------------------------------------------|
| `flutter_bloc`            | BLoC pattern for state management            |
| `dio`                     | Powerful HTTP client for API calls           |
| `shared_preferences`      | Local storage for filters/preferences        |
| `firebase_core`           | Required for initializing Firebase           |
| `firebase_messaging`      | FCM for push notifications                   |
| `flutter_local_notifications` | Local notifications on Android/iOS       |
| `image_picker`            | Pick images from camera/gallery              |
| `path_provider`           | File system paths                            |
| `json_annotation`         | JSON model annotations                       |
| `fl_chart`                | Beautiful chart library for data visualizations |
| `cupertino_icons`         | iOS-style icons                              |

### Dev

| Package            | Description                                |
|--------------------|--------------------------------------------|
| `flutter_test`     | Unit testing support                       |
| `build_runner`     | Code generation for JSON models            |
| `json_serializable`| Converts JSON to Dart models and back      |

---

## Getting Started

### Prerequisites

- Flutter SDK
- Firebase project (for notifications)

### Installation

```bash
git clone https://github.com/ShanjeevEswaramoorthy/gnb_flutter_task/tree/main
flutter pub get
