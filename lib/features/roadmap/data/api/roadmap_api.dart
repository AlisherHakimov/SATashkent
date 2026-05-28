import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'roadmap_api.g.dart';

@RestApi()
@singleton
abstract class RoadmapApi {
  @factoryMethod
  factory RoadmapApi(Dio dio) = _RoadmapApi;

  @GET('/roadmap/')
  Future<dynamic> getRoadmap();

  @POST('/roadmap/topics/{id}/complete/')
  Future<void> completeTopic(@Path('id') int topicId);
}
