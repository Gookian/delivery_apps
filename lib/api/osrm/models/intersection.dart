import 'package:delivery_apps/api/osrm/models/lane.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intersection.g.dart';

@JsonSerializable()
class Intersection {
  const Intersection({
    required this.entry,
    required this.bearings,
    required this.location,
    this.lanes,
    this.out,
    this.into
  });

  factory Intersection.fromJson(Map<String, dynamic> json) => _$IntersectionFromJson(json);

  final List<bool> entry;
  final List<int> bearings;
  final List<double> location;
  final List<Lane>? lanes;
  final int? out;
  final int? into;

  Map<String, dynamic> toJson() => _$IntersectionToJson(this);
}