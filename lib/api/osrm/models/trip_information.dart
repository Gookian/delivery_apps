import 'package:delivery_apps/api/osrm/models/route.dart';
import 'package:delivery_apps/api/osrm/models/waypoint.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip_information.g.dart';

@JsonSerializable()
class TripInformation {
  const TripInformation({
    required this.code,
    required this.routes,
    required this.waypoints
  });

  factory TripInformation.fromJson(Map<String, dynamic> json) => _$TripInformationFromJson(json);

  final String code;
  final List<Route> routes;
  final List<Waypoint> waypoints;

  Map<String, dynamic> toJson() => _$TripInformationToJson(this);
}