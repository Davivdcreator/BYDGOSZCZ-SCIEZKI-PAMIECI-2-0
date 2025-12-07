import '../models/monument.dart';
import '../models/user_profile.dart';
import '../theme/tier_colors.dart';

/// Mock AI Chat Service - simulates tier-based AI responses
class AIChatService {
  /// Generate AI response based on monument tier and user message
  static Future<String> generateResponse({
    required Monument monument,
    required String userMessage,
    List<ChatMessage>? history,
  }) async {
    // Simulate network delay
    await Future.delayed(
        Duration(milliseconds: 800 + (userMessage.length * 10)));

    final tier = monument.tier;

    switch (tier) {
      case MonumentTier.tierC:
        return _generateTierCResponse(monument, userMessage);
      case MonumentTier.tierB:
        return _generateTierBResponse(monument, userMessage);
      case MonumentTier.tierA:
        return _generateTierAResponse(monument, userMessage);
      case MonumentTier.tierS:
        return _generateTierSResponse(monument, userMessage);
    }
  }

  /// Tier C - Faktograf: Short historical facts
  static String _generateTierCResponse(Monument m, String q) {
    final responses = [
      'Ciekawostka: ${m.description}',
      if (m.year != null) 'Powstałem w roku ${m.year}. ${m.shortDescription}.',
      if (m.style != null)
        'Reprezentuję styl ${m.style}. To charakterystyczny element architektury tego okresu.',
      'Znajduję się w samym sercu Bydgoszczy, niedaleko rzeki Brdy.',
    ];
    return responses[DateTime.now().second % responses.length];
  }

  /// Tier B - Obserwator: Nostalgic narratives
  static String _generateTierBResponse(Monument m, String q) {
    final lowerQ = q.toLowerCase();

    if (lowerQ.contains('pamięta') ||
        lowerQ.contains('dawniej') ||
        lowerQ.contains('kiedyś')) {
      return '''Ach, pamiętam te czasy... Ulice były węższe, a ludzie mieli więcej czasu. 
      
Słyszałem turkot dorożek po bruku, śmiech dzieci bawiących się przy fontannie, i ten charakterystyczny zapach świeżego chleba z pobliskiej piekarni.

${m.description}''';
    }

    if (lowerQ.contains('ludzi') ||
        lowerQ.contains('kto') ||
        lowerQ.contains('mieszka')) {
      return '''Przez lata widziałem tysiące twarzy. Zakochane pary szukające cienia, 
staruszków dzielących się wspomnieniami, dzieci odkrywające świat.

Każdy z nich zostawił tu cząstkę siebie. I dlatego to miejsce żyje.''';
    }

    if (lowerQ.contains('zmieni') || lowerQ.contains('teraz')) {
      return '''Miasto się zmieniło, to prawda. Ale pewne rzeczy pozostają niezmienne - 
szum Brdy, światło słońca o zachodzie i ta szczególna atmosfera Bydgoszczy.

Kiedyś tu pachniało inaczej - dymem z kominów, końskim łajnem, 
ale i świeżymi kwiatami z pobliskiego targu.''';
    }

    return '''${m.description}

Stoję tu od lat, obserwując jak miasto się zmienia. 
Każdy dzień przynosi nowe historie, nowe twarze. 
I choć nie mogę się ruszyć, czuję, że jestem częścią życia tego miejsca.''';
  }

  /// Tier A - Postać: Historical role-play
  static String _generateTierAResponse(Monument m, String q) {
    final lowerQ = q.toLowerCase();

    // Kazimierz Wielki specific responses
    if (m.id == 'pomnik_kazimierza') {
      if (lowerQ.contains('prawa') || lowerQ.contains('miasto')) {
        return '''Nadałem Bydgoszczy prawa miejskie w roku Pańskim 1346, 
bowiem miasto to leży na ważnym szlaku handlowym nad rzeką Brdą.

Prawo lokacyjne daje mieszczanom wolność handlu, prawo do jarmarków 
i samorządu. Tak buduje się potęgę państwa - cegła po cegle, 
przywilej po przywileju.

Zastałem Polskę drewnianą, a zostawię murowaną!''';
      }

      if (lowerQ.contains('osiągn') || lowerQ.contains('dumny')) {
        return '''Dumny jestem z wielu rzeczy - z Akademii Krakowskiej, 
którą ufundowałem w 1364 roku, z kodeksu praw zwanych Statutami Wiślickimi, 
z zamków obronnych, które wzniosłem po całej Polsce.

Ale najbardziej dumny jestem z tego, że mój lud żyje w pokoju 
i dobrobycie. To jest prawdziwe dziedzictwo króla.''';
      }

      return '''Witaj, młody człowieku. Jestem Kazimierzem, z Bożej łaski 
królem polskim. Mówią o mnie "Wielki", choć ta wielkość to zasługa 
moich poddanych i mądrych doradców.

Czego chcesz się dowiedzieć o mych czasach i czynach?''';
    }

    // Generic Tier A response for other monuments
    return '''${m.description}

Mówię do Ciebie głosem przeszłości, ale moje słowa mają znaczenie także dziś. 
Historia to nie martwe fakty - to żywe lekcje dla przyszłych pokoleń.

Pytaj, a opowiem Ci więcej o moich czasach i doświadczeniach.''';
  }

