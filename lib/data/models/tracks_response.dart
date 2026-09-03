import 'package:jamendo_music_player/data/models/track.dart';

class TracksResponse {
  final List<Track> tracks;
  final String? next;

  const TracksResponse({required this.tracks, required this.next});

  factory TracksResponse.fromJson(Map<String, dynamic> json) {
    final tracksJson = json['results'] as List<dynamic>? ?? [];

    return TracksResponse(
      tracks: tracksJson.map((e) => Track.fromJson(e)).toList(),
      next: json['headers']?['next'] as String?,
    );
  }
}
