import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'utils/rates.dart';

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


