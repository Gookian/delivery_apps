import 'package:json_annotation/json_annotation.dart';

part 'network_error.g.dart';

@JsonSerializable()
class NetworkError {
  const NetworkError({
    required this.statusCode,
    required this.message
  });

  factory NetworkError.fromJson(Map<String, dynamic> json) => _$NetworkErrorFromJson(json);

  final int statusCode;
  final String message;

  Map<String, dynamic> toJson() => _$NetworkErrorToJson(this);
}