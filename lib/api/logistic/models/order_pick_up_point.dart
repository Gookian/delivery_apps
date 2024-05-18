import 'package:json_annotation/json_annotation.dart';

part 'order_pick_up_point.g.dart';

@JsonSerializable()
class OrderPickUpPoint {
  const OrderPickUpPoint({
    required this.orderPickUpPointId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory OrderPickUpPoint.fromJson(Map<String, dynamic> json) => _$OrderPickUpPointFromJson(json);

  final int orderPickUpPointId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$OrderPickUpPointToJson(this);
}