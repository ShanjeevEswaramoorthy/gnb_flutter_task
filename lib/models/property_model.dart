import 'package:json_annotation/json_annotation.dart';
part 'property_model.g.dart';

@JsonSerializable()
class PropertyModel {
  final bool? status;
  final ResponseData? response;

  PropertyModel({this.status, this.response});

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);
}

@JsonSerializable()
class ResponseData {
  final List<Logs>? logs;

  ResponseData({this.logs});

  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDataToJson(this);
}

@JsonSerializable()
class Logs {
  final String? id;
  final String? postcode;
  @JsonKey(name: 'machine_id')
  final String? machineId;
  @JsonKey(name: 'start_at')
  final String? startAt;
  @JsonKey(name: 'end_at')
  final String? endAt;
  final String? status;

  Logs({
    this.id,
    this.postcode,
    this.machineId,
    this.startAt,
    this.endAt,
    this.status,
  });

  factory Logs.fromJson(Map<String, dynamic> json) => _$LogsFromJson(json);

  Map<String, dynamic> toJson() => _$LogsToJson(this);
}
