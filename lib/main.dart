import 'package:flutter/material.dart';
import 'weatherScreens/WeatherApp.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: WeatherApp(),
    );
  }
}
