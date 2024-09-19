import 'package:coinapp/models/appconfig.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HttpService {
  HttpService(){
    _appconfig=GetIt.instance.get<Appconfig>();
    _base_url=_appconfig!.BASE_API_URL;
    print(_base_url);
  }

  Appconfig? _appconfig;
  final Dio dio = Dio();

  String? _base_url;

  Future<Response?> get(String path) async{
    try{
      return await dio.get(_base_url!+path);
    }
    catch(e){
      print('HTTPservice error: $e');
    }
    return null;
  }
}