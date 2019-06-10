import 'package:flutter/material.dart';
import 'package:flutter_app_video_demo/bottom_navigation_widget.dart';
import 'package:flutter_app_video_demo/car_control_home.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: BottomNavigationWidget(),
//      home: CarControlHomeActivity(),
    );
  }
}


class AnimationHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: IconButton(
            icon: ImageIcon(
              AssetImage(
                'images/home_icon_personal.png',
              ),
              color: Colors.white,
            ),
            onPressed: null),
      ),
//      body:DebugDump(),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context,position){
            return   ListTile(
              title: Text(list[position].name),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder:list[position].builder));
              },
            );
          }
      ),
    );
  }
}

class _RouterInfo {
  String name;
  WidgetBuilder builder;
  _RouterInfo({this.name, this.builder});
}

final List<_RouterInfo> list = <_RouterInfo>[
  _RouterInfo(name: "CarControl", builder: (context) => CarControlHomeActivity()),
];