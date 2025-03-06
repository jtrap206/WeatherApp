class WeatherModel {
  final String name;
  final Temperature temperature;
  final int humidity;
  final Wind wind;
  final double maxTemperature;
  final double minTemperature;
  final int pressure;
  final int seaLevel;
  final List<WeatherInfo> weather;
  final DateTime dateTime;
  final double latitude;
  final double longitude;

  WeatherModel({
    required this.name,
    required this.temperature,
    required this.humidity,
    required this.wind,
    required this.maxTemperature,
    required this.minTemperature,
    required this.pressure,
    required this.seaLevel,
    required this.weather,
    required this.dateTime,
    required this.latitude,
    required this.longitude,

  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['name'],
      temperature: Temperature.fromJson(json['main']['temp']),
      humidity: json['main']['humidity'],
      wind: Wind.fromJson(json['wind']),
      maxTemperature: (json['main']['temp_max'] - 273.15),
      minTemperature: (json['main']['temp_min'] - 273.15),
      pressure: json['main']['pressure'],
      seaLevel: json['main']['sea_level'] ?? 0,
      weather: List<WeatherInfo>.from
      (json['weather'].map((weather) => WeatherInfo.fromJson(weather),
      )
      ),
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt']+json['timezone']) * 1000).toUtc(),
      latitude: json['coord']['lat'],
      longitude: json['coord']['lon'],
    );
  }
}

class WeatherInfo{
  final String main;
  WeatherInfo({required this.main});

  factory WeatherInfo.fromJson(Map<String, dynamic> json){
    return WeatherInfo(
      main: json['main'],
    );
  }
}

class Temperature
{
  final double current;
  Temperature({required this.current});

  factory Temperature.fromJson(dynamic json){
    return Temperature(
      current: (json - 273.15),
    );
  }
}

class Wind{
  final double speed;
  Wind ({required this.speed});
  factory Wind.fromJson(dynamic json){
    return Wind(
      speed: json['speed'],
    );
  }
} 