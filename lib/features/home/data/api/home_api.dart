import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api.g.dart';

@RestApi()
@singleton
abstract class HomeApi {
  @factoryMethod
  factory HomeApi(Dio dio) = _HomeApi;

  @GET('/home/dashboard/')
  Future<dynamic> getDashboard();
}
