import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_video_demo/utils/image_util.dart';

class CircleOn extends StatefulWidget {
  _CircleOnState createState() => new _CircleOnState();
}
class _CircleOnState extends State<CircleOn>
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
        child: new ImagesAnimation(
          durationSeconds: 1,
          entry: ImagesAnimationEntry(
              0, 26, 'assets/images/circles/圆圈点亮1_000%s.png'),
          h: 60,
          w: 60,
        ),
      ),
    );
  }
}

