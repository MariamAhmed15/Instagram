class UserData {
  final String id;
  final String username;
  final String? name;
  String? profile_photo;
  final String? gender;
  final int followers;
  final int following;
  final String? email;
  final String? website;
  final String? phone;
  final String? bio;

  UserData({
    required this.id,
    required this.username,
    this.name,
    this.profile_photo,
    this.gender,
    required this.followers,
    required this.following,
    this.email,
    this.website,
    this.phone,
    this.bio,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      profile_photo: json['profile_photo'],
      gender: json['gender'],
      followers: json['followers'] ?? 0, // Default to 0 if null
      following: json['following'] ?? 0, // Default to 0 if null
      email: json['email'],
      website: json['website'],
      phone: json['phone'],
      bio: json['bio'], // Added bio
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'profile_photo': profile_photo,
      'gender': gender,
      'followers': followers,
      'following': following,
      'email': email,
      'website': website,
      'phone': phone,
      'bio': bio, // Added bio
    };
  }
}
