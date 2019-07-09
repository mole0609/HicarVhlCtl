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
import 'package:flutter_app_video_demo/utils/dialog_util.dart';
import 'package:flutter_app_video_demo/utils/flutter_screenutil.dart';
import 'package:flutter_app_video_demo/utils/flutter_snackbar.dart';
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
  int count = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final GlobalKey<SnackBarWidgetState> _globalKey = new GlobalKey();

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

  int page1Status = 0;
  int page2Status = 0;
  int page3Status = 0;

  static const int ACTION_LOCK = 1;
  static const int ACTION_UNLOCK = 2;

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

  Image _lastPage1Image = Image(
    image: AssetImage('assets/images/unlock_lock/解锁——上锁 原角度_00046.jpg'),
  );

  Image _lastPage2Image = Image(
    image: AssetImage('assets/images/ori_heat/1原角度——热车（开）_0000.jpg'),
  );

  Image _lastPage3Image = Image(
    image: AssetImage('assets/images/ori_openwin/1原角度——开窗_0000.jpg'),
  );

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


  void _onLockClickLister(BuildContext context) {
    _isLocked = !_isLocked;
    _streamControllerLock.sink.add(getPage1Status());
    _globalKey.currentState.show('解锁----');
    showMyMaterialDialog(context);
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
          height: ScreenUtil().setHeight(460),
          width: ScreenUtil().setWidth(656),
          child: StreamBuilder<Object>(
              stream: _streamControllerLock.stream,
              initialData: 0,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case ACTION_LOCK:
                    _lastPage1Image = Image(
                      image: AssetImage(
                          'assets/images/unlock_lock/解锁——上锁 原角度_00046.jpg'),
                    );
                    return new UnLockToLock();
                    break;
                  case ACTION_UNLOCK:
                    _lastPage1Image = Image(
                      image: AssetImage(
                          'assets/images/unlock_lock/解锁——上锁 原角度_0000.jpg'),
                    );
                    return new LockToUnLock();
                    break;
                  default:
                    return _lastPage1Image;
                }
              }),
        ),
        SizedBox(
          child: Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(40),
            ),
            color: const Color(0xFF100F27),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image(
                    image: AssetImage(
                        'assets/images/buttons/home_icon_refresh@3x.png'),
                    fit: BoxFit.contain,
                    height: 14,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
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
          height: ScreenUtil().setHeight(240),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
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
                            onPressed: (){
                              _onLockClickLister(context);
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

  int getPage1Status() {
    if (_isLocked) {
      page1Status = ACTION_LOCK;
    } else {
      page1Status = ACTION_UNLOCK;
    }
    printLog('page1Status---' + page2Status.toString());
    return page1Status;
  }

  int getPage2Status() {
    //开启热车 温暖关 清凉关
    if (_isHeating && !_isWarmed && !_isCooled && !_isHeated) {
      _isHeated = true;
      page2Status = ACTION_HEATING; //1
      //关闭热车 温暖关 清凉关
    } else if (!_isHeating && !_isWarmed && !_isCooled && _isHeated) {
      _isHeated = false;
      page2Status = ACTION_UNHEATING; //2
      //开启温暖 热车开 清凉关
    } else if (_isHeated &&
        _isWarming &&
        !_isCooling &&
        !_isWarmed &&
        !_isCooled) {
      _isWarmed = true;
      page2Status = ACTION_HEATED_WARMING; //21
      //关闭温暖 热车开 清凉关
    } else if (_isHeated &&
        !_isWarming &&
        !_isCooling &&
        _isWarmed &&
        !_isCooled) {
      _isWarmed = false;
      page2Status = ACTION_HEATED_UNWARMING; //22
      //开启温暖 热车关 清凉关
    } else if (!_isHeated &&
        !_isWarmed &&
        !_isCooling &&
        _isWarming &&
        !_isCooled) {
      _isWarmed = true;
      page2Status = ACTION_UNHEATED_WARM; //23
      //关闭温暖 热车关 清凉关
    } else if (!_isHeated &&
        _isWarmed &&
        !_isCooling &&
        !_isWarming &&
        !_isCooled) {
      _isWarmed = false;
      page2Status = ACTION_UNHEATED_UNWARM; //24
      //开启清凉 热车开 温暖关
    } else if (_isHeated &&
        _isCooling &&
        !_isCooled &&
        !_isWarmed &&
        !_isWarming) {
      _isCooled = true;
      page2Status = ACTION_HEATED_COOLING; //25
      //关闭清凉 热车开 温暖关
    } else if (_isHeated &&
        !_isCooling &&
        _isCooled &&
        !_isWarmed &&
        !_isWarming) {
      _isCooled = false;
      page2Status = ACTION_HEATED_UNCOOLING; //26
      //开启清凉 热车关 温暖关
    } else if (!_isHeated &&
        _isCooling &&
        !_isCooled &&
        !_isWarmed &&
        !_isWarming) {
      _isCooled = true;
      page2Status = ACTION_UNHEATED_COOLING; //27
      //关闭清凉 热车关 温暖关
    } else if (!_isHeated &&
        !_isCooling &&
        _isCooled &&
        !_isWarmed &&
        !_isWarming) {
      _isCooled = false;
      page2Status = ACTION_UNHEATED_UNCOOLING; //28
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
          height: ScreenUtil().setHeight(460.0),
          width: ScreenUtil().setWidth(656.0),
          child: Stack(
            children: <Widget>[
              StreamBuilder<Object>(
                  stream: _streamPage2Status.stream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    printLog('default status : snapshot.data---' +
                        snapshot.data.toString());
                    switch (snapshot.data) {
                      case ACTION_UNHEATING:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/ori_heat/1原角度——热车（开）_0000.jpg'),
                        );
                        return new HeatToOri();
                        break;
                      case ACTION_HEATING:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/ori_heat/1原角度——热车（开）_00019.jpg'),
                        );
                        return new OriToHeat();
                        break;
                      case ACTION_HEATED_WARMING:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/heat_warm/2热车（开）——温暖_00043.jpg'),
                        );
                        return new HeatedAndWarm();
                        break;
                      case ACTION_HEATED_UNWARMING:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/heat_warm/2热车（开）——温暖_0000.jpg'),
                        );
                        return new HeatedAndUnwarm();
                        break;
                      case ACTION_UNHEATED_WARM:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/ori_warm/6热车（关）原角度——温暖_00027.jpg'),
                        );
                        return new OriToWarm();
                        break;
                      case ACTION_UNHEATED_UNWARM:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/ori_warm/6热车（关）原角度——温暖_0000.jpg'),
                        );
                        return new WarmToOri();
                        break;
                      case ACTION_HEATED_COOLING:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/heat_cool/3热车（开）——清凉_00041.jpg'),
                        );
                        return new HeatedAndCool();
                        break;
                      case ACTION_HEATED_UNCOOLING:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/heat_cool/3热车（开）——清凉_0000.jpg'),
                        );
                        return new HeatedAndUncool();
                        break;
                      case ACTION_UNHEATED_COOLING:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/ori_cool/7热车（关）原角度——清凉_00028.jpg'),
                        );
                        return new OriToCool();
                        break;
                      case ACTION_UNHEATED_UNCOOLING:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/ori_cool/7热车（关）原角度——清凉_0000.jpg'),
                        );
                        return new CoolToOri();
                        break;
                      case ACTION_WARM_TO_COOL:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/warm_cool/11温暖 ——- 清凉_00032.jpg'),
                        );
                        return new WarmToCool();
                        break;
                      case ACTION_COOL_TO_WARM:
                        _lastPage2Image = Image(
                          image: AssetImage(
                              'assets/images/warm_cool/11温暖 ——- 清凉_0000.jpg'),
                        );
                        return new CoolToWarm();
                        break;
                      default:
                        return Center(child: _lastPage2Image);
                    }
                  }),
              StreamBuilder<Object>(
                  stream: _streamControllerLock.stream,
                  builder: (context, snapshot) {
                    return Center(
                      child: _isLocked
                          ? Image(
                              image:
                                  AssetImage('assets/images/buttons/1上锁.png'),
                              fit: BoxFit.contain,
                              color: Colors.white,
                            )
                          : null,
                    );
                  }),
            ],
          ),
        ),
        SizedBox(
          child: Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            color: const Color(0xFF100F27),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image(
                    image: AssetImage(
                        'assets/images/buttons/home_icon_refresh@3x.png'),
                    fit: BoxFit.contain,
                    height: 14,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
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
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
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
          height: ScreenUtil().setHeight(460.0),
          width: ScreenUtil().setWidth(656.0),
          child: Stack(
            children: <Widget>[
              StreamBuilder<Object>(
                  stream: _streamPage3Status.stream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    printLog('default _streamPage3Status : snapshot.data---' +
                        snapshot.data.toString());
                    switch (snapshot.data) {
                      case ACTION_OPEN_WINDOW:
                        _lastPage3Image = Image(
                          image: AssetImage(
                              'assets/images/ori_openwin/1原角度——开窗_00023.jpg'),
                        );
                        return new WindowOpen();
                        break;
                      case ACTION_CLOSE_WINDOW:
                        _lastPage3Image = Image(
                          image: AssetImage(
                              'assets/images/ori_openwin/1原角度——开窗_0000.jpg'),
                        );
                        return new windowClose();
                        break;
                      case ACTION_OPEN_TRAIL:
                        _lastPage3Image = Image(
                          image: AssetImage(
                              'assets/images/ori_opentra/2原角度——开尾门_00023.jpg'),
                        );
                        return new TrailOpen();
                        break;
                      case ACTION_CLOSE_TRAIL:
                        _lastPage3Image = Image(
                          image: AssetImage(
                              'assets/images/ori_opentra/2原角度——开尾门_0000.jpg'),
                        );
                        return new TrailClose();
                        break;
                      case ACTION_WINED_TRA:
                        _lastPage3Image = Image(
                          image: AssetImage(
                              'assets/images/wined_and_tra/3开窗——开尾门和开窗_00012.jpg'),
                        );
                        return new WinedAndTra();
                        break;
                      case ACTION_WINED_UNTRA:
                        _lastPage3Image = Image(
                          image: AssetImage(
                              'assets/images/wined_and_tra/3开窗——开尾门和开窗_0000.jpg'),
                        );
                        return new WinedAndUntra();
                        break;
                      case ACTION_TRAED_WIN:
                        _lastPage3Image = Image(
                          image: AssetImage(
                              'assets/images/traed_and_win/4开尾门——开窗和开尾门_00012.jpg'),
                        );
                        return new TraedAndWin();
                        break;
                      case ACTION_TRAED_UNWIN:
                        _lastPage3Image = Image(
                          image: AssetImage(
                              'assets/images/traed_and_win/4开尾门——开窗和开尾门_0000.jpg'),
                        );
                        return new TraedAndUnwin();
                        break;
                      default:
                        printLog('default');
                        return Center(child: _lastPage3Image);
                    }
                  }),
              StreamBuilder<Object>(
                  stream: _streamControllerLock.stream,
                  builder: (context, snapshot) {
                    return Center(
                      child: _isLocked
                          ? Image(
                              image:
                                  AssetImage('assets/images/buttons/1上锁.png'),
                              fit: BoxFit.contain,
                              color: Colors.white,
                            )
                          : null,
                    );
                  }),
            ],
          ),
        ),
        SizedBox(
          child: Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(40),
            ),
            color: const Color(0xFF100F27),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image(
                    image: AssetImage(
                        'assets/images/buttons/home_icon_refresh@3x.png'),
                    fit: BoxFit.contain,
                    height: 14,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
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
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
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

  //msg可以不传
  Widget _mySnackBarWidget(String msg) {
    return SnackBarWidget(
      // 绑定GlobalKey，用于调用显示/隐藏方法
      key: _globalKey,
      //textBuilder用于动态构建Text，用于显示变化的内容。优先级高于'text'属性
      textBuilder: (String message) {
        return Text(message ?? msg,
            style: TextStyle(color: Colors.white, fontSize: 16.0));
      },
      // 内容不变时使用text属性
      text: Text("内容不变时使用text属性"),
      // 设定背景decoration
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          color: Colors.blue.withOpacity(0.8)),
      //设置显示时长，从动画开始
      duration: Duration(seconds: 2),
      // 用于显示内容，默认是填充空白区域的
      /*content: Center(child: Text("这是内容部分"))*/
//      margin: EdgeInsets.only(top: 2.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF100F27),
        title: const Text('HUAWEI Car'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
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
      body: Stack(
        children: <Widget>[
          Container(
//            padding: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(color: const Color(0xFF100F27)),
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      '沪A88888',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                ),
                Expanded(
                  flex: 90,
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
//                Expanded(
//                  flex: 28,
//                  child: Container(
//                    child: Container(
//                      child: Card(
//                          color: const Color(0x20FFFFFF),
//                          margin: EdgeInsets.all(10),
//                          child: Container(
//                            padding: EdgeInsets.only(
//                                left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Text(
//                                  '附近加油站',
//                                  style: TextStyle(
//                                      color: Colors.white, fontSize: 20.0),
//                                ),
//                                Row(
//                                  mainAxisAlignment:
//                                      MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    Row(
//                                      children: <Widget>[
//                                        ImageIcon(
//                                          AssetImage(
//                                            'assets/images/buttons/home_icon_gs_order@3x.png',
//                                          ),
//                                          color: Colors.white,
//                                          size: 20,
//                                        ),
//                                        SizedBox(
//                                          width: 14,
//                                        ),
//                                        Column(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
//                                          children: <Widget>[
//                                            Text(
//                                              '船厂路加油站',
//                                              style: TextStyle(
//                                                  color: Colors.white,
//                                                  fontSize: 18),
//                                            ),
//                                            Text(
//                                              '距离600m',
//                                              style: TextStyle(
//                                                  color: Colors.white,
//                                                  fontSize: 12),
//                                            ),
//                                          ],
//                                        ),
//                                      ],
//                                    ),
//                                    Column(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.end,
//                                      children: <Widget>[
//                                        Text(
//                                          '￥6.95',
//                                          style: TextStyle(
//                                              color: const Color(0xFF49D7FF),
//                                              fontSize: 20),
//                                        ),
//                                        Text(
//                                          '#95',
//                                          style: TextStyle(
//                                              color: const Color(0x9949D7FF),
//                                              fontSize: 10),
//                                        ),
//                                      ],
//                                    ),
//                                  ],
//                                ),
//                                Divider(
//                                  height: 10,
//                                  color: Colors.grey,
//                                ),
//                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  crossAxisAlignment: CrossAxisAlignment.end,
//                                  children: <Widget>[
//                                    Text(
//                                      '更多加油站 >',
//                                      style: TextStyle(color: Colors.white),
//                                    ),
//                                  ],
//                                ),
//                              ],
//                            ),
//                          )),
//                    ),
//                  ),
//                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _mySnackBarWidget(''),
          ),
        ],
      ),
    );
  }
}
