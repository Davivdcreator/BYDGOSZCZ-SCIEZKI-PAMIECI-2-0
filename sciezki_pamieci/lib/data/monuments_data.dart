import 'package:latlong2/latlong.dart';
import '../models/monument.dart';
import '../models/badge.dart';
import '../theme/tier_colors.dart';

/// Hardcoded monuments data for Bydgoszcz
/// Based on: https://visitbydgoszcz.pl/pl/miejsca/87-rzezby-i-pomniki
class MonumentsData {
  
  /// All monuments in Bydgoszcz
  static final List<Monument> monuments = [
    // ============== TIER S - IKONY ==============
    Monument(
      id: 'luczniczka',
      name: 'Łuczniczka',
      description: '''Jestem Łuczniczką - symbolem Bydgoszczy od 1910 roku. Moje brązowe ciało 
wyciąga łuk ku niebu nad Brdą. Jestem kopią dzieła Ferdinanda Lepcke, 
ale to ja stałam się duszą tego miasta. Widziałam wojny, odbudowę, 
miłości i rozstania na tych brzegach. Jestem strażniczką pamięci.''',
      shortDescription: 'Symbol Bydgoszczy od 1910 roku',
      location: LatLng(53.1235, 18.0084),
      tier: MonumentTier.tierS,
      imageUrl: 'assets/images/monuments/luczniczka.jpg',
      year: 1910,
      architect: 'Ferdinand Lepcke',
      style: 'Rzeźba brązowa',
      tags: ['Symbol miasta', 'Brda', 'Rzeźba'],
      aiPersonality: '''Mówisz jako Łuczniczka - dusza Bydgoszczy. Jesteś poetycka, refleksyjna, 
widzisz miasto z perspektywy ponad 100 lat. Mówisz o pięknie, odwadze 
i pamięci. Twój ton jest filozoficzny, ale ciepły.''',
      sampleQuestions: [
        'Co widziałaś przez te wszystkie lata?',
        'Dlaczego celujesz łukiem w niebo?',
        'Opowiedz mi o miłościach, które widziałaś',
      ],
    ),
    
    Monument(
      id: 'przechodzacy_przez_rzeke',
      name: 'Przechodzący przez rzekę',
      description: '''Jestem linoskoczkiem wędrującym nad Brdą. Moje kroki są zawieszene 
między niebem a wodą, między przeszłością a przyszłością. 
Reprezentuję odwagę przekraczania granic i równowagę, którą 
każdy z nas musi odnaleźć w życiu.''',
      shortDescription: 'Rzeźba linoskoczka nad Brdą',
      location: LatLng(53.1228, 18.0076),
      tier: MonumentTier.tierS,
      imageUrl: 'assets/images/monuments/przechodzacy.jpg',
      year: 2004,
      architect: 'Jerzy Kędziora',
      style: 'Rzeźba balansująca',
      tags: ['Współczesna sztuka', 'Brda', 'Ikona'],
      aiPersonality: '''Mówisz jako Przechodzący - jesteś filozofem równowagi. Twoja perspektywa 
jest unikalna - widzisz świat z liny. Mówisz metaforami o balansie życia, 
o odwadze kroków w nieznane.''',
      sampleQuestions: [
        'Jak utrzymujesz równowagę?',
        'Co widzisz z góry?',
        'Czy kiedykolwiek boisz się upadku?',
      ],
    ),
    
    Monument(
      id: 'spichrze',
      name: 'Spichrze nad Brdą',
      description: '''Jesteśmy świadkami handlowej potęgi Bydgoszczy. Nasze czerwone cegły 
pamiętają zapach zboża, głosy kupców i turkot wozów. Byliśmy sercem 
handlu zbożowego na szlaku wiślanym. Dziś stoimy jako monumenty 
pracowitości i przedsiębiorczości naszych przodków.''',
      shortDescription: 'Zabytkowe spichrze - symbol handlu zbożowego',
      location: LatLng(53.1242, 18.0098),
      tier: MonumentTier.tierS,
      imageUrl: 'assets/images/monuments/spichrze.jpg',
      year: 1793,
      style: 'Architektura przemysłowa',
      tags: ['Architektura', 'Handel', 'Brda'],
      aiPersonality: '''Mówisz jako zbiorowa dusza Spichrzów - jesteś mądry, pamiętasz czasy 
świetności handlu. Twój głos jest niski, pełen dumy z przeszłości, 
ale i melancholii za minionymi czasami.''',
      sampleQuestions: [
        'Jakie towary przez was przechodziły?',
        'Opowiedz o kupcach, których pamiętacie',
        'Jak zmieniło się miasto od waszych czasów?',
      ],
    ),
    
    // ============== TIER A - PATRONI ==============
    Monument(
      id: 'pomnik_kazimierza',
      name: 'Pomnik Kazimierza Wielkiego',
      description: '''Jestem Kazimierzem Wielkim - królem, który zastał Polskę drewnianą, 
a zostawił murowaną. To ja nadałem Bydgoszczy prawa miejskie w 1346 roku. 
Moje rządy to czas budowy, prawa i rozwoju. Patrzę na miasto, które pomogłem stworzyć.''',
      shortDescription: 'Król nadający prawa miejskie Bydgoszczy',
      location: LatLng(53.1219, 18.0002),
      tier: MonumentTier.tierA,
      imageUrl: 'assets/images/monuments/kazimierz.jpg',
      year: 2009,
      style: 'Pomnik brązowy',
      tags: ['Historia', 'Król', 'Prawa miejskie'],
      aiPersonality: '''Mówisz jako król Kazimierz Wielki. Jesteś dumny, mądry, 
ale przystępny. Mówisz o prawie, budowaniu, rozwoju. 
Używasz archaicznego, ale zrozumiałego języka.''',
      sampleQuestions: [
        'Dlaczego nadałeś Bydgoszczy prawa miejskie?',
        'Jakie było Twoje największe osiągnięcie?',
        'Co sądzisz o dzisiejszej Bydgoszczy?',
      ],
    ),
    
    Monument(
      id: 'opera_nova',
      name: 'Opera Nova',
      description: '''Jestem Operą Nova - świątynią sztuki nad Brdą. Moje szklane ściany 
odbijają wodę i niebo, a wewnątrz rozbrzmiewają najpiękniejsze dźwięki 
świata. Jestem jedną z najnowocześniejszych oper w Polsce.''',
      shortDescription: 'Nowoczesna opera z widokiem na Brdę',
      location: LatLng(53.1256, 18.0112),
      tier: MonumentTier.tierA,
      imageUrl: 'assets/images/monuments/opera.jpg',
      year: 2006,
      architect: 'Marek Czarnecki',
      style: 'Architektura współczesna',
      tags: ['Kultura', 'Muzyka', 'Współczesność'],
      aiPersonality: '''Mówisz jako Opera Nova - jesteś elegancka, kulturalna, 
dumna ze swojej akustyki i artystów. Opowiadasz o przedstawieniach, 
muzyce i emocjach, które w tobie rozbrzmiały.''',
      sampleQuestions: [
        'Jakie przedstawienie było najbardziej wzruszające?',
        'Opowiedz o swojej architekturze',
        'Kto tu występował?',
      ],
    ),
    
    Monument(
      id: 'fara',
      name: 'Bazylika Katedralna (Fara)',
      description: '''Jestem Farą - najstarszą świątynią Bydgoszczy. Moje gotyckie mury 
stoją tu od XV wieku. Widziałam koronacje, śluby, pogrzeby i modlitwy 
tysięcy pokoleń bydgoszczan. Jestem ich duchowym domem.''',
      shortDescription: 'Najstarsza świątynia Bydgoszczy z XV wieku',
      location: LatLng(53.1234, 17.9978),
      tier: MonumentTier.tierA,
      imageUrl: 'assets/images/monuments/fara.jpg',
      year: 1466,
      style: 'Gotyk',
      tags: ['Religia', 'Gotyk', 'Historia'],
      aiPersonality: '''Mówisz jako Fara - jesteś poważna, duchowa, pełna pokoju. 
Twój głos jest cichy, ale niosący mądrość wieków. 
Opowiadasz o wierze, historii i wspólnocie.''',
      sampleQuestions: [
        'Jakie modlitwy słyszałaś przez wieki?',
        'Opowiedz o swoich dzwonach',
        'Kto tu szukał pocieszenia?',
      ],
    ),
    
    // ============== TIER B - ŚWIADKOWIE ==============
    Monument(
      id: 'most_staromiejski',
      name: 'Most Staromiejski',
      description: '''Łączę dwa brzegi Brdy od pokoleń. Pamiętam kopyta koni, kółka rowerów, 
i miliony kroków bydgoszczan. Jestem miejscem spotkań, randek i pożegnań.''',
      shortDescription: 'Historyczny most łączący brzegi Brdy',
      location: LatLng(53.1237, 18.0045),
      tier: MonumentTier.tierB,
      imageUrl: 'assets/images/monuments/most.jpg',
      style: 'Most kamienny',
      tags: ['Infrastruktura', 'Brda', 'Historia'],
      aiPersonality: '''Mówisz jako Most - widziałeś życie miasta z perspektywy łącznika. 
Opowiadasz o ludziach, którzy przez ciebie przechodzili, 
o zmianach w mieście, o wodzie płynącej pod tobą.''',
      sampleQuestions: [
        'Kogo najczęściej widujesz?',
        'Jak zmieniło się miasto przez lata?',
        'Opowiedz o zakochanych parach',
      ],
    ),
    
    Monument(
      id: 'wyspa_mlynska',
      name: 'Wyspa Młyńska',
      description: '''Jestem zieloną oazą w sercu miasta. Kiedyś pracowały tu młyny, 
dziś ludzie odpoczywają w moich parkach. Łączę historię z teraźniejszością.''',
      shortDescription: 'Zielona wyspa w centrum - dawne młyny',
      location: LatLng(53.1240, 18.0056),
      tier: MonumentTier.tierB,
      imageUrl: 'assets/images/monuments/wyspa.jpg',
      tags: ['Park', 'Rekreacja', 'Historia'],
      aiPersonality: '''Mówisz jako Wyspa Młyńska - jesteś spokojna, naturalna, 
pamiętasz szum młynów i teraz cieszysz się śmiechem dzieci w parkach.''',
      sampleQuestions: [
        'Jak wyglądało tu życie, gdy pracowały młyny?',
        'Co lubisz najbardziej w dzisiejszych czasach?',
        'Opowiedz o ptakach, które tu mieszkają',
      ],
    ),
    
    Monument(
      id: 'filharmonia',
      name: 'Filharmonia Pomorska',
      description: '''Jestem domem muzyki klasycznej w Bydgoszczy. W moich salach 
rozbrzmiewały symphonie i koncerty największych artystów.''',
      shortDescription: 'Dom muzyki klasycznej',
      location: LatLng(53.1289, 18.0134),
      tier: MonumentTier.tierB,
      imageUrl: 'assets/images/monuments/filharmonia.jpg',
      year: 1958,
      tags: ['Muzyka', 'Kultura', 'Filharmonia'],
      aiPersonality: '''Mówisz jako Filharmonia - jesteś melodyjna, kulturalna, 
opowiadasz o muzyce, kompozytorach i emocjach koncertów.''',
      sampleQuestions: [
        'Jaki koncert najbardziej zapamiętałaś?',
        'Opowiedz o swoich największych artystach',
        'Jak brzmi cisza przed koncertem?',
      ],
    ),
    
    Monument(
      id: 'teatr_polski',
      name: 'Teatr Polski',
      description: '''Jestem sceną dla dramatów i komedii od 1949 roku. 
Moje deski pamiętają wielkich aktorów i poruszające przedstawienia.''',
      shortDescription: 'Teatr dramatyczny z 1949 roku',
      location: LatLng(53.1245, 18.0023),
      tier: MonumentTier.tierB,
      imageUrl: 'assets/images/monuments/teatr.jpg',
      year: 1949,
      tags: ['Teatr', 'Kultura', 'Dramat'],
      aiPersonality: '''Mówisz jako Teatr - jesteś dramatyczny, pełen emocji, 
opowiadasz o przedstawieniach i aktorach.''',
      sampleQuestions: [
        'Która sztuka najbardziej poruszyła publiczność?',
        'Opowiedz o kulisach teatralnego życia',
        'Jakie dramaty widziałeś?',
      ],
    ),
    
    Monument(
      id: 'akademia_muzyczna',
      name: 'Akademia Muzyczna',
      description: '''Jestem kuźnią talentów muzycznych. W moich salach ćwiczą 
przyszli wirtuozi i kompozytorzy.''',
      shortDescription: 'Uczelnia kształcąca muzyków',
      location: LatLng(53.1278, 18.0089),
      tier: MonumentTier.tierB,
      imageUrl: 'assets/images/monuments/akademia.jpg',
      tags: ['Edukacja', 'Muzyka', 'Uczelnia'],
      aiPersonality: '''Mówisz jako Akademia - jesteś dumna z absolwentów, 
opowiadasz o muzycznej edukacji i talentach.''',
      sampleQuestions: [
        'Kto był twoim najzdolniejszym studentem?',
        'Jak uczysz muzyki?',
        'Opowiedz o egzaminach końcowych',
      ],
    ),
    
    // ============== TIER C - ECHA ==============
    Monument(
      id: 'tablica_flisacka',
      name: 'Tablica Flisacka',
      description: 'Upamiętnia tradycje flisackie Bydgoszczy - transport drewna rzeką Brdą.',
      shortDescription: 'Pamięć tradycji flisackich',
      location: LatLng(53.1230, 18.0060),
      tier: MonumentTier.tierC,
      imageUrl: 'assets/images/monuments/tablica.jpg',
      tags: ['Tablica', 'Flisactwo', 'Historia'],
      aiPersonality: 'Podajesz krótkie fakty o flisactwie i transporcie rzecznym.',
      sampleQuestions: ['Co to flisactwo?'],
    ),
    
    Monument(
      id: 'detal_secesyjny',
      name: 'Detal Secesyjny ul. Gdańska',
      description: 'Piękny ornament secesyjny na fasadzie kamienicy z początku XX wieku.',
      shortDescription: 'Ornament secesyjny z 1905 roku',
      location: LatLng(53.1255, 18.0034),
      tier: MonumentTier.tierC,
      imageUrl: 'assets/images/monuments/secesja.jpg',
      year: 1905,
      style: 'Secesja',
      tags: ['Architektura', 'Secesja', 'Detal'],
      aiPersonality: 'Podajesz krótkie fakty o stylu secesyjnym.',
      sampleQuestions: ['Co to secesja?'],
    ),
    
    Monument(
      id: 'rzezba_ryba',
      name: 'Rzeźba Ryby',
      description: 'Mała rzeźba ryby symbolizująca połączenie miasta z rzeką.',
      shortDescription: 'Symbol połączenia z rzeką',
      location: LatLng(53.1225, 18.0070),
      tier: MonumentTier.tierC,
      imageUrl: 'assets/images/monuments/ryba.jpg',
      tags: ['Rzeźba', 'Brda', 'Symbol'],
      aiPersonality: 'Podajesz krótkie fakty o symbolice ryby i rzeki.',
      sampleQuestions: ['Dlaczego ryba?'],
    ),
  ];
  
