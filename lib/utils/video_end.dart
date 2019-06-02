import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_video_demo/utils/image_util.dart';
import 'package:flutter_app_video_demo/utils/video_lock.dart';
import 'package:flutter_app_video_demo/utils/video_unlock.dart';

class VideoOff extends StatefulWidget {
  _VideoOffState createState() => new _VideoOffState();
}

class _VideoOffState extends State<VideoOff>
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
    return new AnimatedDismiss(animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedDismiss extends AnimatedWidget {
  AnimatedDismiss({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Center(
      child: new Container(
        padding: EdgeInsets.all(7),
        child: VideoLock(),
      ),
    );
  }
}
