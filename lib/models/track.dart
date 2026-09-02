class Track {
  String id;
  String name;
  String artistName;
  String albumName;
  String imageUrl;
  String audioUrl;
  int duration;

  Track({
    required this.id,
    required this.name,
    required this.artistName,
    required this.albumName,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Track',
      artistName: json['artistName'] ?? 'Unknown Artist',
      albumName: json['albumNmae'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      duration: (json['duration'] is int)
          ? json['duration']
          : int.tryParse(json['duration']?.toString() ?? '') ?? 0,
    );
  }
}
