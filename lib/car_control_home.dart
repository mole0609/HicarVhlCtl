import 'package:flutter/material.dart';
import 'package:flutter_app_video_demo/animations/animation_circle_on.dart';
import 'package:flutter_app_video_demo/animations/animation_circle_off.dart';
import 'package:flutter_app_video_demo/animations/animation_cool_heat.dart';
import 'package:flutter_app_video_demo/animations/animation_cool_ori.dart';
import 'package:flutter_app_video_demo/animations/animation_cool_warm.dart';
import 'package:flutter_app_video_demo/animations/animation_heat_cool.dart';
import 'package:flutter_app_video_demo/animations/animation_heat_ori.dart';
import 'package:flutter_app_video_demo/animations/animation_heat_warm.dart';
import 'package:flutter_app_video_demo/animations/animation_lock_unlock.dart';
import 'package:flutter_app_video_demo/animations/animation_ori_cool.dart';
import 'package:flutter_app_video_demo/animations/animation_ori_heat.dart';
import 'package:flutter_app_video_demo/animations/animation_ori_warm.dart';
import 'package:flutter_app_video_demo/animations/animation_tra_close.dart';
import 'package:flutter_app_video_demo/animations/animation_tra_open.dart';
import 'package:flutter_app_video_demo/animations/animation_traed_unwin.dart';
import 'package:flutter_app_video_demo/animations/animation_traed_win.dart';
import 'package:flutter_app_video_demo/animations/animation_unlock_lock.dart';
import 'package:flutter_app_video_demo/animations/animation_warm_cool.dart';
import 'package:flutter_app_video_demo/animations/animation_warm_heat.dart';
import 'package:flutter_app_video_demo/animations/animation_warm_ori.dart';
import 'package:flutter_app_video_demo/animations/animation_win_close.dart';
import 'package:flutter_app_video_demo/animations/animation_win_open.dart';
import 'package:flutter_app_video_demo/animations/animation_wined_tra.dart';
import 'package:flutter_app_video_demo/animations/animation_wined_untra.dart';
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

  StreamController<int> _streamPage2Status,
      _streamPage3Status,
      _streamControllerLock,
      _streamControllerHeat,
      _streamControllerWarm,
      _streamControllerCool,
      _streamControllerWindow,
      _streamControllerTrail;

  ImagesAnimation imagesAnimation;
  ImagesAnimationEntry imagesAnimationEntry;

  int page2Status = 0;
  int page3Status = 0;

  static const int ACTION_HEATING = 10;
  static const int ACTION_UNHEATING = 20;
  static const int ACTION_HEATED_WARMING = 21;
  static const int ACTION_HEATED_UNWARMING = 22;
  static const int ACTION_UNHEATED_WARM = 23;
  static const int ACTION_UNHEATED_UNWARM = 24;
  static const int ACTION_HEATED_COOLING = 25;
  static const int ACTION_HEATED_UNCOOLING = 26;
  static const int ACTION_UNHEATED_COOLING = 27;
  static const int ACTION_UNHEATED_UNCOOLING = 28;
  static const int ACTION_WARM_TO_COOL = 29;
  static const int ACTION_COOL_TO_WARM = 30;

  static const int ACTION_OPEN_WINDOW = 30;
  static const int ACTION_CLOSE_WINDOW = 31;
  static const int ACTION_OPEN_TRAIL = 32;
  static const int ACTION_CLOSE_TRAIL = 33;
  static const int ACTION_WINED_TRA = 34;
  static const int ACTION_WINED_UNTRA = 35;
  static const int ACTION_TRAED_WIN = 36;
  static const int ACTION_TRAED_UNWIN = 37;

  bool _isLocked = true;

  bool _isHeating = false;
  bool _isHeated = false;

  bool _isWarming = false;
  bool _isWarmed = false;

  bool _isCooling = false;
  bool _isCooled = false;

  bool _isWinOpening = false;
  bool _isTraOpening = false;
  bool _isWinOpened = false;
  bool _isTraOpened = false;

  _VideoState() {
    printLog('_VideoState--------------');
    imagesAnimation = new ImagesAnimation(
      durationSeconds: 1,
      entry: ImagesAnimationEntry(
        26,
        26,
        'assets/images/buttons/circles/圆圈点亮1_000%s.png',
      ),
      h: 60,
      w: 60,
    );
  }

  @override
  void initState() {
    super.initState();
    printLog('initState-----------------');
    _streamPage2Status = StreamController.broadcast();
    _streamPage3Status = StreamController.broadcast();
    _streamControllerLock = StreamController.broadcast();
    _streamControllerHeat = StreamController.broadcast();
    _streamControllerWarm = StreamController.broadcast();
    _streamControllerCool = StreamController.broadcast();
    _streamControllerWindow = StreamController.broadcast();
    _streamControllerTrail = StreamController.broadcast();
  }

  @override
  void dispose() {
    printLog('dispose-----------------');
    _streamPage2Status.close();
    _streamPage3Status.close();
    _streamControllerLock.close();
    _streamControllerHeat.close();
    _streamControllerWarm.close();
    _streamControllerCool.close();
    _streamControllerWindow.close();
    _streamControllerTrail.close();
    super.dispose();
  }

  void _onLockClickLister() {
    _isLocked = !_isLocked;
    _streamControllerLock.sink.add(++count);
  }

  void onHeatClickListener() {
    _isHeating = !_isHeating;
    _streamControllerHeat.sink.add(++count);
    _streamPage2Status.sink.add(getPage2Status());
  }

  void onWarmClickListener() {
    _isWarming = !_isWarming;
    _isCooling = false;
    _streamControllerWarm.sink.add(++count);
    _streamControllerCool.sink.add(++count);
    _streamPage2Status.sink.add(getPage2Status());
  }

  void onCoolClickListener() {
    _isCooling = !_isCooling;
    _isWarming = false;
    _streamControllerWarm.sink.add(++count);
    _streamControllerCool.sink.add(++count);
    _streamPage2Status.sink.add(getPage2Status());
  }

  void onWindowClickListener() {
    _isWinOpening = !_isWinOpening;
    _streamControllerWindow.sink.add(++count);
    _streamPage3Status.sink.add(getPage3Status());
  }

  void onTrailClickListener() {
    _isTraOpening = !_isTraOpening;
    _streamControllerTrail.sink.add(++count);
    _streamPage3Status.sink.add(getPage3Status());
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
                    image: AssetImage('assets/images/buttons/home_icon_refresh@3x.png'),
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
                                      ? Text(
                                          '                 解锁                 ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        )
                                      : Text(
                                          '                 上锁                 ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        );
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

  int getPage2Status() {
      //开启热车 温暖关 清凉关
    if (_isHeating && !_isWarmed && !_isCooled && !_isHeated) {
      _isHeated = true;
      page2Status = ACTION_HEATING;//1
      //关闭热车 温暖关 清凉关
    } else if (!_isHeating && !_isWarmed && !_isCooled && _isHeated) {
      _isHeated = false;
      page2Status = ACTION_UNHEATING;//2
      //开启温暖 热车开 清凉关
    } else if (_isHeated && _isWarming && !_isCooling && !_isWarmed && !_isCooled) {
      _isWarmed = true;
      page2Status = ACTION_HEATED_WARMING;//21
      //关闭温暖 热车开 清凉关
    } else if (_isHeated && !_isWarming && !_isCooling && _isWarmed && !_isCooled) {
      _isWarmed = false;
      page2Status = ACTION_HEATED_UNWARMING;//22
      //开启温暖 热车关 清凉关
    } else if (!_isHeated && !_isWarmed && !_isCooling && _isWarming && !_isCooled) {
      _isWarmed = true;
      page2Status = ACTION_UNHEATED_WARM;//23
      //关闭温暖 热车关 清凉关
    } else if (!_isHeated && _isWarmed && !_isCooling && !_isWarming && !_isCooled) {
      _isWarmed = false;
      page2Status = ACTION_UNHEATED_UNWARM;//24
      //开启清凉 热车开 温暖关
    } else if (_isHeated && _isCooling && !_isCooled && !_isWarmed && !_isWarming) {
      _isCooled = true;
      page2Status = ACTION_HEATED_COOLING;//25
      //关闭清凉 热车开 温暖关
    } else if (_isHeated && !_isCooling && _isCooled && !_isWarmed && !_isWarming) {
      _isCooled = false;
      page2Status = ACTION_HEATED_UNCOOLING;//26
      //开启清凉 热车关 温暖关
    } else if (!_isHeated && _isCooling && !_isCooled && !_isWarmed && !_isWarming) {
      _isCooled = true;
      page2Status = ACTION_UNHEATED_COOLING;//27
      //关闭清凉 热车关 温暖关
    } else if (!_isHeated && !_isCooling && _isCooled && !_isWarmed && !_isWarming) {
      _isCooled = false;
      page2Status = ACTION_UNHEATED_UNCOOLING;//28
      //温暖变清凉
    } else if (_isCooling && !_isCooled && _isWarmed) {
      _isCooled = true;
      _isWarmed = false;
      page2Status = ACTION_WARM_TO_COOL; //29
      //清凉变温暖
    } else if (_isWarming && !_isWarmed && _isCooled) {
      _isCooled = false;
      _isWarmed = true;
      page2Status = ACTION_COOL_TO_WARM; //30
      //取消温暖
    } else if (!_isWarming && _isWarmed) {
      _isWarmed = false;
      page2Status = ACTION_COOL_TO_WARM; //30
      //取消清凉
    } else if (!_isCooling && _isCooled) {
      _isCooled = false;
      page2Status = ACTION_COOL_TO_WARM; //30
    }

    printLog('page2Status---' +
        page2Status.toString() +
        '  _isHeating---' +
        _isHeated.toString());
    return page2Status;
  }

  int getPage3Status() {
    if (_isWinOpening && !_isWinOpened && !_isTraOpened) {
      _isWinOpened = true;
      page3Status = ACTION_OPEN_WINDOW;
    } else if (!_isWinOpening && _isWinOpened && !_isTraOpened) {
      _isWinOpened = false;
      page3Status = ACTION_CLOSE_WINDOW;
    } else if (_isTraOpening && !_isWinOpened && !_isTraOpened) {
      _isTraOpened = true;
      page3Status = ACTION_OPEN_TRAIL;
    } else if (!_isTraOpening && !_isWinOpened && _isTraOpened) {
      _isTraOpened = false;
      page3Status = ACTION_CLOSE_TRAIL;
    } else if (_isWinOpened && !_isTraOpened && _isTraOpening) {
      _isTraOpened = true;
      page3Status = ACTION_WINED_TRA;
    } else if (_isWinOpened && _isTraOpened && !_isTraOpening) {
      _isTraOpened = false;
      page3Status = ACTION_WINED_UNTRA;
    } else if (!_isWinOpened && _isTraOpened && _isWinOpening) {
      _isWinOpened = true;
      page3Status = ACTION_TRAED_WIN;
    } else if (_isWinOpened && _isTraOpened && !_isWinOpening) {
      _isWinOpened = false;
      page3Status = ACTION_TRAED_UNWIN;
    }

    printLog('page3Status---' + page3Status.toString());
    return page3Status;
  }

  _pageCarControl() {
    return Container(
      child: Column(children: <Widget>[
        SizedBox(
          height: 230.0,
          width: 328.0,
          child: StreamBuilder<Object>(
              stream: _streamPage2Status.stream,
              initialData: 0,
              builder: (context, snapshot) {
                printLog('default status : snapshot.data---' +
                    snapshot.data.toString());
                switch (snapshot.data) {
                  case ACTION_UNHEATING:
                    return new HeatToOri();
                    break;
                  case ACTION_HEATING:
                    return new OriToHeat();
                    break;
                  case ACTION_HEATED_WARMING:
                    return new HeatedAndWarm();
                    break;
                  case ACTION_HEATED_UNWARMING:
                    return new HeatedAndUnwarm();
                    break;
                  case ACTION_UNHEATED_WARM:
                    return new OriToWarm();
                    break;
                  case ACTION_UNHEATED_UNWARM:
                    return new WarmToOri();
                    break;
                  case ACTION_HEATED_COOLING:
                    return new HeatedAndCool();
                    break;
                  case ACTION_HEATED_UNCOOLING:
                    return new HeatedAndUncool();
                    break;
                  case ACTION_UNHEATED_COOLING:
                    return new OriToCool();
                    break;
                  case ACTION_UNHEATED_UNCOOLING:
                    return new CoolToOri();
                    break;
                  case ACTION_WARM_TO_COOL:
                    return new WarmToCool();
                    break;
                  case ACTION_COOL_TO_WARM:
                    return new CoolToWarm();
                    break;
                  default:
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
                    image: AssetImage('assets/images/buttons/home_icon_refresh@3x.png'),
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
                                      if (!_isHeating) {
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
                                          return !_isHeating
                                              ? ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/open_bt_no_selection@3x.png',
                                                  ),
                                                  color: Colors.white,
                                                )
                                              : ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/open_bt_selection@3x.png',
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
                                  return !_isHeating
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
                                      if (!_isWarming) {
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
                                          return !_isWarming
                                              ? ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/heat_bt_no_selection@3x.png',
                                                  ),
                                                  color: Colors.white,
                                                )
                                              : ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/heat_bt_selection@3x.png',
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
                                  return !_isWarming
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
                                    stream: _streamControllerCool.stream,
                                    initialData: 0,
                                    builder: (context, snapshot) {
                                      if (!_isCooling) {
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
                                        stream: _streamControllerCool.stream,
                                        initialData: 0,
                                        builder: (context, snapshot) {
                                          return !_isCooling
                                              ? ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/heat_bt_no_selection@3x.png',
                                                  ),
                                                  color: Colors.white,
                                                )
                                              : ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/heat_bt_selection@3x.png',
                                                  ),
                                                  color: Colors.white,
                                                );
                                        }),
                                    onPressed: onCoolClickListener,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<Object>(
                                stream: _streamControllerCool.stream,
                                initialData: 0,
                                builder: (context, snapshot) {
                                  return !_isCooling
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
          child: StreamBuilder<Object>(
              stream: _streamPage3Status.stream,
              initialData: 0,
              builder: (context, snapshot) {
                printLog('default _streamPage3Status : snapshot.data---' +
                    snapshot.data.toString());
                switch (snapshot.data) {
                  case ACTION_OPEN_WINDOW:
                    return new WindowOpen();
                    break;
                  case ACTION_CLOSE_WINDOW:
                    return new windowClose();
                    break;
                  case ACTION_OPEN_TRAIL:
                    return new TrailOpen();
                    break;
                  case ACTION_CLOSE_TRAIL:
                    return new TrailClose();
                    break;
                  case ACTION_WINED_TRA:
                    return new WinedAndTra();
                    break;
                  case ACTION_WINED_UNTRA:
                    return new WinedAndUntra();
                    break;
                  case ACTION_TRAED_WIN:
                    return new TraedAndWin();
                    break;
                  case ACTION_TRAED_UNWIN:
                    return new TraedAndUnwin();
                    break;
                  default:
                    printLog('default');
                    return new windowClose();
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
                    image: AssetImage('assets/images/buttons/home_icon_refresh@3x.png'),
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
                                      if (!_isWinOpening) {
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
                                          return !_isWinOpening
                                              ? ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/window_bt_no_selection@3x.png',
                                                  ),
                                                  color: Colors.white,
                                                )
                                              : ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/window_bt_selection@3x.png',
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
                                  return !_isWinOpening
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
                                      if (!_isTraOpening) {
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
                                          return !_isTraOpening
                                              ? ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/trail_bt_no_selection@3x.png',
                                                  ),
                                                  color: Colors.white,
                                                )
                                              : ImageIcon(
                                                  AssetImage(
                                                    'assets/images/buttons/trail_bt_selection@3x.png',
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
                                  return !_isTraOpening
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
                'assets/images/buttons/scan.png',
              ),
              color: Colors.white,
              size: 20,
            ),
          )
        ],
        leading: Padding(
          padding: const EdgeInsets.all(0.0),
          child: IconButton(
              iconSize: 30,
              icon: ImageIcon(
                AssetImage(
                  'assets/images/buttons/home_icon_personal.png',
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
                                        'assets/images/buttons/home_icon_gs_order@3x.png',
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
