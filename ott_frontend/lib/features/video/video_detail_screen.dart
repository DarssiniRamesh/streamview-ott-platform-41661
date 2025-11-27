import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import 'video_models.dart';
import 'video_player_provider.dart';
import 'video_player_screen.dart';

/// Video detail screen with a Play button that starts playback and expands
/// to full-screen player. Also supports mini player persistence.
class VideoDetailScreen extends StatelessWidget {
  final VideoItem item;

  const VideoDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final posterAsset = item.posterAsset;
    final posterUrl = item.posterUrl;

    Widget posterWidget;
    if (posterAsset != null && posterAsset.isNotEmpty) {
      posterWidget = Image.asset(
        posterAsset,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (posterUrl != null && posterUrl.isNotEmpty) {
      posterWidget = Image.network(
        posterUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Icon(Icons.movie, size: 48)),
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      posterWidget = Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Icon(Icons.movie, size: 48)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: posterWidget,
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Open-source demo video from Blender Foundation (CC BY 3.0).',
              style: TextStyle(color: AppTheme.secondary),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                  onPressed: () async {
                    // Start playback and navigate to full player
                    await context.read<VideoPlayerProvider>().play(item, expandToFull: true, autoplay: true);
                    if (context.mounted) {
                      Navigator.of(context).push(VideoPlayerScreen.route(item));
                    }
                  },
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.picture_in_picture_alt),
                  label: const Text('Play in Mini'),
                  onPressed: () async {
                    await context.read<VideoPlayerProvider>().play(item, expandToFull: false, autoplay: true);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Playing in mini player')),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a demonstration of integrated video playback with a full player and a dockable mini player. '
              'You can continue browsing while the mini player remains at the bottom.',
            ),
          ],
        ),
      ),
    );
  }
}
