import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLock extends StatefulWidget {
  @override
  _VideoLockState createState() => _VideoLockState();
}

class _VideoLockState extends State<VideoLock> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/page_1/unlock_lock.mp4')
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          })..setLooping(false)..setVolume(0)
          ..play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF100F27),
        body: Center(
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: VideoPlayer(_controller),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
