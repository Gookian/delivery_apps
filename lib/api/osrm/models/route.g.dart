// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      geometry: json['geometry'] as String,
      legs: (json['legs'] as List<dynamic>)
          .map((e) => Leg.fromJson(e as Map<String, dynamic>))
          .toList(),
      weightName: json['weight_name'] as String,
      weight: (json['weight'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'geometry': instance.geometry,
      'legs': instance.legs,
      'weight_name': instance.weightName,
      'weight': instance.weight,
      'duration': instance.duration,
      'distance': instance.distance,
    };