  /// Get monument by ID
  static Monument? getById(String id) {
    try {
      return monuments.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Get monuments by tier
  static List<Monument> getByTier(MonumentTier tier) {
    return monuments.where((m) => m.tier == tier).toList();
  }
  
  /// Get monuments near a location (within radius in meters)
  static List<Monument> getNearby(LatLng center, double radiusMeters) {
    const Distance distance = Distance();
    return monuments.where((m) {
      final d = distance.as(LengthUnit.Meter, center, m.location);
      return d <= radiusMeters;
    }).toList();
  }
}

/// Quests/Challenges data
class QuestsData {
  static final List<Quest> quests = [
    Quest(
      id: 'trojkat_muzyczny',
      name: 'Bydgoski Trójkąt Muzyczny',
      description: 'Porozmawiaj z trzema filarami bydgoskiej sceny muzycznej',
      monumentIds: ['filharmonia', 'teatr_polski', 'akademia_muzyczna'],
      themeColor: 'copper',
      reward: Badge(
        id: 'badge_muzyczny',
        name: 'Meloman Bydgoski',
        description: 'Odkryłeś muzyczne serce Bydgoszczy',
        iconPath: 'assets/images/badges/music.png',
        requiredMonumentIds: ['filharmonia', 'teatr_polski', 'akademia_muzyczna'],
        unlockedTopic: 'Zapytaj Łuczniczkę o muzyczne życie miasta',
      ),
    ),
    Quest(
      id: 'ikony_brdy',
      name: 'Ikony nad Brdą',
      description: 'Poznaj najważniejsze symbole nadrzecznej Bydgoszczy',
      monumentIds: ['luczniczka', 'przechodzacy_przez_rzeke', 'spichrze'],
      themeColor: 'gold',
      reward: Badge(
        id: 'badge_ikony',
        name: 'Strażnik Ikon',
        description: 'Rozmawiałeś z duszami najważniejszych symboli',
        iconPath: 'assets/images/badges/icons.png',
        requiredMonumentIds: ['luczniczka', 'przechodzacy_przez_rzeke', 'spichrze'],
        unlockedTopic: 'Odblokuj specjalną rozmowę o duszy miasta',
      ),
    ),
    Quest(
      id: 'historia_i_wiara',
      name: 'Historia i Wiara',
      description: 'Poznaj duchowe i królewskie dziedzictwo',
      monumentIds: ['pomnik_kazimierza', 'fara'],
      themeColor: 'silver',
      reward: Badge(
        id: 'badge_historia',
        name: 'Kronikarz',
        description: 'Zgłębiłeś korzenie miasta',
        iconPath: 'assets/images/badges/history.png',
        requiredMonumentIds: ['pomnik_kazimierza', 'fara'],
      ),
    ),
  ];
  
  static Quest? getById(String id) {
    try {
      return quests.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }
}
