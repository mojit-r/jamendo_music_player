import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jamendo_music_player/data/models/track.dart';
import 'package:just_audio/just_audio.dart';

class PlayerState {
  final Track? currentTrack;
  final List<Track> playlist;
  final int currentIndex;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final String? error;

  const PlayerState({
    this.currentTrack,
    this.playlist = const [],
    this.currentIndex = -1,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.error,
  });

  PlayerState copyWith({
    Track? currentTrack,
    List<Track>? playlist,
    int? currentIndex,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    String? error,
  }) {
    return PlayerState(
      currentTrack: currentTrack ?? this.currentTrack,
      playlist: playlist ?? this.playlist,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      error: error ?? this.error,
    );
  }
}

class PlayerNotifier extends Notifier<PlayerState> {
  final _audioPlayer = AudioPlayer();
  @override
  PlayerState build() {
    _audioPlayer.playerStateStream.listen(
      (playerState) {
        state = state.copyWith(isPlaying: playerState.playing);
        if (playerState.processingState == ProcessingState.completed) {
          next();
        }
      },
      onError: (e, st) {
        state = PlayerState(
          currentTrack: state.currentTrack,
          playlist: state.playlist,
          currentIndex: state.currentIndex,
          isPlaying: false,
          position: state.position,
          duration: state.duration,
          error: 'Playback error — check your connection',
        );
      },
    );
    _audioPlayer.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });
    _audioPlayer.durationStream.listen((dur) {
      state = state.copyWith(duration: dur ?? Duration.zero);
    });

    ref.onDispose(() => _audioPlayer.dispose());

    return const PlayerState();
  }

  Future<void> playTrack(
    Track track, {
    required List<Track> playlist,
    required int index,
  }) async {
    if (state.currentTrack?.id == track.id) {
      return;
    }
    state = state.copyWith(
      currentTrack: track,
      playlist: playlist,
      currentIndex: index,
    );
    try {
      await _audioPlayer.setUrl(track.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      state = PlayerState(
        currentTrack: state.currentTrack,
        playlist: state.playlist,
        currentIndex: state.currentIndex,
        isPlaying: false,
        error: 'Couldn\'t play track — check your connection',
      );
    }
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  Future<void> next() async {
    if (state.currentIndex < state.playlist.length - 1) {
      final nextIndex = state.currentIndex + 1;
      await playTrack(
        state.playlist[nextIndex],
        playlist: state.playlist,
        index: nextIndex,
      );
    }
  }

  Future<void> previous() async {
    if (state.currentIndex > 0) {
      final prevIndex = state.currentIndex - 1;
      await playTrack(
        state.playlist[prevIndex],
        playlist: state.playlist,
        index: prevIndex,
      );
    }
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(
  PlayerNotifier.new,
);
