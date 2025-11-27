import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'video_player_provider.dart';

/// Overlay with play/pause, scrubber, mute, and duration display.
/// Shows buffering/progress and error states gracefully.
class VideoControlsOverlay extends StatelessWidget {
  const VideoControlsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerProvider>(
      builder: (context, vm, _) {
        final controller = vm.controller;
        final error = vm.error;
        final isLoading = vm.isLoading;

        if (error != null) {
          return _ErrorOverlay(message: error, onClose: vm.stop);
        }

        if (controller == null) {
          return const SizedBox.shrink();
        }

        final value = controller.value;

        return Stack(
          children: [
            // Buffering indicator centered
            if (isLoading || value.isBuffering)
              const Center(
                child: CircularProgressIndicator(),
              ),
            // Tap to play/pause center button
            if (!isLoading)
              Center(
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black45,
                  ),
                  iconSize: 56,
                  onPressed: vm.togglePlay,
                  icon: Icon(
                    value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            // Bottom gradient bar with progress, time, mute, fullscreen toggle hint
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomControlsBar(vm: vm),
            ),
          ],
        );
      },
    );
  }
}

class _ErrorOverlay extends StatelessWidget {
  final String message;
  final Future<void> Function() onClose;

  const _ErrorOverlay({required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.white70, size: 40),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
            label: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _BottomControlsBar extends StatelessWidget {
  final VideoPlayerProvider vm;

  const _BottomControlsBar({required this.vm});

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '${two(h)}:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
    // keeping minimalistic
  }

  @override
  Widget build(BuildContext context) {
    final duration = vm.duration;
    final position = vm.position;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black54],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: vm.isMuted ? 'Unmute' : 'Mute',
                icon: Icon(vm.isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white),
                onPressed: vm.toggleMute,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                    trackHeight: 2.5,
                  ),
                  child: Slider(
                    value: duration.inMilliseconds == 0
                        ? 0
                        : (position.inMilliseconds.clamp(0, duration.inMilliseconds)).toDouble(),
                    min: 0,
                    max: duration.inMilliseconds == 0 ? 1 : duration.inMilliseconds.toDouble(),
                    onChanged: (v) {
                      vm.seekTo(Duration(milliseconds: v.toInt()));
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_fmt(position)} / ${_fmt(duration)}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
