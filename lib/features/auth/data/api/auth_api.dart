import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_model.dart';

part 'auth_api.g.dart';

@RestApi()
@singleton
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/auth/login/')
  Future<LoginResponseModel> login({
    @Field('email') required String email,
    @Field('password') required String password,
  });

  @POST('/auth/register/')
  Future<LoginResponseModel> register({
    @Body() required RegisterRequestModel body,
  });

  @POST('/auth/send-otp/')
  Future<void> sendOtp({
    @Field('phone') required String phone,
  });

  @POST('/auth/verify-otp/')
  Future<LoginResponseModel> verifyOtp({
    @Field('phone') required String phone,
    @Field('otp') required String otp,
  });

  @POST('/auth/token/refresh/')
  Future<TokenModel> refreshToken({
    @Field('refresh') required String refreshToken,
  });

  @POST('/auth/logout/')
  Future<void> logout({
    @Field('refresh') required String refreshToken,
  });
}
