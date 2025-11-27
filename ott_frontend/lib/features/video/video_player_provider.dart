import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import 'video_models.dart';

/// Provides app-wide state for current video playback, including a dockable mini player.
class VideoPlayerProvider extends ChangeNotifier {
  VideoPlayerController? _controller;
  VideoItem? _current;
  bool _isMuted = false;
  bool _isExpanded = false; // false = mini, true = full
  bool _isLoading = false;
  String? _error;

  VideoPlayerController? get controller => _controller;
  VideoItem? get current => _current;
  bool get isMuted => _isMuted;
  bool get isExpanded => _isExpanded;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Duration get position => _controller?.value.position ?? Duration.zero;
  Duration get duration => _controller?.value.duration ?? Duration.zero;
  bool get isPlaying => _controller?.value.isPlaying ?? false;
  bool get hasVideo => _current != null;

  /// Dispose existing controller safely.
  Future<void> _disposeController() async {
    final c = _controller;
    _controller = null;
    if (c != null) {
      try {
        await c.pause();
      } catch (_) {}
      await c.dispose();
    }
  }

  /// Start playing a [VideoItem]. If already playing another, it replaces it.
  // PUBLIC_INTERFACE
  Future<void> play(VideoItem item, {bool expandToFull = true, bool autoplay = true}) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      await _disposeController();
      _current = item;

      final controller = item.isNetwork
          ? VideoPlayerController.networkUrl(Uri.parse(item.url!))
          : VideoPlayerController.asset(item.assetPath!);

      _controller = controller;

      await controller.initialize();

      if (_isMuted) {
        await controller.setVolume(0);
      }

      if (autoplay) {
        await controller.play();
      }

      _isExpanded = expandToFull;
      _isLoading = false;
      notifyListeners();

      controller.addListener(_onControllerUpdate);
    } catch (e) {
      _error = 'Playback error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onControllerUpdate() {
    // Propagate UI changes such as buffering/position/progress
    notifyListeners();
  }

  /// Toggle play/pause.
  // PUBLIC_INTERFACE
  Future<void> togglePlay() async {
    final c = _controller;
    if (c == null) return;
    if (c.value.isPlaying) {
      await c.pause();
    } else {
      await c.play();
    }
    notifyListeners();
  }

  /// Seek to a specific position.
  // PUBLIC_INTERFACE
  Future<void> seekTo(Duration position) async {
    final c = _controller;
    if (c == null) return;
    await c.seekTo(position);
    notifyListeners();
  }

  /// Toggle mute.
  // PUBLIC_INTERFACE
  Future<void> toggleMute() async {
    final c = _controller;
    if (c == null) return;
    _isMuted = !_isMuted;
    await c.setVolume(_isMuted ? 0 : 1);
    notifyListeners();
  }

  /// Collapse or expand the player UI.
  // PUBLIC_INTERFACE
  void setExpanded(bool expanded) {
    if (_isExpanded != expanded) {
      _isExpanded = expanded;
      notifyListeners();
    }
  }

  /// Stop playback and clear state (hides mini player).
  // PUBLIC_INTERFACE
  Future<void> stop() async {
    _error = null;
    _isLoading = false;
    _isExpanded = false;
    _current = null;
    await _disposeController();
    notifyListeners();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}
