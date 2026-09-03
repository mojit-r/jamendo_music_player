import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:jamendo_music_player/data/models/track.dart';
import 'package:jamendo_music_player/utils/formatters.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final bool isPlaying;
  final VoidCallback onTap;

  const TrackTile({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: isPlaying
          ? colorScheme.primaryContainer.withValues(alpha: 0.4)
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: track.imageUrl,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: Colors.grey[300]),
            // progressIndicatorBuilder: (context, url, downloadProgress) =>
            //     CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (_, _, _) => const Icon(Icons.music_note),
          ),
        ),
        title: Text(
          track.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
            color: isPlaying ? colorScheme.primary : null,
          ),
        ),
        subtitle: Text(
          track.artistName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isPlaying
              ? TextStyle(color: colorScheme.primary.withValues(alpha: 0.8))
              : null,
        ),
        trailing: Text(
          formatDuration(Duration(seconds: track.duration)),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: onTap,
      ),
    );
  }
}
