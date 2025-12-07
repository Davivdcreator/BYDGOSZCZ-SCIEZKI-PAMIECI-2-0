import 'package:latlong2/latlong.dart';
import '../models/monument.dart';
import '../theme/tier_colors.dart';

final List<Map<String, dynamic>> newUniqueMonuments = [
  {
    'id': 'unique_ratusz',
    'name': 'Ratusz w Bydgoszczy',
    'description':
        'Neogotycki budynek z lat 1878-1879, pierwotnie kolegium jezuickie. Siedziba władz miasta, usytuowany przy Starym Rynku.',
    'shortDescription': 'Siedziba władz miasta przy Starym Rynku.',
    'location': {
      'latitude': 53.1218,
      'longitude': 18.0004,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/97/xl.jpg',
    'architect': 'Karol Kulm',
    'year': 1879,
    'style': 'Neogotyk',
    'tags': ['Ratusz', 'Historia', 'Architektura'],
    'aiPersonality':
        'Jestem Ratuszem, sercem administracyjnym miasta. Widziałem, jak Bydgoszcz zmieniała się przez stulecia. Chętnie opowiem Ci o Starym Rynku.',
    'sampleQuestions': [
      'Jaka jest twoja historia?',
      'Kto urzęduje w twoich murach?',
      'Co ciekawego działo się na Starym Rynku?',
    ]
  },
  {
    'id': 'unique_katedra',
    'name': 'Katedra Bydgoska',
    'description':
        'Najstarszy zachowany kościół w Bydgoszczy (Fara), gotycki, z malowniczym położeniem nad rzeką Brdą. Sanktuarium Matki Bożej Pięknej Miłości.',
    'shortDescription': 'Gotycka Fara, najstarszy kościół w mieście.',
    'location': {
      'latitude': 53.1230,
      'longitude': 17.9995,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/2253/xl.jpg',
    'architect': 'Nieznany',
    'year': 1502,
    'style': 'Gotyk',
    'tags': ['Kościół', 'Gotyk', 'Religia'],
    'aiPersonality':
        'Jestem Katedrą, niemym świadkiem historii Bydgoszczy od XV wieku. W moim wnętrzu kryje się słynny obraz Matki Bożej Pięknej Miłości.',
    'sampleQuestions': [
      'Kiedy zostałeś zbudowany?',
      'Co to jest obraz Matki Bożej Pięknej Miłości?',
      'Opowiedz o swojej architekturze.',
    ]
  },
  {
    'id': 'unique_opera',
    'name': 'Opera Nova',
    'description':
        'Nowoczesny gmach opery w kształcie trzech kręgów, malowniczo położony w zakolu Brdy. Ważne centrum kulturalne.',
    'shortDescription': 'Ikona nowoczesnej Bydgoszczy nad Brdą.',
    'location': {
      'latitude': 53.1250,
      'longitude': 17.9970,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/6682/xl.jpg',
    'architect': 'Józef Chmiel, Andrzej Prusiewicz',
    'year': 2006,
    'style': 'Modernizm',
    'tags': ['Kultura', 'Muzyka', 'Rzeka'],
    'aiPersonality':
        'Jestem Operą Nova, nowoczesną duszą miasta. W moich kręgach rozbrzmiewa muzyka, a moje odbicie tańczy w wodach Brdy.',
    'sampleQuestions': [
      'Jakie spektakle można tu zobaczyć?',
      'Dlaczego masz taki kształt?',
      'Kiedy odbywa się Bydgoski Festiwal Operowy?',
    ]
  },
  {
    'id': 'unique_bazylika',
    'name': 'Bazylika św. Wincentego à Paulo',
    'description':
        'Monumentalna neoklasyczna bazylika wzorowana na rzymskim Panteonie. Jej kopuła jest jednym z dominantów w panoramie miasta.',
    'shortDescription': 'Polska Bazylika wzorowana na Panteonie.',
    'location': {
      'latitude': 53.1265,
      'longitude': 18.0120,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/937/xl.jpg',
    'architect': 'Adam Ballenstedt',
    'year': 1939,
    'style': 'Neoklasycyzm',
    'tags': ['Kościół', 'Panteon', 'Kopuła'],
    'aiPersonality':
        'Jestem Bazyliką, "bydgoskim Watykanem". Moja kopuła góruje nad miastem. Zapraszam do wnętrza, które onieśmiela swym ogromem.',
    'sampleQuestions': [
      'Jak wysoka jest twoja kopuła?',
      'Na czym jesteś wzorowana?',
      'Kiedy zakończono twoją budowę?',
    ]
  },
  {
    'id': 'unique_mlyny',
    'name': 'Młyny Rothera',
    'description':
        'Zrewitalizowany zespół młynów na Wyspie Młyńskiej. Obecnie centrum nauki, kultury i wystaw. Serce wyspy.',
    'shortDescription': 'Zrewitalizowane serce Wyspy Młyńskiej.',
    'location': {
      'latitude': 53.1245,
      'longitude': 17.9960,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/5202/xl.jpg',
    'architect': 'Friedrich Wolff',
    'year': 1849,
    'style': 'Architektura przemysłowa',
    'tags': ['Wyspa Młyńska', 'Rewitalizacja', 'Kultura'],
    'aiPersonality':
        'Jestem Młynami Rothera. Kiedyś mieliłem zboże, dziś mielę pomysły i kulturę. Jestem sercem Wyspy Młyńskiej.',
    'sampleQuestions': [
      'Co znajduje się w środku?',
      'Jaka jest historia Wyspy Młyńskiej?',
      'Co to są "Spichrze"?',
    ]
  },
  {
    'id': 'unique_kanal',
    'name': 'Stary Kanał Bydgoski',
    'description':
        'Zabytkowa droga wodna łącząca Wisłę i Odrę. Otoczony pięknym parkiem ze starodrzewem. Miejsce spacerów i rekreacji.',
    'shortDescription': 'Zabytkowa droga wodna i park.',
    'location': {
      'latitude': 53.1280,
      'longitude': 17.9800,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/9731/xl.jpg',
    'architect': 'Franciszek von Brenkenhoff',
    'year': 1774,
    'style': 'Inżynieria wodna',
    'tags': ['Kanał', 'Przyroda', 'Spacer'],
    'aiPersonality':
        'Jestem Kanałem Bydgoskim, wodnym oknem na świat. Płynie we mnie historia handlu i inżynierii. Spacerując moimi brzegami, odpoczniesz.',
    'sampleQuestions': [
      'Jak działają śluzy?',
      'Dokąd można dopłynąć tym kanałem?',
      'Jakie drzewa rosną w parku?',
    ]
  },
  {
    'id': 'unique_wieza',
    'name': 'Wieża Ciśnień',
    'description':
        'Neogotycka wieża ciśnień położona w parku na Wzgórzu Dąbrowskiego. Obecnie muzeum wodociągów z tarasem widokowym.',
    'shortDescription': 'Muzeum Wodociągów z widokiem na miasto.',
    'location': {
      'latitude': 53.1210,
      'longitude': 17.9920,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/10186/xl.jpg',
    'architect': 'Franz Marschall',
    'year': 1900,
    'style': 'Neogotyk',
    'tags': ['Widok', 'Muzeum', 'Woda'],
    'aiPersonality':
        'Jestem Wieżą Ciśnień. Ze Wzgórza Dąbrowskiego spoglądam na całe miasto. Opowiem Ci o tym, jak woda docierała do domów.',
    'sampleQuestions': [
      'Jaki jest widok z góry?',
      'Do czego służyłaś dawniej?',
      'Co jest w muzeum?',
    ]
  },
  {
    'id': 'unique_exploseum',
    'name': 'Exploseum',
    'description':
        'Unikalne muzeum w dawnej niemieckiej fabryce materiałów wybuchowych (DAG Fabrik Bromberg). Mroczna, ale fascynująca historia.',
    'shortDescription': 'Centrum techniki wojennej DAG Fabrik Bromberg.',
    'location': {
      'latitude': 53.0850,
      'longitude': 18.0650,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/2798/xl.jpg',
    'architect': 'Niemieccy inżynierowie',
    'year': 1939,
    'style': 'Architektura militarna',
    'tags': ['Historia', 'II Wojna Światowa', 'Fabryka'],
    'aiPersonality':
        'Jestem Exploseum. Moje betonowe korytarze kryją tajemnice DAG Fabrik Bromberg. Opowiadam trudną historię wojny i przymusowej pracy.',
    'sampleQuestions': [
      'Co tu produkowano?',
      'Kto tu pracował?',
      'Czy można zwiedzać tunele?',
    ]
  },
  {
    'id': 'unique_klaryski',
    'name': 'Kościół Klarysek',
    'description':
        'Gotycko-renesansowy kościół przy ulicy Gdańskiej. Charakterystyczna wieża z zegarem. Jeden z symboli ulicy Gdańskiej.',
    'shortDescription': 'Zabytkowy kościół z hejnałem.',
    'location': {
      'latitude': 53.1255,
      'longitude': 18.0040,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/931/xl.jpg',
    'architect': 'Nieznany',
    'year': 1618,
    'style': 'Gotyk/Renesans',
    'tags': ['Kościół', 'Gdańska', 'Zegar'],
    'aiPersonality':
        'Jestem Kościołem Klarysek. Mój zegar odmierza czas na ulicy Gdańskiej. Posłuchaj hejnału, który rozbrzmiewa z mojej wieży.',
    'sampleQuestions': [
      'Kto to były Klaryski?',
      'Co to za melodia hejnału?',
      'Co znajduje się wewnątrz?',
    ]
  },
  {
    'id': 'unique_poczta',
    'name': 'Poczta Główna',
    'description':
        'Monumentalny neogotycki gmach poczty nad brzegiem Brdy. Przykład pruskiej architektury urzędowej w pełnej okazałości.',
    'shortDescription': 'Neogotycki gmach nad brzegiem Brdy.',
    'location': {
      'latitude': 53.1225,
      'longitude': 18.0020,
    },
    'tier': 'tierUnique',
    'imageUrl':
        'https://visitbydgoszcz.pl/images/com_adsmanager/ads//media/photos/56/xl.jpg',
    'architect': 'Klefeldt',
    'year': 1899,
    'style': 'Neogotyk',
    'tags': ['Poczta', 'Architektura', 'Rzeka'],
    'aiPersonality':
        'Jestem Pocztą Główną. Mój ceglany gmach odbija się w Brdzie. Przez lata łączyłem ludzi listami i paczkami.',
    'sampleQuestions': [
      'Kiedy zostałeś zbudowany?',
      'Czy nadal działasz jako poczta?',
      'Co to za styl architektoniczny?',
    ]
  }
];
