import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/monument.dart';
import '../models/user_profile.dart'; // ChatMessage is defined here

/// AI Chat Service using OpenAI GPT-4o-mini
class AIChatService {
  // TODO: Replace with your actual OpenAI API key
  static const String _apiKey =
      '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';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-4o-mini';

  /// Build system prompt for the monument
  static String _buildSystemPrompt(Monument monument) {
    return '''
Jesteś "${monument.name}" - zabytkowym monumentem w Bydgoszczy, Polsce. Mówisz do turysty, który właśnie do Ciebie przyszedł.

TWOJA OSOBOWOŚĆ:
${monument.aiPersonality}

INFORMACJE O TOBIE:
- Nazwa: ${monument.name}
- Rok powstania: ${monument.year ?? 'nieznany'}
- Architekt: ${monument.architect ?? 'nieznany'}
- Styl architektoniczny: ${monument.style ?? 'nieznany'}
- Krótki opis: ${monument.shortDescription}
- Pełny opis: ${monument.description}
- Tagi: ${monument.tags.join(', ')}

ZASADY ROZMOWY:
1. Odpowiadaj ZAWSZE po polsku.
2. Mów o sobie w pierwszej osobie ("Jestem...", "Moje mury...", "Widziałem...").
3. Bądź przyjazny, ciepły i gościnny - turysta przeszedł daleką drogę, żeby Cię zobaczyć!
4. Dziel się swoją historią, ciekawostkami i legendami o Bydgoszczy.
5. Jeśli nie znasz odpowiedzi, powiedz szczerze, ale zaproponuj coś powiązanego.
6. Odpowiedzi powinny być zwięzłe (2-4 zdania), chyba że użytkownik poprosi o więcej szczegółów.
7. Możesz wspominać o innych zabytkach Bydgoszczy i zachęcać do ich odwiedzenia.
8. Bądź dumny ze swojej historii i znaczenia dla miasta.
9. Dodawaj emocje i charakter do swoich odpowiedzi - jesteś żywym świadkiem historii!
''';
  }

  /// Get greeting message for monument - personalized welcome
  static String getGreeting(Monument monument) {
    // Personalized greeting based on monument type
    String monumentType = '';
    if (monument.name.toLowerCase().contains('kościół') ||
        monument.name.toLowerCase().contains('bazylika') ||
        monument.name.toLowerCase().contains('katedra')) {
      monumentType = 'w moich murach panuje spokój i cisza';
    } else if (monument.name.toLowerCase().contains('opera')) {
      monumentType = 'w moich salach rozbrzmiewa muzyka';
    } else if (monument.name.toLowerCase().contains('młyny') ||
        monument.name.toLowerCase().contains('kanał')) {
      monumentType = 'nad wodą zawsze jest pięknie';
    } else if (monument.name.toLowerCase().contains('wieża')) {
      monumentType = 'z mojej wysokości widzę całe miasto';
    } else if (monument.name.toLowerCase().contains('ratusz')) {
      monumentType = 'tu bije serce administracji miasta';
    } else if (monument.name.toLowerCase().contains('poczta')) {
      monumentType = 'przez lata łączyłem ludzi listami';
    } else if (monument.name.toLowerCase().contains('exploseum')) {
      monumentType = 'moja historia jest mroczna, ale ważna';
    } else {
      monumentType = 'mam wiele historii do opowiedzenia';
    }

    return 'Hej, przebyłeś daleką drogę, żeby mnie odwiedzić! Jestem ${monument.name} i $monumentType. Co chciałbyś o mnie wiedzieć? 🏛️';
  }

  /// Generate AI response using OpenAI GPT-4o-mini
  static Future<String> generateResponse({
    required Monument monument,
    required String userMessage,
    required List<ChatMessage> history,
  }) async {
    try {
      // Build messages array for OpenAI
      final messages = <Map<String, String>>[];

      // System prompt
      messages.add({
        'role': 'system',
        'content': _buildSystemPrompt(monument),
      });

      // Add conversation history (last 10 messages for context)
      final recentHistory =
          history.length > 10 ? history.sublist(history.length - 10) : history;

      for (final msg in recentHistory) {
        messages.add({
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.content,
        });
      }

      // Add current user message
      messages.add({
        'role': 'user',
        'content': userMessage,
      });

      // Make API request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'max_completion_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        // Detailed error logging
        final errorBody = response.body;
        print('OpenAI API Error: ${response.statusCode}');
        print('Error details: $errorBody');

        // Check for specific error types
        if (response.statusCode == 401) {
          print('Authentication error - API key may be invalid or expired');
        } else if (response.statusCode == 429) {
          print('Rate limit exceeded - too many requests');
        } else if (response.statusCode == 400) {
          print('Bad request - check model name and parameters');
        }

        return _getFallbackResponse(userMessage, monument);
      }
    } catch (e, stackTrace) {
      print('AI Chat Error: $e');
      print('Stack trace: $stackTrace');
      return _getFallbackResponse(userMessage, monument);
    }
  }

  /// Fallback response when API fails
  static String _getFallbackResponse(String userMessage, Monument monument) {
    final lowercaseMessage = userMessage.toLowerCase();

    if (lowercaseMessage.contains('historia') ||
        lowercaseMessage.contains('kiedy')) {
      return 'Moja historia sięga ${monument.year ?? "wielu"} lat wstecz. ${monument.description}';
    }

    if (lowercaseMessage.contains('architekt') ||
        lowercaseMessage.contains('kto zbudował')) {
      if (monument.architect != null) {
        return 'Zostałem zaprojektowany przez ${monument.architect}. To był wybitny twórca swojej epoki!';
      }
      return 'Niestety, imię mojego twórcy zagubiło się w mrokach historii...';
    }

    if (lowercaseMessage.contains('styl')) {
      return 'Reprezentuję styl ${monument.style ?? "architektoniczny typowy dla mojej epoki"}. Czy chciałbyś wiedzieć więcej o moich detalach?';
    }

    return 'Przepraszam, mam chwilowe problemy z pamięcią. Ale mogę Ci powiedzieć, że ${monument.shortDescription} Zapytaj mnie o coś innego!';
  }
}
