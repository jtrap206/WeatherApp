import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_api/Model/weather_model.dart';

class WeatherService {
  fetchWeather()async{
    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=-1.1483&lon=36.9605&appid=9c8d743e070207c04ca4ac454eeeca42")
     );
     try{
       if(response.statusCode == 200){
         var json = jsonDecode(response.body);
         return WeatherModel.fromJson(json);
         }else{
          throw Exception("Failed to load weather data");
         }
       }catch(e){
         print(e.toString());
       }
  }
}