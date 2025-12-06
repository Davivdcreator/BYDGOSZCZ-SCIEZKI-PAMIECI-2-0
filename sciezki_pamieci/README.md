# Bydgoszcz - Ścieżki Pamięci 2.0

Interaktywna aplikacja mobilna przekształcająca zwiedzanie Bydgoszczy w wciągającą przygodę z elementami AR, AI chatbotem i gamifikacją.

## 🎯 O Projekcie

Aplikacja "Ścieżki Pamięci" ożywia pomniki, rzeźby i zabytki Bydgoszczy. Każdy obiekt posiada unikalną "duszę" - AI, z którym można prowadzić rozmowy dostosowane do rangi obiektu.

### System Tier:
- **Tier C (Echa)** - Tablice pamiątkowe, detale - krótkie fakty
- **Tier B (Świadkowie)** - Mosty, kamienice - nostalgiczne opowieści
- **Tier A (Patroni)** - Pomniki postaci - historyczny role-play
- **Tier S (Ikony)** - Łuczniczka, Spichrze - metafizyczne rozmowy

## 🚀 Uruchomienie

### Wymagania
- Flutter SDK 3.0+
- Android Studio / Xcode
- Urządzenie/emulator z Android 6.0+ lub iOS 12+

### Instalacja

```bash
# Wejdź do folderu projektu
cd sciezki_pamieci

# Pobierz zależności
flutter pub get

# Uruchom aplikację
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## 📱 Ekrany

1. **Wrota Czasu** - Onboarding z animowanym logo
2. **Mapa** - Interaktywna mapa OpenStreetMap z markerami
3. **Soczewka Historii** - Widok AR do wykrywania obiektów
4. **Discovery Card** - Karta obiektu przed rozmową
5. **Sweet Spot** - Chat AI z efektem maszyny do pisania
6. **Paszport Odkrywcy** - Profil stylizowany na paszport
7. **Album Pamięci** - Kolekcja odkrytych miejsc
8. **Ścieżki i Odznaczenia** - Wyzwania i nagrody

## 🎨 Design System "Modern Heritage"

- **Tło**: Porcelain White z teksturą papieru czerpanego
- **Panele**: Frosted Glass (mrożone szkło)
- **Akcenty**: Oxidized Copper (miedź bydgoska)
- **Premium**: Old Gold (dla Tier S)

## 📦 Technologie

- Flutter 3.x
- flutter_map (OpenStreetMap)
- google_fonts
- animated_text_kit
- flutter_animate
- provider (state management)

## 📂 Struktura

```
lib/
├── main.dart
├── app.dart
├── theme/
│   ├── app_theme.dart
│   └── tier_colors.dart
├── models/
│   ├── monument.dart
│   ├── badge.dart
│   └── user_profile.dart
├── screens/
│   ├── onboarding_screen.dart
│   ├── map_screen.dart
│   ├── ar_view_screen.dart
│   ├── discovery_card.dart
│   ├── chat_screen.dart
│   ├── profile_screen.dart
│   ├── collection_screen.dart
│   └── quests_screen.dart
├── widgets/
│   ├── frosted_glass_panel.dart
│   ├── copper_button.dart
│   ├── chat_bubble.dart
│   └── map_marker.dart
├── data/
│   └── monuments_data.dart
└── services/
    └── ai_chat_service.dart
```

## 🏆 HackNation 2024

Projekt stworzony na hackathon HackNation dla miasta Bydgoszcz.

**Cel**: Przekształcić pomniki i zabytki Bydgoszczy w interaktywne źródła historyczne.

**Grupa docelowa**: Turyści i młodzież bydgoska.

---

*"Bydgoszcz ma głos. Czy jesteś gotów go usłyszeć?"*
