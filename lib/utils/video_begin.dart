import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_video_demo/utils/image_util.dart';
import 'package:flutter_app_video_demo/utils/video_unlock.dart';
import 'package:video_player/video_player.dart';

class VideoOn extends StatefulWidget {
  _VideoOnState createState() => new _VideoOnState();
}
class _VideoOnState extends State<VideoOn>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();

    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 50.0, end: 50.0).animate(controller);
    controller.forward();
  }

  Widget build(BuildContext context) {
    return new AnimatedShow(animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedShow extends AnimatedWidget {
  AnimatedShow({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Center(
      child: new Container(
        padding: EdgeInsets.all(7),
        child: VideoUnlock(),
      ),
    );
  }
}
