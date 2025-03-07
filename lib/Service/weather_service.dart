
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:weather_api/Model/weather_model.dart';

class WeatherService {
 
 Future<WeatherModel?> fetchWeather({required double latitude, required double longitude })async{
  
     
      final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=9c8d743e070207c04ca4ac454eeeca42')
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
         return null;
       }
  }
  Future<WeatherModel?> fetchRandomWeather() async {
    
    List<Map<String, double>> randomLocations = [
      {"lat": 40.7128, "lon": -74.0060}, // New York, USA
      {"lat": 34.0522, "lon": -118.2437}, // Los Angeles, USA
      {"lat": 51.5074, "lon": -0.1278}, // London, UK
      {"lat": 35.6895, "lon": 139.6917}, // Tokyo, Japan
      {"lat": -33.8688, "lon": 151.2093}, // Sydney, Australia
      {"lat": 48.8566, "lon": 2.3522}, // Paris, France
      {"lat": -22.9068, "lon": -43.1729}, //Rio de Janeiro, Brazil
      {"lat": -1.29218, "lon": 36.8219}, //nairobi, kenya
      {"lat": 47.324046, "lon": -105.7088943},
    ];

    
    final randomIndex = Random().nextInt(randomLocations.length);
    final location = randomLocations[randomIndex];

    return fetchWeather(latitude: location["lat"]!, longitude: location["lon"]!);
  }

  Future<DateTime>fetchTime(double latitude, double longitude) async{
    final response = await http.get(Uri.parse('http://api.timezonedb.com/v2.1/get-time-zone?key=N6YVQRJ7XMLQ&format=json&by=position&lat=$latitude&lng=$longitude'));
    try{
      if(response.statusCode == 200){
        var json = jsonDecode(response.body);
        String formatedTime = json['formatted'];
        return DateTime.parse(formatedTime);
      }else{
        throw Exception("Failed to load time data");
      }
    }catch(e){
      print(e.toString());
      return DateTime.now();
    }
  }
}