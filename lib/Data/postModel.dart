class Post {
  String description;
  String username;
  int likes;
  String postId;
  DateTime datePublished;
  String postUrl;
  String profImage;

  Post({
    required this.description,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  // Method to create a copy of the post with updated likes
  Post copyWith({int? likes}) {
    return Post(
      description: description,
      username: username,
      likes: likes ?? this.likes,
      postId: postId,
      datePublished: datePublished,
      postUrl: postUrl,
      profImage: profImage,
    );
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      description: map["description"],
      likes: map["likes"] is List ? (map["likes"] as List).length : map["likes"] ?? 0,  // Ensure likes is an int
      postId: map["postId"],
      datePublished: DateTime.parse(map["datePublished"]),
      username: map["username"],
      postUrl: map["postUrl"],
      profImage: map["profImage"],
    );
  }

  Map<String, dynamic> toJson() => {
    "description": description,
    "likes": likes,
    "username": username,
    "postId": postId,
    "datePublished": datePublished.toIso8601String(),
    "postUrl": postUrl,
    "profImage": profImage,
  };
}
