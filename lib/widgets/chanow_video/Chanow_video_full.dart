import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'Chanow_video_controller.dart';

class VideoFullPage extends StatefulWidget {
  final VideoPlayerController controller;
  final String title;

  const VideoFullPage({Key key, this.controller, this.title = ""}) : super(key: key);
  @override
  _VideoFullPageState createState() => _VideoFullPageState();
}

class _VideoFullPageState extends State<VideoFullPage>
    with TickerProviderStateMixin {
  AnimationController _bottomAnicontroller;
  Duration _bottomDuration;
  Animation _bottomAnimation;
  Tween _bottomTween;
  AnimationController _topAnicontroller;
  Duration _topDuration;
  Animation _topAnimation;
  Tween _topTween;
  Timer timer;
  bool isShow = true;
  @override
  void initState() {
    _bottomDuration = Duration(milliseconds: 300);
    _bottomAnicontroller =
        AnimationController(duration: _bottomDuration, vsync: this);
    _bottomTween = Tween(begin: -40.0, end: 0.0);
    _bottomAnimation = _bottomTween.animate(_bottomAnicontroller);
    _bottomAnimation.addListener(listener);

    _topDuration = Duration(milliseconds: 300);
    _topAnicontroller =
        AnimationController(duration: _topDuration, vsync: this);
    _topTween = Tween(begin: -40.0, end: 0.0);
    _topAnimation = _topTween.animate(_topAnicontroller);
    _topAnimation.addListener(listener);

    if (isShow) {
      _bottomAnicontroller.forward();
      _topAnicontroller.forward();
      timer = new Timer(new Duration(seconds: 3), () {
        _bottomAnicontroller.reverse();
        _topAnicontroller.reverse();
        setState(() {
          isShow = false;
        });
      });
    }
    super.initState();
  }

  void listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: GestureDetector(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: widget.controller.value.aspectRatio,
                    child: VideoPlayer(widget.controller),
                  ),
                ),
                onTap: () {
                  if (isShow) {
                    _bottomAnicontroller.reverse();
                    _topAnicontroller.reverse();
                    timer.cancel();
                    setState(() {
                      isShow = false;
                    });
                  } else {
                    _bottomAnicontroller.forward();
                    _topAnicontroller.forward();
                    setState(() {
                      isShow = true;
                    });
                    timer = new Timer(new Duration(seconds: 3), () {
                      _bottomAnicontroller.reverse();
                      _topAnicontroller.reverse();
                      setState(() {
                        isShow = false;
                      });
                    });
                  }
                },
              ),
            ),
            Positioned(
              top: _topAnimation.value,
              left: 0.0,
              right: 0.0,
              child: Container(
                width: double.maxFinite,
                height: 40.0,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                color: Color.fromRGBO(0, 0, 0, .7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.keyboard_backspace,
                        color: Colors.white,
                        size: 28.0,
                      ),
                      onTap: () {
                        if (timer != null) {
                          timer.cancel();
                        }
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown
                        ]).then((_) {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: _bottomAnimation.value,
              left: 0,
              right: 0,
              child: VideoController(
                controller: widget.controller,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bottomAnimation.removeListener(listener);
    _topAnimation.removeListener(listener);
    _bottomAnicontroller.dispose();
    _topAnicontroller.dispose();
    super.dispose();
  }
}
