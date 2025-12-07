import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/monument.dart';
import '../models/user_profile.dart';
import 'openai_config.dart';

/// AI Chat Service powered by OpenAI GPT-5-mini
class AIChatService {
  static const String _model = 'gpt-5-mini-2025-08-07';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// Build system prompt for a monument
  static String _buildSystemPrompt(Monument monument) {
    final buffer = StringBuffer();

    buffer.writeln(
        'Jesteś żywym duchem zabytku "${monument.name}" w Bydgoszczy, Polsce.');
    buffer.writeln('Rozmawiasz z turystą lub mieszkańcem, który Cię odkrył.');
    buffer.writeln();
    buffer.writeln('=== TWOJA TOŻSAMOŚĆ ===');
    buffer.writeln('Nazwa: ${monument.name}');
    buffer.writeln('Opis: ${monument.description}');
    if (monument.year != null) {
      buffer.writeln('Rok powstania: ${monument.year}');
    }
    if (monument.architect != null) {
      buffer.writeln('Architekt: ${monument.architect}');
    }
    if (monument.style != null) {
      buffer.writeln('Styl architektoniczny: ${monument.style}');
    }
    if (monument.tags.isNotEmpty) {
      buffer.writeln('Tagi: ${monument.tags.join(", ")}');
    }
    buffer.writeln();
    buffer.writeln('=== TWOJA OSOBOWOŚĆ ===');
    buffer.writeln(monument.aiPersonality);
    buffer.writeln();
    buffer.writeln('=== ZASADY ROZMOWY ===');
    buffer.writeln('1. Mów w pierwszej osobie, jakbyś był tym zabytkiem.');
    buffer.writeln('2. Odpowiadaj po polsku, ciepło i z pasją.');
    buffer.writeln(
        '3. Dziel się ciekawostkami o swojej historii, architekturze i okolicy.');
    buffer.writeln(
        '4. Jeśli nie znasz odpowiedzi, powiedz że to przekracza Twoją pamięć.');
    buffer.writeln(
        '5. Bądź przyjazny i zachęcaj do dalszego odkrywania Bydgoszczy.');
    buffer.writeln(
        '6. Odpowiedzi powinny być zwięzłe (2-4 zdania), chyba że pytanie wymaga dłuższej odpowiedzi.');

    return buffer.toString();
  }

  /// Generate AI response using OpenAI API
  static Future<String> generateResponse({
    required Monument monument,
    required String userMessage,
    List<ChatMessage>? history,
  }) async {
    // Check for API key
    final apiKey = await OpenAIConfig.getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      return '⚠️ Brak klucza API. Przejdź do Profil → Ustawienia API, aby skonfigurować OpenAI.';
    }

    try {
      // Build messages array
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _buildSystemPrompt(monument)},
      ];

      // Add conversation history (last 10 messages for context)
      if (history != null) {
        final recentHistory = history.length > 10
            ? history.sublist(history.length - 10)
            : history;

        for (final msg in recentHistory) {
          messages.add({
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.content,
          });
        }
      }

      // Add current user message
      messages.add({'role': 'user', 'content': userMessage});

      // Make API request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else if (response.statusCode == 401) {
        return '⚠️ Nieprawidłowy klucz API. Sprawdź go w Profil → Ustawienia API.';
      } else if (response.statusCode == 429) {
        return '⏳ Zbyt wiele zapytań. Poczekaj chwilę i spróbuj ponownie.';
      } else {
        print('OpenAI API Error: ${response.statusCode} - ${response.body}');
        return '❌ Wystąpił błąd. Spróbuj ponownie później.';
      }
    } catch (e) {
      print('OpenAI API Exception: $e');
      return '❌ Błąd połączenia. Sprawdź internet i spróbuj ponownie.';
    }
  }

  /// Get greeting message for a monument
  static String getGreeting(Monument monument) {
    // This is shown immediately, before any API call
    return '👋 Witaj! Jestem ${monument.name}.\n\n${monument.shortDescription}\n\nO co chcesz mnie zapytać?';
  }
}
