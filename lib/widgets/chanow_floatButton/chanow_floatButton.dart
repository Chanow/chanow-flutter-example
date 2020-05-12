import 'package:flutter/material.dart';

class ChanowFloatButton extends StatefulWidget {
  final Offset offset; //初始位置
  final double top; //顶部距离
  final double left; //左边距离
  final double right; //右边距离
  final double bottom; //下边距离
  final double width; //按钮宽度
  final double height; //按钮高度
  final bool hasAppBar; //是否有AppBar
  final Color bgColor; //按钮背景色
  final Function onPressed; //点击事件
  final Widget child;

  const ChanowFloatButton({
    Key key,
    @required this.offset,
    this.top = 80.0,
    this.left = 25.0,
    this.right = 75.0,
    this.bottom = 100.0,
    this.onPressed,
    @required this.child,
    this.width = 50.0,
    this.height = 50.0,
    this.hasAppBar = true,
    this.bgColor = const Color.fromRGBO(55, 142, 240, 1),
  }) : super(key: key);
  @override
  _ChanowFloatButtonState createState() => _ChanowFloatButtonState();
}

class _ChanowFloatButtonState extends State<ChanowFloatButton> {
  Offset offset;

  @override
  void initState() {
    offset = Offset(widget.offset.dx, widget.offset.dy);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
          //更新child的位置
          onPanUpdate: (details) {
            setState(() {
              offset = Offset(
                details.globalPosition.dx - widget.width / 2,
                widget.hasAppBar
                    ? details.globalPosition.dy - widget.height - 50.0
                    : details.globalPosition.dy - widget.height,
              );
            });
          },
          //拖动结束，处理child贴边悬浮
          onPanEnd: (details) {
            if (offset.dx > MediaQuery.of(context).size.width - widget.right) {
              setState(() {
                offset = Offset(
                  MediaQuery.of(context).size.width - widget.right,
                  offset.dy,
                );
              });
            }
            if (offset.dx < widget.left) {
              setState(() {
                offset = Offset(widget.left, offset.dy);
              });
            }
            if (offset.dy < widget.top) {
              setState(() {
                offset = Offset(offset.dx, widget.top);
              });
            }
            if (offset.dy >
                MediaQuery.of(context).size.height - widget.bottom) {
              setState(() {
                offset = Offset(
                  offset.dx,
                  MediaQuery.of(context).size.height - widget.bottom,
                );
              });
            }
          },
          //悬浮部件布局
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(5.0, 5.0),
                  color: Color.fromRGBO(0, 0, 0, .3),
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              color: widget.bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: widget.child,
              onPressed: widget.onPressed,
            ),
          )),
    );
  }
}
