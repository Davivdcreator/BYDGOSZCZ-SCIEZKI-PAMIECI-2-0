import 'package:latlong2/latlong.dart';
import '../models/monument.dart';
import '../models/badge.dart';
import '../theme/tier_colors.dart';

class MonumentsData {
  static const List<Monument> monuments = [
    Monument(
      id: 'luczniczka',
      name: 'Łuczniczka',
      description:
          'Jeden z najbardziej rozpoznawalnych symboli Bydgoszczy. Rzeźba Ferdinanda Lepckego z 1910 roku, przedstawiająca nagą kobietę napinającą łuk. Przez lata budziła kontrowersje, dziś jest ikoną miasta.',
      shortDescription: 'Symbol miasta nad Brdą',
      location: LatLng(53.1218, 18.0065),
      tier: MonumentTier.tierS,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Luczniczka_Bydgoszcz_2.jpg/800px-Luczniczka_Bydgoszcz_2.jpg',
      year: 1910,
      architect: 'Ferdinand Lepcke',
      style: 'Realizm / Neoklasycyzm',
      tags: ['Rzeźba', 'Symbol', 'Park'],
      aiPersonality:
          'Dostojna, poetycka, nieco tajemnicza. Mówi o dążeniu do celu i pięknie.',
      sampleQuestions: [
        'Do czego celujesz?',
        'Co widziałaś przez te wszystkie lata?',
        'Dlaczego stoisz właśnie tutaj?'
      ],
    ),
    Monument(
      id: 'kazimierz_wielki',
      name: 'Pomnik Kazimierza Wielkiego',
      description:
          'Pomnik króla, który nadał Bydgoszczy prawa miejskie w 1346 roku. Przedstawia monarchę na koniu, trzymającego akt lokacyjny.',
      shortDescription: 'Król na koniu',
      location: LatLng(53.1210, 17.9980),
      tier: MonumentTier.tierA,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/8/8c/Pomnik_Kazimierza_Wielkiego_w_Bydgoszczy.jpg',
      year: 2006,
      architect: 'Mariusz Białecki',
      style: 'Monumentalny',
      tags: ['Król', 'Historia', 'Koń'],
      aiPersonality:
          'Władczy, dymny, ale ojcowski. Opowiada o historii Polski i budowaniu miasta.',
      sampleQuestions: [
        'Dlaczego nadałeś prawa miejskie Bydgoszczy?',
        'Jak wyglądała Polska za Twoich czasów?',
      ],
    ),
    Monument(
      id: 'spichrze',
      name: 'Spichrze nad Brdą',
      description:
          'Zabytkowe spichlerze zbożowe, będące symbolem handlowej historii Bydgoszczy. Dziś siedziba Muzeum Okręgowego.',
      shortDescription: 'Symbol handlowej Bydgoszczy',
      location: LatLng(53.1225, 18.0015),
      tier: MonumentTier.tierB,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/e/e0/Spichrze_w_Bydgoszczy.jpg',
      year: 1793,
      style: 'Szachulec',
      tags: ['Architektura', 'Muzeum', 'Rzeka'],
      aiPersonality:
          'Stare, mądre, pachnące drewnem i zbożem. Pamiętają czasy handlu rzecznego.',
      sampleQuestions: [
        'Co przechowywano w Twoim wnętrzu?',
        'Jak zmieniało się miasto wokół Ciebie?',
      ],
    ),
    Monument(
      id: 'most_staromiejski',
      name: 'Most Staromiejski',
      description:
          'Most łączący Stare Miasto z centrum. Idealne miejsce do podziwiania rzeki i Przechodzącego przez rzekę.',
      shortDescription: 'Widok na Brdę',
      location: LatLng(53.1232, 18.0025),
      tier: MonumentTier.tierC,
      imageUrl:
          'https://bydgoszcz.pl/fileadmin/_processed_/5/6/csm_most_staromiejski_01_a62e0325d9.jpg',
      tags: ['Most', 'Widok', 'Brda'],
      aiPersonality:
          'Faktograficzny, precyzyjny. Zna parametry rzeki i historię przepraw.',
      sampleQuestions: [
        'Jak głęboka jest tu rzeka?',
        'Ile osób przechodzi tędy dziennie?',
      ],
    ),
  ];

  static Monument? getById(String id) {
    try {
      return monuments.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}

class QuestsData {
  static final List<Quest> quests = [
    const Quest(
      id: 'q1',
      name: 'Szlakiem Lepckego',
      description: 'Odkryj dzieła mistrza Ferdinanda Lepckego w Bydgoszczy.',
      monumentIds: ['luczniczka', 'fontanna_potop'],
      reward: Badge(
        id: 'b1',
        name: 'Znawca Sztuki',
        description: 'Poznałeś twórczość Ferdinanda Lepckego.',
        iconPath: 'assets/icons/badge_art.png',
        requiredMonumentIds: ['luczniczka', 'fontanna_potop'],
      ),
      themeColor: 'gold',
    ),
    const Quest(
      id: 'q2',
      name: 'Nad Brdą',
      description: 'Odwiedź miejsca związane z rzeką Brdą.',
      monumentIds: [
        'spichrze',
        'przechodzacy_przez_rzeke',
        'most_staromiejski'
      ],
      reward: Badge(
        id: 'b2',
        name: 'Wilk Rzeczny',
        description: 'Bydgoszcz i Brda nie mają przed Tobą tajemnic.',
        iconPath: 'assets/icons/badge_river.png',
        requiredMonumentIds: [
          'spichrze',
          'przechodzacy_przez_rzeke',
          'most_staromiejski'
        ],
      ),
      themeColor: 'blue',
    ),
  ];
}
