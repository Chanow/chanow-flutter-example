import 'package:flutter/material.dart';
import 'chanow_cityData.dart';
import 'chanow_citySliderBar.dart';

class ChanowCityPicker extends StatefulWidget {
  final Function onChanged;

  const ChanowCityPicker({Key key, this.onChanged}) : super(key: key);
  @override
  _ChanowCityPickerState createState() => _ChanowCityPickerState();
}

class _ChanowCityPickerState extends State<ChanowCityPicker> {
  ScrollController _scrollController = new ScrollController();
  List<double> itemHeights = [];
  List<double> offsets = [];
  String item;
  bool isShow;

  @override
  void initState() {
    setState(() {
      item = '';
      isShow = false;
    });
    for (var i = 0; i < cityData.length; i++) {
      itemHeights.add(getHeight(30.0, 40.0, cityData[i].lists.length));
    }
    offsets = getOffsets(itemHeights);
    super.initState();
  }

  double getHeight(double titleHeight, double itemHeight, int nums) {
    double height = titleHeight + nums * itemHeight;
    return height;
  }

  List<double> getOffsets(List heights) {
    List<double> offsets = [0.0];
    for (var i = 0; i < heights.length; i++) {
      offsets.add(heights[i] + offsets[i]);
    }
    offsets.remove(offsets[offsets.length - 1]);
    return offsets;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: cityData.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    height: 30.0,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    color: Color.fromRGBO(230, 230, 230, .3),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            cityData[index].title,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cityData[index].lists.map((item) {
                      return GestureDetector(
                        child: Container(
                          height: 40.0,
                          width: double.maxFinite,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                item["name"],
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          widget.onChanged(item);
                          Navigator.of(context).pop(item);
                        },
                      );
                    }).toList(),
                  )
                ],
              );
            },
          ),
        ),
        isShow
            ? Positioned(
                child: Center(
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, .3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                        child: Text(
                      item,
                      style: TextStyle(color: Colors.white, fontSize: 40.0),
                    )),
                  ),
                ),
              )
            : Container(),
        ChanowCitySliderBar(
          onChanged: (Result result) {
            if (result.index > -1 && result.index < cityData.length) {
              setState(() {
                item = result.item;
                isShow = result.touch;
              });
              if (!result.touch) {
                _scrollController.animateTo(offsets[result.index],
                    duration: Duration(milliseconds: 300),
                    curve: Curves.bounceInOut);
              }
            } else {
              setState(() {
                isShow = false;
              });
            }
          },
        ),
      ],
    );
  }
}
