import 'package:delivery_apps/api/osrm/models/step.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leg.g.dart';

@JsonSerializable()
class Leg {
  const Leg({
    required this.steps,
    required this.summary,
    required this.weight,
    required this.duration,
    required this.distance
  });

  factory Leg.fromJson(Map<String, dynamic> json) => _$LegFromJson(json);

  final List<Step> steps;
  final String summary;
  final double weight;
  final double duration;
  final double distance;

  Map<String, dynamic> toJson() => _$LegToJson(this);
}