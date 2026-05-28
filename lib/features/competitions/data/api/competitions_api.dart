import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'competitions_api.g.dart';

@RestApi()
@singleton
abstract class CompetitionsApi {
  @factoryMethod
  factory CompetitionsApi(Dio dio) = _CompetitionsApi;

  @GET('/competitions/')
  Future<dynamic> getCompetitions();

  @POST('/competitions/{id}/join/')
  Future<void> joinCompetition(@Path('id') int id);

  @GET('/competitions/{id}/leaderboard/')
  Future<dynamic> getLeaderboard(@Path('id') int id);
}
