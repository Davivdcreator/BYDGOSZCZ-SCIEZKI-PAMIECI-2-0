/// Badge/Achievement model for gamification
class Badge {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final List<String> requiredMonumentIds;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String? unlockedTopic; // Special conversation topic unlocked
  
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.requiredMonumentIds,
    this.isUnlocked = false,
    this.unlockedAt,
    this.unlockedTopic,
  });
  
  /// Calculate progress (0.0 to 1.0)
  double progress(List<String> discoveredIds) {
    if (requiredMonumentIds.isEmpty) return 0;
    int completed = requiredMonumentIds
        .where((id) => discoveredIds.contains(id))
        .length;
    return completed / requiredMonumentIds.length;
  }
  
  /// Check if all requirements are met
  bool canUnlock(List<String> discoveredIds) {
    return requiredMonumentIds.every((id) => discoveredIds.contains(id));
  }
  
  Badge copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Badge(
      id: id,
      name: name,
      description: description,
      iconPath: iconPath,
      requiredMonumentIds: requiredMonumentIds,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      unlockedTopic: unlockedTopic,
    );
  }
}

/// Quest/Challenge model
class Quest {
  final String id;
  final String name;
  final String description;
  final List<String> monumentIds;
  final Badge reward;
  final String themeColor; // 'copper', 'gold', 'silver'
  
  const Quest({
    required this.id,
    required this.name,
    required this.description,
    required this.monumentIds,
    required this.reward,
    this.themeColor = 'copper',
  });
  
  /// Get completed count
  int completedCount(List<String> discoveredIds) {
    return monumentIds.where((id) => discoveredIds.contains(id)).length;
  }
  
  /// Check if quest is complete
  bool isComplete(List<String> discoveredIds) {
    return completedCount(discoveredIds) >= monumentIds.length;
  }
  
  /// Get progress as 0.0 to 1.0
  double progress(List<String> discoveredIds) {
    if (monumentIds.isEmpty) return 0;
    return completedCount(discoveredIds) / monumentIds.length;
  }
}
