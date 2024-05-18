import 'package:json_annotation/json_annotation.dart';

part 'sorting_center.g.dart';

@JsonSerializable()
class SortingCenter {
  const SortingCenter({
    required this.sortingCenterId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory SortingCenter.fromJson(Map<String, dynamic> json) => _$SortingCenterFromJson(json);

  final int sortingCenterId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$SortingCenterToJson(this);
}