class Track {
  final String id;
  final String name;
  final String artistName;
  final String albumName;
  final String imageUrl;
  final String audioUrl;
  final int duration;

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
      artistName: json['artist_name'] ?? 'Unknown Artist',
      albumName: json['album_name'] ?? '',
      imageUrl: json['image'] ?? '',
      audioUrl: json['audio'] ?? '',
      duration: (json['duration'] is int)
          ? json['duration']
          : int.tryParse(json['duration']?.toString() ?? '') ?? 0,
    );
  }
}
