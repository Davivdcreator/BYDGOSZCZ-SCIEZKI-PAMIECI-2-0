import 'dart:async';
import '../models/game.dart';

/// Singleton service managing active game state
class GameStateService {
  static final GameStateService _instance = GameStateService._internal();
  factory GameStateService() => _instance;
  GameStateService._internal();

  final _gameController = StreamController<Game?>.broadcast();
  Game? _activeGame;

  /// Stream of active game changes
  Stream<Game?> get gameStream => _gameController.stream;

  /// Currently active game (null if no game active)
  Game? get activeGame => _activeGame;

  /// Whether a game is currently active
  bool get isGameActive => _activeGame != null;

  /// List of monument IDs in the active game
  List<String> get activeMonumentIds => _activeGame?.monumentIds ?? [];

  /// Start a game
  void startGame(Game game) {
    _activeGame = game;
    _gameController.add(_activeGame);
  }

  /// End the current game
  void endGame() {
    _activeGame = null;
    _gameController.add(null);
  }

  /// Dispose the service
  void dispose() {
    _gameController.close();
  }
}
