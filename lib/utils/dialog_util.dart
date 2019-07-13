import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  final Function positiveButton;
  final Function negativeButton;

  const DialogWidget({Key key, this.positiveButton, this.negativeButton})
      : super(key: key);

  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
    new AnimationController(vsync: this, duration: Duration(seconds: 1))
      ..forward();
//    _controller.addStatusListener(listener);
    _animation = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.1,
          curve: Curves.easeIn,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "请输入密码",
        style: TextStyle(fontSize: 20),
      ),
      content: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: "请输入安全码",
                hintStyle: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
                filled: true,
                fillColor: Color(0x30FFFFFF),
                contentPadding: EdgeInsets.only(left: 12, top: 15),
                border: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 0.0, style: BorderStyle.none)),
                counterText: '',
              ),
              maxLength: 6,
              showCursor: false,
              style: TextStyle(
                letterSpacing: 22,
                fontSize: 20,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        CupertinoButton(
          child: Text("取消"),
          onPressed: widget.negativeButton,
        ),
        CupertinoButton(
          child: Text("确定"),
          onPressed: widget.positiveButton,
        ),
      ],
    );
  }
}