class Podcast {
  final String id;
  final String title;
  final String article;
  final String type;
  final String authorName;
  final String? audioUrl;
  final DateTime createdAt;

  Podcast({
    required this.id,
    required this.title,
    required this.article,
    required this.type,
    required this.authorName,
    this.audioUrl,
    required this.createdAt,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'].toString(),
      title: json['title'],
      article: json['article'],
      type: json['type'],
      authorName: json['author_name'],
      audioUrl: json['audio_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
