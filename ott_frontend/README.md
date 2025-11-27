# ott_frontend

A Flutter OTT frontend featuring browsing, details, and integrated video playback with a full player and a dockable mini player.

## Video Playback

- Open-source demo videos are included (Big Buck Bunny, Sintel, Tears of Steel).
- Full player uses `video_player` with a controls overlay (play/pause, seek, mute, duration).
- Mini player docks at the bottom while you browse Home/Search/Profile and can be expanded with a tap.

### How to use
- Launch the app. On Home or Search, tap any item to open the Video Detail screen.
- Use Play to start full-screen playback, or "Play in Mini" to start playback in the mini player.
- While video is playing in mini, navigate with the bottom tabs. Tap the mini player to expand to full.

### Notes
- Handles buffering and error states gracefully with indicators and messages.
- Attribution for demo media is included in `assets/videos/README.md`.
