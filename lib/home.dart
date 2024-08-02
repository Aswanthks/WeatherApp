import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/model/weathermodel.dart';
import 'package:weatherapp/search.dart';
import 'package:weatherapp/utils/constants.dart';
import 'package:weatherapp/utils/helper.dart';

import 'package:weatherapp/weather%20card.dart';
import 'package:http/http.dart' as http;

import 'home2.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> pages = [home2(), Placeholder(), screen3()];

  void _onItemTapped(int index) {
    if (index == 1) {
      // Change index condition from 1 to 2
      _showBottomSheet(context); // Pass context to the method
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // Make the bottom sheet background transparent
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white
                  .withOpacity(0), // Adjust the opacity for transparency
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Hourly Forecast",
                          style:
                              TextStyle(color: Colors.white.withOpacity(.5))),
                      Text(
                        "Weekly Forecast",
                        style: TextStyle(color: Colors.white.withOpacity(.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 120, // Adjust height as needed
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        WeatherCard(
                            time: '3 PM',
                            temperature: '28',
                            chance: '74%',
                            icon: 'Moon cloud mid rain.png'),
                        WeatherCard(
                            time: 'Now',
                            temperature: '28',
                            chance: '70%',
                            icon: 'Moon cloud mid rain.png'),
                        WeatherCard(
                            time: '5 PM',
                            temperature: '27',
                            chance: '70%',
                            icon: 'Moon cloud mid rain.png'),
                        WeatherCard(
                            time: '6 PM',
                            temperature: '27',
                            chance: '68%',
                            icon: 'Moon cloud mid rain.png'),
                        WeatherCard(
                            time: '7 AM',
                            temperature: '27',
                            chance: '65%',
                            icon: 'Moon cloud mid rain.png'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double? lat;
  double? longt;
  bool loading =false;

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
      loading= true;
    });
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
    lat = position.latitude;
    longt = position.longitude;
    setState(() {
      loading =false;
    });
  }

  Future<weathermodel> Weather() async {
    if (lat != null || longt != null) {
      var data = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$longt&appid=$apiKey'));
     if(data.statusCode==200){
       var decoded  = jsonDecode(data.body);
       weathermodel datas=weathermodel.fromJson(decoded);

       print(decoded);
       return datas;

     }else{
       throw errorhandler(data);
     }

    } else {
      throw Exception(Text("No latitude and longitude"));
    }
  }
  TextEditingController location = TextEditingController();

  @override
  void initState() {
    getlocation();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading==true? Center(child: CircularProgressIndicator()):
      FutureBuilder<weathermodel>(

        future: Weather(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _selectedIndex == 0
                ? home2(snapshot: snapshot.data!)  // Pass snapshot.data to home2
                : pages[_selectedIndex]; // Corrected placeholder or other pages
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },


      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurpleAccent.withOpacity(.5),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
