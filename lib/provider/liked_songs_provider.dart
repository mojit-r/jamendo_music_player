import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jamendo_music_player/data/models/track.dart';

class LikedSongsState {
  final Set<String> likedTrackIds;
  final List<Track> likedTracks; 

  const LikedSongsState({
    this.likedTrackIds = const {},
    this.likedTracks = const [],
  });

  bool isLiked(String trackId) => likedTrackIds.contains(trackId);
}

class LikedSongsNotifier extends Notifier<LikedSongsState> {
  @override
  LikedSongsState build() => const LikedSongsState();

  void toggleLike(Track track) {
    final ids = Set<String>.from(state.likedTrackIds);
    final tracks = List<Track>.from(state.likedTracks);

    if (ids.contains(track.id)) {
      ids.remove(track.id);
      tracks.removeWhere((t) => t.id == track.id);
    } else {
      ids.add(track.id);
      tracks.add(track);
    }

    state = LikedSongsState(likedTrackIds: ids, likedTracks: tracks);
  }
}

final likedSongsProvider =
    NotifierProvider<LikedSongsNotifier, LikedSongsState>(
      LikedSongsNotifier.new,
    );
