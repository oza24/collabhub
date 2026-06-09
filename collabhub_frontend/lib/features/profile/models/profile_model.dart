class ProfileModel {
  final String id;
  final String username;
  final String email;
  final String avatar;
  final String bio;
  final List<dynamic> workspaces;
  final List<dynamic> channels;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
    required this.bio,
    required this.workspaces,
    required this.channels ,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["_id"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      avatar: json["avatar"] ?? "",
      bio: json["bio"] ?? "",
      workspaces: json["workspaces"] ?? [],
      channels: json["channels"] ?? [],
    );
  }
}