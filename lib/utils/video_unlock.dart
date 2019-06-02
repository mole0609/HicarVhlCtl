import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoUnlock extends StatefulWidget {
  @override
  _VideoUnlockState createState() => _VideoUnlockState();
}

class _VideoUnlockState extends State<VideoUnlock> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/page_1/lock_unlock.mp4')
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
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
