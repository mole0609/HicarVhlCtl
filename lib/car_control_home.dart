import 'package:flutter/material.dart';
import 'package:flutter_app_video_demo/animations/animation_circle_on.dart';
import 'package:flutter_app_video_demo/animations/animation_circle_off.dart';
import 'package:flutter_app_video_demo/animations/animation_heat_ori.dart';
import 'package:flutter_app_video_demo/animations/animation_lock_unlock.dart';
import 'package:flutter_app_video_demo/animations/animation_ori_heat.dart';
import 'package:flutter_app_video_demo/animations/animation_unlock_lock.dart';
import 'package:flutter_app_video_demo/utils/date_format_util.dart';
import 'package:flutter_app_video_demo/utils/log_util.dart';
import 'dart:async';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'utils/image_util.dart';

class CarControlHomeActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoState();
  }
}

class _VideoState extends State<CarControlHomeActivity> {
  final String TAG = '[CarContrlLog]';
  int count = 0;

  StreamController<int> _streamControllerLock,
      _streamControllerHeat,
      _streamControllerWarm,
      _streamControllerCold,
      _streamControllerWindow,
      _streamControllerTrail
  ;

  ImagesAnimation imagesAnimation;
  ImagesAnimationEntry imagesAnimationEntry;

  bool _isLocked = true;
  bool _isHeated = false;
  bool _isWarmed = false;
  bool _isCooled = false;
  bool _isWinClosed = false;
  bool _isTraClosed = false;

  _VideoState() {
    printLog('_VideoState--------------');
    imagesAnimation = new ImagesAnimation(
      durationSeconds: 1,
      entry: ImagesAnimationEntry(
        26,
        26,
        'assets/images/circles/圆圈点亮1_000%s.png',
      ),
      h: 60,
      w: 60,
    );
  }

  @override
  void initState() {
    super.initState();
    printLog('initState-----------------');
    _streamControllerHeat = StreamController.broadcast();
    _streamControllerWarm = StreamController.broadcast();
    _streamControllerCold = StreamController.broadcast();
    _streamControllerLock = StreamController.broadcast();
    _streamControllerWindow = StreamController.broadcast();
    _streamControllerTrail = StreamController.broadcast();
  }

  @override
  void dispose() {
    printLog('dispose-----------------');
    _streamControllerHeat.close();
    _streamControllerLock.close();
    _streamControllerWarm.close();
    _streamControllerCold.close();
    _streamControllerWindow.close();
    _streamControllerTrail.close();
    super.dispose();
  }


  void _onLockClickLister() {
    _isLocked = !_isLocked;
    _streamControllerLock.sink.add(++count);
  }
  void onHeatClickListener() {
    _isHeated = !_isHeated;
//    _addHeatingToStream();
    _streamControllerHeat.sink.add(++count);
  }
  void onWarmClickListener() {
    _isWarmed = !_isWarmed;
//    _addHeatingToStream();
    _streamControllerWarm.sink.add(++count);
  }
  void onColdClickListener() {
    _isCooled = !_isCooled;
//    _addHeatingToStream();
    _streamControllerCold.sink.add(++count);
  }
  void onWindowClickListener() {
    _isWinClosed = !_isWinClosed;
//    _addHeatingToStream();
    _streamControllerWindow.sink.add(++count);
  }
  void onTrailClickListener() {
    _isTraClosed = !_isTraClosed;
//    _addHeatingToStream();
    _streamControllerTrail.sink.add(++count);
  }

  _getCurrentTime() {
    return formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    List<Widget> pageList = new List();
    pageList.add(_pageUnlock());
    pageList.add(_pageCarControl());
    pageList.add(_pageCarMode());
    return pageList[index];
  }

