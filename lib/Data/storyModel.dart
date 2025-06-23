class Story {
  final String id;
  final String userId;
  final String imageUrl;
  final int duration;

  Story({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.duration,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      userId: json['user_id'],
      imageUrl: json['image_url'],
      duration: json['duration'] ?? 5,
    );
  }
}
