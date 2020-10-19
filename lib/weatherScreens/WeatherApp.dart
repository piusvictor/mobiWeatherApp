import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather/Animation/FadeAnimation.dart';
import 'package:http/http.dart' as http;
import 'package:weather/Config/AppConfig.dart';

class WeatherApp extends StatefulWidget {
  WeatherApp({Key key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _searchWeather(apiUrl + regions[currentIndex]);
    });
  }

  final List<List<String>> products = [
    ['assets/images/watch-1.jpg', 'Hugo Boss Oxygen', '100 \$'],
    ['assets/images/watch-2.jpg', 'Hugo Boss Signature', '120 \$'],
    ['assets/images/watch-3.jpg', 'Casio G-Shock Premium', '80 \$']
  ];

  int currentIndex = 0;
  var temperature = "";
  var humidity = "";
  var pressure = "";
  var wind = "";
  var main = "";
  var icon = "";

  static List<String> regions = ['Dar es Salaam', 'Arusha', 'Mbeya'];
  var apiUrl =
      'https://api.openweathermap.org/data/2.5/weather?units=metric&appid=${AppConfig.SECRET_KEY}&q=';

  void _next() {
    setState(() {
      if (currentIndex < products.length - 1) {
        currentIndex++;
        _searchWeather(apiUrl + regions[currentIndex]);
      } else {
        currentIndex = currentIndex;
        _searchWeather(apiUrl + regions[currentIndex]);
      }
    });
  }

  void _preve() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        _searchWeather(apiUrl + regions[currentIndex]);
      } else {
        currentIndex = 0;
        _searchWeather(apiUrl + regions[currentIndex]);
      }
    });
  }

//API_URL
  void _searchWeather(String url) async {
    var searchResult = await http.get(url);
    var result = json.decode(searchResult.body);
    setState(() {
      //Sending received and decoded data to the user Interface
      temperature = (result["main"]["temp"]).toString();
      wind = (result["wind"]["speed"].toString());
      main = (result["weather"][0]["main"].toString());
      humidity = result["main"]["humidity"].toString();
      pressure = result["main"]["pressure"].toString();
      icon = (result["weather"][0]["icon"].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/purple.jpg'), fit: BoxFit.cover),
        ),
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.velocity.pixelsPerSecond.dx > 0) {
              _preve();
            } else if (details.velocity.pixelsPerSecond.dx < 0) {
              _next();
            }
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.8),
              Colors.black.withOpacity(.3),
            ])),
            child: temperature == ""
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(40.0, 55.0, 0.0, 20.0),
                          width: double.infinity,
                          // color: Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FadeAnimation(
                                1,
                                Text(
                                  "$temperature°C",
                                  style: TextStyle(
                                      fontSize: 80.0,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                              ),
                              Text(
                                "$main",
                                style: TextStyle(
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Text(
                                regions[currentIndex],
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                          child: Image.network(
                            "http://openweathermap.org/img/w/$icon.png",
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            // color: Color.fromRGBO(0, 0, 0, .5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(186, 104, 200, .4),
                                        border: Border(
                                            bottom: BorderSide(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .8),
                                                width: 35.0))),
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/images/wind.png",
                                              width: 60.0,
                                              height: 60.0,
                                            ),
                                            Container(
                                              transform:
                                                  Matrix4.translationValues(
                                                      0.0, 20.0, 0.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "$wind",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.0),
                                                  ),
                                                  Text(
                                                    " km/h",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          transform: Matrix4.translationValues(
                                              0.0, 43.0, 0.0),
                                          child: Text('Wind',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20.0)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(186, 104, 200, .4),
                                        border: Border(
                                            bottom: BorderSide(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .8),
                                                width: 35.0))),
                                    padding: EdgeInsets.fromLTRB(
                                        22.0, 16.0, 22.0, 16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/images/humidity.png",
                                              width: 60.0,
                                              height: 60.0,
                                            ),
                                            Container(
                                              transform:
                                                  Matrix4.translationValues(
                                                      0.0, 20.0, 0.0),
                                              child: Text(
                                                '$humidity %',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          transform: Matrix4.translationValues(
                                              0.0, 43.0, 0.0),
                                          child: Text('Humidity',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20.0)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(186, 104, 200, .4),
                                        border: Border(
                                            bottom: BorderSide(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .8),
                                                width: 35.0))),
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/images/pressure.png",
                                              width: 60.0,
                                              height: 60.0,
                                            ),
                                            Container(
                                              transform:
                                                  Matrix4.translationValues(
                                                      0.0, 20.0, 0.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '$pressure',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.0),
                                                  ),
                                                  Text(
                                                    ' hpa',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          transform: Matrix4.translationValues(
                                              0.0, 43.0, 0.0),
                                          child: Text('Pressure',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20.0)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        FadeAnimation(
                          1,
                          Container(
                            width: 90,
                            margin: EdgeInsets.only(bottom: 60),
                            child: Row(
                              children: _buildIndicator(),
                            ),
                          ),
                        )
                      ],
                    ))),
          ),
        ));
  }

  Widget _indicator(bool isActive) {
    return Expanded(
      child: Container(
        height: 4,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: isActive ? Colors.grey[800] : Colors.white),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < products.length; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
