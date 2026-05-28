// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => TokenModel(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
    );

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      phone: json['phone'] as String,
      email: json['email'] as String?,
      username: json['username'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'email': instance.email,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar': instance.avatar,
    };

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      tokens: TokenModel.fromJson(json['tokens'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
    <String, dynamic>{
      'tokens': instance.tokens,
      'user': instance.user,
    };

RegisterRequestModel _$RegisterRequestModelFromJson(
        Map<String, dynamic> json) =>
    RegisterRequestModel(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterRequestModelToJson(
        RegisterRequestModel instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
    };
