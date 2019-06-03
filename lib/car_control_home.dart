import 'package:flutter/material.dart';
import 'package:flutter_app_video_demo/utils/animation_circle_on.dart';
import 'package:flutter_app_video_demo/utils/animation_circle_off.dart';
import 'package:flutter_app_video_demo/utils/animation_heat_ori.dart';
import 'package:flutter_app_video_demo/utils/animation_lock_unlock.dart';
import 'package:flutter_app_video_demo/utils/animation_ori_heat.dart';
import 'package:flutter_app_video_demo/utils/animation_unlock_lock.dart';
import 'package:flutter_app_video_demo/utils/date_format_util.dart';
import 'package:flutter_app_video_demo/utils/video_begin.dart';
import 'package:flutter_app_video_demo/utils/video_end.dart';
import 'package:video_player/video_player.dart';
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

  VideoPlayerController _firstPageController,
      _secondPageController,
      _thirdPageController,
      _controllerLock,
      _controllerUnLock,
      _controllerHeating,
      _controllerUnHeating;

  StreamController<VideoPlayerController> _streamLock,
      _streamUnLock,
      _streamHeating,
      _streamUnHeating;

  StreamController<ImagesAnimation> _streamCircle;

  StreamController<int> _streamControllerLock,
      _streamControllerHeat,
      _streamControllerWarm,
      _streamControllerCold;

  StreamSubscription _circleSubscription;

  ImagesAnimation imagesAnimation;
  ImagesAnimationEntry imagesAnimationEntry;

  bool _isInit = false;
  bool _isLocked = true;
  int _index = 1;
  StreamSink _sinkDemo;

  bool _isHeating = false;
  bool isWarm = false;
  bool isCold = false;

  _VideoState() {
    /*---------------page1 begin--------------*/
    _controllerLock = VideoPlayerController.asset(
      'assets/videos/page_1/lock_unlock.mp4',
    );
    _controllerLock.setLooping(false);
    _controllerLock.setVolume(0.0);

    _controllerUnLock = VideoPlayerController.asset(
      'assets/videos/page_1/unlock_lock.mp4',
    );
    _controllerUnLock.setLooping(false);
    _controllerUnLock.setVolume(0.0);
    _firstPageController = _controllerLock;
    /*---------------page1 end----------------*/

    /*---------------page2 begin--------------*/
    _controllerHeating = VideoPlayerController.asset(
      'assets/videos/page_2/ori_heating.mp4',
    );
    _controllerHeating.setLooping(false);
    _controllerHeating.setVolume(0.0);

    _controllerUnHeating = VideoPlayerController.asset(
      'assets/videos/page_2/heating_ori.mp4',
    );
    _controllerUnHeating.setLooping(false);
    _controllerUnHeating.setVolume(0.0);

    _secondPageController = _controllerHeating;
    /*---------------page2 end----------------*/
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

    _streamCircle = StreamController.broadcast();
    _streamLock = StreamController.broadcast();
    _streamUnLock = StreamController.broadcast();
    _streamHeating = StreamController.broadcast();
    _streamUnHeating = StreamController.broadcast();

    _streamControllerHeat = StreamController.broadcast();
    _streamControllerWarm = StreamController.broadcast();
    _streamControllerCold = StreamController.broadcast();
    _streamControllerLock = StreamController.broadcast();

    _streamCircle.stream.listen(onDataCircle, onDone: onDone);
    _streamLock.stream.listen(onDataLock, onDone: onDone);
    _streamUnLock.stream.listen(onDataUnLock, onDone: onDone);
    _streamHeating.stream.listen(onDataHeating, onDone: onDone);
    _streamUnHeating.stream.listen(onDataUnHeating, onDone: onDone);

    _sinkDemo = _streamCircle.sink;

    _controllerLock.initialize().then((value) {
      setState(() {
        _isInit = _controllerLock.value.initialized;
      });
    });

    _controllerUnLock.initialize().then((value) {
      setState(() {
        _isInit = _controllerUnLock.value.initialized;
      });
    });

    _controllerHeating.initialize().then((value) {
      setState(() {
        _isInit = _controllerHeating.value.initialized;
      });
    });
    _controllerUnHeating.initialize().then((value) {
      setState(() {
        _isInit = _controllerUnHeating.value.initialized;
      });
    });
  }

  @override
  void dispose() {
    printLog('dispose-----------------');
    _controllerLock.dispose();
    _controllerUnLock.dispose();
    _controllerHeating.dispose();
    _controllerUnHeating.dispose();
    _streamControllerHeat.close();
    _streamControllerLock.close();
    _streamControllerWarm.close();
    _streamControllerCold.close();
    super.dispose();
  }

  void onDataCircle(ImagesAnimation data) {
    setState(() {
      imagesAnimation = data;
    });
  }

  void onDataLock(VideoPlayerController data) {
    setState(() {
      _firstPageController = data;
    });
    _firstPageController.initialize();
    _firstPageController.play();
    _isLocked = !_isLocked;
  }

  void onDataUnLock(VideoPlayerController data) {
    setState(() {
      _firstPageController = data;
    });
    _firstPageController.initialize();
    _firstPageController.play();
  }

  void onDataHeating(VideoPlayerController data) {
    setState(() {
      _secondPageController = data;
    });
    _secondPageController.initialize();
    _secondPageController.play();
  }

  void onDataUnHeating(VideoPlayerController data) {
    setState(() {
      _secondPageController = data;
    });
    _secondPageController.initialize();
    _secondPageController.play();
  }

  void onDone() {
    printLog('onDone');
  }

  ///创建播放中的视频界面
  Widget _buildPlayingWidget(VideoPlayerController controller) {
    return AspectRatio(
        aspectRatio: 3 / 2,
        child: GestureDetector(
          child: VideoPlayer(controller),
        ));
  }

  ///视频正在加载的界面
  Widget _buildInitingWidget(VideoPlayerController controller) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Stack(
        children: <Widget>[
          VideoPlayer(controller),
        ],
        fit: StackFit.expand,
      ),
    );
  }

  _getCurrentTime() {
    return formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }

  Widget _checkAndPlayVideo(VideoPlayerController controller) {
    return _isInit
        ? _buildPlayingWidget(controller)
        : _buildInitingWidget(controller);
  }

  Widget _myFlatButton(bool isLocked) {
    return isLocked
        ? FlatButton(
            onPressed: () {
              _addLockToStream();
            },
            child: _myButtonText('解锁'))
        : FlatButton(
            onPressed: () {
              _addUnLockToStream();
            },
            child: _myButtonText('上锁'));
  }

  Widget _myButtonText(String msg) {
    return Text(
      '                 $msg                 ',
      style: TextStyle(color: Colors.white, fontSize: 25),
    );
  }

  void _addCircleToStream() async {
    ImagesAnimation data = await fetchCircleData();
    _streamCircle.add(data);
//    _sinkDemo.add(data);
  }

  void _addLockToStream() async {
    VideoPlayerController data = await fetchLockData();
    _streamLock.add(data);
  }

  void _addUnLockToStream() async {
    VideoPlayerController data = await fetchLockData();
    _streamUnLock.add(data);
  }

  void _addHeatingToStream() async {
    VideoPlayerController data = await fetchHeatingData();
    _streamHeating.add(data);
    _isHeating = true;
  }

  void _addUnHeatingToStream() async {
    VideoPlayerController data = await fetchUnHeatingData();
    _streamUnHeating.add(data);
    _isHeating = false;
  }

  Future<ImagesAnimation> fetchCircleData() async {
    return imagesAnimation;
  }

  Future<VideoPlayerController> fetchLockData() async {
    await Future.delayed(Duration(
      seconds: 1,
    ));
    return _isLocked ? _controllerLock : _controllerUnLock;
  }

  Future<VideoPlayerController> fetchHeatingData() async {
    await Future.delayed(Duration(
      seconds: 1,
    ));
    return _controllerHeating;
  }

  Future<VideoPlayerController> fetchUnHeatingData() async {
    await Future.delayed(Duration(
      seconds: 1,
    ));
    return _controllerUnHeating;
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
                if (!_isLockedBT) {
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
                                  return _isLockedBT
                                      ? _myButtonText('解锁')
                                      : _myButtonText('上锁');
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

  bool _isLockedBT = true;

  void _onLockClickLister() {
    _addLockToStream();
    _isLockedBT = !_isLockedBT;
    _streamControllerLock.sink.add(++count);
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
                printLog('isHeated---------------' + isHeated.toString());
                if (isHeated) {
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
                                      if (!isHeated) {
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
                                          return !isHeated
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
                                  return !isHeated
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
                                      if (!isWarmMode) {
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
                                          return !isWarmMode
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
                                  return !isWarmMode
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
                                      if (!isColdMode) {
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
                                          return !isColdMode
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
                                  return !isColdMode
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

  var isHeated = false;
  var isWarmMode = false;
  var isColdMode = false;
  int durationSeconds = 0;

  void onHeatClickListener() {
    isHeated = !isHeated;
//    _addHeatingToStream();
    _streamControllerHeat.sink.add(++count);
  }

  void onWarmClickListener() {
    isWarmMode = !isWarmMode;
//    _addHeatingToStream();
    _streamControllerWarm.sink.add(++count);
  }

  void onColdClickListener() {
    isColdMode = !isColdMode;
//    _addHeatingToStream();
    _streamControllerCold.sink.add(++count);
  }

  _pageCarMode() {
    return Container(
      child: Column(children: <Widget>[
        SizedBox(
          height: 230.0,
          width: 328.0,
          child: _checkAndPlayVideo(_secondPageController),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          StreamBuilder<Object>(
                              stream: _streamControllerHeat.stream,
                              initialData: 0,
                              builder: (context, snapshot) {
                                if (!isHeated) {
                                  return new CircleOff();
                                } else {
                                  return new CircleOn();
                                }
                              }),
                          Center(
                            child: IconButton(
                              padding: EdgeInsets.all(10),
                              iconSize: 55,
                              icon: ImageIcon(
                                AssetImage(
                                  'assets/images/trail_bt_no_selection@3x.png',
                                ),
                                color: Colors.white,
                              ),
                              onPressed: onHeatClickListener,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          StreamBuilder<Object>(
                              stream: _streamControllerWarm.stream,
                              initialData: 0,
                              builder: (context, snapshot) {
                                if (!isWarmMode) {
                                  return new CircleOff();
                                } else {
                                  return new CircleOn();
                                }
                              }),
                          Center(
                            child: IconButton(
                              padding: EdgeInsets.all(10),
                              iconSize: 55,
                              icon: ImageIcon(
                                AssetImage(
                                  'assets/images/window_bt_no_selection@3x.png',
                                ),
                                color: Colors.white,
                              ),
                              onPressed: onWarmClickListener,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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

  printLog(String s) {
    print('$TAG : ' + s);
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    List<Widget> pageList = new List();
    pageList.add(_pageUnlock());
    pageList.add(_pageCarControl());
    pageList.add(_pageCarMode());
    return pageList[index];
  }
}
