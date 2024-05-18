// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkError _$NetworkErrorFromJson(Map<String, dynamic> json) => NetworkError(
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$NetworkErrorToJson(NetworkError instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
    };
