import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Cuaca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey = '347352c1b05843e69ac175708230707';
  String selectedCity = 'Jakarta';
  dynamic weatherData;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  void getWeather() async {
    String url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$selectedCity';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Cuaca'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: selectedCity,
            items: <String>['Jakarta', 'Surabaya', 'Bandung', 'Yogyakarta']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCity = newValue!;
                getWeather();
              });
            },
          ),
          SizedBox(height: 20),
          if (weatherData != null)
            Column(
              children: [
                Text(
                  'Lokasi: ${weatherData['location']['name']}',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                Text(
                  'Suhu: ${weatherData['current']['temp_c']}°C',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Cuaca: ${weatherData['current']['condition']['text']}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
        ],
      ),
    );
  }
}