

/// Simple model describing a playable video source and metadata.
class VideoItem {
  /// Title displayed in UI.
  final String title;

  /// Asset path for an MP4 included in the app bundle (optional).
  final String? assetPath;

  /// Network URL for streaming (MP4 or HLS m3u8). Optional, fallback to asset.
  final String? url;

  /// Poster or thumbnail path (asset). Optional.
  final String? posterAsset;

  const VideoItem({
    required this.title,
    this.assetPath,
    this.url,
    this.posterAsset,
  });

  bool get isNetwork => url != null && url!.isNotEmpty;

  @override
  String toString() => 'VideoItem(title=$title, asset=$assetPath, url=$url)';
}

/// Curated list of open-source Blender Foundation demo videos.
/// Sources:
/// - Big Buck Bunny (CC BY 3.0)
/// - Sintel (CC BY 3.0)
/// - Tears of Steel (CC BY 3.0)
class DemoVideos {
  static const bigBuckBunny = VideoItem(
    title: 'Big Buck Bunny',
    // Local fallback mp4 bundled as asset.
    assetPath: 'assets/videos/big_buck_bunny_720p_1mb.mp4',
    // Common mirror URL for small demo clip (mp4)
    url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    posterAsset: 'assets/videos/posters/bbb.jpg',
  );

  static const sintel = VideoItem(
    title: 'Sintel',
    assetPath: 'assets/videos/sintel_720p_1mb.mp4',
    url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    posterAsset: 'assets/videos/posters/sintel.jpg',
  );

  static const tearsOfSteel = VideoItem(
    title: 'Tears of Steel',
    assetPath: 'assets/videos/tearsofsteel_720p_1mb.mp4',
    url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    posterAsset: 'assets/videos/posters/steel.jpg',
  );

  static const all = <VideoItem>[
    bigBuckBunny,
    sintel,
    tearsOfSteel,
  ];
}
