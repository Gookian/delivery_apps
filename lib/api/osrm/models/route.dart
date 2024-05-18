import 'package:delivery_apps/api/osrm/models/leg.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route.g.dart';

@JsonSerializable()
class Route {
  const Route({
    required this.geometry,
    required this.legs,
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance
  });

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  final String geometry;
  final List<Leg> legs;
  @JsonKey(name: 'weight_name')
  final String weightName;
  final double weight;
  final double duration;
  final double distance;

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}