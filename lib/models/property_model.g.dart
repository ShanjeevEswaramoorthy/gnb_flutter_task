// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      status: json['status'] as bool?,
      response:
          json['response'] == null
              ? null
              : ResponseData.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{'status': instance.status, 'response': instance.response};

ResponseData _$ResponseDataFromJson(Map<String, dynamic> json) => ResponseData(
  logs:
      (json['logs'] as List<dynamic>?)
          ?.map((e) => Logs.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ResponseDataToJson(ResponseData instance) =>
    <String, dynamic>{'logs': instance.logs};

Logs _$LogsFromJson(Map<String, dynamic> json) => Logs(
  id: json['id'] as String?,
  postcode: json['postcode'] as String?,
  machineId: json['machine_id'] as String?,
  startAt: json['start_at'] as String?,
  endAt: json['end_at'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$LogsToJson(Logs instance) => <String, dynamic>{
  'id': instance.id,
  'postcode': instance.postcode,
  'machine_id': instance.machineId,
  'start_at': instance.startAt,
  'end_at': instance.endAt,
  'status': instance.status,
};
