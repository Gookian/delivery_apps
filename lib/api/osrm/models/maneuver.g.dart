// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maneuver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Maneuver _$ManeuverFromJson(Map<String, dynamic> json) => Maneuver(
      bearingAfter: (json['bearing_after'] as num).toInt(),
      bearingBefore: (json['bearing_before'] as num).toInt(),
      location: (json['location'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      type: json['type'] as String,
      exit: (json['exit'] as num?)?.toInt(),
      modifier: json['modifier'] as String?,
    );

Map<String, dynamic> _$ManeuverToJson(Maneuver instance) => <String, dynamic>{
      'bearing_after': instance.bearingAfter,
      'bearing_before': instance.bearingBefore,
      'location': instance.location,
      'type': instance.type,
      'exit': instance.exit,
      'modifier': instance.modifier,
    };
