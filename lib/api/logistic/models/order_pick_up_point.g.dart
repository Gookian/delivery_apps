// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_pick_up_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPickUpPoint _$OrderPickUpPointFromJson(Map<String, dynamic> json) =>
    OrderPickUpPoint(
      orderPickUpPointId: (json['orderPickUpPointId'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderPickUpPointToJson(OrderPickUpPoint instance) =>
    <String, dynamic>{
      'orderPickUpPointId': instance.orderPickUpPointId,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
