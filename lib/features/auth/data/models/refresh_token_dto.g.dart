// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenDto _$RefreshTokenDtoFromJson(Map<String, dynamic> json) =>
    RefreshTokenDto(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$RefreshTokenDtoToJson(RefreshTokenDto instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};

PasswordResetDto _$PasswordResetDtoFromJson(Map<String, dynamic> json) =>
    PasswordResetDto(email: json['email'] as String);

Map<String, dynamic> _$PasswordResetDtoToJson(PasswordResetDto instance) =>
    <String, dynamic>{'email': instance.email};

ResetPasswordDto _$ResetPasswordDtoFromJson(Map<String, dynamic> json) =>
    ResetPasswordDto(
      token: json['token'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$ResetPasswordDtoToJson(ResetPasswordDto instance) =>
    <String, dynamic>{'token': instance.token, 'password': instance.password};
