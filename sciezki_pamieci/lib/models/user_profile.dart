/// User profile model for "Paszport Odkrywcy"
class UserProfile {
  final String id;
  final String? name;
  final String? avatarPath;
  final DateTime joinedAt;
  final List<String> discoveredMonumentIds;
  final List<String> unlockedBadgeIds;
  final Map<String, List<ChatMessage>> conversationHistory;
  final int totalDistanceMeters;
  final String rank;
  
  const UserProfile({
    required this.id,
    this.name,
    this.avatarPath,
    required this.joinedAt,
    this.discoveredMonumentIds = const [],
    this.unlockedBadgeIds = const [],
    this.conversationHistory = const {},
    this.totalDistanceMeters = 0,
    this.rank = 'Początkujący Odkrywca',
  });
  
  /// Get number of discoveries
  int get discoveryCount => discoveredMonumentIds.length;
  
  /// Get number of conversations
  int get conversationCount => conversationHistory.length;
  
  /// Get total distance in kilometers
  double get distanceKm => totalDistanceMeters / 1000;
  
  /// Calculate rank based on discoveries
  String calculateRank() {
    if (discoveryCount >= 50) return 'Legenda Bydgoszczy';
    if (discoveryCount >= 30) return 'Strażnik Historii';
    if (discoveryCount >= 15) return 'Kronikarz Miejski';
    if (discoveryCount >= 5) return 'Odkrywca';
    return 'Początkujący Odkrywca';
  }
  
  /// Get XP points (simple calculation)
  int get xp => discoveryCount * 100 + conversationCount * 50 + unlockedBadgeIds.length * 500;
  
  /// Get level from XP
  int get level => (xp / 500).floor() + 1;
  
  /// Get XP progress to next level (0.0 to 1.0)
  double get levelProgress => (xp % 500) / 500;
  
  UserProfile copyWith({
    String? name,
    String? avatarPath,
    List<String>? discoveredMonumentIds,
    List<String>? unlockedBadgeIds,
    Map<String, List<ChatMessage>>? conversationHistory,
    int? totalDistanceMeters,
    String? rank,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      joinedAt: joinedAt,
      discoveredMonumentIds: discoveredMonumentIds ?? this.discoveredMonumentIds,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
      conversationHistory: conversationHistory ?? this.conversationHistory,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      rank: rank ?? this.rank,
    );
  }
}

/// Chat message model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  
  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
  };
  
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'],
    content: json['content'],
    isUser: json['isUser'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
