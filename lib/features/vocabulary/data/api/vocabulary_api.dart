import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'vocabulary_api.g.dart';

@RestApi()
@singleton
abstract class VocabularyApi {
  @factoryMethod
  factory VocabularyApi(Dio dio) = _VocabularyApi;

  @GET('/vocabulary/words/')
  Future<dynamic> getWords({
    @Query('difficulty') String? difficulty,
    @Query('status') String? status,
  });

  @PATCH('/vocabulary/words/{id}/status/')
  Future<void> updateWordStatus(
    @Path('id') int id, {
    @Field('status') required String status,
  });
}
