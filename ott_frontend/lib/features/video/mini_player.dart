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
        if (controller == null || !controller.value.isInitialized) {
          return _MiniBarSkeleton(onClose: vm.stop);
        }

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
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        VideoPlayer(controller),
                        // overlay just for buffering indicator in mini
                        if (controller.value.isBuffering)
                          const Center(child: CircularProgressIndicator(color: Colors.white)),
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

  const _MiniBarSkeleton({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.black,
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            Container(width: 128, color: Colors.black26),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Loading...', style: TextStyle(color: Colors.white70)),
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
}
