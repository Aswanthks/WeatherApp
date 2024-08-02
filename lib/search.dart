import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:weatherapp/utils/constants.dart';
import 'package:weatherapp/utils/helper.dart';

class screen3 extends StatefulWidget {
  const screen3({
    super.key,
  });

  @override
  State<screen3> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<screen3> {
  double? lat;
  double? longt;
  var weatherData;
  bool loading = false;
  TextEditingController location = TextEditingController();

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  void getlocation() async {
    setState(() {
      loading = true;
    });
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      lat = position.latitude;
      longt = position.longitude;
    });
    fetchWeatherData(lat, longt);
  }

  Future<void> fetchWeatherData(double? lat, double? longt) async {
    if (lat != null && longt != null) {
      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$longt&appid=$apiKey'));
      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    }
  }

  Future<void> searchWeather(String location) async {
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey'));
    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    getlocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3352C5E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xFF3352C5E),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 30),
                    Text(
                      "Weather",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    SizedBox(width: 180),
                    Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: location,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search for a city",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(CupertinoIcons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: Colors.black26,
                      filled: true,
                    ),
                    onSubmitted: (value) {
                      searchWeather(value);
                    },
                  ),
                ),
                SizedBox(height: 10),
                if (weatherData != null)
                  Container(
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/image/Rectangle 5.png',
                          height: 200,
                          width: 400,
                        ),
                        Positioned(
                          right: -45,
                          bottom: -5,
                          child: Image.asset(
                            'assets/image/moonvloudrain.png',
                            height: 260,
                            width: 260,
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 25,
                          child: Text(
                            '${((weatherData['main']['temp']) - 273.15).toStringAsFixed(0)}°',
                            style: TextStyle(color: Colors.white, fontSize: 60),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 100,
                          child: Text(
                            'H:${((weatherData['main']['humidity']))} %',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 145,
                          child: Text(
                            '${((weatherData['name']))}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Positioned(
                          right: 30,
                          top: 145,
                          child: Text(
                            '${((weatherData['weather'][0]['main']))}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20),
                if (weatherData != null)
                  WeatherDetailsCard(
                      maxTemp:
                          (weatherData['main']['temp'] - 273.15).toInt(),

                      humidity: weatherData['main']['humidity'],
                      windSpeed: weatherData['wind']['speed'],
                      clouds: weatherData['clouds']['all'],
                      visibility: weatherData['visibility'] / 1000,
                      sunrise: weatherData['sys']['sunrise'] * 1000,
                      sunset: weatherData['sys']['sunset'] * 1000,
                      timezones: weatherData['timezone']),
                // Add more widgets here as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherDetailsCard extends StatelessWidget {
  final int maxTemp;

  final int humidity;
  final double windSpeed;
  final int clouds;
  final int timezones;
  final int sunrise;
  final double visibility;
  final int sunset;

  const WeatherDetailsCard({
    Key? key,
    required this.maxTemp,

    required this.humidity,
    required this.windSpeed,
    required this.clouds,
    required this.timezones,
    required this.sunrise,
    required this.visibility,
    required this.sunset,
  }) : super(key: key);

  String getTimezoneGMT() {
    // Convert timezone offset to GMT format
    int offsetHours = timezones ~/ 3600; // Seconds to hours
    int offsetMinutes =
        (timezones % 3600) ~/ 60; // Remaining seconds to minutes

    String offsetStr = offsetHours >= 0
        ? '+${offsetHours.toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}'
        : '${offsetHours.toString().padLeft(3, '0')}:${offsetMinutes.toString().padLeft(2, '0')}';

    return 'GMT$offsetStr';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeatherData(
              WeatherStatuses: "Timezone",
              Weatherdata: getTimezoneGMT(),
              WeatherIcon: CupertinoIcons.time,
            ),
            SizedBox(height: 10),
            WeatherData(
              WeatherStatuses: " Temperature",
              Weatherdata: '$maxTemp°C',
              WeatherIcon: CupertinoIcons.thermometer,
            ),


            SizedBox(height: 10),
            WeatherData(
              WeatherStatuses: "Humidity",
              Weatherdata: '$humidity%',
              WeatherIcon: CupertinoIcons.drop,
            ),
            SizedBox(height: 10),
            WeatherData(
              WeatherStatuses: "Wind Speed",
              Weatherdata:'$windSpeed m/s',
              WeatherIcon: CupertinoIcons.wind,
            ),
            SizedBox(height: 10),
            WeatherData(
              WeatherStatuses: "Cloudiness",
              Weatherdata:'$clouds%',
              WeatherIcon: CupertinoIcons.cloud,
            ),
            SizedBox(height: 10),
            WeatherData(
              WeatherStatuses: "Visibility",
              Weatherdata: '$visibility km',
              WeatherIcon: CupertinoIcons.eye,
            ),
            SizedBox(height: 10),
            WeatherData(
              WeatherStatuses: "Sunrise",
              Weatherdata: DateTime.fromMillisecondsSinceEpoch(sunrise).toLocal().toString().split(' ')[1],
              WeatherIcon: CupertinoIcons.sunrise,
            ),
            SizedBox(height: 10),
            WeatherData(
              WeatherStatuses: "Sunset",
              Weatherdata: DateTime.fromMillisecondsSinceEpoch(sunset).toLocal().toString().split(' ')[1],
              WeatherIcon: CupertinoIcons.sunset,
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherData extends StatelessWidget {
  final String WeatherStatuses;
  final dynamic Weatherdata;
  final IconData WeatherIcon;

  const WeatherData({
    Key? key,
    required this.WeatherStatuses,
    required this.Weatherdata,
    required this.WeatherIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              WeatherIcon,
              color: Colors.blue,
            ),
            SizedBox(width: 10),
            Text(
              WeatherStatuses,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          '$Weatherdata',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
