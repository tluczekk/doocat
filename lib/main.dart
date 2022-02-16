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
        primaryColor: Colors.lightGreen,
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
                //return Text("Kurs ${snapshot.data!.code} to ${snapshot.data!.bid}/${snapshot.data!.ask}");
                return ListView.builder(
                  itemCount: snapshot.data!.rates.length,
                  itemBuilder: (context, index){
                    Rate currRate = snapshot.data!.rates[index];
                    return ListTile(
                      title: Text("${currRate.code}: ${((currRate.bid + currRate.ask)/2).toStringAsFixed(4)}",
                      style: const TextStyle(fontSize: 18)),
                    );
                  },
                );
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
  final List<Rate> rates;

  const Rates({
    required this.rates,
  });

  factory Rates.fromJson(Map<String, dynamic> json){
    List<Rate> temp = List.empty(growable: true);
    for (var rate in json['rates']){
      temp.add(Rate(code: rate['code'], bid: rate['bid'], ask: rate['ask']));
    }
    return Rates(
      rates: temp,
    );
  }
}

class Rate{
  final String code;
  final double bid;
  final double ask;

  const Rate({
    required this.code,
    required this.bid,
    required this.ask,
  });
}

Future<Rates> fetchRates() async{
  final response = await http
      .get(Uri.parse('http://api.nbp.pl/api/exchangerates/tables/c/?format=json'));
  if(response.statusCode == 200){
    var jsonZdekodowany = jsonDecode(response.body);
    return Rates.fromJson(jsonZdekodowany[0]);
  } else {
    throw Exception('Failed to fetch rates');
  }
}
