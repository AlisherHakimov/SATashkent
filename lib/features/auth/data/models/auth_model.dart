import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class TokenModel {
  final String access;
  final String refresh;

  const TokenModel({required this.access, required this.refresh});

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}

@JsonSerializable()
class UserModel {
  final int id;
  final String phone;
  final String? email;
  final String? username;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? avatar;

  const UserModel({
    required this.id,
    required this.phone,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  String get fullName {
    final parts = [firstName, lastName].whereType<String>();
    return parts.isNotEmpty ? parts.join(' ') : username ?? phone;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class LoginResponseModel {
  final TokenModel tokens;
  final UserModel user;

  const LoginResponseModel({required this.tokens, required this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@JsonSerializable()
class RegisterRequestModel {
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String phone;
  final String email;
  final String username;
  final String password;

  const RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.username,
    required this.password,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
