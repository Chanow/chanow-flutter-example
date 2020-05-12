import 'package:chanow_flutter_example/widgets/chanow_video/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoController extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoController({
    Key key,
    this.controller,
  }) : super(key: key);
  @override
  _VideoControllerState createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  get controller => widget.controller;
  bool isPlaying = false;
  bool isFull = false;
  String duration;
  String position;
  double sliderMax = 0.0;
  double sliderValue = 0.0;

  @override
  void initState() {
    setState(() {
      isPlaying = controller.value.isPlaying;
      duration = formatDuration(controller.value.duration);
      position = formatDuration(controller.value.position);
      sliderMax = formatSlider(controller.value.duration);
      sliderValue = formatSlider(controller.value.position);
    });
    controller.addListener(settingSlider);
    super.initState();
  }

  void settingSlider() {
    setState(() {
      position = formatDuration(controller.value.position);
      sliderValue = formatSlider(controller.value.position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, .7),
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 28.0,
            ),
            onTap: () {
              if (isPlaying) {
                widget.controller.pause().then((_) {
                  setState(() {
                    isPlaying = false;
                  });
                });
              } else {
                widget.controller.play().then((_) {
                  setState(() {
                    isPlaying = true;
                  });
                });
              }
            },
          ),
          Text(
            "$position",
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
          Text(
            "/$duration",
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
          Expanded(
            flex: 1,
            child: SliderTheme(
              //自定义风格
              data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white, //进度条滑块左边颜色
                  inactiveTrackColor:
                      Color.fromRGBO(255, 255, 255, .3), //进度条滑块右边颜色
                  thumbColor: Colors.white, //滑块颜色
                  overlayColor: Color.fromRGBO(255, 255, 255, .7), //滑块拖拽时外圈的颜色
                  overlayShape: RoundSliderOverlayShape(
                    //可继承SliderComponentShape自定义形状
                    overlayRadius: 7.0, //滑块外圈大小
                  ),
                  thumbShape: RoundSliderThumbShape(
                    //可继承SliderComponentShape自定义形状
                    disabledThumbRadius: 6.0, //禁用是滑块大小
                    enabledThumbRadius: 6.0, //滑块大小
                  ),
                  trackHeight: 3 //进度条宽度
                  ),
              child: Slider(
                value: sliderValue,
                max: sliderMax,
                min: 0.0,
                onChanged: (double value) {
                  widget.controller.seekTo(sliderTo(value)).then((_) {
                    setState(() {
                      sliderValue = value;
                    });
                  });
                },
              ),
            ),
          ),
          GestureDetector(
            child: Icon(
              isFull ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 28.0,
            ),
            onTap: () {
              if (isFull) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown
                ]).then((_) {
                  setState(() {
                    isFull = false;
                  });
                });
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight
                ]).then((_) {
                  setState(() {
                    isFull = true;
                  });
                });
              }
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(settingSlider);
    super.dispose();
  }
}
