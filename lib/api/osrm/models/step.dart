import 'package:delivery_apps/api/osrm/models/intersection.dart';
import 'package:delivery_apps/api/osrm/models/maneuver.dart';
import 'package:json_annotation/json_annotation.dart';

part 'step.g.dart';

@JsonSerializable()
class Step {
  const Step({
    required this.geometry,
    required this.maneuver,
    required this.mode,
    required this.drivingSide,
    required this.name,
    required this.intersections,
    required this.weight,
    required this.duration,
    required this.distance,
    required this.destinations,
    this.ref,
  });

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);

  final String geometry;
  final Maneuver maneuver;
  final String mode;
  @JsonKey(name: 'driving_side')
  final String drivingSide;
  final String name;
  final List<Intersection> intersections;
  final double weight;
  final double duration;
  final double distance;
  final String? destinations;
  final String? ref;

  Map<String, dynamic> toJson() => _$StepToJson(this);
}