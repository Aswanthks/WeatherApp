// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
//
// class Page3 extends StatefulWidget {
//   Page3({super.key});
//
//   @override
//   State<Page3> createState() => _Page3State();
// }
//
// class _Page3State extends State<Page3> {
//   Future<dynamic> Fetchlocation() async {
//     var data1 = await http.get(Uri.parse(
//         "https://api.openweathermap.org/data/2.5/weather?q=${citynameController.text}&appid=b7c1b004d8907dee9db0248ee6acebf3"));
//     if (data1.statusCode == 200) {
//       var decode1 = jsonDecode(data1.body);
//       return decode1;
//     } else {
//       throw NetworkError(data1);
//     }
//   }
//
//   TextEditingController citynameController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         children: [
//         appbar(),
//     Searchbar(
//     city: citynameController,
//     onpress: () {
//     setState(() {});
//     },
//     ),
//     citynameController.text.isEmpty
//     ? Center(
//     child: Container(
//     padding: EdgeInsets.only(top: 260),
//     child: Center(
//     child: Text(
//     "No Data!!",
//     style: TextStyle(
//     fontWeight: FontWeight.w500,
//     color: Colors.white,
//     fontSize: 30),
//     )),
//     ),
//     )
//         : Expanded(
//     child: FutureBuilder(
//     future: Fetchlocation(),
//     builder: (context, snapshot) {
//     if (snapshot.hasData) {
//     return Container(
//     height: MediaQuery.of(context).size.height,
//     width: MediaQuery.of(context).size.width,
//     color: Color(0xFF3352C5E),
//     child: SingleChildScrollView(
//     child: Column(children: [
//     WeatherBox(
//     cityname: snapshot.data!["name"],
//     Temprature:
//     snapshot.data!['main']['temp'] - 273.15,
//     humidity: snapshot.data!['main']['humidity'],
//     windspeed: snapshot.data!['wind']['speed'],
//     description: snapshot.data!["weather"][0]
//     ["description"]),
//     Container(
//     height: 300,
//     width: 350,
//     padding: EdgeInsets.all(20),
//     child: Column(
//     children: [
//     WeatherData(
//     WeatherStatuses: "Temprature Max",
//     Weatherdata:
//     snapshot.data["main"]["temp_max"] - 273,
//     WeatherIcon: CupertinoIcons.thermometer,
//     ),
//     SizedBox(
//     height: 20,
//     ),
//     WeatherData(
//     WeatherStatuses: "Temprature Min",
//     Weatherdata: snapshot.data["main"]
//     ["temp_min"] -
//     273,
//     WeatherIcon: CupertinoIcons.thermometer),
//       SizedBox(
//         height: 20,
//       ),
//       WeatherData(
//           WeatherStatuses: "Humidity            ",
//           Weatherdata: double.parse(snapshot
//               .data!["main"]["humidity"]
//               .toString()),
//           WeatherIcon: CupertinoIcons.drop),
//       SizedBox(
//         height: 20,
//       ),
//       WeatherData(
//           WeatherStatuses: "Cloudy                ",
//           Weatherdata: double.parse(snapshot
//               .data!["clouds"]["all"]
//               .toString()),
//           WeatherIcon: CupertinoIcons.cloud),
//       SizedBox(
//         height: 20,
//       ),
//       WeatherData(
//           WeatherStatuses:
//           "Wind                   ",
//           Weatherdata: snapshot.data!["wind"]
//           ["speed"],
//           WeatherIcon: CupertinoIcons.wind),
//     ],
//     ),
//     )
//     ]),
//     ),
//     );
//     } else if (snapshot.hasError) {
//       return Text(
//         "${snapshot.error}",
//         style: TextStyle(
//             fontSize: 25,
//             color: Colors.white,
//             fontWeight: FontWeight.bold),
//       );
//     }
//     return CircularProgressIndicator();
//     },
//     ),
//     ),
//         ],
//     );
//   }
// }