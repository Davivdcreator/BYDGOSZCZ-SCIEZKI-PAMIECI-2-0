class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final int points;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.points = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'lastSeen': DateTime.now().toIso8601String(),
    };
  }
}
