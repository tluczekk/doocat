import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  late Future<Rates> futureRates;

  @override
  void initState(){
    super.initState();
    futureRates = fetchRates();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'doocat',
      theme: ThemeData(
        primaryColor: Colors.cyan[200],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('doocat'),
        ),
        body: Center(
          child: FutureBuilder<Rates>(
            future: futureRates,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return Text("Kurs ${snapshot.data!.code} to ${snapshot.data!.bid}/${snapshot.data!.ask}");
              } else if (snapshot.hasError){
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            },
          ),
        )
      ),
    );
  }
}

class Rates{
  final String code;
  final double bid;
  final double ask;

  const Rates({
    required this.code,
    required this.bid,
    required this.ask,
  });

  factory Rates.fromJson(Map<String, dynamic> json){
    int i = 0;
    return Rates(
      code: json['code'],
      bid: json['rates'][i]['bid'],
      ask: json['rates'][i]['ask']
    );
  }
}

Future<Rates> fetchRates() async{
  final response = await http
      .get(Uri.parse('http://api.nbp.pl/api/exchangerates/rates/c/chf/today/?format=json'));
  if(response.statusCode == 200){
    return Rates.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch rates');
  }
}
