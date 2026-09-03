import 'package:jamendo_music_player/data/models/track.dart';

class TracksResponse {
  final List<Track> tracks;
  final int resultsCount;

  const TracksResponse({required this.tracks, required this.resultsCount});

  factory TracksResponse.fromJson(Map<String, dynamic> json) {
    final tracksJson = json['results'] as List<dynamic>? ?? [];

    return TracksResponse(
      tracks: tracksJson.map((e) => Track.fromJson(e)).toList(),
      resultsCount: json['headers']?['results_count'] ?? 0,
    );
  }
}
