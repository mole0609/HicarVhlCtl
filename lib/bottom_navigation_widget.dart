import 'package:flutter/material.dart';
import 'car_control_home.dart';

class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _bottomNavigationColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _bottomNavigationColor,
            ),
            title:
                Text('Home', style: TextStyle(color: _bottomNavigationColor))),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.email,
              color: _bottomNavigationColor,
            ),
            title:
                Text('Email', style: TextStyle(color: _bottomNavigationColor))),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.pages,
              color: _bottomNavigationColor,
            ),
            title:
                Text('Pages', style: TextStyle(color: _bottomNavigationColor))),

      ], type: BottomNavigationBarType.fixed),
      body: list[1],
    );
  }

  List<Widget> list = List();

  @override
  void initState() {
    list
      ..add(CarControlHomeActivity())
      ..add(CarControlHomeActivity())
      ..add(CarControlHomeActivity());
    super.initState();
  }
}
