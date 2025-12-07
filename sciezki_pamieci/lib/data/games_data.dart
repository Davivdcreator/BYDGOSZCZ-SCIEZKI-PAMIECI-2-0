import '../models/game.dart';

/// Static data containing all available city exploration games
class GamesData {
  static const List<Game> games = [
    Game(
      id: 'game_01_bike_meridian',
      title: 'Wzdłuż 18. Południka: Rowerem przez Dzieje',
      time: '120 min',
      location: 'Stary Rynek -> Gdańska -> Myślęcinek',
      categories: ['Rower', 'Przyroda', 'Historia'],
      shortDescription:
          'Rowerowa przygoda przez secesyjne kamienice, zielone Myślęcinek i dziki brzeg Wisły.',
      description:
          'Wyrusz w podróż rowerową wzdłuż 18. południka – osi łączącej historię z przyrodą. Start przy Starym Rynku, następnie ulicą Gdańską przez secesyjne kamienice "Małego Berlina". W Myślęcinku (największy park miejski w Polsce!) wybierz trasę: relaksowe aleje lub leśne ścieżki. Cel: Górka Myślęcińska w Ogrodzie Botanicznym. Hardcore Mode: przedłuż trasę do Starego Fordonu nad Wisłą (~12 km).',
      imagePath: 'assets/images/woman-8368830_1920.jpg',
    ),
    Game(
      id: 'game_02_youth_alternative',
      title: 'Betonowe Płótno: Szlak Alternatywny',
      time: '90 min',
      location: 'Śródmieście -> Londynek -> Dworcowa',
      categories: ['Sztuka', 'Ze znajomymi', 'Kultura'],
      shortDescription:
          'Odkryj ukryte murale, legendę Yass i pruskie koszary – autentyczna Bydgoszcz off the beaten path.',
      description:
          'To polowanie na ukrytą sztukę miejską, nie wycieczka szkolna. Znajdź Pomnik Wędrowca, kultowe murale (Piotruś Pan, Zamilcz), legendarny klub Mózg – kolebkę Yass. Wejdź do Londynka: XIX-wieczne pruskie koszary z czerwonej cegły, murale w negatywie, ogrody społeczne. Gra na spostrzegawczość – szukaj tagów, wlepek i detali tworzących współczesną tkankę miasta.',
      imagePath: 'assets/images/dluga-street-903730_1280.jpg',
      badge: 'Hot',
    ),
    Game(
      id: 'game_03_youth_lifestyle',
      title: 'Industrial Chill: Kawiarniany Archipelag',
      time: '120 min',
      location: 'Wyspa Młyńska -> Długa -> Gimnazjalna -> Gdańska',
      categories: ['Fotografia', 'Spacer', 'Relaks'],
      shortDescription:
          'Instagramowe miejsca, Wielkie Krzesła, rzeźby i latte art – Bydgoszcz w stylu chill.',
      description:
          'Vibe check najmodniejszych zakątków miasta. Start: Wyspa Młyńska – zrób selfie przy Wielkich Krzesłach i 18. Południku. Bydgoskie Autografy na Długiej, neony Landschaftu, Ławeczka Rejewskiego. Zdobywaj punkty za kreatywne zdjęcia z rzeźbami i znajdowanie unikatowych pozycji w kawiarnianych menu.',
      imagePath: 'assets/images/mill-island-904001_1280.jpg',
    ),
    Game(
      id: 'game_04_walking_legend',
      title: 'Kod Mistrza Twardowskiego: Tajemnice Starego Miasta',
      time: '100 min',
      location:
          'Stary Rynek -> Mostowa -> Wyspa Młyńska -> Park Kazimierza Wielkiego',
      categories: ['Historia', 'Zagadki', 'Rodzinny'],
      shortDescription:
          'Wyścig z czasem do Mistrza Twardowskiego, historyczne zagadki i magiczna Fontanna Potop.',
      description:
          'Wyścig z czasem! Dotrzeć na Stary Rynek 15 przed 13:13 (lub 21:13), by spotkać Mistrza Twardowskiego. Makieta dawnej Bydgoszczy, rzeźba Przechodzącego przez Rzekę, Trzy Gracje nad Brdą. Finał: majestatyczna Fontanna Potop. Rozwiązuj zagadki, zbieraj cyfry z dat na pomnikach i złam szyfr czarnoksiężnika!',
      imagePath: 'assets/images/fontanna-ptop-904161_1280.jpg',
      badge: 'Najlepiej oceniane',
    ),
  ];

  /// Get all unique categories from games
  static List<String> getAllCategories() {
    final categories = <String>{};
    for (final game in games) {
      categories.addAll(game.categories);
    }
    return categories.toList()..sort();
  }

  /// Filter games by category
  static List<Game> filterByCategory(String category) {
    return games.where((game) => game.categories.contains(category)).toList();
  }
}
