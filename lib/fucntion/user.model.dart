class UserModel {
  final String username;
  final String email;
  final String profile;
  final int score;

  UserModel({
    required this.username,
    required this.email,
    required this.profile,
    required this.score,
  });

  // Factory constructor to create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profile: data['profile'] ?? '',
      score: data['score'] ?? 0,
    );
  }

  // Convert the UserModel to a Map (optional, for saving/updating data)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profile': profile,
      'score': score,
    };
  }
}
