import 'package:flutter/material.dart';

import 'chanow_cityData.dart';

class ChanowCitySliderBar extends StatefulWidget {
  final Function onChanged;

  const ChanowCitySliderBar({Key key, this.onChanged}) : super(key: key);
  @override
  _ChanowCitySliderBarState createState() => _ChanowCitySliderBarState();
}

class Result {
  String item;
  int index;
  bool touch;

  Result({this.item, this.index, this.touch});
}

class _ChanowCitySliderBarState extends State<ChanowCitySliderBar> {
  double sliderHeight;
  double itemHeight;
  double top;
  int index;
  List<String> azList = [];

  @override
  void initState() {
    for (var item in cityData) {
      azList.add(item.title[0]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    top = (MediaQuery.of(context).size.height - 90.0) / 10;
    sliderHeight = (MediaQuery.of(context).size.height - 90.0) / 10 * 7.5;
    itemHeight = (sliderHeight - 10) / azList.length;
    return Positioned(
      top: (MediaQuery.of(context).size.height - 90.0) / 10,
      right: 20.0,
      child: GestureDetector(
        child: Container(
          height: sliderHeight,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: azList.map((item) {
              return Text(
                item,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              );
            }).toList(),
          ),
        ),
        onPanStart: (dragUpdateDetails) {
          setState(() {
            index = int.parse(
                ((dragUpdateDetails.localPosition.dy - 10) / itemHeight)
                    .toStringAsFixed(0));
          });
          if (index > -1 && index < azList.length) {
            widget.onChanged(Result(item: azList[index], index:index, touch: true));
          }else{
            widget.onChanged(Result(item: "", index:index, touch: false));
          }
        },
        onPanUpdate: (dragUpdateDetails) {
          setState(() {
            index = int.parse(
                ((dragUpdateDetails.localPosition.dy - 10) / itemHeight)
                    .toStringAsFixed(0));
          });
          if (index > -1 && index < azList.length) {
            widget.onChanged(Result(item: azList[index], index:index, touch: true));
          }else{
            widget.onChanged(Result(item: "", index:index, touch: false));
          }
        },
        onPanEnd: (dragUpdateDetails) {
          if (index > -1 && index < azList.length) {
            widget.onChanged(Result(item: azList[index], index:index, touch: false));
          }else{
            widget.onChanged(Result(item: "", index:index, touch: false));
          }
        },
      ),
    );
  }
}
