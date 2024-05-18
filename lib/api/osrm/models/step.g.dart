// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Step _$StepFromJson(Map<String, dynamic> json) => Step(
      geometry: json['geometry'] as String,
      maneuver: Maneuver.fromJson(json['maneuver'] as Map<String, dynamic>),
      mode: json['mode'] as String,
      drivingSide: json['driving_side'] as String,
      name: json['name'] as String,
      intersections: (json['intersections'] as List<dynamic>)
          .map((e) => Intersection.fromJson(e as Map<String, dynamic>))
          .toList(),
      weight: (json['weight'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      destinations: json['destinations'] as String?,
      ref: json['ref'] as String?,
    );

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'geometry': instance.geometry,
      'maneuver': instance.maneuver,
      'mode': instance.mode,
      'driving_side': instance.drivingSide,
      'name': instance.name,
      'intersections': instance.intersections,
      'weight': instance.weight,
      'duration': instance.duration,
      'distance': instance.distance,
      'destinations': instance.destinations,
      'ref': instance.ref,
    };