  _pageUnlock() {
    return Container(
      child: Column(children: <Widget>[
        SizedBox(
          height: 230.0,
          width: 328.0,
          child: StreamBuilder<Object>(
              stream: _streamControllerLock.stream,
              initialData: 0,
              builder: (context, snapshot) {
                if (!_isLocked) {
                  return new LockToUnLock();
                } else {
                  return new UnLockToLock();
                }
              }),
        ),
        SizedBox(
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
            ),
            color: const Color(0xFF100F27),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image(
                    image: AssetImage('assets/images/home_icon_refresh@3x.png'),
                    fit: BoxFit.contain,
                    height: 14,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(
                    "刷新时间：${_getCurrentTime()}",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                color: const Color(0xFF100F27),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(25))),
                          color: const Color(0xFF584AA8),
                        ),
                        child: FlatButton(
                            onPressed: () {
                              _onLockClickLister();
                            },
                            child: StreamBuilder<Object>(
                                stream: _streamControllerLock.stream,
                                initialData: 0,
                                builder: (context, snapshot) {
                                  return _isLocked
                                      ? Text('                 解锁                 ',
                                    style: TextStyle(color: Colors.white, fontSize: 25),)
                                      : Text('                 上锁                 ',
                                    style: TextStyle(color: Colors.white, fontSize: 25),);
                                }))),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
  _pageCarControl() {
    return Container(
      child: Column(children: <Widget>[
        SizedBox(
          height: 230.0,
          width: 328.0,
          child: StreamBuilder<Object>(
              stream: _streamControllerHeat.stream,
              initialData: 0,
              builder: (context, snapshot) {
                printLog('isHeated---------------' + _isHeated.toString());
                if (_isHeated) {
                  return new OriToHeat();
                } else {
                  return new HeatToOri();
                }
              }),
        ),
        SizedBox(
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
            ),
            color: const Color(0xFF100F27),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image(
                    image: AssetImage('assets/images/home_icon_refresh@3x.png'),
                    fit: BoxFit.contain,
                    height: 14,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(
                    "刷新时间：${_getCurrentTime()}",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 129,
          width: 340,
          child: Container(
//            color: const Color(0xFF999999),
            margin: EdgeInsets.only(top: 25),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                    width: 270,
                    color: const Color(0xFF100F27),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                StreamBuilder<Object>(
                                    stream: _streamControllerHeat.stream,
                                    initialData: 0,
                                    builder: (context, snapshot) {
                                      if (!_isHeated) {
                                        return new CircleOff();
                                      } else {
                                        return new CircleOn();
                                      }
                                    }),
                                Center(
                                  child: IconButton(
                                    padding: EdgeInsets.all(10),
                                    iconSize: 55,
                                    icon: StreamBuilder<Object>(
                                        stream: _streamControllerHeat.stream,
                                        initialData: 0,
                                        builder: (context, snapshot) {
                                          return !_isHeated
                                              ? ImageIcon(
                                            AssetImage(
                                              'assets/images/open_bt_no_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          )
                                              : ImageIcon(
                                            AssetImage(
                                              'assets/images/open_bt_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          );
                                        }),
                                    onPressed: onHeatClickListener,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<Object>(
                                stream: _streamControllerHeat.stream,
                                initialData: 0,
                                builder: (context, snapshot) {
                                  return !_isHeated
                                      ? Text(
                                    '热车',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  )
                                      : Text(
                                    '正在热车',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  );
                                }),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                StreamBuilder<Object>(
                                    stream: _streamControllerWarm.stream,
                                    initialData: 0,
                                    builder: (context, snapshot) {
                                      if (!_isWarmed) {
                                        return new CircleOff();
                                      } else {
                                        return new CircleOn();
                                      }
                                    }),
                                Center(
                                  child: IconButton(
                                    padding: EdgeInsets.all(10),
                                    iconSize: 55,
                                    icon: StreamBuilder<Object>(
                                        stream: _streamControllerWarm.stream,
                                        initialData: 0,
                                        builder: (context, snapshot) {
                                          return !_isWarmed
                                              ? ImageIcon(
                                            AssetImage(
                                              'assets/images/heat_bt_no_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          )
                                              : ImageIcon(
                                            AssetImage(
                                              'assets/images/heat_bt_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          );
                                        }),
                                    onPressed: onWarmClickListener,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<Object>(
                                stream: _streamControllerWarm.stream,
                                initialData: 0,
                                builder: (context, snapshot) {
                                  return !_isWarmed
                                      ? Text(
                                    '温暖',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  )
                                      : Text(
                                    '温暖已开启',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  );
                                }),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                StreamBuilder<Object>(
                                    stream: _streamControllerCold.stream,
                                    initialData: 0,
                                    builder: (context, snapshot) {
                                      if (!_isCooled) {
                                        return new CircleOff();
                                      } else {
                                        return new CircleOn();
                                      }
                                    }),
                                Center(
                                  child: IconButton(
                                    padding: EdgeInsets.all(10),
                                    iconSize: 55,
                                    icon: StreamBuilder<Object>(
                                        stream: _streamControllerCold.stream,
                                        initialData: 0,
                                        builder: (context, snapshot) {
                                          return !_isCooled
                                              ? ImageIcon(
                                            AssetImage(
                                              'assets/images/heat_bt_no_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          )
                                              : ImageIcon(
                                            AssetImage(
                                              'assets/images/heat_bt_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          );
                                        }),
                                    onPressed: onColdClickListener,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<Object>(
                                stream: _streamControllerCold.stream,
                                initialData: 0,
                                builder: (context, snapshot) {
                                  return !_isCooled
                                      ? Text(
                                    '清凉',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  )
                                      : Text(
                                    '清凉已开启',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  );
                                }),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        )
      ]),
    );
  }
  _pageCarMode() {
    return Container(
      child: Column(children: <Widget>[
        SizedBox(
          height: 230.0,
          width: 328.0,
          child: null,
        ),
        SizedBox(
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
            ),
            color: const Color(0xFF100F27),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image(
                    image: AssetImage('assets/images/home_icon_refresh@3x.png'),
                    fit: BoxFit.contain,
                    height: 14,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(
                    "刷新时间：${_getCurrentTime()}",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 129,
          width: 340,
          child: Container(
//            color: const Color(0xFF999999),
            margin: EdgeInsets.only(top: 25),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                    width: 270,
                    color: const Color(0xFF100F27),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                StreamBuilder<Object>(
                                    stream: _streamControllerWindow.stream,
                                    initialData: 0,
                                    builder: (context, snapshot) {
                                      if (!_isWinClosed) {
                                        return new CircleOff();
                                      } else {
                                        return new CircleOn();
                                      }
                                    }),
                                Center(
                                  child: IconButton(
                                    padding: EdgeInsets.all(10),
                                    iconSize: 55,
                                    icon: StreamBuilder<Object>(
                                        stream: _streamControllerWindow.stream,
                                        initialData: 0,
                                        builder: (context, snapshot) {
                                          return !_isWinClosed
                                              ? ImageIcon(
                                            AssetImage(
                                              'assets/images/window_bt_no_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          )
                                              : ImageIcon(
                                            AssetImage(
                                              'assets/images/window_bt_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          );
                                        }),
                                    onPressed: onWindowClickListener,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<Object>(
                                stream: _streamControllerWindow.stream,
                                initialData: 0,
                                builder: (context, snapshot) {
                                  return !_isWinClosed
                                      ? Text(
                                    '开窗',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  )
                                      : Text(
                                    '车窗未关',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  );
                                }),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                StreamBuilder<Object>(
                                    stream: _streamControllerTrail.stream,
                                    initialData: 0,
                                    builder: (context, snapshot) {
                                      if (!_isTraClosed) {
                                        return new CircleOff();
                                      } else {
                                        return new CircleOn();
                                      }
                                    }),
                                Center(
                                  child: IconButton(
                                    padding: EdgeInsets.all(10),
                                    iconSize: 55,
                                    icon: StreamBuilder<Object>(
                                        stream: _streamControllerTrail.stream,
                                        initialData: 0,
                                        builder: (context, snapshot) {
                                          return !_isTraClosed
                                              ? ImageIcon(
                                            AssetImage(
                                              'assets/images/trail_bt_no_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          )
                                              : ImageIcon(
                                            AssetImage(
                                              'assets/images/trail_bt_selection@3x.png',
                                            ),
                                            color: Colors.white,
                                          );
                                        }),
                                    onPressed: onTrailClickListener,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<Object>(
                                stream: _streamControllerTrail.stream,
                                initialData: 0,
                                builder: (context, snapshot) {
                                  return !_isTraClosed
                                      ? Text(
                                    '开尾门',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  )
                                      : Text(
                                    '尾门已开',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                  );
                                }),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF100F27),
        title: const Text('HUAWEI Car'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: ImageIcon(
              AssetImage(
                'assets/images/scan.png',
              ),
              color: Colors.white,
            ),
          )
        ],
        leading: Padding(
          padding: const EdgeInsets.all(0.0),
          child: IconButton(
              iconSize: 35,
              icon: ImageIcon(
                AssetImage(
                  'assets/images/home_icon_personal.png',
                ),
                color: Colors.white,
              ),
              onPressed: null),
        ),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(color: const Color(0xFF100F27)),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 72,
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFF100F27)),
                margin: EdgeInsets.only(top: 0.0),
                child: Swiper(
                  itemBuilder: _swiperBuilder,
                  itemCount: 3,
                  pagination: new SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                    color: Colors.grey,
                    activeColor: Colors.white,
                    size: 7.0,
                    activeSize: 9.0,
                  )),
                  scrollDirection: Axis.horizontal,
                  autoplay: false,
                  onTap: (index) => print('点击了第$index个'),
                ),
              ),
            ),
            Expanded(
              flex: 28,
              child: Container(
                child: Container(
                  child: Card(
                      color: const Color(0x20FFFFFF),
                      margin: EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '附近加油站',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    ImageIcon(
                                      AssetImage(
                                        'assets/images/home_icon_gs_order@3x.png',
                                      ),
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '船厂路加油站',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          '距离600m',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      '￥6.95',
                                      style: TextStyle(
                                          color: const Color(0xFF49D7FF),
                                          fontSize: 20),
                                    ),
                                    Text(
                                      '#95',
                                      style: TextStyle(
                                          color: const Color(0x9949D7FF),
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              height: 10,
                              color: Colors.black45,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '更多加油站 >',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
