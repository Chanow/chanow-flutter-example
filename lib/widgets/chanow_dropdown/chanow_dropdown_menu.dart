import 'package:flutter/material.dart';
import 'PopRoute.dart';
import 'chanow_dropdown_model.dart';
import 'chanow_dropdown_page.dart';

class ChanowDropdownMenu extends StatefulWidget {
  final List<ChanowDropdownHeaderItem> headers; //顶部菜单
  final List<ChanowDropdownMenuItem> menus; //选项弹窗
  final double headerHeight;  //顶部高度
  final List<double> menuHeights; //弹窗高度
  final TextStyle headerStyle;  //顶部字体样式
  final EdgeInsets headMargin;  //顶部margin
  final EdgeInsets headPadding; //顶部padding
  final EdgeInsets menuMargin;  //弹窗margin
  final EdgeInsets menuPadding; //弹窗padding
  final double top; //上边距离
  final bool hasAppBar; //是否有AppBar

  const ChanowDropdownMenu({
    Key key,
    @required this.headers,
    @required this.menus,
    this.headerHeight = 30.0,
    this.menuHeights,
    this.headerStyle = const TextStyle(fontSize: 14.0),
    this.top = 0.0,
    this.headMargin,
    this.headPadding,
    this.menuMargin,
    this.menuPadding,
    this.hasAppBar = false,
  }) : super(key: key);
  @override
  _ChanowDropdownMenuState createState() => _ChanowDropdownMenuState();
}

class _ChanowDropdownMenuState extends State<ChanowDropdownMenu>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
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
                Navigator.push(
                  context,
                  PopRoute(
                    child: ChanowDropdownPage(
                      headers: widget.headers,
                      menus: widget.menus,
                      headerHeight: widget.headerHeight,
                      menuHeights: widget.menuHeights,
                      headerStyle: widget.headerStyle,
                      headMargin: widget.headMargin,
                      headPadding: widget.headPadding,
                      menuMargin: widget.menuMargin,
                      menuPadding: widget.menuPadding,
                      top: widget.top,
                      selectIndex: index,
                      hasAppBar: widget.hasAppBar,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
