import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_api/Model/weather_model.dart';
import 'package:weather_api/Service/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late WeatherModel weatherInfo;
  bool isLoading = false;
  myWeather() {
    isLoading = false;
     WeatherService().fetchWeather().then((value){
      setState(() {
        weatherInfo=value;
        isLoading = true;
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
      weather: []
      );
    super.initState();
    myWeather();
  }

  @override
  Widget build(BuildContext context) {
    String formatedDate = DateFormat('EEE D, MMMM yyyy').format(DateTime.now());
    String formatedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: 
                isLoading ?
                WeatherDetail(
                  weather:weatherInfo, 
                  formattedDate: formatedDate, 
                  formattedTime: formatedTime
                  )
                  
                  : const CircularProgressIndicator(
                    color: Colors.white,
              )     ),
            ]),
          ),
      
          ),
      );

  }
}

class WeatherDetail extends StatelessWidget {
  const WeatherDetail ({super.key, required this.weather, required this.formattedDate, required this.formattedTime});
 final WeatherModel weather;
 final String formattedDate;
  final String formattedTime;
  @override
  Widget build(BuildContext context) {
    

    
      return Column(
        children: [
          Text(weather.name, 
            style: const TextStyle(
            color: Colors.white, 
            fontSize: 20,
            fontWeight: FontWeight.bold),
            ),
      
            if(weather.weather.isNotEmpty)
            Text(
             "${weather.temperature.current.toStringAsFixed(2)}°C", 
              style: const TextStyle(
              color: Colors.white, 
              fontSize: 40,
              fontWeight: FontWeight.bold),
            ),
      
             Text(
             weather.weather[0].main, 
             style: const TextStyle(
             color: Colors.white, 
             fontSize: 15,
             fontWeight: FontWeight.bold),
            ),
      
            const SizedBox(height: 30),
      
            Text(
            formattedDate, 
            style: const TextStyle(
            color: Colors.white, 
            fontSize: 18,
            fontWeight: FontWeight.bold),
            ),
      
            Text(
            formattedTime, 
            style: const TextStyle(
            color: Colors.white, 
            fontSize: 18,
            fontWeight: FontWeight.bold),
            ),
      
            const SizedBox(height: 20),
            Container(height: 200, width: 200, decoration: BoxDecoration(), child: Lottie.asset("assets/animations/sun_cloudy.json"), ),
      
            const SizedBox(height: 30),
            Container(
              height: 250, 
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.blueAccent, 
                borderRadius: BorderRadius.circular(20)
                ), 
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
                                Icon(
                                  Icons.wind_power, 
                                  color: Colors.orangeAccent
                                ),
                                const SizedBox(height: 5),
                                weatherInfoCard(
                                  title: "Wind Speed", 
                                  value: "${weather.wind.speed} km/h"
                                )
                                
                              ],
                            ),
                        
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wb_sunny_rounded, 
                                  color: Colors.redAccent
                                ),
                                const SizedBox(height: 5),
                                weatherInfoCard(
                                  title: "Max", 
                                  value: "${weather.maxTemperature.toStringAsFixed(2)}°C"
                                )
                                
                              ],
                            ),
                        
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wb_sunny_outlined, 
                                  color: Colors.purpleAccent
                                ),
                                const SizedBox(height: 5),
                                weatherInfoCard(
                                  title: "min", 
                                  value: "${weather.minTemperature.toStringAsFixed(2)}°C"
                                )
                                
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
                                Icon(
                                  Icons.water_drop, 
                                  color: Colors.blueGrey
                                ),
                                const SizedBox(height: 5),
                                weatherInfoCard(
                                  title: "Humidity", 
                                  value: "${weather.humidity} %"
                                )
                                
                              ],
                            ),
                        
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.airline_seat_flat, 
                                  color: Colors.amberAccent
                                ),
                                const SizedBox(height: 5),
                                weatherInfoCard(
                                  title: "Pressure", 
                                  value: "${weather.pressure}hPa"
                                )
                                
                              ],
                            ),
                        
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.leaderboard_rounded, 
                                  color: Colors.green
                                ),
                                const SizedBox(height: 5),
                                weatherInfoCard(
                                  title: "Sea-Level", 
                                  value: "${weather.seaLevel}m"
                                )
                                
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  )
                )
        ],
      );
      
    
  }

  Column weatherInfoCard ({required String title, required String value}){
    return Column(
      children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white
              ) , 
            ),

            Text(
             title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                  fontSize: 16,
                    color: Colors.white
              ) , 
            )
                              ],
    ); 
  }
}