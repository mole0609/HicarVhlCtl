import 'package:flutter/material.dart';

void showMyMaterialDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: new Text(
            "输入安全码",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: 100,
            height: 100,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                myBox(),
                myBox(),
                myBox(),
                myBox(),
                myBox(),
                myBox(),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("确认"),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("取消"),
            ),
          ],
        );
      });
}
Widget myBox(){
  return Container(
    color: Color(0xFF882188),
    child: SizedBox(
      height: 30,
      width: 20,
      child: Text('1'),
    ),
  );
}