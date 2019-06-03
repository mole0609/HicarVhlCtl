import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_video_demo/utils/image_util.dart';

class CircleOff extends StatefulWidget {
  _CircleOffState createState() => new _CircleOffState();
}

class _CircleOffState extends State<CircleOff>
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
        child: new ImagesAnimation(
          durationSeconds: 1,
          entry: ImagesAnimationEntry(
              0, 0, 'assets/images/circles/圆圈点亮1_000%s.png'),
          h: 60,
          w: 60,
        ),
      ),
    );
  }
}