  /// Tier S - Symbol: Metaphysical immersion
  static String _generateTierSResponse(Monument m, String q) {
    final lowerQ = q.toLowerCase();

    // Łuczniczka specific responses
    if (m.id == 'luczniczka') {
      if (lowerQ.contains('widzia') || lowerQ.contains('lat')) {
        return '''Widziałam wszystko...

Widziałam żołnierzy maszerujących na wojnę i wracających - 
tych, którzy wrócili. Widziałam łzy matek i uśmiechy zakochanych.

Widziałam, jak miasto płonęło i jak odradzało się z popiołów. 
Widziałam dzieci, które stały się staruszkami, patrząc na mnie każdego dnia.

Mój łuk wymierzony jest w niebo, bo tam mieszka nadzieja. 
A nadzieja jest tym, czego ludzie potrzebują najbardziej.''';
      }

      if (lowerQ.contains('łuk') ||
          lowerQ.contains('cel') ||
          lowerQ.contains('niebo')) {
        return '''Celuję w niebo, bo to jest cel najbardziej ambitny 
i najbardziej niemożliwy zarazem.

Mój łuk to symbol aspiracji - tego, co w człowieku najpiękniejsze. 
Dążenia ku wyższym wartościom, ku pięknu, ku prawdzie.

Nigdy nie wypuszczę strzały. Bo ważniejsze od celu jest samo 
dążenie, samo napięcie cięciwy, sam gest sięgania ku gwiazdom.''';
      }

      if (lowerQ.contains('miłoś')) {
        return '''Ach, miłość... Ile par stało przede mną, 
przysięgając sobie wieczność?

Widziałam pierwszy pocałunek nieśmiałych nastolatków. 
Widziałam oświadczyny drżącego ze strachu mężczyzny. 
Widziałam stare małżeństwa trzymające się za ręce po 50 latach.

Miłość jest jak rzeka pode mną - płynie nieustannie, 
zmienia się, ale nigdy nie wysycha. I to jest piękne.''';
      }

      return '''Jestem Łuczniczką. Jestem symbolem.

Stoję nad Brdą od ponad stu lat i patrzę, jak czas płynie 
niczym woda pode mną. Widziałam wojny i pokój, 
radość i smutek, narodziny i odejścia.

Jestem częścią duszy tego miasta. 
A ty jesteś częścią mojej historii, już teraz, w tej chwili.

O czym chciałbyś porozmawiać ze mną?''';
    }

    // Przechodzący specific responses
    if (m.id == 'przechodzacy_przez_rzeke') {
      if (lowerQ.contains('równowag')) {
        return '''Równowaga... To słowo ma dla mnie szczególne znaczenie.

Wisząc nad rzeką nauczyłem się, że równowaga to nie statyczność. 
To nieustanny ruch - drobne korekty, ciągłe dostosowywanie się.

W życiu jest tak samo. Nie chodzi o to, by stać nieruchomo, 
ale o to, by umieć reagować na wiatr, który próbuje nas zepchnąć.''';
      }

      return '''Z mojej perspektywy świat wygląda inaczej.

Ni to w górze, ni to na dole. Między niebem a wodą. 
Między snem a jawą. To miejsce, gdzie wszystko jest możliwe.

Każdy krok to ryzyko. Każdy krok to odwaga. 
I każdy krok przybliża mnie do drugiego brzegu.''';
    }

    // Generic S-tier response
    return '''${m.description}

Jestem więcej niż tym, co widzisz. Jestem symbolem - 
ucieleśnieniem wartości, które przekraczają kamień i brąz.

Rozmowa ze mną to rozmowa z historią, z pamięcią zbiorową, 
z tym, co w Bydgoszczy i jej mieszkańcach najważniejsze.

Pytaj o wszystko. O sens, o piękno, o czas...''';
  }

  /// Get greeting message for a monument
  static String getGreeting(Monument monument) {
    switch (monument.tier) {
      case MonumentTier.tierC:
        return '📜 ${monument.shortDescription}';
      case MonumentTier.tierB:
        return 'Witaj, wędrowcze...\n\n${monument.shortDescription}';
      case MonumentTier.tierA:
        return '${monument.name} wita Cię!\n\n${monument.description.split('.').first}.';
      case MonumentTier.tierS:
        return '${monument.description.split('.').take(2).join('.')}.\n\nCo chciałbyś wiedzieć?';
    }
  }
}
