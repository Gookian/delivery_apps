// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lane _$LaneFromJson(Map<String, dynamic> json) => Lane(
      valid: json['valid'] as bool,
      indications: (json['indications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LaneToJson(Lane instance) => <String, dynamic>{
      'valid': instance.valid,
      'indications': instance.indications,
    };
