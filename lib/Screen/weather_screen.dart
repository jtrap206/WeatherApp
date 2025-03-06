import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_api/Model/weather_model.dart';
import 'package:weather_api/Service/weather_service.dart';
import 'package:weather_api/Widgets/weather_animations.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late WeatherModel weatherInfo;
  bool isLoading = true;
  DateTime cityTime = DateTime.now();

  void myWeather() async {
    setState(() {
      isLoading = true;
    });
    // try {
    //   WeatherModel? weatherModel = await WeatherService()
    //       .fetchWeather(latitude: 40.7128, longitude: -74.0060);
    // } on Exception catch (e) {
    //   // TODO
    // }
    WeatherService()
        .fetchWeather(latitude: 40.7128, longitude: -74.0060)
        .then((value) {
      print("API Response: $value");
      if (value != null) {
        setState(() {
          weatherInfo = value;
          cityTime = cityTime;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((error) {
      print("error fetching weather data: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  void fetchRandomWeather(){
    setState(() {
      isLoading = true;
    });
    WeatherService().fetchRandomWeather().then((value){
      if(value != null){
        WeatherService()
        .fetchTime(value.latitude, value.longitude)
        .then((time){
          setState(() {
            weatherInfo = value;
            cityTime = time;
            isLoading = false;
          });
        });
      }else{
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((error){
      print("error fetching random weather data: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    weatherInfo = WeatherModel(
        name: "",
        temperature: Temperature(current: 0),
        humidity: 0,
        wind: Wind(speed: 0),
        maxTemperature: 0,
        minTemperature: 0,
        pressure: 0,
        seaLevel: 0,
        weather: [],
        dateTime: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0);
    super.initState();
    myWeather();
  }

  @override
  Widget build(BuildContext context) {
    String formatedDate =
        DateFormat('EEE D, MMMM yyyy').format(cityTime);
    String formatedTime = 
        DateFormat('hh:mm a').format(cityTime);

    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.shuffle, color: Colors.white),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                WeatherService().fetchRandomWeather().then((value) {
                  if (value != null) {
                    setState(() {
                      weatherInfo = value;
                      isLoading = false;
                    });
                  }
                }).catchError((error) {
                  print(error);
                  setState(() {
                    isLoading = false;
                  });
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: 
            MainAxisAlignment.center, 
            children: [
            Center(
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : WeatherDetail(
                        weather: weatherInfo,
                        formattedDate: formatedDate,
                        formattedTime: formatedTime, 
                        cityTime: cityTime,))
          ]),
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  const WeatherDetail(
      {super.key,
      required this.weather,
      required this.formattedDate,
      required this.formattedTime, 
      required this.cityTime});
  final WeatherModel weather;
  final String formattedDate;
  final String formattedTime;
  final DateTime cityTime;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.name,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (weather.weather.isNotEmpty)
          Text(
            "${weather.temperature.current.toStringAsFixed(2)}°C",
            style: const TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
        if (weather.weather.isNotEmpty)
          Text(
            weather.weather[0].main,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 30),
        Text(
          formattedDate,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          formattedTime,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        WeatherAnimations(
          conditions:
              weather.weather.isNotEmpty ? weather.weather[0].main : "clear",
              cityTime: cityTime,
        ),
        const SizedBox(height: 30),
        Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wind_power, color: Colors.orangeAccent),
                            const SizedBox(height: 5),
                            weatherInfoCard(
                                title: "Wind Speed",
                                value: "${weather.wind.speed} km/h")
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wb_sunny_rounded,
                                color: Colors.redAccent),
                            const SizedBox(height: 5),
                            weatherInfoCard(
                                title: "Max",
                                value:
                                    "${weather.maxTemperature.toStringAsFixed(2)}°C")
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wb_sunny_outlined,
                                color: Colors.purpleAccent),
                            const SizedBox(height: 5),
                            weatherInfoCard(
                                title: "min",
                                value:
                                    "${weather.minTemperature.toStringAsFixed(2)}°C")
                          ],
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.water_drop, color: Colors.blueGrey),
                            const SizedBox(height: 5),
                            weatherInfoCard(
                                title: "Humidity",
                                value: "${weather.humidity} %")
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.airline_seat_flat,
                                color: Colors.amberAccent),
                            const SizedBox(height: 5),
                            weatherInfoCard(
                                title: "Pressure",
                                value: "${weather.pressure}hPa")
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.leaderboard_rounded,
                                color: Colors.green),
                            const SizedBox(height: 5),
                            weatherInfoCard(
                                title: "Sea-Level",
                                value: "${weather.seaLevel}m")
                          ],
                        )
                      ],
                    )
                  ],
                )))
      ],
    );
  }

  Column weatherInfoCard({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
        ),
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
        )
      ],
    );
  }
}
