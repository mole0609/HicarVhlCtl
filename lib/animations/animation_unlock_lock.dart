import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_video_demo/utils/image_util.dart';

class UnLockToLock extends StatefulWidget {
  _UnLockToLockState createState() => new _UnLockToLockState();
}

class _UnLockToLockState extends State<UnLockToLock>
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
              0, 46, 'assets/images/unlock_lock/解锁——上锁 原角度_000%s.jpg'),
          h: 230,
          w: 328,
        ),
      ),
    );
  }
}
