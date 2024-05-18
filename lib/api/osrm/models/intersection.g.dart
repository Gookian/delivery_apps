// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intersection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Intersection _$IntersectionFromJson(Map<String, dynamic> json) => Intersection(
      entry: (json['entry'] as List<dynamic>).map((e) => e as bool).toList(),
      bearings: (json['bearings'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      location: (json['location'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      lanes: (json['lanes'] as List<dynamic>?)
          ?.map((e) => Lane.fromJson(e as Map<String, dynamic>))
          .toList(),
      out: (json['out'] as num?)?.toInt(),
      into: (json['into'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IntersectionToJson(Intersection instance) =>
    <String, dynamic>{
      'entry': instance.entry,
      'bearings': instance.bearings,
      'location': instance.location,
      'lanes': instance.lanes,
      'out': instance.out,
      'into': instance.into,
    };
