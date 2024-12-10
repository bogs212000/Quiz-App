class AppData {
  final bool update;
  final String appLink;

  AppData({

    required this.update,
    required this.appLink,
  });

  // Factory constructor to create a UserModel from a Map
  factory AppData.fromMap(Map<String, dynamic> data) {
    return AppData(
      update: data['updates'] ?? false,
      appLink: data['app_link'] ?? "",
    );
  }

  // Convert the UserModel to a Map (optional, for saving/updating data)
  Map<String, dynamic> toMap() {
    return {
      'update': update,
      'app_link': appLink,
    };
  }
}
