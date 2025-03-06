// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherAnimations extends StatelessWidget {
  const WeatherAnimations({
    Key? key,
    required this.conditions, required this.cityTime,
  });
  final String conditions;
  final DateTime cityTime;

 String getWeatherAnimation(String conditions){
  int hour = cityTime.hour;
  bool isNight = hour >=19 || hour < 6;
  if(isNight){
    return "assets/animations/moon.json";
  }
  switch (conditions.toLowerCase()){
    case "clear":
      return "assets/animations/sunny.json";
    case "rain":
      return "assets/animations/rainny.json";
    case "clouds":
      return "assets/animations/sun_cloudy.json";
    case "snow":
      return "assets/animations/snow.json";
    case "thunderstorm":
      return "assets/animations/rainny.json";
    default:
      return "assets/animations/sunny.json";
    
      
  }
 }
 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      child: Lottie.asset(getWeatherAnimation(conditions)),
    );
   
  }
}
