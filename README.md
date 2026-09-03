# 🎵 Jamendo Music Player

A Flutter music player app built with the Jamendo Music API — browse tracks, search, paginated infinite scroll, and full audio playback (play/pause/seek/next/previous).

---

## ✨ Features

- 🎧 Browse & search tracks via the Jamendo API
- ⏬ Infinite scroll pagination (load more on scroll, duplicate-request safe)
- ▶️ Full playback controls — play/pause, next/previous, seek bar
- 🎚️ Mini player + full Now Playing screen
- 🌗 Light & Dark theme support
- ⚠️ Loading, error, and empty states handled throughout
- 🎨 Clean, modern Material UI

---

## 🛠️ Built With

- **Flutter** / **Dart**
- **flutter_riverpod** – State management
- **just_audio** – Audio playback
- **http** – Jamendo API integration
- **cached_network_image** – Artwork loading & caching
- **flutter_dotenv** – API config via `.env`

---

## 📂 Project Structure

```plaintext
lib/
├── main.dart
├── core/
│ └── constants/api_constants.dart      # base URL, client ID, endpoint builders
├── data/
│ ├── models/                           # Track, TracksResponse
│ └── services/jamendo_service.dart     # API calls + error handling
├── provider/
│ ├── track_list_provider.dart          # browse/search + pagination state
│ └── player_provider.dart              # playback state (wraps just_audio)
├── screens/
│ ├── home_screen.dart
│ └── now_playing_screen.dart
├── widget/
│ ├── track_tile.dart
│ ├── mini_player.dart
│ └── custom_search_bar.dart
├── theme/
│ └── theme.dart
└── utils/
  └── formatters.dart                   # duration formatting (mm:ss)
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code
- Emulator or physical device

### API Configuration
Create a `.env` file in the project root (see `.env.example`):
```
CLIENT_ID=bc66595a
```
`.env` is gitignored — never committed. `ApiConstants` reads the client ID from it at runtime via `flutter_dotenv`.

### Run the App
```bash
flutter pub get
flutter run
```

---

## 🧠 Architecture & State Management

- **State management:** Riverpod (`Notifier`/`NotifierProvider`) throughout.
- **`TrackListNotifier`** — handles both browsing and searching (single active mode via internal `_activeQuery`), tracks `offset`/`isLoadingMore`/`hasReachedEnd` for pagination, and guards against duplicate requests near the scroll threshold.
- **`PlayerNotifier`** — wraps a single `just_audio` player instance, exposes `position`/`duration`/`isPlaying` as reactive state via stream listeners, holds its own playlist snapshot so playback is decoupled from whatever list is on screen, and auto-advances on track completion.
- Layers are one-directional: screens → providers → services/models — so UI and networking code stay independent of each other.

---

## 📝 Notes

- Offline caching (bonus) was not implemented due to time constraints.
- Home screen uses a single-column list rather than a responsive grid — a straightforward extension if needed later.