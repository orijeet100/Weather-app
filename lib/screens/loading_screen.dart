import 'package:weather_app/services/networking.dart';
import 'package:weather_app/services/weather.dart';
import 'package:flutter/material.dart';
import 'location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

const String apikey='abc021d2e6402252ab993137d220b4ae';

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    getLocationdata();
    super.initState();
  }

  void getLocationdata () async
  {
    WeatherModel w=WeatherModel();
    var weatherdata=await w.getLocation();
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return LocationScreen(locationData: weatherdata);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 100,
        ),
      )
    );
  }
}

class Location
{
  late double lat;
  late double long;
  Future<void> getLocation () async
  {

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      LocationPermission permission = await Geolocator.checkPermission();
      lat=position.latitude;
      long=position.longitude;
    }

    catch(e)
    {
      print(e);
    }
  }

}
