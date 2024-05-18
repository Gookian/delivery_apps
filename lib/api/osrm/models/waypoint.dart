import 'package:json_annotation/json_annotation.dart';

part 'waypoint.g.dart';

@JsonSerializable()
class Waypoint {
  const Waypoint({
    required this.hint,
    required this.distance,
    required this.name,
    required this.location
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) => _$WaypointFromJson(json);

  final String hint;
  final double distance;
  final String name;
  final List<double> location;

  Map<String, dynamic> toJson() => _$WaypointToJson(this);
}