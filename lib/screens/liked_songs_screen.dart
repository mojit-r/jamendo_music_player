import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jamendo_music_player/provider/liked_songs_provider.dart';
import 'package:jamendo_music_player/provider/player_provider.dart';
import 'package:jamendo_music_player/screens/now_playing_screen.dart';
import 'package:jamendo_music_player/widget/track_tile.dart';

class LikedSongsScreen extends ConsumerWidget {
  const LikedSongsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedState = ref.watch(likedSongsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Liked Songs')),
      body: likedState.likedTracks.isEmpty
          ? const Center(child: Text('No liked songs yet'))
          : ListView.builder(
              itemCount: likedState.likedTracks.length,
              itemBuilder: (context, index) {
                final track = likedState.likedTracks[index];
                return TrackTile(
                  track: track,
                  isPlaying:
                      false, // wire this to playerProvider.currentTrack?.id == track.id if you want highlighting here too
                  onTap: () {
                    ref
                        .read(playerProvider.notifier)
                        .playTrack(
                          track,
                          playlist: likedState.likedTracks,
                          index: index,
                        );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NowPlayingScreen(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
