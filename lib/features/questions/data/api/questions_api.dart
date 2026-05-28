import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'questions_api.g.dart';

@RestApi()
@singleton
abstract class QuestionsApi {
  @factoryMethod
  factory QuestionsApi(Dio dio) = _QuestionsApi;

  @GET('/questions/')
  Future<dynamic> getQuestions({
    @Query('subject') String? subject,
    @Query('difficulty') String? difficulty,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  @GET('/questions/{id}/')
  Future<dynamic> getQuestion(@Path('id') int id);
}
