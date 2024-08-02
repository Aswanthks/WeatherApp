
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart'as http;
import 'package:weatherapp/model/weathermodel.dart';
import 'package:weatherapp/model/weathermodel.dart';
class home2 extends StatefulWidget {
  final weathermodel? snapshot;

  const home2({
    super.key,  this.snapshot,
  });

  @override
  State<home2> createState() => _home2State();
}

class _home2State extends State<home2> {

  @override
  Widget build(BuildContext context) {
    var main = widget.snapshot?.main;
    var weather = widget.snapshot?.weather?[0];
    var wind = widget.snapshot?.wind;

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            "assets/image/weather_background.png",
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            top: 356,
            left: 50,
            child: Image.asset(
              "assets/image/househome.png",
              height: 270,
              width: 250,
            )),
        Positioned(
            top: 80,
            left: 80,
            child: Text(
              "${widget.snapshot?.name}",
              style: TextStyle(color: Colors.white, fontSize: 50,fontWeight: FontWeight.w300),
            )),

        Positioned(
            top: 130,
            left: 90,
            child: Text(

             "${((widget.snapshot?.main?.temp)! - 273.15).toStringAsFixed(1)}° ",
              style: TextStyle(color: Colors.white, fontSize: 90,fontWeight: FontWeight.w200),
            )),
        Positioned(
            top: 236,
            left: 100,
            child: Text(
              "${((widget.snapshot?.weather?[0].description))}",
              style: TextStyle(color: Colors.white70, fontSize: 25,fontWeight: FontWeight.w500),
            )),
        Positioned(
            top: 270,
            left: 80,
            child: Row(
              children: [
                Text(
                  "H:${((widget.snapshot?.main?.humidity).toString())}%  ",
                  style: TextStyle(color: Colors.white, fontSize: 23,fontWeight: FontWeight.w300,),
                ), Text(
                  "  WS:${((widget.snapshot?.wind?.speed)!.toStringAsFixed(1))}kmph",
                  style: TextStyle(color: Colors.white, fontSize: 23,fontWeight: FontWeight.w300,),
                ),
              ],
            )),
      ],
    );
  }
}
