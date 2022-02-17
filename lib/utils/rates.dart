import 'dart:convert';

import 'package:http/http.dart' as http;

class Rates{
  final List<Rate> rates;

  const Rates({
    required this.rates,
  });

  factory Rates.fromJson(Map<String, dynamic> json){
    List<Rate> temp = List.empty(growable: true);
    for (var rate in json['rates']){
      temp.add(Rate(
          code: rate['code'],
          bid: rate['bid'],
          ask: rate['ask']));
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
    return Rates.fromJson(jsonDecode(response.body)[0]);
  } else {
    throw Exception('Failed to fetch rates');
  }
}