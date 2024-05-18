import 'package:json_annotation/json_annotation.dart';

part 'warehouse.g.dart';

@JsonSerializable()
class Warehouse {
  const Warehouse({
    required this.warehouseId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) => _$WarehouseFromJson(json);

  final int warehouseId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$WarehouseToJson(this);
}