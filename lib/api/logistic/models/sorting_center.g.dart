// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorting_center.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortingCenter _$SortingCenterFromJson(Map<String, dynamic> json) =>
    SortingCenter(
      sortingCenterId: (json['sortingCenterId'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$SortingCenterToJson(SortingCenter instance) =>
    <String, dynamic>{
      'sortingCenterId': instance.sortingCenterId,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
