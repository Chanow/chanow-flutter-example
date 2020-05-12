import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'Chanow_video_full.dart';

class ChanowVideo extends StatefulWidget {
  final bool autoPlay;
  final bool loop;
  final dynamic url;
  final double height;
  final String type;

  const ChanowVideo({
    Key key,
    this.autoPlay = false,
    this.loop = false,
    this.url = 'video/test.mp4',
    this.height = 180.0,
    this.type = "asset",
  }) : super(key: key);
  @override
  _ChanowVideoState createState() => _ChanowVideoState();
}

class _ChanowVideoState extends State<ChanowVideo> {
  get autoPlay => widget.autoPlay;
  get loop => widget.loop;
  get url => widget.url;
  VideoPlayerController _controller;
  bool isPlaying = false;
  bool isLooping = false;
  bool isFull = false;
  String title = "";

  @override
  void initState() {
    if (!isFull) {
      switch (widget.type) {
        case "file":
          _controller = VideoPlayerController.file(url);
          break;
        case "asset":
          _controller = VideoPlayerController.asset(url);
          break;
        case "network":
          _controller = VideoPlayerController.network(url);
          break;
      }
      _controller.initialize().then((_) {
        setState(() {
          isPlaying = autoPlay;
          isLooping = loop;
        });
        autoPlay ? _controller.play() : _controller.pause();
        _controller.setLooping(loop);
      });
      int left = url.toString().lastIndexOf("/");
      int right = url.toString().lastIndexOf(".");
      for (int i = left + 1; i < right; i++) {
        title += url.toString()[i];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 500.0,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            child: GestureDetector(
              child: Container(
                width: double.maxFinite,
                height: widget.height,
                color: Colors.grey,
                child: _controller.value.initialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return VideoFullPage(
                    controller: _controller,
                    title: title,
                  );
                })).then((_) {
                  setState(() {
                    isPlaying = false;
                  });
                  _controller.pause();
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown
                  ]);
                });
              },
            ),
          ),
          Positioned(
            top: widget.height / 2 - 20.0,
            left: 0,
            right: 0,
            child: GestureDetector(
              child: Icon(
                Icons.play_arrow,
                color: Color.fromRGBO(255, 255, 255, .8),
                size: 40.0,
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return VideoFullPage(
                    controller: _controller,
                    title: title,
                  );
                })).then((_) {
                  setState(() {
                    isPlaying = false;
                  });
                  _controller.pause();
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown
                  ]);
                });
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
