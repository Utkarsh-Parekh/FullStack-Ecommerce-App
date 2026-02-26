class UserModel {
  final String id;
  final String username;
  final String emailId;
  final String refreshToken;
  final bool isLoggedIn;

  UserModel({
    required this.id,
    required this.username,
    required this.emailId,
    required this.refreshToken,
    required this.isLoggedIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["username"],
      emailId: json["emailId"],
      refreshToken: '',
      isLoggedIn: json["isLoggedIn"] ?? false
    );
  }

  factory UserModel.fromLoginJson(Map<String, dynamic> json) {
    final user = json["user"];
    return UserModel(
      id: user["id"],
      username: user["username"],
      emailId: user["emailId"],
      refreshToken: json["refreshToken"],
      isLoggedIn: user["isLoggedIn"]
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'emailId': emailId,  'refreshToken': refreshToken,
    'isLoggedIn': isLoggedIn
    };
  }
}
