import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'video_controls_overlay.dart';
import 'video_models.dart';
import 'video_player_provider.dart';

/// Full-screen video player page.
/// Expects a VideoItem in route args with key 'item'.
class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  // PUBLIC_INTERFACE
  static Route route(VideoItem item) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/player'),
      builder: (_) => _VideoPlayerPage(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // not used directly; use route() above
  }
}

class _VideoPlayerPage extends StatefulWidget {
  final VideoItem item;

  const _VideoPlayerPage({required this.item});

  @override
  State<_VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<_VideoPlayerPage> {
  @override
  void initState() {
    super.initState();
    // Trigger playback on open, expand to full
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<VideoPlayerProvider>()
          .play(widget.item, expandToFull: true, autoplay: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerProvider>(
      builder: (context, vm, _) {
        final controller = vm.controller;
        final isInitialized = controller?.value.isInitialized ?? false;
        final hasError = vm.error != null || (controller?.value.hasError ?? false);
        final aspect = isInitialized
            ? (controller!.value.aspectRatio == 0
                ? (16 / 9)
                : controller.value.aspectRatio)
            : (16 / 9);

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text(widget.item.title),
          ),
          body: SafeArea(
            child: Center(
              child: AspectRatio(
                aspectRatio: aspect,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isInitialized)
                      VideoPlayer(controller!)
                    else
                      _PosterPlaceholder(item: widget.item),
                    if (hasError)
                      Container(
                        color: Colors.black87,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            vm.error ??
                                controller?.value.errorDescription ??
                                'Playback error',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      const VideoControlsOverlay(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  final VideoItem item;
  const _PosterPlaceholder({required this.item});

  @override
  Widget build(BuildContext context) {
    final posterAsset = item.posterAsset;
    final posterUrl = item.posterUrl;

    if (posterAsset != null && posterAsset.isNotEmpty) {
      return Image.asset(posterAsset, fit: BoxFit.cover);
    }
    if (posterUrl != null && posterUrl.isNotEmpty) {
      return Image.network(
        posterUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const ColoredBox(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        },
      );
    }
    return const ColoredBox(color: Colors.black);
  }
}
