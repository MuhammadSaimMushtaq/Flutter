// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:coinapp/models/http_serice.dart';
import 'package:coinapp/pages/selectcurrency.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double? _deviceheight;
  double? _devicewidth;
  HttpService? _http;
  Map? _rates;
  String _selected = 'bitcoin';
  String _selectedcurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HttpService>();
  }

  Widget dropdowncoin() {
    List<String> items = ["bitcoin", "ethereum", "tether", "cardano", "ripple"];
    List<DropdownMenuItem<String>> dropdownitems = items.map((e) {
      return DropdownMenuItem(
          value: e,
          child: Text(
            e,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ));
    }).toList();
    return DropdownButton(
      value: _selected,
      items: dropdownitems,
      onChanged: (dynamic value) {
        setState(() {
          _selected = value;
        });
      },
      underline: Container(),
      dropdownColor: const Color.fromARGB(255, 89, 38, 177),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
        size: 30,
      ),
      borderRadius: BorderRadius.circular(10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }

  Widget fetchdata() {
    return FutureBuilder(
      future: _http!.get(_selected),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map _data = jsonDecode(snapshot.data.toString());

          String _currentPrice = _data["market_data"]['current_price']
                  [_selectedcurrency.toLowerCase()]
              .toString();
          String _change = _data["market_data"]
                      ['price_change_percentage_24h_in_currency']
                  [_selectedcurrency.toLowerCase()]
              .toString();
          String _imageurl = _data['image']['large'].toString();
          String _description = _data['description']['en'].toString();
          _rates = _data['market_data']['current_price'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              showpicture(_imageurl),
              showprice(_currentPrice),
              showpercentage(_change),
              showdescription(_description),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget showprice(price) {
    _selectedcurrency = _selectedcurrency.toUpperCase();
    return Text(
      '$price $_selectedcurrency',
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }

  Widget showpicture(url) {
    return GestureDetector(
      onDoubleTap: () async {
        _selectedcurrency = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return currencyselection(
            exchangerates: _rates!,
          );
        }));
        setState(() {});
      },
      child: Container(
          height: _deviceheight! * 0.15,
          width: _devicewidth! * 0.15,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(url),
          ))),
    );
  }

  Widget showpercentage(change) {
    return Text(
      '$change %',
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
    );
  }

  Widget showdescription(des) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceheight!.toDouble() * 0.01,
        vertical: _deviceheight!.toDouble() * 0.01,
      ),
      height: _deviceheight! * 0.45,
      width: _devicewidth! * 0.9,
      color: Colors.deepPurple,
      child: SingleChildScrollView(
        hitTestBehavior: HitTestBehavior.translucent,
        child: Text(
          des,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            dropdowncoin(),
            fetchdata(),
          ],
        ),
      ),
    );
  }
}
