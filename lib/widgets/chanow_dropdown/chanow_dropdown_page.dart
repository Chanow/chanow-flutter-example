import 'package:flutter/material.dart';
import 'chanow_dropdown_model.dart';

class ChanowDropdownPage extends StatefulWidget {
  final List<ChanowDropdownHeaderItem> headers;
  final List<ChanowDropdownMenuItem> menus;
  final double headerHeight;
  final List<double> menuHeights;
  final TextStyle headerStyle;
  final EdgeInsets headMargin, headPadding, menuMargin, menuPadding;
  final double top;
  final int selectIndex;
  final bool hasAppBar;

  const ChanowDropdownPage({
    Key key,
    this.headers,
    this.menus,
    this.headerHeight,
    this.menuHeights,
    this.headerStyle,
    this.top,
    this.headMargin,
    this.headPadding,
    this.menuMargin,
    this.menuPadding,
    this.selectIndex = 0,
    this.hasAppBar,
  }) : super(key: key);
  @override
  _ChanowDropdownPageState createState() => _ChanowDropdownPageState();
}

class _ChanowDropdownPageState extends State<ChanowDropdownPage>
    with TickerProviderStateMixin {
  AnimationController _anicontroller;
  Duration _duration;
  Animation _animation;
  Tween _tween;
  AnimationController _opacityAnicontroller;
  Duration _opacityDuration;
  Animation _opacityAnimation;
  Tween _opacityTween;
  bool isShow = false;
  int selectIndex = 0;

  @override
  void initState() {
    _duration = Duration(milliseconds: 200);
    _anicontroller = AnimationController(duration: _duration, vsync: this);
    _tween = Tween(
        begin: 0.0,
        end: widget.hasAppBar
            ? widget.top + widget.headerHeight + 56.0
            : widget.top + widget.headerHeight);
    _animation = _tween.animate(_anicontroller);
    _animation.addListener(listener);
    _opacityDuration = Duration(milliseconds: 200);
    _opacityAnicontroller =
        AnimationController(duration: _opacityDuration, vsync: this);
    _opacityTween = Tween(begin: 0.0, end: 1.0);
    _opacityAnimation = _opacityTween.animate(_opacityAnicontroller);
    _opacityAnimation.addListener(listener);
    setState(() {
      selectIndex = widget.selectIndex;
      isShow = true;
    });
    _opacityAnicontroller.forward();
    _anicontroller.forward();
    super.initState();
  }

  void listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            /**
             * 遮罩层
             */
            Positioned(
              top: widget.hasAppBar ? widget.top + 56.0 : widget.top,
              left: 0.0,
              right: 0.0,
              child: isShow ? GestureDetector(
                child: Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height,
                  color: Color.fromRGBO(0, 0, 0, .3),
                ),
                onTap: () {
                  _opacityAnicontroller.reverse();
                  _anicontroller.reverse();
                  setState(() {
                    isShow = false;
                  });
                  Navigator.pop(context);
                },
              ):SizedBox(),
            ),
            /**
             * 弹出窗
             */
            Positioned(
              top: _animation.value,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  width: double.maxFinite,
                  height: widget.menuHeights[selectIndex],
                  margin: widget.menuMargin,
                  padding: widget.menuPadding,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      isShow
                          ? BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, .3),
                              offset: Offset(5.0, 15.0),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            )
                          : BoxShadow(color: Color.fromRGBO(0, 0, 0, 0)),
                    ],
                  ),
                  child: widget.menus[selectIndex].dropDownWidget,
                ),
              ),
            ),
            /**
             * 菜单栏
             */
            Positioned(
              top: widget.hasAppBar ? widget.top + 56.0 : widget.top,
              left: 0.0,
              right: 0.0,
              child: Container(
                width: double.maxFinite,
                height: widget.headerHeight,
                margin: widget.headMargin,
                padding: widget.headPadding,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.headers.asMap().keys.map((index) {
                    return GestureDetector(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              widget.headers[index].title,
                              style: widget.headerStyle,
                            ),
                            widget.headers[index].iconData != null
                                ? Icon(widget.headers[index].iconData,
                                    size: widget.headers[index].iconSize)
                                : Container(),
                          ],
                        ),
                      ),
                      onTap: () {
                        if (selectIndex == index) {
                          _opacityAnicontroller.reverse();
                          _anicontroller.reverse();
                          setState(() {
                            isShow = false;
                          });
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            isShow = true;
                            selectIndex = index;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
