import 'dart:convert';

import 'package:coinapp/models/appconfig.dart';
import 'package:coinapp/models/http_serice.dart';
import 'package:coinapp/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await geturl();
  registerHTTPservice();
  runApp(const MyApp());
}

Future<void> geturl() async{
  String jsondatawithoutdecoding=await rootBundle.loadString("assets/config/main.json");
  Map jsondatadecoded=jsonDecode(jsondatawithoutdecoding);
  GetIt.instance.registerSingleton<Appconfig>(Appconfig(
    BASE_API_URL:jsondatadecoded['BASE_API_URL']
    ));
}

void registerHTTPservice(){
  GetIt.instance.registerSingleton<HttpService>(HttpService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.deepPurple,
      ),
      home: const Homepage(),
    );
  }
}

