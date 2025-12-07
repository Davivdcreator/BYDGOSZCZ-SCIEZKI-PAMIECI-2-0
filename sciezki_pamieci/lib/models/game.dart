/// Represents a city exploration game/route
class Game {
  final String id;
  final String title;
  final String time;
  final String location;
  final List<String> categories;
  final String description;
  final String? shortDescription; // Short catchy description for cards
  final String? imagePath;
  final String? badge;
  final List<String> monumentIds; // IDs of monuments included in this game

  const Game({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.categories,
    required this.description,
    this.shortDescription,
    this.imagePath,
    this.badge,
    this.monumentIds = const [],
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      title: json['title'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      categories: List<String>.from(json['categories'] as List),
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String?,
      imagePath: json['imagePath'] as String?,
      badge: json['badge'] as String?,
      monumentIds: json['monumentIds'] != null
          ? List<String>.from(json['monumentIds'] as List)
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'location': location,
      'categories': categories,
      'description': description,
      'shortDescription': shortDescription,
      'imagePath': imagePath,
      'badge': badge,
      'monumentIds': monumentIds,
    };
  }
}
