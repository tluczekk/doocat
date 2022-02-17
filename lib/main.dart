import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
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
                return ListView(
                  children: [
                    _createDataTable(snapshot.data!.rates)
                  ],
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

DataTable _createDataTable(List<Rate> rates){
  return DataTable(columns: _createColumns(), rows: _createRows(rates));
}

List<DataColumn> _createColumns(){
  return [
    const DataColumn(label: Text("")),
    const DataColumn(label: Text("Waluta")),
    const DataColumn(label: Text("Kupno")),
    const DataColumn(label: Text("Sprzedaż")),
  ];
}

List<DataRow> _createRows(List<Rate> rates) {
  List<DataRow> temp = List.empty(growable: true);
  for (Rate r in rates) {
    temp.add(
        DataRow(
            cells: [
              DataCell(Flag.fromString(
                r.code.substring(0, 2), height: 50, width: 50,)),
              DataCell(Text(r.code)),
              DataCell(Text(r.ask.toString())),
              DataCell(Text(r.bid.toString()))
            ]
        )
    );
  }
  return temp;
}
