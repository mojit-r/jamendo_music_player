import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:jamendo_music_player/data/models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;

  const TrackTile({super.key, required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      title: Text(track.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(track.artistName, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: onTap,
    );
  }
}
