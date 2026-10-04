import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jamendo_music_player/provider/player_provider.dart';
import 'package:jamendo_music_player/provider/liked_songs_provider.dart';
import 'package:jamendo_music_player/utils/formatters.dart';

class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final track = playerState.currentTrack;
    final colorScheme = Theme.of(context).colorScheme;

    if (track == null) {
      return const Scaffold(body: Center(child: Text('Nothing playing')));
    }

    final likedState = ref.watch(likedSongsProvider);
    final isLiked = likedState.isLiked(track.id);

    final maxSeconds = playerState.duration.inSeconds.toDouble();
    final currentSeconds = playerState.position.inSeconds
        .clamp(0, playerState.duration.inSeconds)
        .toDouble();

    ref.listen(playerProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(likedSongsProvider.notifier).toggleLike(track),
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.yellow : null,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outline, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: track.imageUrl,
                  width: 280,
                  height: 280,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 280,
                    height: 280,
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 280,
                    height: 280,
                    color: colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.music_note, size: 64),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 42),
            Text(
              track.name,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              track.artistName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 34),
            Slider(
              value: currentSeconds,
              max: maxSeconds > 0 ? maxSeconds : 1,
              onChanged: (value) => ref
                  .read(playerProvider.notifier)
                  .seek(Duration(seconds: value.toInt())),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(playerState.position)),
                  Text(formatDuration(playerState.duration)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () => ref.read(playerProvider.notifier).previous(),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  iconSize: 40,
                  icon: Icon(
                    playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () =>
                      ref.read(playerProvider.notifier).togglePlayPause(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.skip_next),
                  onPressed: () => ref.read(playerProvider.notifier).next(),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
