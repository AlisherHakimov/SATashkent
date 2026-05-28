import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'assessments_api.g.dart';

@RestApi()
@singleton
abstract class AssessmentsApi {
  @factoryMethod
  factory AssessmentsApi(Dio dio) = _AssessmentsApi;

  @GET('/assessments/')
  Future<dynamic> getAssessments();

  @POST('/assessments/{id}/start/')
  Future<dynamic> startAssessment(@Path('id') int id);

  @POST('/assessments/{id}/submit/')
  Future<dynamic> submitAssessment(
    @Path('id') int id, {
    @Body() required Map<String, dynamic> answers,
  });
}
