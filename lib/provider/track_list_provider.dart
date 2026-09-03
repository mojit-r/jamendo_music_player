import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jamendo_music_player/data/models/track.dart';
import 'package:jamendo_music_player/data/services/jamendo_service.dart';

class TrackListState {
  final List<Track> tracks;
  final bool isLoading;
  final int offset;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String? error;

  const TrackListState({
    required this.tracks,
    required this.isLoading,
    required this.offset,
    required this.isLoadingMore,
    required this.hasReachedEnd,
    this.error,
  });

  TrackListState copyWith({
    List<Track>? tracks,
    bool? isLoading,
    int? offset,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) {
    return TrackListState(
      tracks: tracks ?? this.tracks,
      isLoading: isLoading ?? this.isLoading,
      offset: offset ?? this.offset,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: null,
    );
  }

  TrackListState withError(String message) {
    return TrackListState(
      tracks: tracks,
      isLoading: isLoading,
      offset: offset,
      isLoadingMore: isLoadingMore,
      hasReachedEnd: hasReachedEnd,
      error: message,
    );
  }
}

class TrackListNotifier extends Notifier<TrackListState> {
  final _service = JamendoService();
  static const _limit = 20;
  String? _activeQuery; // null = browsing, non-null = searching

  @override
  TrackListState build() {
    return const TrackListState(
      tracks: [],
      isLoading: false,
      offset: 0,
      isLoadingMore: false,
      hasReachedEnd: false,
    );
  }

  Future<void> fetchTracks() async {
    _activeQuery = null;
    state = const TrackListState(
      tracks: [],
      isLoading: true,
      offset: 0,
      isLoadingMore: false,
      hasReachedEnd: false,
    );
    await loadPage(offset: 0);
  }

  Future<void> search(String query) async {
    _activeQuery = query;
    state = const TrackListState(
      tracks: [],
      isLoading: true,
      offset: 0,
      isLoadingMore: false,
      hasReachedEnd: false,
    );
    await loadPage(offset: 0);
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.isLoadingMore || state.hasReachedEnd) return;
    state = state.copyWith(isLoadingMore: true);
    await loadPage(offset: state.offset, isNextPage: true);
  }

  Future<void> refresh() async {
    if (_activeQuery == null) {
      await fetchTracks();
    } else {
      await search(_activeQuery!);
    }
  }

  Future<void> loadPage({required int offset, bool isNextPage = false}) async {
    try {
      final response = _activeQuery == null
          ? await _service.getTracks(limit: _limit, offset: offset)
          : await _service.searchTracks(
              query: _activeQuery!,
              limit: _limit,
              offset: offset,
            );

      state = TrackListState(
        tracks: isNextPage
            ? [...state.tracks, ...response.tracks]
            : response.tracks,
        isLoading: false,
        isLoadingMore: false,
        offset: offset + _limit,
        hasReachedEnd: response.tracks.length < _limit || response.next == null,
        error: null,
      );
    } catch (e) {
      state = state
          .copyWith(isLoading: false, isLoadingMore: false)
          .withError(e.toString());
    }
  }
}

final trackListProvider = NotifierProvider<TrackListNotifier, TrackListState>(
  TrackListNotifier.new,
);
