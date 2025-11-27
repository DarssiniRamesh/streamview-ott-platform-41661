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
      context.read<VideoPlayerProvider>().play(widget.item, expandToFull: true, autoplay: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerProvider>(
      builder: (context, vm, _) {
        final controller = vm.controller;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text(widget.item.title),
          ),
          body: controller == null || !controller.value.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio == 0 ? 16 / 9 : controller.value.aspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          VideoPlayer(controller),
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
