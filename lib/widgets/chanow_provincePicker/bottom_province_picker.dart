import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'province.dart';

class BottomProvincePicker extends StatefulWidget {
  final Function onChanged;

  const BottomProvincePicker({Key key, this.onChanged}) : super(key: key);
  @override
  _BottomProvincePickerState createState() => _BottomProvincePickerState();
}

class _BottomProvincePickerState extends State<BottomProvincePicker>
    with TickerProviderStateMixin {
  AnimationController _anicontroller;
  Duration _duration;
  Animation _animation;
  Tween _tween;
  int provinceIndex = 0;
  int cityIndex = 0;
  int areaIndex = 0;
  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> areas = [];
  @override
  void initState() {
    initProvinces();
    initCities("110000");
    initAreas("110100");
    _duration = Duration(milliseconds: 300);
    _anicontroller = AnimationController(duration: _duration, vsync: this);
    _tween = Tween(begin: 0.0, end: 300.0);
    _animation = _tween.animate(_anicontroller);
    _animation.addListener(listener);
    _anicontroller.forward();
    super.initState();
  }

  void listener() {
    setState(() {});
  }

  // 初始化省列表
  void initProvinces() {
    List<Map<String, dynamic>> _provinces = [];
    provincesData.forEach((key, value) {
      _provinces.add({"name": value, "code": key});
    });
    setState(() {
      provinces = _provinces;
    });
  }

  //初始化市列表
  void initCities(String code) {
    List<Map<String, dynamic>> _cities = [];
    citiesData[code].forEach((key, value) {
      _cities.add({"name": value["name"], "code": key});
    });
    setState(() {
      cities = _cities;
    });
  }

  // 初始化区县列表
  void initAreas(String code) {
    List<Map<String, dynamic>> _areas = [];
    citiesData[code].forEach((key, value) {
      _areas.add({"name": value["name"], "code": key});
    });
    setState(() {
      areas = _areas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            child: Container(
              color: Color.fromRGBO(0, 0, 0, .3),
            ),
            onTap: () {
              _anicontroller.reverse();
              Navigator.pop(context);
            },
          )),
          Container(
            width: double.maxFinite,
            height: _animation.value,
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            color: Colors.white,
            child: Column(children: <Widget>[
              Container(
                width: double.maxFinite,
                height: 30.0,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                        "取消",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "确定",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        var data = {
                          "province": provinces[provinceIndex]['name'],
                          "city": cities[cityIndex]['name'],
                          "area": areas[areaIndex]['name'],
                          "code": areas[areaIndex]["code"]
                        };
                        widget.onChanged(data);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: CupertinoPicker.builder(
                          childCount: provinces.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: Text(
                                provinces[index]["name"],
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            );
                          },
                          itemExtent: 45,
                          backgroundColor: Colors.white,
                          onSelectedItemChanged: (int value) {
                            initCities(provinces[value]["code"]);
                            initAreas(cities[0]["code"]);
                            setState(() {
                              provinceIndex = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CupertinoPicker.builder(
                          childCount: cities.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: Text(
                                cities[index]["name"],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            );
                          },
                          itemExtent: 45,
                          backgroundColor: Colors.white,
                          onSelectedItemChanged: (int value) {
                            initAreas(cities[value]["code"]);
                            setState(() {
                              cityIndex = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CupertinoPicker.builder(
                          childCount: areas.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: Text(
                                areas[index]["name"],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            );
                          },
                          itemExtent: 45,
                          backgroundColor: Colors.white,
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              areaIndex = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
