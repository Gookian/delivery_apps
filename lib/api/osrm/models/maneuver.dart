import 'package:json_annotation/json_annotation.dart';

part 'maneuver.g.dart';

@JsonSerializable()
class Maneuver {
  const Maneuver({
    required this.bearingAfter,
    required this.bearingBefore,
    required this.location,
    required this.type,
    this.exit,
    this.modifier,
  });

  factory Maneuver.fromJson(Map<String, dynamic> json) => _$ManeuverFromJson(json);

  @JsonKey(name: 'bearing_after')
  final int bearingAfter;
  @JsonKey(name: 'bearing_before')
  final int bearingBefore;
  final List<double> location;
  final String type;
  final int? exit;
  final String? modifier;

  Map<String, dynamic> toJson() => _$ManeuverToJson(this);
}