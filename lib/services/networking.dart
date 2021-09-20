import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

// ignore: camel_case_types
class NetworkHelper {
  String uri;

  NetworkHelper(this.uri);

  Future<dynamic> getdata() async
  {
    var uriExample = Uri.parse(uri);
    http.Response r = await http.get(uriExample);
    if (r.statusCode == 200) {
      String data = r.body;
      return jsonDecode(data);
    }
    else {
      print(r.statusCode);
    }
  }
}

