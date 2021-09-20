import 'package:flutter/material.dart';
import 'package:weather_app/services/networking.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/utilities/constants.dart';
import 'city_screen.dart';
import 'loading_screen.dart';


class LocationScreen extends StatefulWidget {
  final locationData;
  LocationScreen({this.locationData});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}


class _LocationScreenState extends State<LocationScreen> {
  WeatherModel w=WeatherModel();
  late double temp;
  late int temperature;
  late int condition;
  late String cityname;
  late String message;

  void update(dynamic weatherdata)
  {
    if(weatherdata==null)
      {temperature=0;
      condition=806;
      cityname='the system';
      message='Error';}

    else
        {
          temp=weatherdata['main']['temp']-273.15;
          temperature=temp.toInt();
          condition=weatherdata['weather'][0]['id'];
          cityname=weatherdata['name'];
          message=w.getMessage(temperature);
        }
  }

  @override
  void initState() {
    update(widget.locationData);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async{
                      var weatherdata=await w.getLocation();
                      setState(() {
                        update(weatherdata);
                      });
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                      var typedName=await
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CityScreen();
                      }));
                      print(typedName);
                      NewWeather n=NewWeather();
                      var weatherdata=await n.getLocation(typedName);
                      setState(() {
                        update(weatherdata);
                      });
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°C  ',
                      style: kTempTextStyle.copyWith(fontSize: 80,fontWeight: FontWeight.normal),
                    ),
                    Flexible(
                      child: Text(
                        w.getWeatherIcon(condition),
                        style: kConditionTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Text(
                    "$message in $cityname",
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewWeather
{
  Future<dynamic> getLocation(String cityname) async
  {
    NetworkHelper n=NetworkHelper('https://api.openweathermap.org/data/2.5/weather?q=$cityname&appid=$apikey');
    var weatherdata=await n.getdata();
    return weatherdata;
  }
}