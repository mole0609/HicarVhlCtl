import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_video_demo/utils/image_util.dart';

class InitOri extends StatefulWidget {
  _InitOriState createState() => new _InitOriState();
}

class _InitOriState extends State<InitOri>
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
        child: new ImagesAnimation(
          durationSeconds: 1,
          entry: ImagesAnimationEntry(
              0, 0, 'assets/images/ori_heat/1原角度——热车（开）_000%s.jpg'),
          h: 230,
          w: 328,
        ),
      ),
    );
  }
}
