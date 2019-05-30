import 'package:flutter/material.dart';
import 'package:flutter_app_video_demo/utils/date_format_util.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

import 'package:video_player/video_player.dart';

///
/// 当加载好视频之后自动播放,仅提供
/// 播放功能，不提供暂停等控制事件
///
class CarControlHomeActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoState();
  }
}

class _VideoState extends State<CarControlHomeActivity> {
  final String TAG = '[CarContrlLog]';

  VideoPlayerController _controllerLock, _controllerUnLock;
  bool _isInit = false;
  bool _isUnLockInit = false;
  bool _isLocked = true;
  int _index = 1;
  Completer<void> _creatingCompleter;

  _VideoState() {
    _controllerLock = VideoPlayerController.asset(
      'videos/lock_unlock.mp4',
    );
    _controllerUnLock = VideoPlayerController.asset(
      'videos/unlock_lock.mp4',
    );
    _controllerLock.setLooping(false);
    _controllerUnLock.setLooping(false);
    _controllerLock.setVolume(0.0);
    _controllerUnLock.setVolume(0.0);

    ///随着播放会一直调用
    _controllerLock.addListener(() {
      final bool isPlaying = _controllerLock.value.isPlaying;
//      _controllerLock.value.,
      setState(() {
//        _isLocked = !isPlaying;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerLock.initialize().then((value) {
      setState(() {
        _isInit = _controllerLock.value.initialized;
      });
    });
    printLog('initState--------------_isInit: ' + _isInit.toString());
    _controllerUnLock.initialize().then((value) {
      setState(() {
        _isInit &= _controllerUnLock.value.initialized;
      });
    });
    printLog('initState--------------_isInit: ' + _isInit.toString());
  }

  @override
  void dispose() {
    _controllerLock.dispose();
    _controllerUnLock.dispose();
    super.dispose();
  }

  ///创建播放中的视频界面
  Widget _buildPlayingWidget() {
    return AspectRatio(
            aspectRatio: 328 / 230,
            child: GestureDetector(child: VideoPlayer(_controllerLock)));
  }

  ///视频正在加载的界面
  Widget _buildInitingWidget() {
    printLog('_buildInitingWidget--------------_isInit: ' + _isInit.toString());
    return AspectRatio(
      aspectRatio: 328 / 230,
      child: Stack(
        children: <Widget>[
              VideoPlayer(_controllerLock),
        ],
      ),
    );
  }

  _getCurrentTime() {
    return formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }

  Widget _checkAndPlayVideo() {
    return _isInit ? _buildPlayingWidget() : _buildInitingWidget();
  }

  Widget _myFlatButton(bool isLocked) {
    return isLocked
        ? FlatButton(
            onPressed: () {
              printLog('FlatButton----------isLock: ' + _isLocked.toString());
              _controllerLock.play().whenComplete(actionLockComplt);
            },
            child: _myButton('解锁'))
        : FlatButton(
            onPressed: () {
              printLog('FlatButton----------isLock: ' + _isLocked.toString());
              _controllerLock.play().whenComplete(actionUnLockComplt);
            },
            child:_myButton('上锁'));
  }

  Widget _myButton(String msg) {
    return Text(
      '                 ${msg}                 ',
      style: TextStyle(color: Colors.white, fontSize: 25),
    );
  }

  _pageUnlock() {
    return Container(
      child: Column(children: <Widget>[
        Offstage(
          offstage: false,
          child: _checkAndPlayVideo(),
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
                    image: AssetImage('images/home_icon_refresh@3x.png'),
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
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
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
                      child: _myFlatButton(_isLocked),
                    ),
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
          child: Text(
            "PAGE2",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]),
    );
  }

  _pageCarMode() {
    return Container(
      child: Column(children: <Widget>[
        SizedBox(
          height: 230.0,
          width: 328.0,
          child: Text(
            "PAGE3",
            style: TextStyle(color: Colors.white),
          ),
        ),
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
        leading: IconButton(
            icon: ImageIcon(
              AssetImage(
                'images/home_icon_personal.png',
              ),
              color: Colors.white,
            ),
            onPressed: null),
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(color: const Color(0xFF100F27)),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 72,
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFF100F27)),
                margin: EdgeInsets.only(top: 0.0),
                child: PageView(
                  children: <Widget>[
                    _pageUnlock(),
                    _pageCarControl(),
                    _pageCarMode(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFF100F27)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '.',
                      style: TextStyle(
                        fontSize: 50,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    Text(
                      '.',
                      style: TextStyle(
                        fontSize: 50,
                        color: const Color(0x20FFFFFF),
                      ),
                    ),
                    Text(
                      '.',
                      style: TextStyle(
                        fontSize: 50,
                        color: const Color(0x20FFFFFF),
                      ),
                    ),
                  ],
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
                            left: 16.0, right: 16.0, top: 10.0, bottom: 48.0),
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
                                        'images/home_icon_gs_order@3x.png',
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
                              height: 2,
                              color: Colors.black45,
                            ),
                            Row(
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

  printLog(String s) {
    print('${TAG} : ' + s);
  }

  void initStateUnLockVideo() {
    _controllerLock.initialize().then((value) {
      setState(() {
        _isUnLockInit = _controllerUnLock.value.initialized;
      });
    });
  }

  FutureOr actionLockComplt() {
    _isLocked = false;
    printLog('我完了');
  }
  FutureOr actionUnLockComplt() {
    _isLocked = true;
    printLog('我完了');
  }
}
