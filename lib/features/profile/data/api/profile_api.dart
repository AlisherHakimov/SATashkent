import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api.g.dart';

@RestApi()
@singleton
abstract class ProfileApi {
  @factoryMethod
  factory ProfileApi(Dio dio) = _ProfileApi;

  @GET('/profile/me/')
  Future<dynamic> getProfile();

  @GET('/profile/stats/')
  Future<dynamic> getStats();

  @PATCH('/profile/me/')
  Future<dynamic> updateProfile({
    @Field('first_name') String? firstName,
    @Field('last_name') String? lastName,
    @Field('email') String? email,
  });
}
