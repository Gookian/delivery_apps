import 'package:json_annotation/json_annotation.dart';

part 'lane.g.dart';

@JsonSerializable()
class Lane {
  const Lane({
    required this.valid,
    required this.indications
  });

  factory Lane.fromJson(Map<String, dynamic> json) => _$LaneFromJson(json);

  final bool valid;
  final List<String> indications;

  Map<String, dynamic> toJson() => _$LaneToJson(this);
}