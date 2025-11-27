import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../app_theme.dart';
import 'video_player_provider.dart';

/// A dockable mini player that appears at the bottom of the app when a video is active.
/// Tapping expands to full; provides minimal inline controls.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerProvider>(
      builder: (context, vm, _) {
        if (!vm.hasVideo || vm.isExpanded) {
          return const SizedBox.shrink();
        }

        final controller = vm.controller;
        final hasError = vm.error != null || (controller?.value.hasError ?? false);

        if (controller == null || !controller.value.isInitialized) {
          // Show poster thumbnail if available while loading
          final poster = vm.current?.posterUrl;
          final posterAsset = vm.current?.posterAsset;
          return _MiniBarSkeleton(
            onClose: vm.stop,
            posterUrl: poster,
            posterAsset: posterAsset,
            error: hasError ? (vm.error ?? controller?.value.errorDescription) : null,
          );
        }

        final aspect = controller.value.aspectRatio == 0 ? (16 / 9) : controller.value.aspectRatio;

        return Material(
          elevation: 8,
          color: Colors.black,
          child: InkWell(
            onTap: () => vm.setExpanded(true),
            child: SizedBox(
              height: 72,
              child: Row(
                children: [
                  // Video preview
                  AspectRatio(
                    aspectRatio: aspect,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        VideoPlayer(controller),
                        // overlay just for buffering indicator in mini
                        if (controller.value.isBuffering)
                          const Center(child: CircularProgressIndicator(color: Colors.white)),
                        if (hasError)
                          Container(
                            color: Colors.black54,
                            alignment: Alignment.center,
                            child: const Icon(Icons.error_outline, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title + progress
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.current?.title ?? 'Now Playing',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          backgroundColor: Colors.white24,
                          color: AppTheme.primary,
                          value: _progress(vm),
                          minHeight: 2,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(vm.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                    onPressed: vm.togglePlay,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: vm.stop,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _progress(VideoPlayerProvider vm) {
    final d = vm.duration.inMilliseconds;
    if (d == 0) return 0;
    final p = vm.position.inMilliseconds.clamp(0, d);
    return p / d;
  }
}

class _MiniBarSkeleton extends StatelessWidget {
  final Future<void> Function() onClose;
  final String? posterUrl;
  final String? posterAsset;
  final String? error;

  const _MiniBarSkeleton({
    required this.onClose,
    this.posterUrl,
    this.posterAsset,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.black,
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            SizedBox(
              width: 128,
              child: ClipRRect(
                child: _buildPoster(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error != null ? (error!) : 'Loading...',
                style: TextStyle(color: error != null ? Colors.red[200] : Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster() {
    if (posterAsset != null && posterAsset!.isNotEmpty) {
      return Image.asset(posterAsset!, fit: BoxFit.cover);
    }
    if (posterUrl != null && posterUrl!.isNotEmpty) {
      return Image.network(
        posterUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: Colors.black26),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.black26,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
          );
        },
      );
    }
    return Container(color: Colors.black26);
  }
}
