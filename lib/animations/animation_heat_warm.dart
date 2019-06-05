import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_video_demo/utils/image_util.dart';

class HeatedAndWarm extends StatefulWidget {
  _HeatedAndWarmState createState() => new _HeatedAndWarmState();
}

class _HeatedAndWarmState extends State<HeatedAndWarm>
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
          durationSeconds: 2,
          entry: ImagesAnimationEntry(
              0, 43, 'assets/images/heat_warm/2热车（开）——温暖_000%s.jpg'),
          h: 230,
          w: 328,
        ),
      ),
    );
  }
}
