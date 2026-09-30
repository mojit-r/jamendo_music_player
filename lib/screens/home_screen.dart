import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jamendo_music_player/provider/player_provider.dart';
import 'package:jamendo_music_player/screens/liked_songs_screen.dart';
import 'package:jamendo_music_player/screens/now_playing_screen.dart';
import 'package:jamendo_music_player/widget/mini_player.dart';
import 'package:lottie/lottie.dart';

import 'package:jamendo_music_player/provider/track_list_provider.dart';
import 'package:jamendo_music_player/theme/theme.dart';
import 'package:jamendo_music_player/widget/custom_search_bar.dart';
import 'package:jamendo_music_player/widget/track_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(trackListProvider.notifier).fetchTracks());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await ref.read(trackListProvider.notifier).refresh();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(trackListProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final musicState = ref.watch(trackListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jamendo Player',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset('assets/icon/app_icon.png'),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const LikedSongsScreen())),
            icon: const Icon(Icons.favorite, color: Colors.yellow),
          ),
          IconButton(
            onPressed: () => ref.read(themeProvider.notifier).themeChanger(),
            tooltip: 'theme mode',
            icon: Icon(themeState.themeIcon),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: CustomSearchBar(
              controller: _searchController,
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  ref.read(trackListProvider.notifier).fetchTracks();
                } else {
                  ref.read(trackListProvider.notifier).search(value.trim());
                }
              },
              onCleared: () =>
                  ref.read(trackListProvider.notifier).fetchTracks(),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: switch (musicState) {
          _ when musicState.isLoading => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 300),
              Center(child: CircularProgressIndicator()),
            ],
          ),
          _ when musicState.error != null && musicState.tracks.isEmpty =>
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 300),
                Center(child: Text(musicState.error!)),
              ],
            ),
          _ when musicState.tracks.isEmpty => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 300),
              Center(child: Text('No tracks found')),
            ],
          ),
          _ => ListView.builder(
            controller: _scrollController,
            itemCount:
                musicState.tracks.length +
                ((musicState.isLoadingMore || musicState.hasReachedEnd)
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (index >= musicState.tracks.length) {
                if (musicState.hasReachedEnd) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('You\'ve reached the end')),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Lottie.asset(
                      'assets/animations/sound_wave.json',
                      height: 80,
                    ),
                  ),
                );
              }
              final track = musicState.tracks[index];
              final playerState = ref.watch(playerProvider);
              final isCurrentTrack = playerState.currentTrack?.id == track.id;
              return TrackTile(
                track: track,
                isPlaying: isCurrentTrack,
                onTap: () {
                  ref
                      .read(playerProvider.notifier)
                      .playTrack(
                        track,
                        playlist: musicState.tracks,
                        index: index,
                      );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
                  );
                },
              );
            },
          ),
        },
      ),
      floatingActionButton: const MiniPlayer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
