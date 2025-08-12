class Podcast {
  final String id;
  final String title;
  final String article;
  final String type;
  final String authorName;
  final String? audioUrl;
  final DateTime createdAt;
  // Optional list of attachment URLs (images or files)
  final List<String> attachments;

  Podcast({
    required this.id,
    required this.title,
    required this.article,
    required this.type,
    required this.authorName,
    this.audioUrl,
    required this.createdAt,
    this.attachments = const [],
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    List<String> parsedAttachments = const [];
    final rawAttachments = json['attachments'];
    if (rawAttachments is List) {
      parsedAttachments =
          rawAttachments.whereType<dynamic>().map((e) => e.toString()).toList();
    } else if (rawAttachments is String && rawAttachments.isNotEmpty) {
      // If backend returns a single URL string, wrap it
      parsedAttachments = [rawAttachments];
    }

    return Podcast(
      id: json['id'].toString(),
      title: json['title'],
      article: json['article'],
      type: json['type'],
      authorName: json['author_name'],
      audioUrl: json['audio_url'],
      createdAt: DateTime.parse(json['created_at']),
      attachments: parsedAttachments,
    );
  }
}
