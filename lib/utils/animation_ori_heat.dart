import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_video_demo/utils/image_util.dart';

class OriToHeat extends StatefulWidget {
  _OriToHeatState createState() => new _OriToHeatState();
}

class _OriToHeatState extends State<OriToHeat>
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
              0, 19, 'assets/images/ori_heat/ori_heat_0%s.png'),
          h: 230,
          w: 328,
        ),
      ),
    );
  }
}
