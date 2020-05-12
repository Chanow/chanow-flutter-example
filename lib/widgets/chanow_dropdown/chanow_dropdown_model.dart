import 'package:flutter/material.dart';

class ChanowDropdownHeaderItem {
  final String title;
  final IconData iconData;
  final double iconSize;

  ChanowDropdownHeaderItem(
    this.title, {
    this.iconData,
    this.iconSize,
  });
}

class ChanowDropdownMenuItem {
  final Widget dropDownWidget;

  ChanowDropdownMenuItem(this.dropDownWidget);
}