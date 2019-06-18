import 'package:flutter/material.dart';

class RefreshIcon extends StatefulWidget {
  @override
  _RefreshIconState createState() => _RefreshIconState();
}

class _RefreshIconState extends State<RefreshIcon>
    with TickerProviderStateMixin {
  AnimationController animationController;

  CurvedAnimation curved;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    curved =
        new CurvedAnimation(parent: animationController, curve: Curves.linear);
    animationController.addListener(() {});
    animationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new RotationTransition(
        turns: curved,
        child: Image(
            color: Colors.red,
            image: AssetImage('assets/images/refresh/home_jiazai@2x.png')),
      ),
    );
  }
}
